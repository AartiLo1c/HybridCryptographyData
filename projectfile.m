function varargout = projectfile(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @projectfile_OpeningFcn, ...
    'gui_OutputFcn',  @projectfile_OutputFcn, ...
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


% --- Executes just before projectfile is made visible.
function projectfile_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to projectfile (see VARARGIN)

% Choose default command line output for projectfile
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes projectfile wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = projectfile_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Concatenate.
function Concatenate_Callback(hObject, eventdata, handles)
% hObject    handle to Concatenate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I
User_String=get(handles.edit1,'String');
Owner_String=get(handles.edit2,'String');
value=strcat(User_String,'  ',Owner_String);

I1=ones(128,128);
position =  [8 64]; % [x y]

I = insertText(I1, position, value, 'BoxColor', 'white', 'FontSize', 21,'AnchorPoint', 'LeftBottom');
axes(handles.axes1), imshow(I), title('Concanated Input Image');
tic

% --- Executes on button press in VCS_Encrypt.
function VCS_Encrypt_Callback(hObject, eventdata, handles)
% hObject    handle to VCS_Encrypt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I share12
[share1, share2, share12] = VisCrypt(I);
axes(handles.axes2), imshow(imrotate(share1,90)), title('Share1');
axes(handles.axes3), imshow(imrotate(share2,90)), title('Share2');

save('ownerID.mat','share1');
save('clouda\ownerID.mat','share1');
save('cloudb\userID.mat','share2');
save('userID.mat','share2');

toc
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


% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
% hObject    handle to Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global I M N Iorg
[imname path] = uigetfile('*.gif;*.ppm;*.pgm;*.png;*.jpg','pick a jpge file');
imagename = strcat(path,imname);
Iorg = imread(imagename);
[M,N,ch]=size(Iorg);
M=120;
N=120;
I = imresize(Iorg, [M N]);
axes(handles.axes4), imshow(I), title('Input Image')
Iorg =I;
if ch ==3
    I=rgb2gray(I);
end

tic

% --- Executes on button press in Apply_Encrypt.
function Apply_Encrypt_Callback(hObject, eventdata, handles)
% hObject    handle to Apply_Encrypt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%global b0 r0 c0 bI rI cI
global I M N E Phi_j B SI XnplusOne r1 flk_ID maskImage
%[XnplusOne,r,M,N,flk_ID, maskImage] = Image_Encryption( I );
[E,Phi_j,B,SI,XnplusOne,r1,M,N,flk_ID, maskImage] = Image_Encryption( I,M,N);

disp(flk_ID);

axes(handles.axes5), imshow(maskImage), title('XoR Masked Image')
toc
% --- Executes on button press in Create_Key_Matrix.
function Create_Key_Matrix_Callback(hObject, eventdata, handles)
% hObject    handle to Create_Key_Matrix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global X Y Z P Q R M0 N0 flk_ID b0 r0 c0 bI rI cI EigenValues EigenVector fid Secret_Index
%               X(1)       P(1)      b0 	      bI
%       A   =   Y(1)	   Q(1)      r0           rI         (4.9)
%               Z(1)	   R(1)      c0           cI
%                M0          N0      flk_ID       0
fid = hex2dec(flk_ID);
A = [X,P,b0,bI;Y,Q,r0,rI;Z,R,c0,cI; M0,N0,fid,0];

[EigenVector, EigenValues, Secret_Index ] = Key_Encryption( A );

disp('Key MatriX Created Sucessfull')


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
tic
% --- Executes on button press in Authenicate.
function Authenicate_Callback(hObject, eventdata, handles)
% hObject    handle to Authenicate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global share12 sharedec flag URL Cloud_flk_ID flk_ID
im1=urlread(URL);
fid = fopen('test1.mat','w');
fwrite(fid,im1,'*uint8');
fclose(fid);

flag =0;
if share12 == sharedec
    msgbox('Authenication Request Sucessfully')
    if Cloud_flk_ID == flk_ID
        msgbox('Sucessfully Downloaded from Cloud Server');
    else
        msgbox('Not Sucessfully Downloaded from Cloud Server');
    end
    flag =1;
else
    msgbox('Authenication Denied')
end

% --- Executes on button press in Apply_Decrypt.
function Apply_Decrypt_Callback(hObject, eventdata, handles)
% hObject    handle to Apply_Decrypt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Cloud_flk_ID flk_ID maskImage XnplusOne r1 M N I flag EigenVector EigenValues Secret_Index Iorg

I=Iorg;
if flag==1
 
    [ A1 ] = Key_Decryption( EigenVector, EigenValues, Secret_Index );
    [ ReconstructedOutput ] = Image_Decryption( Cloud_flk_ID, flk_ID, maskImage,XnplusOne,r1,M,N);
    ReconstructedOutput1(:,:,1) = imresize(imadjust(ReconstructedOutput),[M N]);
    ReconstructedOutput1(:,:,2) = imresize(I(:,:,2),[M N]);
    ReconstructedOutput1(:,:,3) = imresize(I(:,:,3),[M N]);
    axes(handles.axes6),imshow(ReconstructedOutput1), title('Reconstructed Image');
        
    figure(10)
    imhist(uint8(I(:,:,1))),title('Original ')
    figure(11)
    imhist(ReconstructedOutput(:,:,1)),title('Reconstruct ')
else
    msgbox('Decrypted is not sucess')
end

% --- Executes on button press in Close_All.
function Close_All_Callback(hObject, eventdata, handles)
% hObject    handle to Close_All (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all


% --- Executes on button press in Owner_Share.
function Owner_Share_Callback(hObject, eventdata, handles)
% hObject    handle to Owner_Share (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ownershare
[imname path] = uigetfile('*.mat','pick a jpge file');
imagename = strcat(path,imname)
load ownerID.mat
ownershare = share1;
disp('Loaded Owner ID');

% --- Executes on button press in User_share.
function User_share_Callback(hObject, eventdata, handles)
% hObject    handle to User_share (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global usershare
%load wrongID.mat
%usershare = share1;
[imname path] = uigetfile('*.mat','pick a jpge file');
imagename = strcat(path,imname);
load userID.mat

usershare = share2;
disp('Loaded User ID');

% --- Executes on button press in VCS_Decrypt.
function VCS_Decrypt_Callback(hObject, eventdata, handles)
% hObject    handle to VCS_Decrypt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sharedec ownershare usershare
sharedec=bitor(ownershare, usershare);
disp('Decrypted VCS sucessfull ');

% --- Executes on button press in Store_Cloud.
function Store_Cloud_Callback(hObject, eventdata, handles)
% hObject    handle to Store_Cloud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global EigenValues EigenVector E Secret_Index flk_ID Cloud_flk_ID URL
save('db.mat','EigenValues','EigenVector','E','Secret_Index','flk_ID');
% Cloud Url
URL ='http://www.mathworks.com/matlabcentral/fileexchange?term=urlwrite';
urlwrite(URL,'db.mat');
Cloud_flk_ID = flk_ID;
msgbox('Sucessfully Uploaded into Cloud Server');
toc
