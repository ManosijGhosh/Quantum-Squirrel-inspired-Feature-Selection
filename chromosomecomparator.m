%0 if equal, +1 if first is better, -1 if second is better than first, 
function [val]=chromosomecomparator(ch1,r1,ch2,r2)
[~,c]=size(ch1);
count1=(sum(ch1==0));
count2=(sum(ch2==0));
if count1==c%zero selected features are not allowed
    val=-1;
elseif count2==c
    val=1;
else
    w1=1;w2=1000;%weigths we assign to 1-number of features,2-accuracy
    count1=count1/c;%ratio of features not used
    count2=count2/c;
    val=((w1*count1)+(w2*r1))-((w1*count2)+(w2*r2));
    if val>0
        val=1;
    elseif val<0
        val=-1;
    end
end
end