inDir = 'D:\Research\ResearchResults\AO\QualitySorter\Data\13125_OD_20150312';
outDir = 'D:\Research\ResearchResults\AO\QualitySorter\Data\13125_OD_20150312_clean';
mkdir(outDir);


AllImages = dir(fullfile(inDir,'*.tif'));

for i = 1: length(AllImages)
 
fnameIn = AllImages(i).name;
fnameInParts = strsplit(fnameIn,'_');
startIdx = find(strcmp(fnameInParts,'CH'));
endIdx = find(strcmp(fnameInParts,'cropped'));
fnameOut = strjoin(fnameInParts(startIdx:endIdx),'_');
copyfile(fullfile(inDir,fnameIn),fullfile(outDir,[fnameOut '.tif']));

end