clear all
clc
close all

%Training;

FaceDetect = vision.CascadeObjectDetector;


[filename, pathname] = uigetfile('*.jpg', 'Pick a test Image');
if isequal(filename,0) || isequal(pathname,0)
    disp('User pressed cancel')
else
    disp(['User selected ', fullfile(pathname, filename)])
end
imname = strcat(pathname, filename);
img =imread(imname);
BB = step(FaceDetect,img);
figure(2),imshow(img);

for i = 1:size(BB,1)
    
    rectangle('Position',BB(i,:),'LineWidth',3,'LineStyle','-','EdgeColor','r');
end

%crop faces
for i = 1:size(BB,1)
    J= imcrop(img,BB(i,:));
    if (size(J,1) <=60 && size(J,2) <=60 )
    else
        imwrite(J,strcat(num2str(i),'.jpg'));
        I=J;
        figure(11),imshow(I)
        Testing;
        pause;
    end
end

