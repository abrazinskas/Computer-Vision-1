% returns an HTML string
function [html] = toHTML(img_names,probs,per_class)
   [m,c] = size(probs);
   ids =(1:m)';
   html = '<table>';
   
   % sorting
   s_ids =[];
   for i = 1:c
       s_id = sortBy(ids,probs(:,i));
       s_ids = [s_ids s_id];
   end
    
   for j =1:per_class 
       html= strcat(html,'<tr>');
       for i = 1:c
           s_id = s_ids(j,i);
           full_name = img_names{s_id};
           html = strcat(html,'<td><img src="../',full_name,'"></td>');
       end
       html = strcat(html,'</tr>');
   end
    html = strcat(html,'</table>');
end