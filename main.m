function []=main
tic
global x t fold;
global population rank angles ftrank;
global scale;

% list = xlsread('Data/expression_data.xlsx','data');
% list = list';
% x = list(:,1:end-1);
% t = list(:,end);

list = importdata('Data/data.mat');
x = list.data(:,1:end-1);
t = list.data(:,end);

ftrank=importdata('Data/franks.txt');

fprintf('imports done\n');

rng('shuffle');
fold = 5;
scale = 6;
n=15;
probM=0.005;

c=size(x,2);

population=datacreate(n,c);
angles = double(((pi/2.0)*scale)-(((pi/2.0)*scale).*population));
createDivision();
fprintf('data created\n');

rank=zeros(1,n);
chromosomeRank(0);
fprintf('Chromosomes ranked\n');

[~,aa]=size(x);
list=zeros(1,aa);
for i=1:aa
    list(i)=i;
end
clear aa;

fnum=2;acc=0.99;count=int16(1);
reccount=0;
if rank(1)>.93
    bound=rank(1);
else
    bound=.93;
end
%frank gives position where the features are whose rank is index
%ftrank(1)=position of feature of rank 1.
while ((sum(population(1,:)==1)>fnum || rank(1)<acc) && (count<=18))
    
    %improving the search space
    [~,c]=size(list);
    %c
    fprintf('bound is - %f\n',bound);
    if ((rank(1)>=bound && rank(2)>=bound && rank(3)>=bound && (count~=1) && (c>25)) || (reccount==0 && count==18) || (count==18 && c>15))  %to one iteration is excuted before recreation
        fprintf('Bound - %f\n',bound);
        reccount=reccount+1;
        temp=(rank(1)+rank(2)+rank(3))/3;
        [list]=recreate(n,list,reccount);
        count=1;
        if(reccount>8)
            if temp>.99
                bound=temp;
            else
                bound=.99;
            end
        elseif(reccount>6)
            if temp>.98
                bound=temp;
            else
                bound=.98;
            end
        elseif(reccount>3)
            if temp>.97
                bound=temp;
            else
                bound=.97;
            end
        end
    end
    %end of improvement
    if(count>10 && bound >= .95)
        bound=bound-.005;
    elseif(count>13 && bound >= .94)
        bound=bound-.005;
    end
    
    %local search
    fprintf('Local search done for the %d th time\n',count);
    localsearch();%local search on all chromosomes using relieff
    
    squirrel(count,probM);
    
    count=count+1;
    chromosomeRank(1);
    save('results.mat','population','rank','list');
end
val=sum(population(1,:)==1);
fprintf('The least number of features is : %d\n',val);
fprintf('The best accuracy is : %d\n',rank(1));
save('results.mat','val','population','rank','list');
toc
end

function [list]=recreate(n,list,count)
global x;
global population angles ftrank scale;
fprintf('\nPopulation recreated for - %d th time\n',count);
[r,c]=size(x);
newx=zeros(r,c);
newlist=zeros(1,c);
newweights = zeros(1,c);
j=0;
weights = zeros(1,c);
temp = 1;
for i=1:c
    weights(ftrank(i)) = temp;
    temp = temp+1;
end
%%{
%ensuring the top 10% population by relieff is always included
top=zeros(1,c);
for i = 1 : int16(c*.1)
    top(ftrank(i))=1;
end
%}
for i=1:c
    if( population(1,i)==1 || population(2,i)==1 || population(3,i)==1 )%|| top(i)==1 )
        j=j+1;
        newx(1:r,j)=x(1:r,i);
        newlist(j)=list(i);
        newweights(j) = weights(i);
    end
end
x=newx(1:r,1:j);
list=newlist(1:j);
newweights = newweights(1,1:j);
[~,ftrank] = sort(newweights); %sacending done as weights made ascending too


fprintf('New size is - %d\n',j);
population=datacreate(n,j);
angles = double(((pi/2.0)*scale)-(((pi/2.0)*scale).*population));
chromosomeRank(0);

%{
k=10;tar=t';
[ftrank,weights] = relieff(x,tar,k,'method','classification');%feature ranking
%}

%new
%count=size(list);
str=strcat('Figure',num2str(count));
disp(str);
%new ends
bar(weights(ftrank),'stacked');
xlabel('Predictor rank');
ylabel('Predictor importance weight');
title(str);
%add for correlation
clear newx r c j weights;
end

function [] = createDivision()
global t fold selection;
rows = size(t,1);
l = max(t);
selection=zeros(1,rows);
for k=1:l
    count1=sum(t(:)==k);
    samplesPerFold=int16(floor((count1/fold)));
    for j=1:fold
        count=0;
        for i=1:rows
            if(t(i)==k && selection(i)==0)
                selection(i)=j;
                count=count+1;
            end
            if(count==samplesPerFold)
                break;
            end
        end
    end
    j=1;
    for i=1:rows
        if(selection(i)==0 && t(i)==k)
            selection(i)=j;%sorts any extra into rest
            j=j+1;
        end
    end
end
end