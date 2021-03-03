function []=frankingfile()
% x=xlsread('Data/expression_data.xlsx','data');
% tar=x(end,:);
% x=x(1:end-1,:)';
x = importdata('data.mat');
x = x.data;

tar=x(:,end);
x=x(:,1:end-1);
k=10;
[ftrank,weights] = relieff(x,tar,k,'method','classification');%feature ranking
bar(weights);
xlabel('Predictor rank');
ylabel('Predictor importance weight');
clear tar k;
fp=fopen('Data/franks.txt','w');
[~,c]=size(x);
for i=1:c
    fprintf(fp,'%d\t',ftrank(i));
    fprintf('%d\t',ftrank(i));
end
fclose(fp);
fprintf('\n');
end
