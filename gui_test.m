%{
* ---------�ļ�����gui_test.m
* ---------���ߣ� init_bin
* ---------������ 1.�����ͼƬ����ԲȦ���б��
                          2.�ɼ�ͼ����ͷ���ϸ�������RGB���ݡ�λ�ò����
                          3.���ݴ洢��excel�С�
                          4.�������Ժ��ͼƬ
* ---------���ʱ�䣺2019-7-9                                         v1
*----------�޸��˼�ʱ�䣺init_bin 2019.7.20                      v2
* ---------�޸����ݣ�1.ȥ�����ֶԻ���
                               2.���İ�ť˳�򣬽���Ҫ¼�����޵�̦�� ̦�׵ķ������
                               3.�ı��ŷ�������RGB��pointxy��score�ֱ���һ��
*----------�޸��˼�ʱ�䣺init_bin 2019.8.15                      v3           
* ---------�޸����ݣ�1.���ڽ����ʵ����󻯣�ʵ�ִ򿪺ͱ����ļ�·���ɼ���
                               2.ȥ��RGBֵ�û�ȡ��洢������������������ǣ�
                               3.̦�ں�̦������Ĭ��ֵ�����ݱ������Ժ����һ���ɼ�
                               4.����һ�����Ķಽ����
                               5.��ÿ����������������������ı�excel���ݴ�Ÿ�ʽ����score��5 335 256
                                all_score: 15
*----------�޸��˼�ʱ�䣺init_bin 2019.9.7                       v4           
* ---------�޸����ݣ�1.�Ż��洢���ݵ�excel�ķ�ʽ�����������ݷ���һ��cell���棬ÿ�д��һ������ݣ������
                                  finish_collect_Callback������ʵ����������һ�δ��롣�ٶ���ԭ����3��������0.45s
                               2.����ÿ����RGBֵ�Ĵ洢��
                               3.ʵ��allscore�ķ������������һ�У���26�С�
                               4.����ÿ������¼�ĵ���Ϊ8����
                               5.��ԭ�е���ʾ�򼯳ɵ��������Ͻǣ������Ͻǵ���ʾ��ʾ���ݡ�
                                  ���ǵ������ָ�����ͬʱ��Ȼʱ��ʾ�����ʽ��
 %}

function varargout = gui_test(varargin)
% GUI_TEST MATLAB code for gui_test.fig
%      GUI_TEST, by itself, creates a new GUI_TEST or raises the existing
%      singleton*.
%
%      H = GUI_TEST returns the handle to a new GUI_TEST or the handle to
%      the existing singleton*.
%
%      GUI_TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_TEST.M with the given input arguments.
%
%      GUI_TEST('Property','Value',...) creates a new GUI_TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_test

% Last Modified by GUIDE v2.5 08-Sep-2019 15:42:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_test_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_test_OutputFcn, ...
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


% --- Executes just before gui_test is made visible.
function gui_test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_test (see VARARGIN)

%set(hObject,'toolbar','figure') % �ڲ˵�����ʾfigure������������ 
global control_color         %����ÿ������ȡ��ʱ�в�ͬ����ɫ��ע
control_color = 0;            %ÿ�δ�һ���ļ����������Ϊ0
% Choose default command line output for gui_test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_test wait for user response (see UIRESUME)
% uiwait(handles.figure_image);


% --- Outputs from this function are returned to the command line.
function varargout = gui_test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in open_file.
function open_file_Callback(hObject, eventdata, handles)
% hObject    handle to open_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global img_src
global filename_copy
global fig_number
global Design                  %�ṹ��
global control_color         %����ÿ������ȡ��ʱ�в�ͬ����ɫ��ע

global new_open_path
old_open_path = cd;        %��ȡ��ǰ�ļ�����·��
if isempty(new_open_path)
    new_open_path = cd;   %�����·��Ϊ�գ����õ�ǰ��������·��
