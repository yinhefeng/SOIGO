% Demo code of SOIGO-PCA-CRC on the AR database.
% Only the neutral image per subject in Session 1 is used as training samples
% and three occluded images by sunglasses per subject in Session 2 are used as
% test samples. The code can reproduce the results in Table 1 in our
% manuscript.
clear
clc
close all

% load data
load('AR_42_30')
rows = 42;
cols = 30;

% when using the first order IGO (IGO-PCA-CRC), set order = 1
% when using the second order IGO (SOIGO-PCA-CRC), set order = 2
order = 1;

% arrange the training data and its corresponding label vector
temp1 = zeros(1,26);
temp1(1) = 1;
temp1_ind = logical(repmat(temp1,1,100));
AR_1260_neutral = DATA(:,temp1_ind);
train_labels = Label(:,temp1_ind)';

% arrange the test data and its corresponding label vector
temp5 = zeros(1,26);
temp5([21,22,23]) = 1;
temp5_ind = logical(repmat(temp5,1,100));
AR_1260_s2Sun = DATA(:,temp5_ind);
test_labels = Label(:,temp5_ind)';

ClassNum = length(unique(train_labels)); % number of classes
% get training and testing data
train_data = AR_1260_neutral;
test_data = AR_1260_s2Sun;

% total number of training and test samples
train_tol = length(train_labels);
test_tol = length(test_labels);

ImageSize = rows*cols;

% extract the IGO feature for the training data
Z = zeros(ImageSize,train_tol);
for i=1:train_tol
    temp = train_data(:,i);
    temp = reshape(temp,rows,cols);
    maxValue = max(temp(:));
    temp = temp./maxValue;
    z = IGO(temp,order);
    Z(:,i) = z;
end

% obtain the projection matrix by using PCA
Pro_Matrix = my_pca(Z);

% extract the IGO feature for the test data
Z_tt = zeros(ImageSize,test_tol);
for i=1:test_tol
    temp = test_data(:,i);
    temp = reshape(temp,rows,cols);
    maxValue = max(temp(:));
    temp = temp./maxValue;
    z = IGO(temp,order);
    Z_tt(:,i) = z;
end

% dimensionality reduction
train_PCA_features = Pro_Matrix'*Z;
test_PCA_features = Pro_Matrix'*Z_tt;

% employ CRC to classify the test data
correct_PCA = zeros(1, size(test_PCA_features, 1));
lambda = 1e-3; % balance parameter for CRC
for ii = 1:size(test_PCA_features, 1)
    test_dat = test_PCA_features(1:ii, :);
    train_dat = train_PCA_features(1:ii, :);
    
    % normalize to unit L2 norm
    train_norm = normc([real(train_dat); imag(train_dat)]);
    test_norm = normc([real(test_dat); imag(test_dat)]);
    
    X = train_norm;
    tr_sym_mat = zeros(length(train_labels));
    for ci = 1 : ClassNum
        ind_ci = find(train_labels == ci);
        tr_descr_bar = zeros(size(X));
        tr_descr_bar(:,ind_ci) = X(:, ind_ci);
        tr_sym_mat = tr_sym_mat + lambda * (tr_descr_bar' * tr_descr_bar);
    end
    
    % pre-compute P
    P = (X'*X+tr_sym_mat+1e-1*eye(length(train_labels)))\X';
    
    % CRC
    correct_PCA(ii) = computaccuracy(train_norm,train_labels',...
        test_norm,test_labels',P);
end

% display results
[max_acc,index] = max(correct_PCA);
fprintf('The maximum recognition accuracy is %.2f%%\n',max_acc*100);
fprintf('The corresponding dimension is %d\n',index);

% plot results
figure;
plot(1:length(correct_PCA), correct_PCA*100,'Color', 'red', 'LineWidth', 2);
grid on
xlabel('Number of features')
ylabel('Recognition accuracy (%)')

