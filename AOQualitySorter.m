function AOQualitySorter()
addpath(genpath('.'));

inDir=uigetdir('.','Select input image directory:');
if (inDir == 0)
    disp('Error: No input image path selected')   
    return
else
    disp(['Input image path selected: ' inDir])
end

outDir=uigetdir(inDir,'Select where to save sorted images:');
if (outDir == 0)
    disp('Error:No output save path selected')   
    return
else
    disp(['Output save path selected: ' outDir])
end

%Load Data and calculate edge score
AllSplit = dir(fullfile(inDir,'*split*'));
N=length(AllSplit);
score = zeros(1,N);

imMasksOverlap = cell(1,N);%This stores the mask of each image as a vector 
                            %subscript and their pairwise overlap
for i = 1:N
    disp(['Calculating quality measures: ' num2str(i) ' of ' num2str(N)])
    im = imread(fullfile(inDir,AllSplit(i).name));
    mask = im(:,:,1)<255;
    imMasksOverlap{i,i} = find(mask(:));
    score(i) = EdgeQualityMeasure(im);
    %score(i) = EdgeQualityThreshMeasure(im);
end

%calculate pair wise overlap
for i = 1:N
    disp(['Calculating pairwise overlaps: ' num2str(i) ' of ' num2str(N)])
    for j = (i+1):N
       imMasksOverlap{i,j} = intersect(imMasksOverlap{i,i},imMasksOverlap{j,j});
       imMasksOverlap{j,i} = imMasksOverlap{i,j};
    end
end    


%sort by score and dondense
I_new = CondenseOrdering(score,imMasksOverlap);

%save out new ordering
for i = 1:N
    disp(['Saving new ordering: ' num2str(i) ' of ' num2str(N)])
    fnameIn = AllSplit(I_new(i)).name;
    fnameOut = [num2str(i,'%04.f') '_' AllSplit(I_new(i)).name];
   copyfile(fullfile(inDir,fnameIn),fullfile(outDir,fnameOut));
   
   fnameIn2 = strrep(fnameIn, '_split_det_', '_avg_');
   fnameIn2 = strrep(fnameIn2, '_m2.', '_m3.');
   fnameOut2 = strrep(fnameOut, '_split_det_', '_avg_');
   fnameOut2 = strrep(fnameOut2, '_m2.', '_m3.');
   copyfile(fullfile(inDir,fnameIn2),fullfile(outDir,fnameOut2));

   fnameIn2 = strrep(fnameIn, '_split_det_', '_confocal_');
   fnameIn2 = strrep(fnameIn2, '_m2.', '_m1.');
   fnameOut2 = strrep(fnameOut, '_split_det_', '_confocal_');
   fnameOut2 = strrep(fnameOut2, '_m2.', '_m3.');
   copyfile(fullfile(inDir,fnameIn2),fullfile(outDir,fnameOut2));
end
end