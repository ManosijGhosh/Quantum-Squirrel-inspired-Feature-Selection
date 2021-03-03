function []=loocvKNN()
    rng('default');
    x=importdata('dataUsedCurrent/Input.xlsx');
    t=importdata('dataUsedCurrent/target.xlsx');
    tar=importdata('dataUsedCurrent/targetsF.xlsx');
    disp('imports done');
    c=size(x,1);
    %count1=sum(tar(:)==1);
    %count0=sum(tar(:)==2);
    
    %{
    prostate - [10 10 10 30 20];
    colon all 10
    AMLGSE2191 - 

    %}
    
    
    temp=load('dataUsedCurrent/results.mat');
    list=temp.list;
    temp=temp.population(1,:);
    accuracy=zeros(1,c);
    x=x(:,list);
    for i=1:c
        fprintf('Fold - %d\n',i);
        chr=zeros(c,1);%0 training, 1 test
        chr(i,1)=1;
        for j=1:12
            per=knn(x,t,chr,temp(1,:),j);
            if(per>accuracy(i))
                accuracy(i)=per;
            end
            if per==1
                break;
            end
        end
    end
    for i=1:c
        fprintf('%f\t',accuracy(i));
    end
    fprintf('\n');
    fprintf('Average & standard deviation - %f\t%f\n',((sum(accuracy)/c)*100),(std(accuracy,0,2)*100));
end
function [performance]=knn(x,t,chr,chromosome,k)
    if(sum(chromosome(1,:)==1)~=0)
        x2=x(chr(:)==1,chromosome(:)==1);
        t2=t(chr(:)==1,:);
        x=x(chr(:)==0,chromosome(:)==1);
        t=t(chr(:)==0,:);
        s=size(t,1);
        label=zeros(1,s);
        for i=1:s
            label(1,i)=find(t(i,:),1);
            %{
            if (find(t(i,:),1)==1)
                label(i,1)=1;
            else
                label(i,1)=2;
            end
            %}
        end

        knnModel=fitcknn(x,label,'NumNeighbors',k,'Standardize',1);
        %knnModel=fitcknn(x,label);
        [label,score] = predict(knnModel,x2);
        %label
        
        s=size(t2,1);
        lab=zeros(s,1);
        for i=1:s
            lab(i,1)=find(t2(i,:),1);
            %{
            if (find(t2(i,:),1)==1)
                lab(i,1)=1;
            else
                lab(i,1)=2;
            end
            %}
        end
        %[c,~]=confusion(t2,label);
        %%{
        %size(lab)
        %size(label)
        c = sum(lab ~= label)/s; % mis-classification rate
        %conMat = confusionmat(Y(P.test),C) % the confusion matrix
        %}
        performance=1-c;
        fprintf('Number of features - %d\n',sum(chromosome(1,:)==1));
        fprintf('The correct classification is %f\n',(100*performance));
    else
        performance=0;
    end
end