inDirBase = 'D:\Min\Dropbox (Aguirre-Brainard Lab)\Quality_sorter\validation_data_set';
resDirBase = 'D:\Min\Dropbox (Aguirre-Brainard Lab)\Quality_sorter\valdata_Individual_locs_11_19_2020\PaperValidation_v4\';

resSub= dir(fullfile(resDirBase,'*_*'))

for r = 1%:length(resSub)
    currDir = fullfile(resDirBase,resSub(r).name);
    locSub = dir(currDir);
    
    for L = 3:length(locSub)
        currLoc=fullfile(currDir,locSub(L).name);
        if(isfolder(currLoc))
            
            imFiles = dir(fullfile(currLoc,'*.tif'));
            newOverlap = 1;
            for f= 1:length(imFiles)
                tempDir = dir(fullfile(inDirBase,resSub(r).name));
                im = imread(fullfile(inDirBase,resSub(r).name,tempDir(3).name,imFiles(f).name));
                if(newOverlap)
                    AllImagesOrig=zeros(size(im(:,:,1)));
                    AllImagesCount=zeros(size(im(:,:,1)));
                    newOverlap=0;
                end
                mask = im(:,:,2)>0;
                vals = im(:,:,1);
                AllImagesOrig(mask) = vals(mask);
                AllImagesCount(mask) = AllImagesCount(mask) + 1;
            end
            
            H=figure(1)
            imshow(AllImagesCount);
            countMax = max(AllImagesCount(:));
            caxis([0 countMax]);
            colorbar
            
            
            
            saveas(H,fullfile(currDir,[locSub(L).name '.png']))
            
        end
        
    end
    
end