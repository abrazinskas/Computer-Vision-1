% perfoms evaluation of cl (classifiers) based on :
% 1. mean average precision
% 2. quantitative visualization of sorted predictions 
function [pred_labels, accuracy, prob] = evaluate(data,labels,model)
         [pred_labels, accuracy, prob] = svmpredict(labels, data, model,'-b 0');
end