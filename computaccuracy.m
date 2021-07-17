function accuracy=computaccuracy(train_norm,train_label,test_norm,test_label,P)
test_tol=size(test_norm,2);
train_tol=size(train_norm,2);
ClassNum = length(unique(train_label));
pre_label=zeros(1,test_tol);

parfor i=1:test_tol
    y=test_norm(:,i);
    xp=P*y;
    coeff=zeros(1,ClassNum);
    r=zeros(1,ClassNum);
    for j=1:ClassNum
        mmu=zeros(train_tol,1);
        ind=(j==train_label);
        mmu(ind)=xp(ind);
        r(j)=norm(y-train_norm*mmu);
        coeff(j)=norm(mmu);
    end
    reg_r=r./coeff;
    [~,index]=min(reg_r);
    pre_label(i)=index;
end
accuracy=sum(pre_label==test_label)/test_tol;