end
cd(new_open_path);         %����·�����Ա�uigetfile���Խ����һ�δ�ͼƬ��·��
[filename, pathname] = uigetfile({'*.bmp;*.jpg;*.png;*jpeg', 'Image Files(*.bmp,*.jpg,*.png,*jpeg)';...
    '*.*','All Files (*.*)'},'pick an image');              %��һ���Ի���
if isequal(filename,0) || isequal(pathname,0)     %���ȡ������Ӧ
    cd(old_open_path)
    return;
end
new_open_path = pathname;  %��ȡ��ͼƬ��·��
cd(old_open_path);                      %�ص�����������·������Ϊ���GUI�ϵİ�ť����Ҫ�ڴ�·���¡�    
%--------��λ��---------------------------
[Design(1).pointXY, Design(2).pointXY, Design(3).pointXY, ...
    Design(4).pointXY, Design(5).pointXY, Design(6).pointXY] = deal({});
%--------���¼��Ϊɾ��ʹ��--------------
[Design(1).circle, Design(2).circle, Design(3).circle, Design(4).circle, ...
    Design(5).circle, Design(6).circle] = deal({});
%--------����------------------------------
[Design(1).score, Design(2).score, Design(3).score, Design(4).score, ...
    Design(5).score, Design(6).score, Design(7).score, Design(8).score] = deal({});
%--------�����---------------------------
[Design(1).allscore, Design(2).allscore, Design(3).allscore, Design(4).allscore, ...
    Design(5).allscore, Design(6).allscore, Design(7).allscore, Design(8).allscore] = deal({});
%--------RGB����-------------------------
[Design(1).rgb, Design(2).rgb, Design(3).rgb, Design(4).rgb, ...
    Design(5).rgb, Design(6).rgb, Design(7).rgb, Design(8).rgb] = deal({});

set(handles.she_hong_score,'string', '');   %��һ��ͼƬ�Ժ󣬴��ֵ���
set(handles.she_zi_score,'string', '');
set(handles.she_an_score,'string', '');
set(handles.tai_bai_score,'string', 'T');
set(handles.tai_huang_score,'string', '');
set(handles.tai_hei_score,'string', 'F');
set(handles.tai_hui_score,'string', '');
set(handles.she_shen_score,'string', '');

set(handles.she_hong_allscore,'string', '');   %��һ��ͼƬ�Ժ�������ֵ���
set(handles.she_zi_allscore,'string', '');
set(handles.she_an_allscore,'string', '');
set(handles.tai_bai_allscore,'string', '');
set(handles.tai_huang_allscore,'string', '');
set(handles.tai_hei_allscore,'string', '');
set(handles.tai_hui_allscore,'string', '');
set(handles.she_shen_allscore,'string', '');
control_color = 0;                                              %��ͼƬ��Ĭ����0���
filename_copy = filename;                                %����һ���ļ���

axes(handles.axes1);                     %��axes�����趨��ǰ��������������axes1
fpath = [pathname,filename];       %���ļ�����Ŀ¼����ϳ�һ��������·��
img_src = imread(fpath);               %��imread����ͼƬ
imshow(img_src);                           %imshow��axes1����ʾ
set(handles.figure_name,'string',filename);         %����̬�ı���ֵ����ʾ��ǰͼƬ�ļ���
position = strfind(filename_copy,'-');                  %����ͼƬ�����ص��ҵ��ַ�-��λ�ã�Ϊ����ȡǰ�������
fig_number = filename_copy(1:position(1)-1);     %�õ��ļ�����ǰ�������֣���Ϊ��¼�ڼ���ͼƬ
fig_number = str2num(fig_number);                   %һ��ͼƬ���ݴ���һ��sheet���棬fig_number���ƴ����ĸ�sheet
%msgbox('��ѡ�����');                                              %���ļ�����ʾͼƬ�󵯳��Ի���
set(handles.prompt_box,'string','��ѡ�����');





% --- Executes on button press in finish_collect.
function finish_collect_Callback(hObject, eventdata, handles)
% hObject    handle to finish_collect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Design
global fig_number
global filename_copy

