function [] = extractResultsAverage()
%EXTRACTRESULTS Summary of this function goes here
%   Detailed explanation goes here
count = 51;
choice = 2;

rank = zeros(1, count);
popCount = zeros(1, count);

for i=1:count
    if choice == 1
        str = strcat('Results/expressionResults/results',num2str(i),'_noreliefF.mat');
    else
        str = strcat('Results/methylationResults/results',num2str(i),'_noreliefF.mat');
    end
    temp = load(str);
    
    %{
    rank(i) = temp.rank(1);
    popCount(i) = sum(temp.population(1,:));
    %}
    rank(i) = mean(temp.rank);
    popCount(i) = mean(sum(temp.population,2));
end
%{
temp = rank==1;
rank = rank(temp);
popCount = popCount(temp);
disp(size(rank,2));
fprintf('%f\t%f\t%f\t%f\n',mean(rank),std(rank),mean(popCount),std(popCount));
%}
for i=1:count
    fprintf('%f\t%f\n',rank(i),popCount(i));
end
end
