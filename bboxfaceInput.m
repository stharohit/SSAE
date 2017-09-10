function [] = bboxfaceInput( fin,strnum,numframes)

readerobj = VideoReader(fin, 'tag', 'myreader1');
%numframes=readerobj.NumberOfFrames;
fr=10;
P=0;

figure(1),
for j = 1:fr:numframes
   
    clear allVideoFrames;
    allVideoFrames = read(readerobj, [j j+fr-1]);
    for i = 1 :fr
        P= P+1
        I = allVideoFrames(:,:,:,i);
%         if strnum ==1
% 
%             I=imrotate(I,90);   
%            I=imresize(I,[324 256]);             
%         end
        if strnum ==4 || strnum ==3
           I=imrotate(I,90);
        end
       if strnum == 10
           I=imrotate(I,180);
       end
       if strnum == 11
           I=imrotate(I,180);
        end
       
       % I=imresize(I,[128 192]);
        detector = buildDetector();
        [bbox bbimg faces bbfaces] = detectFaceParts(detector,I,0);
        try
            if(~isempty(faces{1}))
                I = imresize(faces{1},[64 64]); %[224 224]); %
                imshow(I,[]),drawnow();
                if strnum ==0
                    dataname=strcat('./Input/data',num2str(P),'.mat');
                else                 
                    dataname=strcat('./Input',num2str(strnum),'/data',num2str(P),'.mat');
                end
                save(dataname,'I');
            end
        catch
            P=P-1;
        end
       
    end
end

end