%tic
% first_col = {filename_copy; '����'; '���϶�';'�వ��';'̦�Ҷ�';'̦�ƶ�';'̦�ڶ�';'̦�׶�';'��  ��'};   %ÿ��sheet��Ĭ������
% try
%     xlswrite('save_data.xlsx',first_col,fig_number,'A1');                          %��Ĭ�����ݱ������Ӧ��sheet
% catch
%     msgbox('Excel�ļ����̿��ܱ�ռ�ã���ر�')
%     return
% end


%��֤�ڳ���Ϊ�գ�����Ĭ��ֵ������¡�̦����̦�׾���Ĭ��ֵ����
if isempty(Design(6).score)
    Design(6).score = [Design(6).score, 'F'];  
end
if isempty(Design(7).score)
    Design(7).score = [Design(7).score, 'T'];
end

%try--catch--end �����ݴ�����try����������������ʱ��ִ��catch�������䡣
%she_hong_data(:)'���н�cellת��һ��cell,Ȼ����ת�ó�һ��cell
try
    she_hong_data = [Design(1).score;Design(1).rgb;Design(1).pointXY];
    Design(1).data = ['����', she_hong_data(:)'];
catch
    msgbox('�������ݵ�ʹ�ָ�����ƥ�䣬�����²ɼ�');
    %set(handles.prompt_box,'string','�������ݵ�ʹ�ָ�����ƥ�䣬�����²ɼ�');
    %return;        %ֻ��������ǰ�Ŀ顣try--catch--end,�����try����ִ�С�
end

try
    she_zi_data = [Design(2).score;Design(2).rgb;Design(2).pointXY];
    Design(2).data = ['���϶�',she_zi_data(:)'];
catch
    msgbox('���϶����ݵ�ʹ�ָ�����ƥ�䣬�����²ɼ�');
end

try
    she_an_data = [Design(3).score;Design(3).rgb;Design(3).pointXY];
    Design(3).data = ['�వ��',she_an_data(:)'];
catch
    msgbox('�వ�����ݵ�ʹ�ָ�����ƥ�䣬�����²ɼ�');
end

try
    tai_hui_data = [Design(4).score;Design(4).rgb;Design(4).pointXY];
    Design(4).data = ['̦�Ҷ�',tai_hui_data(:)'];
catch
    msgbox('̦�Ҷ����ݵ�ʹ�ָ�����ƥ�䣬�����²ɼ�');
end

try
    tai_huang_data = [Design(5).score;Design(5).rgb;Design(5).pointXY];
    Design(5).data = ['̦�ƶ�',tai_huang_data(:)'];
catch
    msgbox('̦�ƶ����ݵ�ʹ�ָ�����ƥ�䣬�����²ɼ�');
end

if ~isempty(Design(6).pointXY)
    try
        tai_hei_data = [Design(6).score;Design(6).rgb;Design(6).pointXY];
        Design(6).data = ['̦�ڶ�',tai_hei_data(:)'];
    catch
        msgbox('̦�ڶ����ݵ�ʹ�ָ�����ƥ�䣬�����²ɼ�');
    end
else 
    Design(6).data = ['̦�ڶ�',Design(6).score];
end

Design(7).data = ['̦�׶�',Design(7).score];
Design(8).data = ['��  ��',Design(8).score];


first_col = {filename_copy,'Score','Rgb','Position','Score','Rgb','Position','Score','Rgb','Position','Score','Rgb','Position',...
    'Score','Rgb','Position','Score','Rgb','Position','Score','Rgb','Position','Score','Rgb','Position','AllScore'};
data = cell(9,26);
try
    for j = 1:26
        data{1,j} = first_col{1,j};
    end
    for i  = 2:9
        for j = 1:length(Design(i-1).data)
            data{i,j} = Design(i-1).data{j};
        end
        %�������ǳ�ʼ����ʱ����{}���������Ƶ�data{i,31}��Ȼ��浽excel�ᱨ��
        %���������{};�����Ǹĳ�[]��ֵ��ȥ��
        if isempty(Design(i-1).allscore)     
            Design(i-1).allscore = [];
        end
        data{i,26} = Design(i-1).allscore;
    end
    xlswrite('save_data.xlsx', data, fig_number, 'A1');
    set(handles.prompt_box,'string','���ݲɼ����');
catch
    set(handles.prompt_box,'string','excel�ļ����̿��ܱ�ռ�ã���ر�');
end
[Design(1).pointXY, Design(2).pointXY, Design(3).pointXY, ...
    Design(4).pointXY, Design(5).pointXY, Design(6).pointXY] = deal({});
[Design(1).score, Design(2).score, Design(3).score, Design(4).score, ...
    Design(5).score, Design(6).score, Design(7).score, Design(8).score] = deal({});

% [Design(1).allscore, Design(2).allscore, Design(3).allscore, Design(4).allscore, ...
%     Design(5).allscore, Design(6).allscore, Design(7).allscore, Design(8).allscore] = deal({});
%toc

% --- Executes on button press in save_figure.
function save_figure_Callback(hObject, eventdata, handles)
% hObject    handle to save_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global new_save_path
old_save_path = cd;
if isempty(new_save_path) 
    new_save_path = cd;
end
cd(new_save_path);
[filename,pathname] = uiputfile({'*.jpg', 'JPG files'; '*.bmp', 'BMP files'}, 'Pick an image');
if isequal(filename, 0) || isequal(pathname, 0)
    return;
else
    fpath = fullfile(pathname,filename);
    new_save_path = pathname;
end
cd(old_save_path);
frame = getframe(gca);                          %����������ͼ����ΪӰƬ֡
sign_image = frame2im(frame);              %�������ӰƬ֡ת��Ϊͼ������
imwrite(sign_image,fpath);                      %����ͼƬ
set(handles.prompt_box,'string','ͼƬ�������');                      %����ͼƬ�󵯳��Ի���

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure_image_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Design    %�ṹ��
global control_color
global img_src

%axis on 
if strcmp(get(hObject,'SelectionType'),'normal')  %���������
    pt = get(gca,'CurrentPoint');           %����õ����ǵ�ǰ�������λ�ã���ͼƬ���Ͻ�Ϊ���
    x = round(pt(1,1));
    y = round(pt(1,2));
    hold on                                         %�����ڵ�ǰͼ���ϲ�������ֹ����
    if  ((0<x)&&(x<5568)) && ((0<y)&&(y<3712))      %���ӵ����ͼƬ����ݴ���ÿ��ͼƬ�Ĵ�С�ǹ̶���
         r = img_src(x,y,1);                     %ȡĳһ�����괦��RGB����
         g = img_src(x,y,2);
         b = img_src(x,y,3);
         switch control_color
            case 1
                Design(1).circle = [Design(1).circle, plot(x,y,'ro','MarkerSize',3)];  %�ڵ���ĵط������Ȼ�����ɫԲȦ��
                set(handles.she_hong_score,'string', '');   %�����һ���㣬���������
                Design(1).pointXY = [Design(1).pointXY, num2str([x y])];
                Design(1).rgb = [Design(1).rgb, num2str([r g b])];
                set(handles.prompt_box,'string','����');
            case 2
                Design(2).circle = [Design(2).circle, plot(x,y,'go','MarkerSize',3)];  %�ڵ���ĵط������϶Ȼ�����ɫԲȦ.
                set(handles.she_zi_score,'string', '');
                Design(2).pointXY = [Design(2).pointXY, num2str([x y])];
                Design(2).rgb = [Design(2).rgb, num2str([r g b])];
                set(handles.prompt_box,'string','����');
            case 3
                Design(3).circle = [Design(3).circle, plot(x,y,'bo','MarkerSize',3)];  %�ڵ���ĵط����వ�Ȼ�����ɫԲȦ��
                set(handles.she_an_score,'string', '');
                Design(3).pointXY = [Design(3).pointXY, num2str([x y])];
                Design(3).rgb = [Design(3).rgb, num2str([r g b])];
                set(handles.prompt_box,'string','����');
            case 4
                Design(4).circle = [Design(4).circle, plot(x,y,'co','MarkerSize',3)];  %�ڵ���ĵط���̦�ҶȻ�����ɫԲȦ.
                set(handles.tai_hui_score,'string', '');
                Design(4).pointXY = [Design(4).pointXY, num2str([x y])];
                Design(4).rgb = [Design(4).rgb, num2str([r g b])];
                set(handles.prompt_box,'string','����');
            case 5
                Design(5).circle = [Design(5).circle, plot(x,y,'yo','MarkerSize',3)];  %�ڵ���ĵط���̦�ƶȻ�����ɫԲȦ��
                set(handles.tai_huang_score,'string', '');
                Design(5).pointXY = [Design(5).pointXY, num2str([x y])];
                Design(5).rgb = [Design(5).rgb, num2str([r g b])];
                set(handles.prompt_box,'string','����');
            case 6
                Design(6).circle = [Design(6).circle, plot(x,y,'ko','MarkerSize',3)];  %�ڵ���ĵط���̦�ڶȻ�����ɫԲȦ.
                set(handles.tai_hei_score,'string', '');
                Design(6).pointXY = [Design(6).pointXY, num2str([x y])];
                Design(6).rgb = [Design(6).rgb, num2str([r g b])];
                set(handles.prompt_box,'string','����');
            case 7                     %̦�׶Ȳ���Ҫ���
                return
            case 8                     %������Ҫ���
                 return
            case 0
                return
         end
    else
        set(handles.prompt_box,'string','�������������ѡ��');
        return
    end
elseif strcmp(get(hObject,'SelectionType'),'alt')  %�������Ҽ��������յ����һ��
    switch control_color
        case 1
            if isempty(Design(1).circle)
                set(handles.prompt_box,'string','�����Ѿ�ȫ�����أ���ֹͣ���ز���');
                return
            end
            delete(Design(1).circle(end));
            Design(1).circle(end) = [];
            if ~isempty(Design(1).pointXY)
                Design(1).pointXY(end) = [];
            end
            if ~isempty(Design(1).score)
                Design(1).score(end) = [];
            end
            if ~isempty(Design(1).rgb)
                Design(1).rgb(end) = [];
            end
        case 2
            if isempty(Design(2).circle)
                set(handles.prompt_box,'string','���϶��Ѿ�ȫ�����أ���ֹͣ���ز���');
                return
            end
            delete(Design(2).circle(end));
            Design(2).circle(end) = [];
            if ~isempty(Design(2).pointXY)
                Design(2).pointXY(end) = [];
            end
            if ~isempty(Design(2).score)
                Design(2).score(end) = [];
            end
            if ~isempty(Design(2).rgb)
                Design(2).rgb(end) = [];
            end
        case 3
            if isempty(Design(3).circle)
                set(handles.prompt_box,'string','�వ���Ѿ�ȫ�����أ���ֹͣ���ز���');
                return
            end
            delete(Design(3).circle(end));
            Design(3).circle(end) = [];
           if ~isempty(Design(3).pointXY)
                Design(3).pointXY(end) = [];
            end
            if ~isempty(Design(3).score)
                Design(3).score(end) = [];
            end
            if ~isempty(Design(3).rgb)
                Design(3).rgb(end) = [];
            end
        case 4
            if isempty(Design(4).circle)
                set(handles.prompt_box,'string','̦�Ҷ��Ѿ�ȫ�����أ���ֹͣ���ز���');
                return
            end
            delete(Design(4).circle(end));
            Design(4).circle(end) = [];
           if ~isempty(Design(4).pointXY)
                Design(4).pointXY(end) = [];
            end
            if ~isempty(Design(4).score)
                Design(4).score(end) = [];
            end
            if ~isempty(Design(4).rgb)
                Design(4).rgb(end) = [];
            end
        case 5
            if isempty(Design(5).circle)
                set(handles.prompt_box,'string','̦�ƶ��Ѿ�ȫ�����أ���ֹͣ���ز���');
                return
            end
            delete(Design(5).circle(end));
            Design(5).circle(end) = [];
           if ~isempty(Design(5).pointXY)
                Design(5).pointXY(end) = [];
            end
            if ~isempty(Design(5).score)
                Design(5).score(end) = [];
            end
            if ~isempty(Design(5).rgb)
                Design(5).rgb(end) = [];
            end
        case 6
            if isempty(Design(6).circle)
                set(handles.prompt_box,'string','̦�ڶ��Ѿ�ȫ�����أ���ֹͣ���ز���');
                return
            end
            delete(Design(6).circle(end));
            Design(6).circle(end) = [];
            if ~isempty(Design(6).pointXY)
                Design(6).pointXY(end) = [];
            end
            if ~isempty(Design(6).score)
                Design(6).score(end) = [];
            end
            if ~isempty(Design(6).rgb)
                Design(6).rgb(end) = [];
            end
        case 7
            if isempty(Design(7).score)
                set(handles.prompt_box,'string','̦�׶��Ѿ�ȫ�����أ���ֹͣ���ز���');
                return
            end
            Design(7).score(end) = []; 
        case 8
            if isempty(Design(8).score)
                set(handles.prompt_box,'string','�����Ѿ�ȫ�����أ���ֹͣ���ز���');
                return
            end
            Design(8).score(end) = [];
        case 0
            set(handles.prompt_box,'string','��δѡ�������ѡ�����г���');
            return
    end
end

% --- Executes on button press in tai_hui_button.
function tai_hui_button_Callback(hObject, eventdata, handles)
% hObject    handle to tai_hui_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global control_color
control_color = 4 ;  %�ڵ���ĵط���̦�ҶȻ�����ɫԲȦ
set(handles.prompt_box,'string','��ѡ��̦�Ҷȣ�����ͼƬ�ϵ��ѡ��');       %ѡ�����󵯳��Ի���

% --- Executes on button press in tai_hei_button.
function tai_hei_button_Callback(hObject, eventdata, handles)
% hObject    handle to tai_hei_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global control_color
control_color = 6; %�ڵ���ĵط���̦�ڶȻ�����ɫԲȦ.
set(handles.prompt_box,'string','��ѡ��̦�ڶȣ�����ͼƬ�ϵ��ѡ��');       %ѡ�����󵯳��Ի���

% --- Executes on button press in tai_huang_button.
function tai_huang_button_Callback(hObject, eventdata, handles)
% hObject    handle to tai_huang_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global control_color
control_color = 5; %�ڵ���ĵط���̦�ƶȻ�����ɫԲȦ��
set(handles.prompt_box,'string','��ѡ��̦�ƶȣ�����ͼƬ�ϵ��ѡ��');       %ѡ�����󵯳��Ի���

% --- Executes on button press in tai_bai_button.
function tai_bai_button_Callback(hObject, eventdata, handles)
% hObject    handle to tai_bai_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global control_color
control_color = 7; %�ڵ���ĵط���̦�׶Ȼ�����ɫԲȦ.
set(handles.prompt_box,'string','��ѡ��̦�׶ȣ�����ͼƬ�ϵ��ѡ��');       %ѡ�����󵯳��Ի���

% --- Executes on button press in she_an_button.
function she_an_button_Callback(hObject, eventdata, handles)
% hObject    handle to she_an_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global control_color
control_color = 3;  %�ڵ���ĵط����వ�Ȼ�����ɫԲȦ��
set(handles.prompt_box,'string','��ѡ���వ�ȣ�����ͼƬ�ϵ��ѡ��');       %ѡ�����󵯳��Ի���

% --- Executes on button press in she_zi_button.
function she_zi_button_Callback(hObject, eventdata, handles)
% hObject    handle to she_zi_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global control_color
control_color = 2; %�ڵ���ĵط������϶Ȼ�����ɫԲȦ.
set(handles.prompt_box,'string','��ѡ�����϶ȣ�����ͼƬ�ϵ��ѡ��');       %ѡ�����󵯳��Ի���

% --- Executes on button press in she_hong_button.
function she_hong_button_Callback(hObject, eventdata, handles)
% hObject    handle to she_hong_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global control_color
control_color = 1; %�ڵ���ĵط������Ȼ�����ɫԲȦ��
set(handles.prompt_box,'string','��ѡ�����ȣ�����ͼƬ�ϵ��ѡ��');       %ѡ�����󵯳��Ի���


function she_hong_score_Callback(hObject, eventdata, handles)
% hObject    handle to she_hong_score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of she_hong_score as text
%        str2double(get(hObject,'String')) returns contents of she_hong_score as a double
global Design                  %�ṹ��
str = get(hObject,'String');
Design(1).score = [Design(1).score, str];

% --- Executes during object creation, after setting all properties.
function she_hong_score_CreateFcn(hObject, eventdata, handles)
% hObject    handle to she_hong_score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function she_zi_score_Callback(hObject, eventdata, handles)
% hObject    handle to she_zi_score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of she_zi_score as text
%        str2double(get(hObject,'String')) returns contents of she_zi_score as a double
global Design                  %�ṹ��
str = get(hObject,'String');
Design(2).score = [Design(2).score, str];

% --- Executes during object creation, after setting all properties.
function she_zi_score_CreateFcn(hObject, eventdata, handles)
% hObject    handle to she_zi_score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function she_an_score_Callback(hObject, eventdata, handles)
% hObject    handle to she_an_score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of she_an_score as text
%        str2double(get(hObject,'String')) returns contents of she_an_score as a double
global Design                  %�ṹ��
str = get(hObject,'String');
Design(3).score = [Design(3).score, str];

% --- Executes during object creation, after setting all properties.
function she_an_score_CreateFcn(hObject, eventdata, handles)
% hObject    handle to she_an_score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tai_bai_score_Callback(hObject, eventdata, handles)
% hObject    handle to tai_bai_score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tai_bai_score as text
%        str2double(get(hObject,'String')) returns contents of tai_bai_score as a double
global Design                  %�ṹ��
Design(7).score = [Design(7).score, get(hObject,'String')];

% --- Executes during object creation, after setting all properties.
function tai_bai_score_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tai_bai_score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tai_huang_score_Callback(hObject, eventdata, handles)
% hObject    handle to tai_huang_score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tai_huang_score as text
%        str2double(get(hObject,'String')) returns contents of tai_huang_score as a double
global Design                  %�ṹ��
str = get(hObject,'String');
Design(5).score = [Design(5).score, str];

% --- Executes during object creation, after setting all properties.
function tai_huang_score_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tai_huang_score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tai_hei_score_Callback(hObject, eventdata, handles)
% hObject    handle to tai_hei_score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tai_hei_score as text
%        str2double(get(hObject,'String')) returns contents of tai_hei_score as a double
global Design                  %�ṹ��
Design(6).score = [Design(6).score, get(hObject,'String')];

% --- Executes during object creation, after setting all properties.
function tai_hei_score_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tai_hei_score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tai_hui_score_Callback(hObject, eventdata, handles)
% hObject    handle to tai_hui_score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tai_hui_score as text
%        str2double(get(hObject,'String')) returns contents of tai_hui_score as a double
global Design                  %�ṹ��
str = get(hObject,'String');
Design(4).score = [Design(4).score, str];

% --- Executes during object creation, after setting all properties.
function tai_hui_score_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tai_hui_score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in she_shen_button.
function she_shen_button_Callback(hObject, eventdata, handles)
% hObject    handle to she_shen_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global control_color
control_color = 8; 
set(handles.prompt_box,'string','��ѡ����������ͼƬ�ϵ��ѡ��');       %ѡ�����󵯳��Ի���

function she_shen_score_Callback(hObject, eventdata, handles)
% hObject    handle to she_shen_score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of she_shen_score as text
%        str2double(get(hObject,'String')) returns contents of she_shen_score as a double
global Design                  %�ṹ��
str = get(hObject,'String');
Design(8).score = [Design(8).score, str];

% --- Executes during object creation, after setting all properties.
function she_shen_score_CreateFcn(hObject, eventdata, handles)
% hObject    handle to she_shen_score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function she_hong_allscore_Callback(hObject, eventdata, handles)
% hObject    handle to she_hong_allscore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of she_hong_allscore as text
%        str2double(get(hObject,'String')) returns contents of she_hong_allscore as a double
global Design                  %�ṹ��
str = get(hObject,'String');
Design(1).allscore = str;

% --- Executes during object creation, after setting all properties.
function she_hong_allscore_CreateFcn(hObject, eventdata, handles)
% hObject    handle to she_hong_allscore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function she_zi_allscore_Callback(hObject, eventdata, handles)
% hObject    handle to she_zi_allscore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of she_zi_allscore as text
%        str2double(get(hObject,'String')) returns contents of she_zi_allscore as a double
global Design                  %�ṹ��
str = get(hObject,'String');
Design(2).allscore = str;

% --- Executes during object creation, after setting all properties.
function she_zi_allscore_CreateFcn(hObject, eventdata, handles)
% hObject    handle to she_zi_allscore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function she_an_allscore_Callback(hObject, eventdata, handles)
% hObject    handle to she_an_allscore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of she_an_allscore as text
%        str2double(get(hObject,'String')) returns contents of she_an_allscore as a double
global Design                  %�ṹ��
str = get(hObject,'String');
Design(3).allscore = str;

% --- Executes during object creation, after setting all properties.
function she_an_allscore_CreateFcn(hObject, eventdata, handles)
% hObject    handle to she_an_allscore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tai_bai_allscore_Callback(hObject, eventdata, handles)
% hObject    handle to tai_bai_allscore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tai_bai_allscore as text
%        str2double(get(hObject,'String')) returns contents of tai_bai_allscore as a double
global Design                  %�ṹ��
str = get(hObject,'String');
Design(7).allscore = str;

% --- Executes during object creation, after setting all properties.
function tai_bai_allscore_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tai_bai_allscore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tai_huang_allscore_Callback(hObject, eventdata, handles)
% hObject    handle to tai_huang_allscore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tai_huang_allscore as text
%        str2double(get(hObject,'String')) returns contents of tai_huang_allscore as a double
global Design                  %�ṹ��
str = get(hObject,'String');
Design(5).allscore = str;

% --- Executes during object creation, after setting all properties.
function tai_huang_allscore_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tai_huang_allscore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tai_hei_allscore_Callback(hObject, eventdata, handles)
% hObject    handle to tai_hei_allscore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tai_hei_allscore as text
%        str2double(get(hObject,'String')) returns contents of tai_hei_allscore as a double
global Design                  %�ṹ��
str = get(hObject,'String');
Design(6).allscore = str;

% --- Executes during object creation, after setting all properties.
function tai_hei_allscore_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tai_hei_allscore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tai_hui_allscore_Callback(hObject, eventdata, handles)
% hObject    handle to tai_hui_allscore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tai_hui_allscore as text
%        str2double(get(hObject,'String')) returns contents of tai_hui_allscore as a double
global Design                  %�ṹ��
str = get(hObject,'String');
Design(4).allscore = str;

% --- Executes during object creation, after setting all properties.
function tai_hui_allscore_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tai_hui_allscore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function she_shen_allscore_Callback(hObject, eventdata, handles)
% hObject    handle to she_shen_allscore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of she_shen_allscore as text
%        str2double(get(hObject,'String')) returns contents of she_shen_allscore as a double
global Design                  %�ṹ��
str = get(hObject,'String');
Design(8).allscore = str;

% --- Executes during object creation, after setting all properties.
function she_shen_allscore_CreateFcn(hObject, eventdata, handles)
% hObject    handle to she_shen_allscore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function prompt_box_Callback(hObject, eventdata, handles)
% hObject    handle to prompt_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prompt_box as text
%        str2double(get(hObject,'String')) returns contents of prompt_box as a double


% --- Executes during object creation, after setting all properties.
function prompt_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prompt_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
