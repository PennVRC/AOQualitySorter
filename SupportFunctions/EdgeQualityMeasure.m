function score = EdgeQualityMeasure(im)

imCropped = cropWhiteSpace(im(:,:,1));
imCroppedEdge = edge(imCropped,'canny',.15);
score = sum(imCroppedEdge(:))/length(imCroppedEdge(:));