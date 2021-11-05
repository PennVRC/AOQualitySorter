inDir = 'D:\Min\Dropbox (Aguirre-Brainard Lab)\Quality_sorter\TVST2021\Figure1Images';

allFiles = dir(fullfile(inDir,'*.tif'));


imIn = imread(fullfile(inDir,allFiles(1).name));
imMaskAll = imIn(:,:,2);


for f = 1:length(allFiles)

    imIn = imread(fullfile(inDir,allFiles(f).name));
    imMask = imIn(:,:,2);
    imMaskAll=imMaskAll.*imMask;
    
end

%find the inclusive bounding box
[~,vMin]=max(imMaskAll,[],2);
[~,vMax]=max(fliplr(imMaskAll),[],2);
[~,hMin]=max(imMaskAll,[],1);
[~,hMax]=max(flipud(imMaskAll),[],1);

XN = size(imMaskAll,2);
YN = size(imMaskAll,1);

xMin = median(vMin(vMin>1));
xMax = XN - median(vMax(vMax>1)) + 1;
yMin = median(hMin((hMin>1)));
yMax = YN - median(hMax(hMax>1)) + 1;

score=zeros(4,2);

outDir = 'D:\Min\Dropbox (Personal)\Research\Projects\AOQualitySorter\Utilities\Validation\fig2tif';
mkdir(outDir)

percentEdge = zeros(4,5);

for f = 1:length(allFiles)

    imIn = imread(fullfile(inDir,allFiles(f).name));
    im = imIn(yMin:yMax,xMin:xMax,1);

    imwrite(im,fullfile(outDir,['cropped_' num2str(f) '.tif']));
    
    thresh = [ .1 .15 .2 .25 .30];
    counter=0;
    for i = thresh
        counter=counter+1;
        imEdge= edge(im,'canny',i);
        percentEdge(f,counter) = sum(imEdge(:))/length(imEdge(:));
        imwrite(imEdge,fullfile(outDir,['edge_' num2str(f) '_thresh' num2str(i) '.tif']));
    end
    
    score(f,1) = EdgeQualityMeasure(im);
    score(f,2) = EdgeQualityThreshMeasure(im);
    
end

