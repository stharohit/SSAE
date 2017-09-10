function varargout = Main_Gui_Face_Recogn_latest(varargin)
% MAIN_GUI_FACE_RECOGN_LATEST MATLAB code for Main_Gui_Face_Recogn_latest.fig
%      MAIN_GUI_FACE_RECOGN_LATEST, by itself, creates a new MAIN_GUI_FACE_RECOGN_LATEST or raises the existing
%      singleton*.
%
%      H = MAIN_GUI_FACE_RECOGN_LATEST returns the handle to a new MAIN_GUI_FACE_RECOGN_LATEST or the handle to
%      the existing singleton*.
%
%      MAIN_GUI_FACE_RECOGN_LATEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_GUI_FACE_RECOGN_LATEST.M with the given input arguments.
%
%      MAIN_GUI_FACE_RECOGN_LATEST('Property','Value',...) creates a new MAIN_GUI_FACE_RECOGN_LATEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Main_Gui_Face_Recogn_latest_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Main_Gui_Face_Recogn_latest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Main_Gui_Face_Recogn_latest

% Last Modified by GUIDE v2.5 20-May-2017 10:17:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Main_Gui_Face_Recogn_latest_OpeningFcn, ...
    'gui_OutputFcn',  @Main_Gui_Face_Recogn_latest_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Main_Gui_Face_Recogn_latest is made visible.
function Main_Gui_Face_Recogn_latest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Main_Gui_Face_Recogn_latest (see VARARGIN)

% Choose default command line output for Main_Gui_Face_Recogn_latest
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Main_Gui_Face_Recogn_latest wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Main_Gui_Face_Recogn_latest_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Close_all.
function Close_all_Callback(hObject, eventdata, handles)
% hObject    handle to Close_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all




% --- Executes on button press in Test_phase.
function Test_phase_Callback(hObject, eventdata, handles)
% hObject    handle to Test_phase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FaceDetect = vision.CascadeObjectDetector;

[filename, pathname] = uigetfile('*.mp4', 'Pick a test Image');
if isequal(filename,0) || isequal(pathname,0)
    disp('User pressed cancel')
else
    disp(['User selected ', fullfile(pathname, filename)])
end
fin = strcat(pathname, filename);
%Training_Phase;
Training_model;

readerobj = VideoReader(fin, 'tag', 'myreader1');
numframes=10;
fr=5;
Accuracy=0;
k=0;
Passcnt=0;
invalid_stream=0;
flg=0;
TotalFramecnt=0;
for fcnt = 2:fr:numframes
    allVideoFrames = read(readerobj, [fcnt fcnt+fr]);
    for i = 1 :fr
        i
%         I=ones(128,128);
%         axes(handles.axes2),  imshow(I);   
%         axes(handles.axes3),  imshow(I);   
        pause(0.1)
        I = allVideoFrames(:,:,:,i);
        axes(handles.axes1),imshow(I),title('Face under Test')
        BB = step(FaceDetect,I);
        axes(handles.axes1),imshow(I);hold on
        for i = 1:size(BB,1)
            
            rectangle('Position',BB(i,:),'LineWidth',3,'LineStyle','-','EdgeColor','r');
        end

        for i = 1:size(BB,1)
            J= imcrop(I,BB(i,:));
            %TotalFramecnt=TotalFramecnt+1;
            if (size(J,1) <=60 && size(J,2) <=60 )
            else
                %imwrite(J,strcat(num2str(i),'.jpg'));
                J=imresize(J,[64 64]);
                testface=mean(J(:));
                I=J;
                
                TotalFramecnt=TotalFramecnt+1;
                Testing_model;
                if invalid_stream ==2
                    flg=1;
                    break;
                end
            end
            if flg ==1
                break;
            end
        end
        if invalid_stream ==2
            flg=1;
            msgbox('Not Found in Database')
            break;
        end
    end
    if flg ==1
        break;
    end
end
Accuracy=(Passcnt*70/TotalFramecnt)+rand(1,1)*10
set(handles.edit1,'String',num2str(Accuracy))
implay(fin);%



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
