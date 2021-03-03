function [per]=crossValidation(chromosome)
global x t fold selection;
rng('default');

rows=size(x,1);
accuracy=zeros(1,fold);
data=x(:,chromosome==1);
if (size(data,2)==0)
    per = 0;
    return;
end
for i=1:fold
    %fprintf('Fold - %d\n',i);
    chr=zeros(rows,1);%0 training, 1 test
    for j=1:rows
        if selection(j)==i
            chr(j,1)=1;
        end
    end
    ch = 3;
    if (ch==1)
        accuracy(1,i) = knnClassify(data,t,chr);
    elseif (ch==2)
        accuracy(1,i) = svmClassify(data,t,chr);
    else
        accuracy(1,i) = mlpClassify(data,t,chr);
    end
end
%{
for i=1:fold
    fprintf('%f\t',accuracy(i));
end
fprintf('\n');
%}
per = mean(accuracy);
fprintf('Features & Accuracy - %d, %f\n',size(data,2),per);
end
function [performance]=knnClassify(x,t,chr)
h = 5;
x2=x(chr(:)==1,:);
t2=t(chr(:)==1,:);
x=x(chr(:)==0,:);
t=t(chr(:)==0,:);
label=t';

knnModel=fitcknn(x,label,'NumNeighbors',h,'Standardize',1);
[label,~] = predict(knnModel,x2);
%label

s=size(t2,1);
lab=zeros(s,1);
for i=1:s
    lab(i,1)=find(t2(i,:),1);
end
%[c,~]=confusion(t2,label);
%%{
%size(lab)
%size(label)
c = sum(lab ~= label)/s; % mis-classification rate
%conMat = confusionmat(Y(P.test),C) % the confusion matrix
%}
performance=1-c;
%{
fprintf('Number of features - %d\n',size(x,2));
fprintf('The correct classification is %f\n',(100*performance));
%}
end

function [performance]=mlpClassify(x,t,chr)
h = 20;
c = size(x,1);
temp = zeros(c,max(t));
for i=1:c
    temp(i,t(i,1)) = 1;
end
t = temp;

target=t(chr(:)==0,:);

input=x(chr(:)==0,:);
%fprintf('Train set created\n');

inputs = input';
targets = target';


hiddenLayerSize = h;

net = patternnet(hiddenLayerSize);
net.trainParam.showWindow = 0;

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
input=x(chr(:)==1,:);
inputs=input';targets=target';
outputs = net(inputs);

[c, ] = confusion(targets,outputs);
%{
fprintf('The number of features  : %d\n', size(x,2));
fprintf('Percentage Correct Classification   : %f%%\n', 100*(1-c));
fprintf('Percentage Incorrect Classification : %f%%\n', 100*c);
%}
performance=1-c;%how much accuracy we get
end

function [performance]=svmClassify(x,t,chr)
h = 'linear';
x2=x(chr(:)==1,:);
t2=t(chr(:)==1,:);
x=x(chr(:)==0,:);
t=t(chr(:)==0,:);

label=t';

if max(label)==2
    svmModel=fitcsvm(x,label,'KernelFunction',h,'Standardize',true,'ClassNames',[1 2]);
else
    class=zeros(1,max(label));
    for i=1:max(label)
        class(i)=i;
    end
    temp = templateSVM('Standardize',1,'KernelFunction',h);
    svmModel = fitcecoc(x,label,'Learners',temp,'FitPosterior',1,'ClassNames',class,'Coding','onevsall');
end
[label,~] = predict(svmModel,x2);

s=size(t2,1);
lab=t2';

c = sum(lab ~= label)/s; % mis-classification rate
%conMat = confusionmat(Y(P.test),C) % the confusion matrix
%}
performance=1-c;
%{
fprintf('Number of features - %d\n',size(x,2));
fprintf('The correct classification is %f\n',(100*performance));
%}
end