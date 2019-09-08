%{
* ---------文件名：gui_test.m
* ---------作者： init_bin
* ---------描述： 1.鼠标点击图片，以圆圈进行标记
                          2.采集图像（舌头）上各个类别的RGB数据、位置并打分
                          3.数据存储到excel中。
                          4.保存标记以后的图片
* ---------完成时间：2019-7-9                                         v1
*----------修改人及时间：init_bin 2019.7.20                      v2
* ---------修改内容：1.去除请打分对话框
                               2.更改按钮顺序，将需要录入有无的苔黑 苔白的放在最后
                               3.改变存放方法，将RGB、pointxy、score分别存放一格
*----------修改人及时间：init_bin 2019.8.15                      v3           
* ---------修改内容：1.窗口界面可实现最大化，实现打开和保存文件路径可记忆
                               2.去除RGB值得获取与存储，增加舌神打分项（不须标记）
                               3.苔黑和苔白设置默认值，数据标记完成以后进行一键采集
                               4.增加一个类别的多步撤回
                               5.在每个类别后面增加整体评分项，改变excel数据存放格式：例score：5 335 256
                                all_score: 15
*----------修改人及时间：init_bin 2019.9.7                       v4           
* ---------修改内容：1.优化存储数据到excel的方式，将所有数据放在一个cell里面，每行存放一类的数据，具体见
                                  finish_collect_Callback函数，实现所有数据一次存入。速度由原来的3秒提升到0.45s
                               2.增加每个点RGB值的存储。
                               3.实现allscore的分数都放在最后一列，第26列。
                               4.设置每类最大记录的点数为8个。
                               5.将原有的提示框集成到界面右上角，在右上角的显示提示内容。
                                  但是点数与打分个数不同时仍然时提示框的形式。
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

%set(hObject,'toolbar','figure') % 在菜单栏显示figure工具条的内容 
global control_color         %控制每个类型取点时有不同的颜色标注
control_color = 0;            %每次打开一个文件，控制类别为0
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
global Design                  %结构体
global control_color         %控制每个类型取点时有不同的颜色标注

global new_open_path
old_open_path = cd;        %获取当前文件所处路径
if isempty(new_open_path)
    new_open_path = cd;   %如果新路径为空，则获得当前程序所处路径
end
cd(new_open_path);         %更新路径，以便uigetfile可以进入第一次打开图片的路径
[filename, pathname] = uigetfile({'*.bmp;*.jpg;*.png;*jpeg', 'Image Files(*.bmp,*.jpg,*.png,*jpeg)';...
    '*.*','All Files (*.*)'},'pick an image');              %打开一个对话框
if isequal(filename,0) || isequal(pathname,0)     %点击取消的响应
    cd(old_open_path)
    return;
end
new_open_path = pathname;  %获取打开图片的路径
cd(old_open_path);                      %回到程序所处的路径，因为点击GUI上的按钮，需要在此路径下。    
%--------点位置---------------------------
[Design(1).pointXY, Design(2).pointXY, Design(3).pointXY, ...
    Design(4).pointXY, Design(5).pointXY, Design(6).pointXY] = deal({});
%--------点记录，为删除使用--------------
[Design(1).circle, Design(2).circle, Design(3).circle, Design(4).circle, ...
    Design(5).circle, Design(6).circle] = deal({});
%--------分数------------------------------
[Design(1).score, Design(2).score, Design(3).score, Design(4).score, ...
    Design(5).score, Design(6).score, Design(7).score, Design(8).score] = deal({});
%--------整体分---------------------------
[Design(1).allscore, Design(2).allscore, Design(3).allscore, Design(4).allscore, ...
    Design(5).allscore, Design(6).allscore, Design(7).allscore, Design(8).allscore] = deal({});
%--------RGB数据-------------------------
[Design(1).rgb, Design(2).rgb, Design(3).rgb, Design(4).rgb, ...
    Design(5).rgb, Design(6).rgb, Design(7).rgb, Design(8).rgb] = deal({});

set(handles.she_hong_score,'string', '');   %打开一张图片以后，打分值清除
set(handles.she_zi_score,'string', '');
set(handles.she_an_score,'string', '');
set(handles.tai_bai_score,'string', 'T');
set(handles.tai_huang_score,'string', '');
set(handles.tai_hei_score,'string', 'F');
set(handles.tai_hui_score,'string', '');
set(handles.she_shen_score,'string', '');

set(handles.she_hong_allscore,'string', '');   %打开一张图片以后，整体打分值清除
set(handles.she_zi_allscore,'string', '');
set(handles.she_an_allscore,'string', '');
set(handles.tai_bai_allscore,'string', '');
set(handles.tai_huang_allscore,'string', '');
set(handles.tai_hei_allscore,'string', '');
set(handles.tai_hui_allscore,'string', '');
set(handles.she_shen_allscore,'string', '');
control_color = 0;                                              %打开图片后默认是0类别
filename_copy = filename;                                %拷贝一份文件名

axes(handles.axes1);                     %用axes命令设定当前操作的坐标轴是axes1
fpath = [pathname,filename];       %将文件名和目录名组合成一个完整的路径
img_src = imread(fpath);               %用imread读入图片
imshow(img_src);                           %imshow在axes1上显示
set(handles.figure_name,'string',filename);         %给静态文本赋值，显示当前图片文件名
position = strfind(filename_copy,'-');                  %根据图片命名特点找到字符-的位置，为了提取前面的数字
fig_number = filename_copy(1:position(1)-1);     %得到文件名的前几个数字，作为记录第几张图片
fig_number = str2num(fig_number);                   %一幅图片数据存在一个sheet里面，fig_number控制存在哪个sheet
%msgbox('请选择类别');                                              %打开文件并显示图片后弹出对话框
set(handles.prompt_box,'string','请选择类别');





% --- Executes on button press in finish_collect.
function finish_collect_Callback(hObject, eventdata, handles)
% hObject    handle to finish_collect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Design
global fig_number
global filename_copy

%tic
% first_col = {filename_copy; '舌红度'; '舌紫度';'舌暗度';'苔灰度';'苔黄度';'苔黑度';'苔白度';'舌  神'};   %每个sheet的默认数据
% try
%     xlswrite('save_data.xlsx',first_col,fig_number,'A1');                          %将默认数据保存进对应的sheet
% catch
%     msgbox('Excel文件进程可能被占用，请关闭')
%     return
% end


%保证在撤销为空，或者默认值的情况下。苔黑与苔白均是默认值保存
if isempty(Design(6).score)
    Design(6).score = [Design(6).score, 'F'];  
end
if isempty(Design(7).score)
    Design(7).score = [Design(7).score, 'T'];
end

%try--catch--end 增加容错处理，当try里面的语句出现问题的时候，执行catch里面的语句。
%she_hong_data(:)'按列将cell转成一列cell,然后在转置成一行cell
try
    she_hong_data = [Design(1).score;Design(1).rgb;Design(1).pointXY];
    Design(1).data = ['舌红度', she_hong_data(:)'];
catch
    msgbox('舌红度数据点和打分个数不匹配，请重新采集');
    %set(handles.prompt_box,'string','舌红度数据点和打分个数不匹配，请重新采集');
    %return;        %只是跳出当前的块。try--catch--end,后面的try还会执行。
end

try
    she_zi_data = [Design(2).score;Design(2).rgb;Design(2).pointXY];
    Design(2).data = ['舌紫度',she_zi_data(:)'];
catch
    msgbox('舌紫度数据点和打分个数不匹配，请重新采集');
end

try
    she_an_data = [Design(3).score;Design(3).rgb;Design(3).pointXY];
    Design(3).data = ['舌暗度',she_an_data(:)'];
catch
    msgbox('舌暗度数据点和打分个数不匹配，请重新采集');
end

try
    tai_hui_data = [Design(4).score;Design(4).rgb;Design(4).pointXY];
    Design(4).data = ['苔灰度',tai_hui_data(:)'];
catch
    msgbox('苔灰度数据点和打分个数不匹配，请重新采集');
end

try
    tai_huang_data = [Design(5).score;Design(5).rgb;Design(5).pointXY];
    Design(5).data = ['苔黄度',tai_huang_data(:)'];
catch
    msgbox('苔黄度数据点和打分个数不匹配，请重新采集');
end

if ~isempty(Design(6).pointXY)
    try
        tai_hei_data = [Design(6).score;Design(6).rgb;Design(6).pointXY];
        Design(6).data = ['苔黑度',tai_hei_data(:)'];
    catch
        msgbox('苔黑度数据点和打分个数不匹配，请重新采集');
    end
else 
    Design(6).data = ['苔黑度',Design(6).score];
end

Design(7).data = ['苔白度',Design(7).score];
Design(8).data = ['舌  神',Design(8).score];


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
        %由于我们初始化的时候是{}，这样复制到data{i,31}，然后存到excel会报错。
        %所以如果是{};则我们改成[]赋值过去。
        if isempty(Design(i-1).allscore)     
            Design(i-1).allscore = [];
        end
        data{i,26} = Design(i-1).allscore;
    end
    xlswrite('save_data.xlsx', data, fig_number, 'A1');
    set(handles.prompt_box,'string','数据采集完毕');
catch
    set(handles.prompt_box,'string','excel文件进程可能被占用，请关闭');
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
frame = getframe(gca);                          %捕获坐标区图像作为影片帧
sign_image = frame2im(frame);              %将捕获的影片帧转换为图像数据
imwrite(sign_image,fpath);                      %保存图片
set(handles.prompt_box,'string','图片保存完成');                      %保存图片后弹出对话框

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure_image_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Design    %结构体
global control_color
global img_src

%axis on 
if strcmp(get(hObject,'SelectionType'),'normal')  %点击鼠标左键
    pt = get(gca,'CurrentPoint');           %这个得到就是当前鼠标点击的位置，以图片左上角为零点
    x = round(pt(1,1));
    y = round(pt(1,2));
    hold on                                         %保持在当前图像上操作，防止覆盖
    if  ((0<x)&&(x<5568)) && ((0<y)&&(y<3712))      %增加点击在图片外的容错处理，每张图片的大小是固定的
         r = img_src(x,y,1);                     %取某一点坐标处的RGB数据
         g = img_src(x,y,2);
         b = img_src(x,y,3);
         switch control_color
            case 1
                Design(1).circle = [Design(1).circle, plot(x,y,'ro','MarkerSize',3)];  %在点击的地方，舌红度画出红色圆圈。
                set(handles.she_hong_score,'string', '');   %点击下一个点，分数框清空
                Design(1).pointXY = [Design(1).pointXY, num2str([x y])];
                Design(1).rgb = [Design(1).rgb, num2str([r g b])];
                set(handles.prompt_box,'string','请打分');
            case 2
                Design(2).circle = [Design(2).circle, plot(x,y,'go','MarkerSize',3)];  %在点击的地方，舌紫度画出绿色圆圈.
                set(handles.she_zi_score,'string', '');
                Design(2).pointXY = [Design(2).pointXY, num2str([x y])];
                Design(2).rgb = [Design(2).rgb, num2str([r g b])];
                set(handles.prompt_box,'string','请打分');
            case 3
                Design(3).circle = [Design(3).circle, plot(x,y,'bo','MarkerSize',3)];  %在点击的地方，舌暗度画出蓝色圆圈。
                set(handles.she_an_score,'string', '');
                Design(3).pointXY = [Design(3).pointXY, num2str([x y])];
                Design(3).rgb = [Design(3).rgb, num2str([r g b])];
                set(handles.prompt_box,'string','请打分');
            case 4
                Design(4).circle = [Design(4).circle, plot(x,y,'co','MarkerSize',3)];  %在点击的地方，苔灰度画出青色圆圈.
                set(handles.tai_hui_score,'string', '');
                Design(4).pointXY = [Design(4).pointXY, num2str([x y])];
                Design(4).rgb = [Design(4).rgb, num2str([r g b])];
                set(handles.prompt_box,'string','请打分');
            case 5
                Design(5).circle = [Design(5).circle, plot(x,y,'yo','MarkerSize',3)];  %在点击的地方，苔黄度画出黄色圆圈。
                set(handles.tai_huang_score,'string', '');
                Design(5).pointXY = [Design(5).pointXY, num2str([x y])];
                Design(5).rgb = [Design(5).rgb, num2str([r g b])];
                set(handles.prompt_box,'string','请打分');
            case 6
                Design(6).circle = [Design(6).circle, plot(x,y,'ko','MarkerSize',3)];  %在点击的地方，苔黑度画出黑色圆圈.
                set(handles.tai_hei_score,'string', '');
                Design(6).pointXY = [Design(6).pointXY, num2str([x y])];
                Design(6).rgb = [Design(6).rgb, num2str([r g b])];
                set(handles.prompt_box,'string','请打分');
            case 7                     %苔白度不需要点击
                return
            case 8                     %舌神不需要点击
                 return
            case 0
                return
         end
    else
        set(handles.prompt_box,'string','点击错误，请重新选择');
        return
    end
elseif strcmp(get(hObject,'SelectionType'),'alt')  %点击鼠标右键，消除刚点的那一点
    switch control_color
        case 1
            if isempty(Design(1).circle)
                set(handles.prompt_box,'string','舌红度已经全部撤回，请停止撤回操作');
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
                set(handles.prompt_box,'string','舌紫度已经全部撤回，请停止撤回操作');
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
                set(handles.prompt_box,'string','舌暗度已经全部撤回，请停止撤回操作');
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
                set(handles.prompt_box,'string','苔灰度已经全部撤回，请停止撤回操作');
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
                set(handles.prompt_box,'string','苔黄度已经全部撤回，请停止撤回操作');
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
                set(handles.prompt_box,'string','苔黑度已经全部撤回，请停止撤回操作');
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
                set(handles.prompt_box,'string','苔白度已经全部撤回，请停止撤回操作');
                return
            end
            Design(7).score(end) = []; 
        case 8
            if isempty(Design(8).score)
                set(handles.prompt_box,'string','舌神已经全部撤回，请停止撤回操作');
                return
            end
            Design(8).score(end) = [];
        case 0
            set(handles.prompt_box,'string','尚未选择类别，请选择后进行撤回');
            return
    end
end

% --- Executes on button press in tai_hui_button.
function tai_hui_button_Callback(hObject, eventdata, handles)
% hObject    handle to tai_hui_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global control_color
control_color = 4 ;  %在点击的地方，苔灰度画出青色圆圈
set(handles.prompt_box,'string','已选择苔灰度，请在图片上点击选择');       %选好类别后弹出对话框

% --- Executes on button press in tai_hei_button.
function tai_hei_button_Callback(hObject, eventdata, handles)
% hObject    handle to tai_hei_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global control_color
control_color = 6; %在点击的地方，苔黑度画出黑色圆圈.
set(handles.prompt_box,'string','已选择苔黑度，请在图片上点击选择');       %选好类别后弹出对话框

% --- Executes on button press in tai_huang_button.
function tai_huang_button_Callback(hObject, eventdata, handles)
% hObject    handle to tai_huang_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global control_color
control_color = 5; %在点击的地方，苔黄度画出黄色圆圈。
set(handles.prompt_box,'string','已选择苔黄度，请在图片上点击选择');       %选好类别后弹出对话框

% --- Executes on button press in tai_bai_button.
function tai_bai_button_Callback(hObject, eventdata, handles)
% hObject    handle to tai_bai_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global control_color
control_color = 7; %在点击的地方，苔白度画出白色圆圈.
set(handles.prompt_box,'string','已选择苔白度，请在图片上点击选择');       %选好类别后弹出对话框

% --- Executes on button press in she_an_button.
function she_an_button_Callback(hObject, eventdata, handles)
% hObject    handle to she_an_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global control_color
control_color = 3;  %在点击的地方，舌暗度画出蓝色圆圈。
set(handles.prompt_box,'string','已选择舌暗度，请在图片上点击选择');       %选好类别后弹出对话框

% --- Executes on button press in she_zi_button.
function she_zi_button_Callback(hObject, eventdata, handles)
% hObject    handle to she_zi_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global control_color
control_color = 2; %在点击的地方，舌紫度画出绿色圆圈.
set(handles.prompt_box,'string','已选择舌紫度，请在图片上点击选择');       %选好类别后弹出对话框

% --- Executes on button press in she_hong_button.
function she_hong_button_Callback(hObject, eventdata, handles)
% hObject    handle to she_hong_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global control_color
control_color = 1; %在点击的地方，舌红度画出红色圆圈。
set(handles.prompt_box,'string','已选择舌红度，请在图片上点击选择');       %选好类别后弹出对话框


function she_hong_score_Callback(hObject, eventdata, handles)
% hObject    handle to she_hong_score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of she_hong_score as text
%        str2double(get(hObject,'String')) returns contents of she_hong_score as a double
global Design                  %结构体
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
global Design                  %结构体
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
global Design                  %结构体
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
global Design                  %结构体
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
global Design                  %结构体
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
global Design                  %结构体
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
global Design                  %结构体
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
set(handles.prompt_box,'string','已选择舌神，请在图片上点击选择');       %选好类别后弹出对话框

function she_shen_score_Callback(hObject, eventdata, handles)
% hObject    handle to she_shen_score (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of she_shen_score as text
%        str2double(get(hObject,'String')) returns contents of she_shen_score as a double
global Design                  %结构体
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
global Design                  %结构体
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
global Design                  %结构体
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
global Design                  %结构体
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
global Design                  %结构体
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
global Design                  %结构体
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
global Design                  %结构体
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
global Design                  %结构体
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
global Design                  %结构体
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
