% this function performs all steps of Bag of words approach 
% in order to perform classification of test images
% Inputs:
%        vocab_num : how many images from each class to use to create vocabulary
%        train_num : how many images from each class to use to train classifiers
function [] = BOW(folder,vocab_num,train_num,vocab_size,color_space,cached)
    addpath('support/');
    addpath('lib/');
    addpath('/Applications/MATLAB_R2015b.app/toolbox/libsvm-3.21/');
    % SETTING SIFT
    run vlfeat-0.9.20/toolbox/vl_setup.m
    
    % GLOBALS
    k = vocab_size; % number of clusters (vocabulary size) 
    neg = 1*train_num; % number of negative samples for classifiers
    file_prefix = strcat('cache/',color_space,'_',num2str(vocab_size),'_');
    
    % cononical names of training and test subfolderses
    train_subf = {'motorbikes_train';'faces_train';'cars_train';'airplanes_train';}; 
    test_subf = {'motorbikes_test';'faces_test';'cars_test';'airplanes_test';};
    if(nargin<6)
        cached= false;
    end
    
    disp('Number of images to use for vocab. creation:');
    disp(vocab_num);
    disp('Number of images to use for training classifiers:');
    disp(train_num);
    disp('Size of vocabulary:');
    disp(vocab_size);
    disp('Color space:');
    disp(color_space);
    
    if cached
        f = [file_prefix 'vocab.mat'];
        load (f);
    else
        % 1. Feature extraction
        disp('1. Extracting features for vobaculary');
        descr = extractFeat(folder,train_subf,color_space,1,vocab_num);
        % 2. Vocabulary creation (using k-means)
        disp('2. Creating vocabulary');
        vocab = createVocab(descr,k);
        % saving
        save(strcat(file_prefix,'vocab.mat'),'vocab');    
    end
    
    kdtree = vl_kdtreebuild(vocab');
    
    % 3. Quantize features
    disp('3. Quantizing features from training and test sets');
    if cached
        load ([file_prefix 'train.mat'])
        load ([file_prefix 'test.mat'])
        load ([file_prefix 'img_names.mat'])
    else 
        train_data = createDataSet(folder,train_subf,vocab,kdtree,color_space,true,vocab_num+1,train_num+vocab_num);
        [test_data, img_names] = createDataSet(folder,test_subf,vocab, kdtree, color_space, true);
        % saving for later reuse
        save(strcat(file_prefix,'train.mat'),'train_data');
        save(strcat(file_prefix,'test.mat'),'test_data');
        save(strcat(file_prefix,'img_names.mat'),'img_names');
    end
       % some formatting
       train_data = cell2mat(train_data');
       test_data = cell2mat(test_data');
       tr_labels = train_data(:,vocab_size+1);
       te_labels = test_data(:,vocab_size+1);
       test_data(:,vocab_size+1)=[];
       train_data(:,vocab_size+1)=[];
       
     % 4. Training classifiers
        disp('4. Training classifiers');
        cl={};
        for i=1:size(train_subf,1)
           t_data = train_data(tr_labels == i,:);
           n_data = train_data(tr_labels~=i,:);
           
           n = size(n_data,1);
           if(neg>n)
              neg = n;
           end
           % sampling
           n_data = datasample(n_data,neg,'Replace',false);
           m = size(t_data,1);
           data = [t_data;n_data];
           c_labels = [ones(m,1);-1*ones(neg,1)];
           model = getClassifier(data,c_labels);
           evaluate(data,c_labels,model);
           cl=cat(1,cl,model);
        end
        
        

        % 6. Evaluation
        disp('6. Evaluating')
        probs=[];
        map = [];
        mac= []; % mean accuracy
        for i=1:size(test_subf,1)
           c_te_labels = double(te_labels == i);
           c = sum(c_te_labels);
           c_te_labels(te_labels~=i)= -1;
           [pred_labels,ac,prob]=evaluate(test_data,c_te_labels,cl{i});
           matches = double(pred_labels==(c_te_labels == 1));
           s_matches =sortBy(matches,prob);
           ap = getMAP(s_matches,c);
           probs= [probs prob];
           map=[map;ap];
           mac = [mac;ac(1)];
           disp(['AP of classifier ',num2str(i),' ',num2str(ap)]);
           
        end
        
        disp(['Mean accuracy is :',' ',num2str(mean(mac))]);
        disp(['MAP is :',' ',num2str(mean(map))]);
    
   
        visualize(img_names,probs,10);
        %html = toHTML(img_names,probs,200);
        %fid = fopen('images.html','wt');
        %fprintf(fid, html);
        %fclose(fid);
end