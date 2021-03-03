function [] = refining()
%list = xlsread('Data/expression/expression_data.xlsx','data');
list = xlsread('Data/methylation/methylation.xlsx','data');
list = list';
x = list(:,1:end-1);
t = list(:,end);

disp(size(max(x)));
disp(size(min(x)));
row = size(x,1);

temp = (x - repmat(min(x),row,1))./repmat((max(x)-min(x)),row,1);
count = size(temp,2);
values = zeros(1,count);

for i=1:count
    values(1,i) = mean(temp(t==1,i))/mean(temp(t==2,i));
end
[values, index] = sort(values);
%disp(values);
plot(1:count,values);
list = [index(1:500) index(end-499:end)];
data = [x(:,list) t];
disp(size(data));
save('data.mat','data','list');
end