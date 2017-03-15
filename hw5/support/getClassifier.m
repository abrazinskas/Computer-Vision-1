% returns a classifier for each folder
function [model] = getClassifier(data,labels)
   % training each classifier
   %model = svmtrain(data,labels,'kernel_function','mlp');
   model = svmtrain(labels, data,'-q -s 0 -t 2 -g 50 -c 10');
end