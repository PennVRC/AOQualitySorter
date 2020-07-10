function [imOut, Ymin,Ymax,Xmin,Xmax] = cropWhiteSpace(imIn)

imMaxInRows = max(imIn(:,:,1),[],2);
imMaxInCols = max(imIn(:,:,1),[],1);
Xmax = find(imMaxInCols,1,'last');
Xmin = find(imMaxInCols,1,'first');
Ymax = find(imMaxInRows,1,'last');
Ymin = find(imMaxInRows,1,'first');

imOut=imIn(Ymin:Ymax,Xmin:Xmax,:);