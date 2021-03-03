function [] = extractResults()
%EXTRACTRESULTS Summary of this function goes here
%   Detailed explanation goes here
count = 51;
choice = 1;
columns = [];
actualList = load('Data/data.mat');
actualList = actualList.list;
for i=1:count
    if choice == 1
        str = strcat('Results/expressionResults/results',num2str(i),'_noreliefF.mat');
    else
        str = strcat('Results/methylationResults/results',num2str(i),'_noreliefF.mat');
    end
    temp = load(str);
    list = temp.list;
    pop = temp.population(1,:);
    temp = list(pop(:)==1);
    temp = actualList(temp);
    columns = [columns temp];
end
a = unique(columns);
out = histc(columns,a);
genes = extractGenes(a, choice);
% disp([a',out']);
for i = 1:length(a)
    fprintf('%d,%d\n',a(i),out(i));
    %fprintf(genes{i});
    %fprintf('\n');
end
end

function [temp]=extractGenes(a, choice)
if choice == 1
    [~,list] = xlsread('Data/expression/expression_data.xlsx','gene');
else
    [~,list] = xlsread('Data/methylation/methylation.xlsx','gene');
end

temp={};
for i=1:size(a,2)
    fprintf(list{a(i)});
    fprintf('\n');
    temp={temp list{a(i)}};
end
end

