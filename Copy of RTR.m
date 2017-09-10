function  [P]=RTR()

%Create a video input object.
%clear all;

%vid = videoinput('winvideo'); %for external USB Camera
vid = videoinput('winvideo',1,'YUY2_640x480');

set(vid,'ReturnedColorSpace','rgb');
%% Create a figure window. 
hFig = figure('Toolbar','none','Menubar', 'none','NumberTitle','Off',...
    'Name','Video Capture GUI','DeleteFcn',{@deletefig_callback});
axis off;
%% Set up the push buttons
uicontrol('String', 'Start Preview','Callback',{@startpreview_callback},...
    'Units','normalized','Position',[.01 .01 0.15 .06],'Parent',hFig);

uicontrol('String', 'Stop Preview','Callback',{@stoppreview_callback},...
    'Units','normalized','Position',[.16 .01 .15 .06],'Parent',hFig);

uicontrol('String', 'Snapshot','Callback', {@snapshot_callback},...
    'Units','normalized','Position',[.32 .01 .15 .06],'Parent',hFig);

tgl = uicontrol('String','Save Images','Callback',{@saveimages_callback},...
    'Units','normalized','Position',[.48 .01 .15 .06],'Parent',hFig);

uicontrol('String','Start Capture','Callback', {@startcapture_callback},...
    'Units','normalized','Position',[.64 .01 .15 .06],'Parent',hFig);

uicontrol('String', 'Stop Capture','Callback', {@stopcapture_callback},...
    'Units','normalized','Position',[.8 .01 .15 .06],'Parent',hFig);
%% Initialization tasks
vidRes = get(vid, 'VideoResolution');
imWidth = vidRes(1);
imHeight = vidRes(2);
%  imWidth = 600;
% imHeight = 400;
nBands = get(vid, 'NumberOfBands');
hImage = image( zeros(imHeight, imWidth, nBands) );

figSize = get(hFig,'Position');
figWidth = figSize(3);
figHeight = figSize(4);

set(gca,'unit','pixels', 'position',[ ((figWidth - imWidth)/2) ((figHeight - imHeight)/2) imWidth imHeight ]);
%% Set up the update preview window function.
setappdata(hImage,'UpdatePreviewWindowFcn',@mypreview_fcn);
% v=getdata(vid);
preview(vid, hImage);
%% Utility functions for MYGUI
    function mypreview_fcn(obj,event,himage)
    % Example update preview window function.

    % Get timestamp for frame.
    tstampstr = event.Timestamp;

    % Get handle to text label uicontrol.
    ht = getappdata(himage,'HandleToTimestampLabel');

    % Set the value of the text label.
    set(ht,'String',tstampstr);

    % Display image data.
    set(himage, 'CData', event.Data)
    end
%% Callbacks for Snapshot
    function snapshot_callback(hObject, eventdata)
    hFig2 = figure('Toolbar','none','Menubar', 'none','NumberTitle','Off',...
    'Name','Snapshot');
    I= getsnapshot(vid);
    imshow(I);
    %imagesc(ycbcr2rgb(getsnapshot(vid)));
    imwrite(I,'Test.bmp');
    figure(hFig);
    end
%% Callback for SaveImages
    function saveimages_callback(hObject,eventdata)
        if 1
            addpath('.\model');
            S = load('model_param.mat');
            Model = S.Model;
            pc_version = computer();
            if(strcmp(pc_version,'PCWIN')) % currently the code just supports windows OS
                addpath('.\face_detect_32');
                addpath('.\mex_32');
            elseif(strcmp(pc_version, 'PCWIN64'))
                addpath('.\face_detect_64');
                addpath('.\mex_64');
            end
        end     
    for i=1:1
        figure('Toolbar','none','Menubar', 'none','NumberTitle','Off',...
        'Name','Snapshot','Visible','off');
        %imshow(getsnapshot(vid));
        %I=getsnapshot(vid);
       
        I =getsnapshot(vid);
        I = imrotate(I,180,'bilinear','crop');
        if 0
        %img =I(:,:,1);
        %Pose_Facial_Landmark_Fitting;
        [Model,shape,visible]=Pose_Facial_Landmark_Fitting(I(:,:,1),Model);
        %imagesc(ycbcr2rgb(I));
          imshow(I);
        hold on;
        if(~isempty(shape))
            % input: shape, visible, line_color, marker color, marker size, line width, style
            drawLine(reshape(shape,Model.nPts,2), visible, 'b', 'g', 5, 2, '.');
            hold off;
        end
        end
        

        wait(vid,.001);
        saveas(gca,['ArialPic_' int2str(i)],'bmp') ;
%        if tgl.value==0, break; end;
    end
    figure(hFig);
    end
%% Callbacks for StopPreview
    function stoppreview_callback(hObject, eventdata)
    stoppreview(vid);
    figure(hFig);
    end
%% Callback for StartPreview
    function startpreview_callback(hObject, eventdata)
    figure(hFig);
   % vid = imrotate(vid,180,'bilinear','crop');
    
    preview(vid);    
   
    end
%% Callback for StartCapture
    function startcapture_callback(hObject, eventdata)
    set(vid,'TriggerFrameDelay',3);
    set(vid,'TriggerRepeat',0);
    set(vid,'Timeout',Inf);
    set(vid,'LoggingMode','disk');
    set(vid,'FramesPerTrigger',1000000);
    aviobj = avifle('testvd.avi','compression','none', 'fps', 25, 'quality', 95);
    set(vid,'DiskLogger',aviobj);
%    vid = imrotate(vid,180,'bilinear','crop');
    start(vid);
    end
%% Callback for StopCapture
    function stopcapture_callback(hObject, eventdata)
    stop(vid);
    aviobj = close(vid.DiskLogger);
        if(exist('testvd.avi')==2)
        disp('AVI file created.')
        end
    end
%% Callback for deletefig_callback
    function deletefig_callback(hObject,eventdata)
    delete(vid);
    clear vid;
    end
end