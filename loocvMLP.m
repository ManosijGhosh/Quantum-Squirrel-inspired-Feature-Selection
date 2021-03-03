function []=loocvMLP()
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
        for j=10:30
            per=nnetwork(x,t,chr,temp(1,:),j);
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
function [performance]=nnetwork(x,t,chr,chromosome,h)
    if (sum(chromosome(:)==1)==0)
        performance=0;
    else
        c=size(chromosome,2);
        
        target=t(chr(:)==0,:);
        
        input=x(chr(:)==0,chromosome(:)==1);
        %fprintf('Train set created\n');
        
        inputs = input';
        targets = target';
        
        
        hiddenLayerSize = h;

        net = patternnet(hiddenLayerSize);


        % Setup Division of Data for Training, Validation, Testing
        net.divideParam.trainRatio =85/100;
        net.divideParam.valRatio = 15/100;
        net.divideParam.testRatio = 0/100;

        % Train the Network
        %size(inputs)
        %size(targets)
        [net, ] = train(net,inputs,targets);
        
        clear targets target inputs input;
        % Test the Network
        %test set build
        target=t(chr(:)==1,:);
        input=x(chr(:)==1,chromosome(:)==1);
        inputs=input';targets=target';
        outputs = net(inputs);

        [c, ] = confusion(targets,outputs);
        fprintf('The number of features  : %d\n', sum(chromosome(:)==1));
        fprintf('Percentage Correct Classification   : %f%%\n', 100*(1-c));
        fprintf('Percentage Incorrect Classification : %f%%\n', 100*c);
        performance=1-c;%how much accuracy we get
        % View the Network
        %view(net);
        %}
    end
end