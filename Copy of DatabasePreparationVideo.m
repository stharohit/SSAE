% clear all;
% clc;
% close all;
warning off;

[filename, pathname] = uigetfile('*.mp4', 'Pick a test Image');
if isequal(filename,0) || isequal(pathname,0)
    disp('User pressed cancel')
else
    disp(['User selected ', fullfile(pathname, filename)])
end
fin = strcat(pathname, filename);

readerobj = VideoReader(fin, 'tag', 'myreader1');
numframes=10;
FaceDetect = vision.CascadeObjectDetector;
fr=5;
P=0;
r=1;
for j = 1:fr:numframes
    clear allVideoFrames;
    allVideoFrames = read(readerobj, [j j+fr-1]);
    for i = 1 :fr
        i
        P= P+1;
        I = allVideoFrames(:,:,:,i);
        %   detector = buildDetector();
        %  [bbox bbimg faces bbfaces] = detectFaceParts(detector,I,0);
        BB = step(FaceDetect,I);
        figure(11),imshow(I);
        
        for i = 1:size(BB,1)
            
            rectangle('Position',BB(i,:),'LineWidth',3,'LineStyle','-','EdgeColor','r');
        end
        for i = 1:size(BB,1)
            J= imcrop(I,BB(i,:));
            J=imresize(J,[64 64]);
            %fileName=strcat('TestVideoDatabase\S1\',num2str(r),'.jpg');
            fileName =strcat('TestDatabase\',num2str(r),'.jpg');
            imwrite(J,fileName);
            r=r+1;
        end
        
    end
end
%implay(fin);
disp('Finished')