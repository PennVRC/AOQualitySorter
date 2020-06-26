function I_new = CondenseOrdering(score,imMasksOverlapFlag)

N = size(imMasksOverlapFlag,1);

%Start with descending ordering (best image has lowest index)
[B_new I_new] =sort(score,'descend');

%now we collapse the ordering to cluster local images with each other
%this preserves the relative ordering of overlapping images
for iter = 1:200
    changeFlag = 0;
    for i = 1:N
        for j = i+1:N
            if(imMasksOverlapFlag(I_new(i),I_new(j)))
                if((j-i)>4)
                    I_new = movedown(I_new,i,j);
                    changeFlag = 1;
                end
                break
            end
        end
    end
    if(~changeFlag)
        iter
        break;
    end
end

figure(7)
clf
hold on
for i = 1:N
    plot(imMasksOverlap{I_new(i),I_new(i)},i*ones(1,length(imMasksOverlap{I_new(i),I_new(i)})))
end
set(gca, 'YDir','reverse')
end

function neworder = movedown(order, iCurr,iTar)
neworder = [order(1:(iCurr-1)) order((iCurr+1):(iTar-1)) order(iCurr) order(iTar:end)];
end