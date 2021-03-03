function []=loocvSVM()
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
        for j=1:4
            switch(j)
                case 1,
                    per=svm(x,t,chr,temp(1,:),'rbf');
                case 2,
                    per=svm(x,t,chr,temp(1,:),'linear');
                case 3,
                    per=svm(x,t,chr,temp(1,:),'gaussian');
                case 4,
                    per=svm(x,t,chr,temp(1,:),'polynomial');
            end
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
function [performance]=svm(x,t,chr,chromosome,str)
    if(sum(chromosome(1,:)==1)~=0)
        x2=x(chr(:)==1,chromosome(:)==1);
        t2=t(chr(:)==1,:);
        x=x(chr(:)==0,chromosome(:)==1);
        t=t(chr(:)==0,:);
        s=size(t,1);
        label=zeros(1,s);
        for i=1:s
            label(1,i)=find(t(i,:),1);
        end
        
        if max(label)==2
            svmModel=fitcsvm(x,label,'KernelFunction',str,'Standardize',true,'ClassNames',[1 2]);
        else
            class=zeros(1,max(label));
            for i=1:max(label)
                class(i)=i;
            end
            temp = templateSVM('Standardize',1,'KernelFunction',str);
            svmModel = fitcecoc(x,label,'Learners',temp,'FitPosterior',1,'ClassNames',class,'Coding','onevsall');
        end
        [label,~] = predict(svmModel,x2);
        %svmModel=svmtrain(x,label);
        %label=svmclassify(svmModel,x2);
        s=size(t2,1);
        lab=zeros(s,1);
        for i=1:s
            lab(1,i)=find(t2(i,:),1);
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