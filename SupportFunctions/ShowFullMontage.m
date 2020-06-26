temp = imread(fullfile(inDir,AllSplit(1).name));
AllImagesOrig=zeros(size(temp(:,:,1)));
AllImagesSorted=zeros(size(temp(:,:,1)));

figure(1)
for i = N:-1:1
    im = imread(fullfile(inDir,AllSplit(i).name));
    mask = im(:,:,1)<255;
    vals = im(:,:,1);
    AllImagesOrig(mask) = vals(mask);
end

imshow(AllImagesOrig)
caxis([0 255])

figure(2)
for i = N:-1:1
    im = imread(fullfile(inDir,AllSplit(I_new(i)).name));
    mask = im(:,:,1)<255;
    vals = im(:,:,1);
    AllImagesSorted(mask) = vals(mask);
end

imshow(AllImagesSorted)
caxis([0 255])