%%%%%%%
% Hello SLaM 
% Essential & Camera Pose Extraction
% This part is going to extract the Essential matrices and Camera Pose
% matrices between two neighbor frames.
%%%%%%%

%%
clear;
clc;

%% Preprocessing
% Note that the default cameraParams are iPhone 8 Plus's since the data
% were collected by iPhone 8 Plus camera.
load('cameraParams.mat');
dList = dir('../../data1/rgb/*.pgm');
features = cell(2,length(dList));
validPts = cell(1,length(dList));
essential = cell(1,length(dList)-1);
RT = cell(1,length(dList)-1);
inliers = cell(1,length(dList)-1);

%% Extract Feature Points
for i = 1:length(dList)
    tic
    im = imread(fullfile(dList(i).folder,dList(i).name));
    features{1,i} = detectSURFFeatures(im);
    features{2,i} = extractFeatures(im,features{1,i});
    toc
end

%% Estimate Essential Matrix and Camera Pose Matrix
for i = 1:length(dList)-1
    indexPairs = matchFeatures(features{2,i},features{2,i+1});
    matchedPoints1 = features{1,i}(indexPairs(:,1));
    matchedPoints2 = features{1,i+1}(indexPairs(:,2));
    % Firstly, find essential matrices
    [essential{i},inliers] = estimateEssentialMatrix(matchedPoints1,matchedPoints2,cameraParams);
    % Secondly, find camera pose matrices
    inlierPoints1 = matchedPoints1(inliers);
    inlierPoints2 = matchedPoints2(inliers);
    [relativeOrientation,relativeLocation] = relativeCameraPose(essential{i},cameraParams,inlierPoints1,inlierPoints2);
    [rotationMatrix,translationVector] = cameraPoseToExtrinsics(relativeOrientation,relativeLocation);
    RT{i} = [rotationMatrix,translationVector'];
    tx = translationVector;
    tx = [    0 , -tx(3),  tx(2);
           tx(3),     0 , -tx(1);
    	  -tx(2),  tx(1),     0 ];
    essential{i} = rotationMatrix * tx;
end

%% Save 2 results
save('RT.mat','RT');
save('essential.mat','essential');