function score = EdgeQualityThreshMeasure(im)

imCropped = cropWhiteSpace(im(:,:,1));
score = 0;
for t = 0:.005:1
    imCroppedEdge = edge(imCropped,'canny',t);
    ratio = sum(imCroppedEdge(:))/length(imCroppedEdge(:));
    if (ratio<.05)
       score=t;
       break;
    end
end
