function [RankingsBT, revRankingBT]=adjMtx2Rank(RankingMtx)

%input
%RankingMtx = adjacency matrix showing pairwise comparison
%outpu
%RankingsBT - Ranking of IDindex from best to worst
%revRankingBT - The ranking each IDindex placed.

    %Bradley and Terry model
    RankingMtx_complete = makeSym(RankingMtx);
    [Q, R] = pw_scale( RankingMtx_complete);
    [RankingsCountSortedBT,RankingsBT] = sort(Q,'descend');


    [~,revRankingBT] = sort(RankingsBT);


end