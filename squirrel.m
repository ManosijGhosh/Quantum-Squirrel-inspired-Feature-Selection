function [] = squirrel(iterCount, probM)
global population rank angles;

probPd = 0.1;
probHA = 0.5;   % probability moving towads a hickery than a acron
rng('shuffle');


fprintf('Iteration - %d\n',iterCount);

[tangles,tpopulation] = generateRatio(probM, probPd, probHA);

n = size(population,1);
trank = zeros(1,n);
for i = 1:n
    trank(1,i) = crossValidation(tpopulation(i,:));
end
%disp(angles(:,1:15));
population = [population; tpopulation];
rank = [rank trank];
angles = [angles; tangles];
chromosomeRank(1);
population = population(1:n,:);
rank = rank(1,1:n);
angles = angles(1:n,:);
end

function [tangles,tpopulation] = generateRatio(probM, probPd, probHA)
global population angles scale;
%angles = (pi/2)-((pi/2).*population);

[r,c] = size(angles);

dg = 2;
tangles = angles;
tpopulation = population;
for i=1:r
    if(rand>probPd)
        if i<4 || rand<probHA
            tangles(i,:) = tangles(i,:) + dg*(rand(1,c).*(angles(1,:)-angles(i,:)));
        else
            acorn = uint8(ceil(rand*3));
            tangles(i,:) = tangles(i,:) + dg*rand(1,c).*(angles(acorn,:)-angles(i,:));
        end
        prob = cos(tangles(i,:)./scale).^2;
        probability = rand(1,c);
        tpopulation(i,:) = prob > probability;
    else
        for j=1:c
            if (rand<probM)
                tpopulation(i,j) = 1 - tpopulation(i,j);
            end
        end
    end
end
end