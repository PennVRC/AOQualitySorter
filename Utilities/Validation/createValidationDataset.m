inDirBase = 'D:\Min\Dropbox (Aguirre-Brainard Lab)\Quality_sorter\validation_data_set';
outDirBase = 'D:\Research\ResearchResults\AO\QualitySorter\PaperValidation_v2';

allDatasets = dir(fullfile(inDirBase,'*_*'));

for i = 1:length(allDatasets)
    
    outDir = fullfile(outDirBase,allDatasets(i).name);
    mkdir(outDir);
    currData = dir(fullfile(inDirBase,allDatasets(i).name,'*montage*'));
    currDir = fullfile(inDirBase,allDatasets(i).name,currData(1).name);
    currSplit = dir(fullfile(currDir,'*split*.tif'));
    
    temp = imread(fullfile(currDir,currSplit(1).name));
    AllImagesOrig=zeros(size(temp(:,:,1)));
    AllImagesCount=zeros(size(temp(:,:,1)));
    
    figure(1)
    JN = length(currSplit);
    for j = 1:JN
        im = imread(fullfile(currDir,currSplit(j).name));
        mask = im(:,:,2)>0;
        vals = im(:,:,1);
        AllImagesOrig(mask) = vals(mask);
        AllImagesCount(mask) = AllImagesCount(mask) + 1;
    end
%     
%     figure(1)
%     imshow(AllImagesCount);
     countMax = max(AllImagesCount(:));
%     caxis([0 countMax]);
%     colorbar
%     
%     for N = 5:7
%         figure(N)
%         ThreshMapN = AllImagesCount;
%         ThreshMapN(ThreshMapN~=N) = 0;
%         imshow(ThreshMapN)
%         caxis([0 countMax]);
%         colorbar
%     end
    
    
    figure(10)
    ThreshMap4 = zeros(size(AllImagesCount));
    ThreshMap4(AllImagesCount==4) = 1;
   % ThreshMap4 = imerode(ThreshMap4,strel('square',3));
    
    ThreshMap9 = zeros(size(AllImagesCount));
    ThreshMap9(AllImagesCount==9) = 1;
   % ThreshMap9 = imerode(ThreshMap9,strel('square',3));

    %ThreshMap5to7(AllImagesCount==9) = 1;
    %   ThreshMap5to7(ThreshMap5to7>7) = 0;
%    imshow(ThreshMap4)
%    caxis([0 countMax]);
%    colorbar
    
    
    %connected components seedpoints
    CC4 = bwconncomp(ThreshMap4>0);
    CC9 = bwconncomp(ThreshMap9>0);
    CCAll=[];
    CCAll.PixelIdxList=[CC9.PixelIdxList,CC4.PixelIdxList];
    CN = length(CCAll.PixelIdxList);

    CCmap = zeros(size(ThreshMap4));
    for c = 1:CN
        CCmap(CCAll.PixelIdxList{c})=c;
    end
    figure(11)
    imshow(CCmap)
    caxis([0 length(CN)])
    colormap(jet)
    colorbar
    
    %finddatagroups
    dataGroups = zeros(CN,JN);
    for j = 1:JN
        im = imread(fullfile(currDir,currSplit(j).name));
        mask = im(:,:,2);
        for c = 1:CN
            if(sum(dataGroups(c,:)) > 9)
                continue;
            end
            currLocation = CCAll.PixelIdxList{c};
            if(sum(mask(currLocation)) > 0)
                dataGroups(c,j) = 1;
                break;
            end
        end
    end
    
    %plotdatagroups
    
    for c= 1:CN
        if(sum(dataGroups(c,:)) >= 4)
            currGroupIm=zeros(size(ThreshMap4));
            currGroupImCount=zeros(size(ThreshMap4));
            
            for j = 1:JN
                if(dataGroups(c,j))
                    im = imread(fullfile(currDir,currSplit(j).name));
                    mask = im(:,:,2)>0;
                    vals = im(:,:,1);
                    currGroupIm(mask) = vals(mask);
                    currGroupImCount(mask) = currGroupImCount(mask) + 1;
                end
            end
            
            imMax = max(currGroupIm(:));
            imMaxCount = max(currGroupImCount(:));
            if(imMaxCount>=4)
            H=figure(20)
            imshow(currGroupIm);
            caxis([0 imMax]);
            colorbar
            saveas(H,fullfile(outDir,[num2str(c) '.png']))
            
            H=figure(21)
            imshow(currGroupImCount);
            caxis([0 imMaxCount]);
            colorbar
            saveas(H,fullfile(outDir,[num2str(c) '_count.png']))
            end
        end
    end
    
end
