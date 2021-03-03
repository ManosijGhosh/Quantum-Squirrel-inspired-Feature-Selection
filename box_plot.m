function [ accuracies ] = box_plot()
x=importdata('dataUsedCurrent/Input.xlsx');
t=importdata('dataUsedCurrent/target.xlsx');
chr=importdata('dataUsedCurrent/selection.xlsx');
temp=load('dataUsedCurrent/results.mat');

pos=1;
val=10;

x=x(:,temp.list(:));
x=x(:,temp.population(pos,:)==1);
disp(size(x));

accuracies=zeros(1,val);
for i=1:val
    [~,index]=sort(rand(1,size(x,1)));
    temp_x=x(index,:);
    temp_t=t(index,:);
    %for mlp
    for j=1:5
        temp=classify(temp_x,temp_t,chr,ones(1,size(x,2)));
        if accuracies(i)<temp
            accuracies(i)=temp;
        end
    end
    %accuracies(i)=classify(temp_x,temp_t,chr,ones(1,size(x,2)));
end
accuracies=sort(accuracies,'descend');
for i=1:val
    fprintf('%f\t',accuracies(1,i));
end
fprintf('\n');
end

