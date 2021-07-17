function Pro_Matrix=my_pca(Train_SET)
% obtain the projection matrix by using PCA

% input
% Train_SET: training data matrix, each column is the data vector for one sample
% and the size of Train_SET is Dim*Train_Num

% output
% Pro_Matrix: the projection matrix

[Dim,Train_Num]=size(Train_SET);

% when the dimension is less than the number of training samples
if Dim<=Train_Num
    Mean_Image=mean(Train_SET,2);
    Train_SET=bsxfun(@minus,Train_SET,Mean_Image);
    R=Train_SET*Train_SET'/(Train_Num-1);
    
    [eig_vec,eig_val]=eig(R);
    eig_val=diag(eig_val);
    [~,ind]=sort(eig_val,'descend');
    W=eig_vec(:,ind);
    Pro_Matrix=W;
    
else
    % otherwise
    Mean_Image=mean(Train_SET,2);
    Train_SET=bsxfun(@minus,Train_SET,Mean_Image);
    R=Train_SET'*Train_SET/(Train_Num-1);
    %     R=Train_SET'*Train_SET;
    
    [eig_vec,eig_val]=eig(R);
    eig_val=diag(eig_val);
    [val,ind]=sort(eig_val,'descend');
    W=eig_vec(:,ind);
    Pro_Matrix=Train_SET*W*diag(val.^(-1/2));
    %     Pro_Matrix=Train_SET*W(:,1:Eigen_NUM)*diag(val(1:Eigen_NUM).^(-1/2));
end

end
