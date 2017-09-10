% clear all
% clc
% close all

FaceDetect = vision.CascadeObjectDetector;




%crop faces
r=1;s=1;t=1;
Train_Img_Dir = 'TestDatabase\';
froot = '.';
cd TestDatabase;
list = dir(sprintf('%s\\*.jpg', '.'));
cd ..;
l =length(list);
for index = 1 : l
    fn = sprintf('%s\\%s', '.', list(index).name)
    img=imread(fullfile(Train_Img_Dir, fn));
    BB = step(FaceDetect,img);
    figure(2),imshow(img);

    for i = 1:size(BB,1)

        rectangle('Position',BB(i,:),'LineWidth',3,'LineStyle','-','EdgeColor','r');
    end    
    for i = 1:size(BB,1)
        J= imcrop(img,BB(i,:));

        J=imresize(J,[64 64]);
        if i ==1
            fileName=strcat('TrainDatabase\S1\',num2str(r),'.jpg');
            imwrite(J,fileName);
            r=r+1;
        elseif i==2
            fileName=strcat('TrainDatabase\S2\',num2str(s),'.jpg');
            imwrite(J,fileName);
            s=s+1;
        elseif i==3
            fileName=strcat('TrainDatabase\S2\',num2str(t),'.jpg');
            imwrite(J,fileName);
            t=t+1;
        end
    end
end
