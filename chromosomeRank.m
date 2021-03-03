function []=chromosomeRank(flag)
global population rank angles;
rng('shuffle');
[r,~]=size(population);

if flag==0
    for i=1:r
        rank(i)=crossValidation(population(i,:));
    end
end

temp = sum(population,2);
temp= (size(population,2)-temp)./size(population,2);
temp = (rank.*1000) + temp';

[~,temp] = sort(temp,'descend');

rank = rank(temp);
population = population(temp,:);
angles = angles(temp,:);

fprintf('\nPopulation now - \n');
for i=1:r
    fprintf('R - %f\tnum- %d\n',rank(i),sum(population(i,:)));
end
fprintf('\n');
end
