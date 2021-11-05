inFile = 'D:\Min\Dropbox (Aguirre-Brainard Lab)\Quality_sorter\valdata_Individual_locs_11_19_2020\PaperRankingValidation_vFinal-Pregistered\AutoResultsCmp_12_17_2020.mat';

%correlation analysis
res = load(inFile);
N = size(res.allResults,1);
correlation=zeros(N,10); %1- G1vsG2, 2-G1vsAutoT, 3-G1vsAutoP, 4-G2vsBrisque 5-G2vsPiqe 6-G2vsAutoT, 7-G2vsAutoP, 8-G2vsBrisque 9G2vsPiqe 10-N
overalallRankings = [];

pairings=[1 1 1 1 1 2 2 2 2; ... %1- G1, 2-G2, 3-AutoT, 4-AutoP, 5-autoBrique 6-autopiqe
          2 3 4 5 6 3 4 5 6];

for i = 1:N
    
    currRankings = res.allResults{i,9};
    
    overalallRankings=[overalallRankings;currRankings];
    for j = 1:size(pairings,2)
        correlation(i,j)=corr(currRankings(:,pairings(1,j)),currRankings(:,pairings(2,j)));
    end
    correlation(i,10)=size(currRankings,1);
    
end

currRankings=overalallRankings;
overallcorrelation=zeros(1,9);

for j = 1:size(pairings,2)
    overallcorrelation(1,j)=corr(currRankings(:,pairings(1,j)),currRankings(:,pairings(2,j)));
end

accuracy=zeros(N,5,5); %Dim2 1-Total 2-True Positive 3-True Negative 4-False Positive 5-False Negative
                      %Dim3 1- G1vsG2, 2-G1vsAutoT, 3-G1vsAutoP, 4-G2vsAutoT, 5-G2vsAutoP

pairings=[3 3 3 3 3 4 4 4 4; ... %3- G1, 4-G2, 5-AutoT, 6-AutoP 7-AutoBrique 8-AutoPiqe
          4 5 6 7 8 5 6 7 8];
              
for i = 1:N
    for j = 1:size(pairings,2)
        r1 = res.allResults{i,pairings(1,j)}.RankingMtx;
        if(j==1)
            r2 = res.allResults{i,pairings(2,j)}.RankingMtx;
        else
            r2 = res.allResults{i,pairings(2,j)};
        end
        Total = 0;
        TP=0;
        TN=0;
        FP=0;
        FN=0;
        for ii = 1:length(r1)
            for jj = (ii+1):length(r1)
                
                Total = Total+1;
               if(r1(ii,jj)==1)
                   if(r2(ii,jj)==1)
                       TP=TP+1;
                   else
                       FN=FN+1; 
                   end
               elseif(r1(ii,jj)==2)
                   if(r2(ii,jj)==2)
                       TN=TN+1;
                   else
                       FP=FP+1;
                   end
               end
                   
            end
        end
        %Dim2 1-Total 2-True Positive 3-True Negative 4-False Positive
        %5-False Negative 6-Accuracy 7-Spec (TNR) 8-sensitivity (TPR)
        accuracy(i,1,j)=Total;
        accuracy(i,2,j)=TP;
        accuracy(i,3,j)=TN;
        accuracy(i,4,j)=FP;
        accuracy(i,5,j)=FN;
        accuracy(i,6,j)=(TP+TN)/Total;
        accuracy(i,7,j)=TN/(TN+FP);
        accuracy(i,8,j)=TP/(TP+FN);
        
    end
end



