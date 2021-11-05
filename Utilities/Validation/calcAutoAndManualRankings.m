manualIn1='D:\Min\Dropbox (Aguirre-Brainard Lab)\Quality_sorter\valdata_Individual_locs_11_19_2020\PaperRankingValidation_vFinal-Pregistered\Jessica';
manualIn2='D:\Min\Dropbox (Aguirre-Brainard Lab)\Quality_sorter\valdata_Individual_locs_11_19_2020\PaperRankingValidation_vFinal-Pregistered\YuYou';
outFile = 'D:\Min\Dropbox (Aguirre-Brainard Lab)\Quality_sorter\valdata_Individual_locs_11_19_2020\PaperRankingValidation_vFinal-Pregistered\AutoResultsCmp_12_17_2020';
manualResults1=subdir(fullfile(manualIn1,'*.mat'));
manualResults2=subdir(fullfile(manualIn2,'*.mat'));

NLoc = length(manualResults1);

allResults = cell(NLoc,9); %1-montage name, 2-locID, 3-Grader1 result, 4-Grader2 results, 5, Auto-thresh 6, Auto-percent 7Brisque 8piqe 9-Rankings

for i = 1:NLoc
    i
    currFileName1 = strsplit(manualResults1(i).name,'\');
    currFileName2 = strsplit(manualResults2(i).name,'\');
    sN = length(currFileName1);
    
    allResults{i,1} = currFileName1{sN-2};
    allResults{i,2} = currFileName1{sN-1};
    
    manRankingMtx1 = load(manualResults1(i).name);
    manRankingMtx2 = load(manualResults2(i).name);
    allResults{i,3}=manRankingMtx1;
    allResults{i,4}=manRankingMtx2;


    %send to automatic ranker the same files used by graders.
    inDir = fullfile(manualIn1,allResults{i,1},allResults{i,2});
    inImFiles = {manRankingMtx1.inFilesList.name};
    [adjMtxThresh, autoRankingsThresh, autoRevRankingsThresh, allScoresThresh] = calcAutoRankings(inDir,inImFiles,0);
    [adjMtxPrct, autoRankingsPrct, autoRevRankingsPrct, allScoresPrct] = calcAutoRankings(inDir,inImFiles,1);
    [adjMtxBrisque, autoRankingsBrisque, autoRevRankingsBrisque, allScoresBrisque] = calcAutoRankings(inDir,inImFiles,2);
    [adjMtxPIQE, autoRankingsPIQE, autoRevRankingsPIQE, allScoresPIQE] = calcAutoRankings(inDir,inImFiles,3);
    
    allResults{i,5}=adjMtxThresh;
    allResults{i,6}=adjMtxPrct;
    allResults{i,7}=adjMtxBrisque;
    allResults{i,8}=adjMtxPIQE;
    
    rN = length(inImFiles);
    currRankings=nan(rN,6);%Rankings 1-Grader1, 2-Grader2, 3-Auto-thresh, 4-Auto-percent, 5-brisque, 6-piqe

    [manRankingsBT1, revManRankingBT1]=adjMtx2Rank(manRankingMtx1.RankingMtx);
    [manRankingsBT2, revManRankingBT2]=adjMtx2Rank(manRankingMtx2.RankingMtx);
    
    currRankings(:,1)=revManRankingBT1;
    currRankings(:,2)=revManRankingBT2;
    currRankings(:,3)=autoRevRankingsThresh;
    currRankings(:,4)=autoRevRankingsPrct;
    currRankings(:,5)=autoRevRankingsBrisque;
    currRankings(:,6)=autoRevRankingsPIQE;
    
   allResults{i,9}=currRankings;
end

save(outFile,'allResults');
