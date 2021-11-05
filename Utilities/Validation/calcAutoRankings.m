function [adjMtx, rankings, revRankings, allScores] = calcAutoRankings(inDir,inImFiles,measureType)


N = length(inImFiles);
allScores=nan(1,N);
%calculate the score for each image
for i = 1:N
    im = imread(fullfile(inDir,inImFiles{i}));
    im = im(:,:,1);
    switch measureType
        case 0
            allScores(i) = EdgeQualityMeasure(im);
        case 1
            allScores(i) = EdgeQualityThreshMeasure(im);
        case 2
            allScores(i) = brisque(im);    
        case 3
            allScores(i) = piqe(im);
    end
end

%calculate the adjacency matrix
adjMtx=zeros(N,N);


for i = 1:N
    for j = (i+1):N
        if(allScores(i) > allScores(j))
            adjMtx(i,j)=1;
        else
            adjMtx(i,j)=2;
        end
    end
end



[RankingsCountSorted,rankings] = sort(allScores,'descend');

[~,revRankings] = sort(rankings);


end


