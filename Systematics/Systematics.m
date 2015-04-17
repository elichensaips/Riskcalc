function Systematics

%%   Set up some varables
%   First clear everything
clear all
clc
close all
dbstop if error;

%   Get user screen size
SC = get(0, 'ScreenSize');
MaxMonitorX = SC(3);
MaxMonitorY = SC(4);


%   Set the figure window size values
MainFigScaleX = .6;          % Change this value to adjust the figure size
MainFigScaleY = .8;   
MaxWindowX = round(MaxMonitorX*MainFigScaleX);
MaxWindowY = round(MaxMonitorY*MainFigScaleY);
XBorder = (MaxMonitorX-MaxWindowX)/2;
YBorder = (MaxMonitorY-MaxWindowY)/2;
TabOffset = 0;              % This value offsets the tabs inside the figure.
ButtonHeight = 40;
PanelWidth = MaxWindowX-2*TabOffset+4;
PanelHeight = MaxWindowY-ButtonHeight-2*TabOffset;
hData{1}.FigSize=[XBorder YBorder MaxWindowX MaxWindowY ButtonHeight];
hData{1}.colorVec=[0.56 0.83 0.9];

%   Set the color varables.
White = [1  1  1];            % White - Selected tab color
hMain.LastDate='';
hMain.FirstDate='';
%%   Create a figure for the tabs
hTabFig = figure(...
    'Units', 'pixels',...
    'Toolbar', 'none',...
    'Position',[ XBorder, YBorder, MaxWindowX, MaxWindowY ],...
    'NumberTitle', 'off',...
    'Name', 'כלי תמחור ואומדן סיכונים',...
    'MenuBar', 'none',...
    'Resize', 'off',...
    'DockControls', 'off',...
    'Color', hData{1}.colorVec,...
    'Tag','MainScreen');%,...
    %'CloseRequestFcn',@CloseFigMain);

%

%%   Define content for main screen

hp = uipanel('Parent',hTabFig,...
             'BackgroundColor',hData{1}.colorVec,...
             'Position',[0 0.9 1 0.1]);

         uicontrol('Parent', hp, ...
   'Units','normalized', ...
    'Position', [0 0.1 1 0.8], ...
    'String','כלי תמחור ואומדן סיכונים', ...
    'Style', 'text',...
    'HorizontalAlignment', 'center',...
     'BackgroundColor',hData{1}.colorVec,...
      'ForegroundColor',[0.12 0 0.47],...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 24);


hMain.btnLoadHist=uicontrol('Parent', hTabFig,...
    'Units', 'pixels', ...
    'Position', [(round(PanelWidth*0.5)-125)  round(PanelHeight*0.63) 250 ButtonHeight*2], ...
    'String', 'טען נתוני שוק היסטוריים', ...
    'Callback', @LoadHist , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on');

hMain.txtMessageHist=uicontrol('Parent', hTabFig, ...
    'Units', 'pixels', ...
    'Position', [round(PanelWidth*0.5)+135 round(PanelHeight*0.6) 250 ButtonHeight*2], ...
    'String', '', ...
    'Style', 'text',...
    'HorizontalAlignment', 'right',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'Tag','MessageHist',...
    'BackgroundColor',hData{1}.colorVec,...
    'Enable','on');





hMain.btnLoadData=uicontrol('Parent', hTabFig,...
    'Units', 'pixels', ...
    'Position', [(round(PanelWidth*0.5)-125)  round(PanelHeight*0.45) 250 ButtonHeight*2], ...
    'String', 'טען נתוני אחזקות', ...
    'Callback', @LoadData , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on');


hMain.btnPricingPortfolio=uicontrol('Parent', hTabFig, ...
    'Units', 'pixels', ...
    'Position', [(round(PanelWidth*0.5)-150)  round(PanelHeight*0.05) 300 ButtonHeight*2], ...
    'String', 'תמחור מכשירים ואומדן סיכונים', ...
    'Callback', @CalcRisk , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','off');

icon=imresize(imread('date_select.png'),[ButtonHeight/2 ButtonHeight/2]);

hMain.btnDatepick=uicontrol('Parent', hTabFig, ...
    'Units', 'pixels', ...
    'Position', [round(PanelWidth*0.2) round(PanelHeight*0.85) ButtonHeight/2 ButtonHeight/2], ...
    'Callback', @Change_Settle_Date_Callback , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'CData',icon,...
    'Enable','off');

uicontrol('Parent', hTabFig, ...
    'Units', 'pixels', ...
    'Position', [round(PanelWidth*0.2)+ButtonHeight/2 round(PanelHeight*0.9) 100 ButtonHeight/2], ...
    'String','התאריך הקובע', ...
    'Style', 'text',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'BackgroundColor',hData{1}.colorVec,...
    'FontSize', 12);

hMain.DatePick=uicontrol('Parent', hTabFig, ...
    'Units', 'pixels', ...
    'Position', [round(PanelWidth*0.2)+ButtonHeight/2 round(PanelHeight*0.85) 100 ButtonHeight/2], ...
    'String',hMain.LastDate, ...
    'Style', 'text',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12);

uicontrol('Parent', hTabFig, ...
    'Units', 'pixels', ...
    'Position', [round(PanelWidth*0.01)  round(PanelHeight*0.85) 100 ButtonHeight], ...
    'String', 'הגדרות', ...
    'Callback',@OpenSettingCallback  , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'BackgroundColor',[0 1 0.5],...
    'FontWeight', 'bold',...
    'FontSize', 12);


hMain.btnReportFaultHistData=uicontrol('Parent', hTabFig, ...
    'Units', 'pixels', ...
    'Position', [round(PanelWidth*0.2) round(PanelHeight*0.71) 100 ButtonHeight*.8], ...
    'String', 'דוח שגויים נתוני שוק', ...
    'Callback', @OpenReportFaultHistData , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 8,...
    'Enable','off');

hMain.btnExportHist=uicontrol('Parent', hTabFig, ...
    'Units', 'pixels', ...
    'Position', [round(PanelWidth*0.2) round(PanelHeight*0.64) 100 ButtonHeight*.8], ...
    'String', 'יצוא קובץ נתוני שוק', ...
    'Callback', @ExportHist , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 8,...
    'Enable','off');


hMain.btnReportMissing=uicontrol('Parent', hTabFig, ...
    'Units', 'pixels', ...
    'Position', [round(PanelWidth*0.2) round(PanelHeight*0.46) 100 ButtonHeight*.8], ...
    'String', 'דוח חוסרים', ...
    'Callback', @OpenReportMissingCallback , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','off');

hMain.btnGUIMissingData=uicontrol('Parent', hTabFig, ...
    'Units', 'pixels', ...
    'Position', [round(PanelWidth*0.2) round(PanelHeight*0.53) 100 ButtonHeight*.8], ...
    'String', 'השלם נתונים ידנית', ...
    'Callback', @OpenManualMissingReportCallback , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 8,...
    'Enable','off');

hMain.btnReportConflicts=uicontrol('Parent', hTabFig, ...
    'Units', 'pixels', ...
    'Position', [round(PanelWidth*0.07) round(PanelHeight*0.46) 100 ButtonHeight*.8], ...
    'String','דוח סתירות'  ,...
    'Callback', @OpenReportConflictsCallback , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','off');

hMain.btnReportComplited=uicontrol('Parent', hTabFig, ...
    'Units', 'pixels', ...
    'Position', [round(PanelWidth*0.07) round(PanelHeight*0.53) 100 ButtonHeight*.8], ...
    'String','דוח השלמות' , ...
    'Callback', @OpenReportComplitedCallback , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','off');



yourdata ={'' '' false};
columnname =   {'תאריך אחזקות','שם תיק', 'בחר'};
columnformat = {'char','char', 'logical'};
columneditable =  [ false false true];
hMain.Portfolio= uitable( hTabFig,'Units','pixels','Position',...
    [(round(PanelWidth*0.5)-125)  round(PanelHeight*0.21) 250 ButtonHeight*3], 'Data', yourdata,...
    'ColumnName', columnname,...
    'ColumnFormat', columnformat,...
    'ColumnEditable', columneditable,...
    'CellEditCallback',@CheckEnableLoadData,...
    'RowName',[] );

jScroll = findjobj(hMain.Portfolio);
jTable = jScroll.getViewport.getView;
jTable.setAutoResizeMode(jTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);


if (exist('DataSetting.mat','file'))
    load('DataSetting.mat')
    
    ind=strfind(DataSet.table_Data_hist.Data{2},'\');
    path_t=DataSet.table_Data_hist.Data{2}(1:ind(end));
    filename=dir([path_t 'SysHistFile*.xlsx']);
    
    
    if size(filename,1)>0
        fullfilename=[path_t filename.name];
        [~,~,ExcelData]= xlsread(fullfilename);
        
        hExcelData.hist=ExcelData ;
        
        set(hMain.btnDatepick,'Enable','on')
        
        
        set(hMain.txtMessageHist,'string','קיימים נתונים היסטוריים עד התאריך הקובע. לא נדרש לבצע טעינה מחדש.')
        
        hMain.LastDate=ExcelData(2,1);
        hMain.FirstDate=ExcelData(end,1);
        
        set(hMain.btnLoadData,'Enable','on');
        set(hMain.btnExportHist,'Enable','on');

        if isdatetime(hMain.LastDate)
            
            set(hMain.DatePick,'String',datestr(hMain.LastDate,24));
        else
            set(hMain.DatePick,'String',hMain.LastDate);
        end
        
        hData{8}=hExcelData;
    else
        set(hMain.btnLoadData,'Enable','off');
        set(hMain.txtMessageHist,'string','לא קיימים נתונים היסטוריים נדרש לבצע טעינה')
        
        
    end
    %     hMain.Portfolio.Data={DataSet.table_Data_ahzakot.Data{1,3} false};
    %     if size(DataSet.table_Data_ahzakot.Data,1)>1
    %         for i=2:size(DataSet.table_Data_ahzakot.Data,1)
    %             hMain.Portfolio.Data{i,1}=DataSet.table_Data_ahzakot.Data{i,3};
    %             hMain.Portfolio.Data{i,2}=false;
    %         end
    %
    %     end
end

%%   Save the TabHandles in guidata




hData{2}=hMain;
hData{3}=DataSet;

guidata(hTabFig,hData);



end
function CheckEnableEditAhzakot(~,~)

hData = guidata(gcf);


if sum([hData{3}.table_Data_ahzakot.Data{:,5}])==1
    set(hData{3}.btnEditPortfolio,'Enable','on')
else
    set(hData{3}.btnEditPortfolio,'Enable','off')
end

if sum([hData{3}.table_Data_ahzakot.Data{:,5}])>=1
    set(hData{3}.btnDeletePortfolio,'Enable','on')
else
    set(hData{3}.btnDeletePortfolio,'Enable','off')
end

end



function CheckEnableMissingValue(~,~)

hData = guidata(gcf);


if sum([hData{3}.table_Data_missingValue.Data{:,3}])==1
    set(hData{3}.btnEditFileMissingValue,'Enable','on')
else
    set(hData{3}.btnEditFileMissingValue,'Enable','off')
end

if sum([hData{3}.table_Data_missingValue.Data{:,3}])>=1
    set(hData{3}.btnDeleteFileMissingValue,'Enable','on')
else
    set(hData{3}.btnDeleteFileMissingValue,'Enable','off')
end
end

function CheckEnableDefaultValue(~,~)

hData = guidata(gcf);


if sum([hData{3}.table_Data_DefaultValue.Data{:,3}])==1
    set(hData{3}.btnEditFileDefaultValue,'Enable','on')
else
    set(hData{3}.btnEditFileDefaultValue,'Enable','off')
end

if sum([hData{3}.table_Data_DefaultValue.Data{:,3}])>=1
    set(hData{3}.btnDeleteFileDefaultValue,'Enable','on')
else
    set(hData{3}.btnDeleteFileDefaultValue,'Enable','off')
end
end
function CheckEnableLoadData(~,~)

hData = guidata(gcf);


if sum([hData{2}.Portfolio.Data{:,3}])>=1
    set(hData{2}.btnPricingPortfolio,'Enable','on')
else
    set(hData{2}.btnPricingPortfolio,'Enable','off')
end

end


function OpenPortfolio(source,~)

hData = guidata(gcf);

FigSize=hData{1}.FigSize;
typeS=source.Tag;



hPortfolioFig= figure(...
    'Units', 'pixels',...
    'Toolbar', 'none',...
    'Position', [(round(hData{1}.FigSize(1:2))+round(hData{1}.FigSize(3:4)./4)) round(hData{1}.FigSize(3:4)./2)],...
    'NumberTitle', 'off',...
    'Name', 'תיק אחזקות',...
    'MenuBar', 'none',...
    'Resize', 'off',...
    'DockControls', 'off',...
    'Color', 0.8*[1 1 1],...
    'CloseRequestFcn',@CloseFig);

icon=imresize(imread('images.jpg'),[FigSize(5) FigSize(5)]);




%       'Position', [round((hPortfolioFig.Position(1)+hPortfolioFig.Position(2)*0.3)) round((hPortfolioFig.Position(2)+hPortfolioFig.Position(4)*0.3)) 100 FigSize(5)], ...

hPortfolio.tag=typeS;

uicontrol('Parent', hPortfolioFig, ...
    'Units', 'pixels', ...
    'Position', [round((hPortfolioFig.Position(3)*0.3)) round((hPortfolioFig.Position(4)*0.5)) FigSize(5) FigSize(5)], ...
    'String', '', ...
    'Callback', @Get_Path , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on',...
    'CData',icon,...
    'Tag','PortfolioSetting');

hPortfolio.path=uicontrol('Parent', hPortfolioFig, ...
    'Units', 'pixels', ...
    'Position', [round((hPortfolioFig.Position(3)*0.5)) round((hPortfolioFig.Position(4)*0.5)) round(hPortfolioFig.Position(3)*0.4) FigSize(5)], ...
    'String', '', ...
    'Style', 'text',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 8,...
    'Enable','on');



uicontrol('Parent', hPortfolioFig, ...
    'Units', 'pixels', ...
    'Position', [round((hPortfolioFig.Position(3)*0.5)) round((hPortfolioFig.Position(4)*0.2)) round(hPortfolioFig.Position(3)*0.4) FigSize(5)], ...
    'String', 'שם הגיליון', ...
    'Style', 'text',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'BackgroundColor', 0.8*[1 1 1],...
    'Enable','on');



hPortfolio.sheet=uicontrol('Parent', hPortfolioFig, ...
    'Units', 'pixels', ...
    'Position', [round((hPortfolioFig.Position(3)*0.2)) round((hPortfolioFig.Position(4)*0.2)) round(hPortfolioFig.Position(3)*0.2) FigSize(5)], ...
    'String',{'','',''}, ...
    'Value',1,...
    'Style', 'popup',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'Enable','on');


uicontrol('Parent', hPortfolioFig, ...
    'Units', 'pixels', ...
    'Position', [round((hPortfolioFig.Position(3)*0.05)) round((hPortfolioFig.Position(4)*0.05)) FigSize(5)*3 FigSize(5)], ...
    'String', 'שמור מיקום קובץ', ...
    'Callback', @Save_data, ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on',...
    'Tag','PortfolioSettingSave');

if strcmp(typeS,'editAhzkotPortfolio')
    
    set(hPortfolio.sheet,'String',hData{3}.table_Data_ahzakot.Data{([hData{3}.table_Data_ahzakot.Data{:,5}]==1),1})
    set(hPortfolio.path,'String',hData{3}.table_Data_ahzakot.Data{([hData{3}.table_Data_ahzakot.Data{:,5}]==1),2})
end

hData{4}=hPortfolio;
guidata(hPortfolioFig,hData);

end

function CloseSetting(~,~)

hData = guidata(gcf);

indexDefaultValue=find([hData{3}.table_Data_DefaultValue.Data{:,3}]==1);
indexMissingValue=find([hData{3}.table_Data_missingValue.Data{:,3}]==1);
indexAhzakot=find([hData{3}.table_Data_ahzakot.Data{:,5}]==1);


if ~isempty(indexDefaultValue)
    for i=1:length(indexDefaultValue)
        hData{3}.table_Data_DefaultValue.Data{indexDefaultValue(i),3}=false;
    end
end


if ~isempty(indexMissingValue)
    for i=1:length(indexMissingValue)
        hData{3}.table_Data_missingValue.Data{indexMissingValue(i),3}=false;
    end
end
if ~isempty(indexAhzakot)
    for i=1:length(indexAhzakot)
        hData{3}.table_Data_ahzakot.Data{indexAhzakot(i),5}=false;
    end
end


hData{3}.hRadiobuttonStatus=get(get(hData{3}.hRadiobutton,'SelectedObject'),'Tag');
DataSet=hData{3};
%hData{2}.Portfolio.Data={[] [] false};



save('DataSetting.mat','DataSet');


close(gcf);

end


function Get_Path(source,~)

hData = guidata(gcf);

if strcmp(source.Tag,'PortfolioSetting')
    
    index=4;
elseif strcmp(source.Tag,'FileSetting')
    index=5;
end

[FileNameWithTag, FileDirectory] = uigetfile({'*.csv;*.xls;*.xlsx','Excel Files'},...
    'Select file');

if FileNameWithTag == 0,
    %   If User canceles then display error message
    errordlg('יש לבחור קובץ');
    return
end

%   Build path to file
FilePath = strcat(FileDirectory,FileNameWithTag);

[status,sheets] = xlsfinfo(FilePath);
if ~isempty(status)
    
    
    hData{index}.sheet.String=sheets;
    hData{index}.path.String=FilePath;
    
    
    
else
    errordlg('הקובץ לא תקין יש לבחור קובץ אחר');
end
end


function Save_data(source,~)

hData = guidata(gcf);

if strcmp(source.Tag,'PortfolioSettingSave')
    
    indexTab=4;
elseif strcmp(source.Tag,'FileSettingSave')
    indexTab=5;
end

if ~iscell(hData{indexTab}.sheet.String)
    str ={ hData{indexTab}.sheet.String};
else
    str = hData{indexTab}.sheet.String;
    
end
val = get(hData{indexTab}.sheet,'Value');

path_file=hData{indexTab}.path.String;
ind=strfind(path_file,'\');
filename=path_file((max(ind)+1):end);

if (strcmp(hData{indexTab}.tag,'editAhzkotPortfolio'))
    
    hData{3}.table_Data_ahzakot.Data{([hData{3}.table_Data_ahzakot.Data{:,5}]==1),1}=(str{val});
    hData{3}.table_Data_ahzakot.Data{([hData{3}.table_Data_ahzakot.Data{:,5}]==1),2}=hData{indexTab}.path.String;
    hData{3}.table_Data_ahzakot.Data{([hData{3}.table_Data_ahzakot.Data{:,5}]==1),3}=filename;
    hData{3}.table_Data_ahzakot.Data{([hData{3}.table_Data_ahzakot.Data{:,5}]==1),4}=false;
    hData{3}.table_Data_ahzakot.Data{([hData{3}.table_Data_ahzakot.Data{:,5}]==1),5}=false;
    set(hData{3}.btnEditPortfolio,'Enable','off');
    set(hData{3}.btnDeletePortfolio,'Enable','off');
elseif (strcmp(hData{indexTab}.tag,'AddAhzkotPortfolio'))
    
    index=size(hData{3}.table_Data_ahzakot.Data,1)+1;
    for i=1:size(hData{3}.table_Data_ahzakot.Data,1)
        if  (strcmp(hData{3}.table_Data_ahzakot.Data{i,2},hData{indexTab}.path.String))
            errordlg('הקובץ כבר הוגדר עבור תיק אחר. יש לבחור קובץ אחר.');
            return;
            
        end
        if isempty(hData{3}.table_Data_ahzakot.Data{i,2})
            index=i;
            break;
        end
        
    end
    if index==1
        hData{3}.table_Data_ahzakot.Data={ char(str{val}) hData{indexTab}.path.String filename  false false};
    else
        
        hData{3}.table_Data_ahzakot.Data{index,1}=(str{val});
        hData{3}.table_Data_ahzakot.Data{index,2}=hData{indexTab}.path.String;
        hData{3}.table_Data_ahzakot.Data{index,3}=filename;
        hData{3}.table_Data_ahzakot.Data{index,4}=false;
        hData{3}.table_Data_ahzakot.Data{index,5}=false;
    end
    set(hData{3}.btnEditPortfolio,'Enable','off');
    set(hData{3}.btnDeletePortfolio,'Enable','off');
elseif (strcmp(hData{indexTab}.tag,'EditPathHistFilePath'))
    hData{3}.table_Data_hist.Data{1}=str{val};
    hData{3}.table_Data_hist.Data{2}=hData{indexTab}.path.String;
    str_datepick = hData{indexTab}.DatePickformat.String;
    
    
    val_datepick = get(hData{indexTab}.DatePickformat,'Value');
    hData{3}.table_Data_hist.Data{3}=str_datepick{val_datepick};
elseif (strcmp(hData{indexTab}.tag,'EditPathUniqIDField'))
    hData{3}.table_Data_Comper_field.Data{1}=str{val};
    hData{3}.table_Data_Comper_field.Data{2}=hData{indexTab}.path.String;
elseif (strcmp(hData{indexTab}.tag,'EditPathTransFieldName'))
    hData{3}.table_Data_translateName.Data{1}=str{val};
    hData{3}.table_Data_translateName.Data{2}=hData{indexTab}.path.String;
elseif (strcmp(hData{indexTab}.tag,'EditPathTransFieldValue'))
    hData{3}.table_Data_translateValue.Data{1}=str{val};
    hData{3}.table_Data_translateValue.Data{2}=hData{indexTab}.path.String;
elseif (strcmp(hData{indexTab}.tag,'EditPathTransRiskTable'))
    hData{3}.table_Data_translateRisk.Data{1}=str{val};
    hData{3}.table_Data_translateRisk.Data{2}=hData{indexTab}.path.String;
elseif (strcmp(hData{indexTab}.tag,'EditPathRiskTable'))
    hData{3}.table_Data_RiskTable.Data{1}=str{val};
    hData{3}.table_Data_RiskTable.Data{2}=hData{indexTab}.path.String;
elseif (strcmp(hData{indexTab}.tag,'EditPathFileMissingValue'))
    hData{3}.table_Data_missingValue.Data{([hData{3}.table_Data_missingValue.Data{:,3}]==1),1}=str{val};
    hData{3}.table_Data_missingValue.Data{([hData{3}.table_Data_missingValue.Data{:,3}]==1),2}=hData{indexTab}.path.String;
    hData{3}.table_Data_missingValue.Data{([hData{3}.table_Data_missingValue.Data{:,3}]==1),3}=false;
    set(hData{3}.btnEditFileMissingValue,'Enable','off');
    set(hData{3}.btnDeleteFileMissingValue,'Enable','off');
elseif (strcmp(hData{indexTab}.tag,'EditPathFileDefaultValue'))
    hData{3}.table_Data_DefaultValue.Data{([hData{3}.table_Data_DefaultValue.Data{:,3}]==1),1}=str{val};
    hData{3}.table_Data_DefaultValue.Data{([hData{3}.table_Data_DefaultValue.Data{:,3}]==1),2}=hData{indexTab}.path.String;
    hData{3}.table_Data_DefaultValue.Data{([hData{3}.table_Data_DefaultValue.Data{:,3}]==1),3}=false;
    
    set(hData{3}.btnEditFileDefaultValue,'Enable','off')
    set(hData{3}.btnDeleteFileDefaultValue,'Enable','off')
    
elseif (strcmp(hData{indexTab}.tag,'AddFileMissingValue'))
    index=size(hData{3}.table_Data_missingValue.Data,1)+1;
    for i=1:size(hData{3}.table_Data_missingValue.Data,1)
        if  (strcmp(hData{3}.table_Data_missingValue.Data{i,2},hData{indexTab}.path.String))
            errordlg('הקובץ כבר הוגדר יש לבחור קובץ אחר');
            return;
            
        end
        if isempty(hData{3}.table_Data_missingValue.Data{i,2})
            index=i;
            break;
        end
        
    end
    if index==1
        hData{3}.table_Data_missingValue.Data={ str{val} hData{indexTab}.path.String false};
    else
        hData{3}.table_Data_missingValue.Data{index,1}=str{val};
        hData{3}.table_Data_missingValue.Data{index,2}=hData{indexTab}.path.String;
        hData{3}.table_Data_missingValue.Data{index,3}=false;
    end
    set(hData{3}.btnEditFileMissingValue,'Enable','off');
    set(hData{3}.btnDeleteFileMissingValue,'Enable','off');
elseif (strcmp(hData{indexTab}.tag,'AddFileDefaultValue'))
    index=size(hData{3}.table_Data_DefaultValue.Data,1)+1;
    for i=1:size(hData{3}.table_Data_DefaultValue.Data,1)
        if  (strcmp(hData{3}.table_Data_DefaultValue.Data{i,2},hData{indexTab}.path.String))
            errordlg('הקובץ כבר הוגדר יש לבחור קובץ אחר');
            return;
            
        end
        if isempty(hData{3}.table_Data_DefaultValue.Data{i,2})
            index=i;
            break;
        end
        
    end
    
    if index==1
        hData{3}.table_Data_DefaultValue.Data={ str{val} hData{indexTab}.path.String false};
    else
        hData{3}.table_Data_DefaultValue.Data{index,1}=str{val};
        hData{3}.table_Data_DefaultValue.Data{index,2}=hData{indexTab}.path.String;
        hData{3}.table_Data_DefaultValue.Data{index,3}=false;
    end
    
    
    
    set(hData{3}.btnEditFileDefaultValue,'Enable','off')
    set(hData{3}.btnDeleteFileDefaultValue,'Enable','off')
    
    
    
    
    
end

close(gcf);
end

function DeletePortfolio(~,~)

hData = guidata(gcf);
celda=hData{3}.table_Data_ahzakot.Data;
delInd=find([celda{:,5}]==1);
delInd=delInd';
ncols = size(celda,2);
for auxfil = 1: length(delInd)
    fil          = delInd(auxfil,1);
    celda(fil,:) = cell(1, ncols);
end

%     celda(cellfun(@(celda) isempty(celda),celda))=[];
%     hData{3}.table_Data_ahzakot.Data = celda;

hData{3}.table_Data_ahzakot.Data = reshape( celda(~cellfun('isempty',celda)), [], ncols);




end

function DeleteFile(source,~)

hData = guidata(gcf);
if strcmp(source.Tag,'DeleteFileMissingValue')
    celda=hData{3}.table_Data_missingValue.Data;
elseif strcmp(source.Tag,'DeleteFileDefaultValue')
    celda=hData{3}.table_Data_DefaultValue.Data;
end
delInd=find([celda{:,3}]==1);
delInd=delInd';
ncols = size(celda,2);
for auxfil = 1: length(delInd)
    fil          = delInd(auxfil,1);
    celda(fil,:) = cell(1, ncols);
end



%     celda(cellfun(@(celda) isempty(celda),celda))=[];
%     hData{3}.table_Data_ahzakot.Data = celda;

if strcmp(source.Tag,'DeleteFileMissingValue')
    hData{3}.table_Data_missingValue.Data = reshape( celda(~cellfun('isempty',celda)), [], ncols);
    
elseif strcmp(source.Tag,'DeleteFileDefaultValue')
    hData{3}.table_Data_DefaultValue.Data = reshape( celda(~cellfun('isempty',celda)), [], ncols);
    
end






end


function OpenSettingCallback(~,~)

%   Get TabHandles from guidata and set some varables
hData = guidata(gcf);
if (exist('DataSetting.mat','file'))
    load('DataSetting.mat')
    hData{3}=DataSet;
end


FigSize=hData{1}.FigSize;

hSettingFig = figure(...
    'Units', 'pixels',...
    'Toolbar', 'none',...
    'Position', FigSize(1:4),...
    'NumberTitle', 'off',...
    'Name', 'הגדרות',...
    'MenuBar', 'none',...
    'Resize', 'off',...
    'DockControls', 'off',...
    'Color', hData{1}.colorVec);




%%   Define default content for the main Tab

tabgp = uitabgroup(hSettingFig,'Position',[0 0 1 1],'TabLocation','right');
htab(1)    = uitab(tabgp,'Title','קבצי אחזקות','BackgroundColor',hData{1}.colorVec);
htab(2) = uitab(tabgp,'Title','נתונים היסטוריים','BackgroundColor',hData{1}.colorVec);
htab(3) = uitab(tabgp,'Title','טיוב נתונים','BackgroundColor',hData{1}.colorVec);
htab(4) = uitab(tabgp,'Title','טבלאות תרגום','BackgroundColor',hData{1}.colorVec);
htab(5) = uitab(tabgp,'Title','טבלת גורמי סיכון','BackgroundColor',hData{1}.colorVec);

set(tabgp, 'SelectedTab',htab(1));


%%   Define default content for the  Tab 1

yourdata =[];
columnname =   {'שם גיליון','מיקום הקובץ','שם קובץ','בחר קבצים|לטעינה','בחר |לעריכה/מחיקה'};
columnformat = {'char','char','char', 'logical', 'logical'};
columneditable =  [false false false true true];

hTable.table_Data_ahzakot = uitable( htab(1),'Units','normalized','Position',...
    [0 0.5 1 0.3], 'Data', yourdata,...
    'ColumnName', columnname,...
    'ColumnFormat', columnformat,...
    'ColumnWidth',{'auto',round(FigSize(3)*0.3),'auto','auto','auto'},...
    'ColumnEditable', columneditable,...
    'CellEditCallback',@CheckEnableEditAhzakot,...
    'RowName',[]);

%hTable.table_Data_ahzakot.Position(3) = hTable.table_Data_ahzakot.Extent(3);
%table_Data_ahzakot.Position(4) = table_Data_ahzakot.Extent(4);

jScroll_table_Data_ahzakot = findjobj(hTable.table_Data_ahzakot);
jTable_table_Data_ahzakot = jScroll_table_Data_ahzakot.getViewport.getView;
jTable_table_Data_ahzakot.setAutoResizeMode(jTable_table_Data_ahzakot.AUTO_RESIZE_SUBSEQUENT_COLUMNS);


hTable.btnEditPortfolio=uicontrol('Parent', htab(1), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.7)-100 round(FigSize(4)*0.4) 100 FigSize(5)], ...
    'String', 'ערוך קובץ', ...
    'Callback', @OpenPortfolio , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','off',...
    'Tag','editAhzkotPortfolio');

uicontrol('Parent', htab(1), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.5)-100 round(FigSize(4)*0.4) 100 FigSize(5)], ...
    'String', 'הוסף קובץ', ...
    'Callback', @OpenPortfolio , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on',...
    'Tag','AddAhzkotPortfolio');

hTable.btnDeletePortfolio=uicontrol('Parent', htab(1), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.3)-100 round(FigSize(4)*0.4) 100 FigSize(5)], ...
    'String', 'מחק קובץ', ...
    'Callback', @DeletePortfolio , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','off');

uicontrol('Parent', htab(1), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.02) round(FigSize(4)*0.02) 100 FigSize(5)], ...
    'String', 'סגור', ...
    'Callback', @CloseSetting , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on');

%%   Define default content for the Tab 2


hRadiobuttonG(1) = uibuttongroup('visible','off','Position',[0.6 0.7 0.35 0.17],'parent',htab(2),'SelectionChangedFcn',@hist_action_mode_selection,'Tag','RadiobuttonG','BackgroundColor',hData{1}.colorVec);
hRadiobuttonG(2) = uicontrol('Style','Radio','String','','Units', 'pixels', 'Units', 'pixels', ...
    'Position',[ceil(FigSize(3)*htab(2).Position(3)*hRadiobuttonG(1).Position(3)*0.8) ceil(FigSize(4)*tabgp.Position(4)*hRadiobuttonG(1).Position(4)*0.6) 30 20] ,...
    'parent',hRadiobuttonG(1),...
    'Tag','update',...
    'HandleVisibility','off',...
'BackgroundColor',hData{1}.colorVec);
hRadiobuttonG(3)= uicontrol('Style','Radio','String','','Units', 'pixels', ...
    'Position',[ceil(FigSize(3)*htab(2).Position(3)*hRadiobuttonG(1).Position(3)*0.8) ceil(FigSize(4)*htab(2).Position(4)*hRadiobuttonG(1).Position(4)*0.1) 50 20] ,...
    'parent',hRadiobuttonG(1),...
    'Tag','replace',...
    'HandleVisibility','off',...
'BackgroundColor',hData{1}.colorVec);

uicontrol('Parent', hRadiobuttonG(1), ...
    'Units', 'pixels', ...
    'Position',[ceil(FigSize(3)*htab(2).Position(3)*hRadiobuttonG(1).Position(3)*0.01) ceil(FigSize(4)*htab(2).Position(4)*hRadiobuttonG(1).Position(4)*0.55) 140 20] ,...
    'String', 'הוסף תאריכים חדשים בלבד', ...
    'Style', 'text',...
    'HorizontalAlignment', 'right',...
    'FontName', 'arial',...
    'FontSize', 8,...
    'Enable','on',...
'BackgroundColor',hData{1}.colorVec);

uicontrol('Parent',hRadiobuttonG(1), ...
    'Units', 'pixels', ...
    'Position', [ceil(FigSize(3)*htab(2).Position(3)*hRadiobuttonG(1).Position(3)*0.01) ceil(FigSize(4)*htab(2).Position(4)*hRadiobuttonG(1).Position(4)*0.05) 140 20] ,...
    'String', 'דרוס תאריכים קימיים', ...
    'Style', 'text',...
    'HorizontalAlignment', 'right',...
    'FontName', 'arial',...
    'FontSize', 8,...
    'Enable','on',...
'BackgroundColor',hData{1}.colorVec);

set(hRadiobuttonG(1),'SelectedObject',hRadiobuttonG(2));  % No selection

set(hRadiobuttonG(1),'Visible','on');

hTable.hRadiobutton=hRadiobuttonG(1);


yourdata =[ {' '} {' '} {'dd/MM/yyyy'} ];
columnname =   {'שם גיליון','מיקום הקובץ','פורמט  התאריך| בקובץ הנתונים ההיסטוריים'};
columnformat = {'char','char','char'};
columneditable =  [false false false];
hTable.table_Data_hist = uitable( htab(2),'Units','normalized','Position',...
    [0 0.37 1 0.17], 'Data', yourdata,...
    'ColumnName', columnname,...
    'ColumnFormat', columnformat,...
    'ColumnWidth',{'auto',round(FigSize(3)*0.7),'auto'},...
    'ColumnEditable', columneditable,...
    'RowName',[] );


%hTable.table_Data_hist.Position(3) = hTable.table_Data_hist.Extent(3);
hTable.table_Data_hist.Position(4) = hTable.table_Data_hist.Extent(4);

jScroll_table_Data_hist = findjobj(hTable.table_Data_hist);
jTable_table_Data_hist = jScroll_table_Data_hist.getViewport.getView;
jTable_table_Data_hist.setAutoResizeMode(jTable_table_Data_hist.AUTO_RESIZE_SUBSEQUENT_COLUMNS);



uicontrol('Parent', htab(2), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.5)-170 round(FigSize(4)*0.47) 250 FigSize(5)], ...
    'String', 'קובץ הנתונים ההיסטוריים', ...
    'Style', 'text',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on',...
'BackgroundColor',hData{1}.colorVec);

uicontrol('Parent', htab(2), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.5)-100 round(FigSize(4)*0.3) 120 FigSize(5)], ...
    'String', 'ערוך מיקום קובץ', ...
    'Callback', @EditSettingFile , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on',...
    'Tag','EditPathHistFilePath');



uicontrol('Parent', htab(2), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.02) round(FigSize(4)*0.02) 100 FigSize(5)], ...
    'String', 'סגור', ...
    'Callback', @CloseSetting , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on');

%%   Define default content for the Tab 3



columnname =   {'שם גיליון','מיקום הקובץ', 'בחר לעריכה/מחיקה'};


yourdata =[];
columnformat = {'char','char', 'logical'};
columneditable =  [false false true ];
hTable.table_Data_missingValue = uitable( htab(3),'Units','normalized','Position',...
    [0 0.75 1 0.15], 'Data', yourdata,...
    'ColumnName', columnname,...
    'ColumnFormat', columnformat,...
    'ColumnWidth',{'auto',round(FigSize(3)*0.7),'auto'},...
    'ColumnEditable', columneditable,...
    'CellEditCallback',@CheckEnableMissingValue,...
    'RowName',[] );
%hTable.table_Data_missingValue.Position(3) = hTable.table_Data_missingValue.Extent(3);
%table_Data_hist_update.Position(4) = table_Data_hist_update.Extent(4);

jScroll_table_Data_missingValue = findjobj(hTable.table_Data_missingValue);
jTable_table_Data_missingValue = jScroll_table_Data_missingValue.getViewport.getView;
jTable_table_Data_missingValue.setAutoResizeMode(jTable_table_Data_missingValue.AUTO_RESIZE_SUBSEQUENT_COLUMNS);

uicontrol('Parent', htab(3), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.5)-200 round(FigSize(4)*0.9) 250 FigSize(5)/2], ...
    'String', 'קבצי נתוני השלמה', ...
    'Style', 'text',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on',...
    'BackgroundColor',hData{1}.colorVec);



hTable.btnEditFileMissingValue=uicontrol('Parent', htab(3), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.5) round(FigSize(4)*0.65) 120 FigSize(5)], ...
    'String', 'ערוך מיקום קובץ', ...
    'Callback', @EditSettingFile , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','off',...
    'Tag','EditPathFileMissingValue');


uicontrol('Parent', htab(3), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.35) round(FigSize(4)*0.65) 100 FigSize(5)], ...
    'String', 'הוסף קובץ', ...
    'Callback', @EditSettingFile , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on',...
    'Tag','AddFileMissingValue');

hTable.btnDeleteFileMissingValue=uicontrol('Parent', htab(3), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.2) round(FigSize(4)*0.65) 100 FigSize(5)], ...
    'String', 'מחק קובץ', ...
    'Callback', @DeleteFile , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','off',...
    'Tag','DeleteFileMissingValue');



columnname =   {'שם גיליון','מיקום הקובץ', 'בחר לעריכה/מחיקה'};
yourdata =[];
columnformat = {'char','char', 'logical'};
columneditable =  [false false true ];
hTable.table_Data_DefaultValue = uitable( htab(3),'Units','normalized','Position',...
    [0 0.4 1 0.15], 'Data', yourdata,...
    'ColumnName', columnname,...
    'ColumnFormat', columnformat,...
    'ColumnWidth',{'auto',round(FigSize(3)*0.7),'auto'},...
    'ColumnEditable', columneditable,...
    'CellEditCallback',@CheckEnableDefaultValue,...
    'RowName',[]);
%hTable.table_Data_DefaultValue.Position(3) = hTable.table_Data_DefaultValue.Extent(3);
jScroll_table_Data_DefaultValue = findjobj(hTable.table_Data_DefaultValue);
jTable_table_Data_DefaultValue = jScroll_table_Data_DefaultValue.getViewport.getView;
jTable_table_Data_DefaultValue.setAutoResizeMode(jTable_table_Data_DefaultValue.AUTO_RESIZE_SUBSEQUENT_COLUMNS);


uicontrol('Parent', htab(3), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.5)-200 round(FigSize(4)*0.55) 250 FigSize(5)/2], ...
    'String', 'קבצי נתונים ברירת המחדל', ...
    'Style', 'text',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on',...
    'BackgroundColor',hData{1}.colorVec);

hTable.btnEditFileDefaultValue=uicontrol('Parent', htab(3), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.5) round(FigSize(4)*0.3) 120 FigSize(5)], ...
    'String', 'ערוך מיקום קובץ', ...
    'Callback', @EditSettingFile , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','off',...
    'Tag','EditPathFileDefaultValue');


uicontrol('Parent', htab(3), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.35) round(FigSize(4)*0.3) 100 FigSize(5)], ...
    'String', 'הוסף קובץ', ...
    'Callback', @EditSettingFile , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on',...
    'Tag','AddFileDefaultValue');

hTable.btnDeleteFileDefaultValue=uicontrol('Parent', htab(3), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.2) round(FigSize(4)*0.3) 100 FigSize(5)], ...
    'String', 'מחק קובץ', ...
    'Callback', @DeleteFile , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','off',...
    'Tag','DeleteFileDefaultValue');





yourdata =[ {' '} {' '}];
columnname =   {'שם גיליון','מיקום הקובץ'};
columnformat = {'char','char'};
columneditable =  [false false ];
hTable.table_Data_Comper_field = uitable( htab(3),'Units','normalized','Position',...
    [0 0.15 1 0.1], 'Data', yourdata,...
    'ColumnName', columnname,...
    'ColumnFormat', columnformat,...
    'ColumnWidth',{'auto',round(FigSize(3)*0.8)},...
    'ColumnEditable', columneditable,...
    'RowName',[]);
%hTable.table_Data_Comper_field.Position(3) = hTable.table_Data_Comper_field.Extent(3);
hTable.table_Data_Comper_field.Position(4) = hTable.table_Data_Comper_field.Extent(4);

jScroll_table_Data_Comper_field = findjobj(hTable.table_Data_Comper_field);
jTable_table_Data_Comper_field = jScroll_table_Data_Comper_field.getViewport.getView;
jTable_table_Data_Comper_field.setAutoResizeMode(jTable_table_Data_Comper_field.AUTO_RESIZE_SUBSEQUENT_COLUMNS);



uicontrol('Parent', htab(3), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.5)-200 round(FigSize(4)*0.2)+10 250 FigSize(5)/2], ...
    'String', 'קובץ שדות התאמה', ...
    'Style', 'text',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on',...
    'BackgroundColor',hData{1}.colorVec);

uicontrol('Parent', htab(3), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.5)-130 round(FigSize(4)*0.07) 120 FigSize(5)], ...
    'String', 'ערוך מיקום קובץ', ...
    'Callback', @EditSettingFile , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on',...
    'Tag','EditPathUniqIDField');

uicontrol('Parent', htab(3), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.02) round(FigSize(4)*0.02) 100 FigSize(5)], ...
    'String', 'סגור', ...
    'Callback', @CloseSetting , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on');

%%   Define default content for the Tab 4

yourdata =[ {' '} {' '}];
columnname =   {'שם גיליון','מיקום הקובץ'};
columnformat = {'char','char'};
columneditable =  [false false ];
hTable.table_Data_translateName = uitable( htab(4),'Units','normalized','Position',...
    [0 0.8 1 0.2], 'Data', yourdata,...
    'ColumnName', columnname,...
    'ColumnWidth',{'auto',round(FigSize(3)*0.7)},...
    'ColumnFormat', columnformat,...
    'ColumnEditable', columneditable,...
    'RowName',[]);

%hTable.table_Data_translateName.Position(3) = hTable.table_Data_translateName.Extent(3);
hTable.table_Data_translateName.Position(4) = hTable.table_Data_translateName.Extent(4);

jScroll_table_Data_translateName = findjobj(hTable.table_Data_translateName);
jTable_table_Data_translateName = jScroll_table_Data_translateName.getViewport.getView;
jTable_table_Data_translateName.setAutoResizeMode(jTable_table_Data_translateName.AUTO_RESIZE_SUBSEQUENT_COLUMNS);

uicontrol('Parent', htab(4), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.5)-200 round(FigSize(4)*0.88) 250 FigSize(5)/2], ...
    'String', 'טבלת תרגום לשמות השדות', ...
    'Style', 'text',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on',...
    'BackgroundColor',hData{1}.colorVec);

uicontrol('Parent', htab(4), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.5)-130 round(FigSize(4)*0.72) 120 FigSize(5)], ...
    'String', 'ערוך מיקום קובץ', ...
    'Callback', @EditSettingFile , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on',...
    'Tag','EditPathTransFieldName');




yourdata =[ {' '} {' '}];
columnname =   {'שם גיליון','מיקום הקובץ'};
columnformat = {'char','char'};
columneditable =  [false false ];
hTable.table_Data_translateValue = uitable( htab(4),'Units','normalized','Position',...
    [0 0.52 1 0.2], 'Data', yourdata,...
    'ColumnName', columnname,...
    'ColumnFormat', columnformat,...
    'ColumnWidth',{'auto',round(FigSize(3)*0.7)},...
    'ColumnEditable', columneditable,...
    'RowName',[] );


%hTable.table_Data_translateValue.Position(3) = hTable.table_Data_translateValue.Extent(3);
hTable.table_Data_translateValue.Position(4) = hTable.table_Data_translateValue.Extent(4);
jScroll_table_Data_translateValue = findjobj(hTable.table_Data_translateValue);
jTable_table_Data_translateValue = jScroll_table_Data_translateValue.getViewport.getView;
jTable_table_Data_translateValue.setAutoResizeMode(jTable_table_Data_translateValue.AUTO_RESIZE_SUBSEQUENT_COLUMNS);

uicontrol('Parent', htab(4), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.5-200) round(FigSize(4)*0.6) 250 FigSize(5)/2], ...
    'String', 'טבלת תרגום לערכי השדות', ...
    'Style', 'text',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on',...
    'BackgroundColor',hData{1}.colorVec);

uicontrol('Parent', htab(4), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.5)-130 round(FigSize(4)*0.44) 120 FigSize(5)], ...
    'String', 'ערוך מיקום קובץ', ...
    'Callback', @EditSettingFile , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on',...
    'Tag','EditPathTransFieldValue');





yourdata =[ {' '} {' '}];
columnname =   {'שם גיליון','מיקום הקובץ'};
columnformat = {'char','char'};
columneditable =  [false false ];
hTable.table_Data_translateRisk = uitable( htab(4),'Units','normalized','Position',...
    [0 0.2 1 0.2], 'Data', yourdata,...
    'ColumnName', columnname,...
    'ColumnFormat', columnformat,...
    'ColumnWidth',{'auto',round(FigSize(3)*0.7)},...
    'ColumnEditable', columneditable,...
    'RowName',[] );

%hTable.table_Data_translateRisk.Position(3) = hTable.table_Data_translateRisk.Extent(3);
hTable.table_Data_translateRisk.Position(4) = hTable.table_Data_translateRisk.Extent(4);
jScroll_table_Data_translateRisk = findjobj(hTable.table_Data_translateRisk);
jTable_table_Data_translateRisk = jScroll_table_Data_translateRisk.getViewport.getView;
jTable_table_Data_translateRisk.setAutoResizeMode(jTable_table_Data_translateRisk.AUTO_RESIZE_SUBSEQUENT_COLUMNS);



uicontrol('Parent', htab(4), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.5)-200 round(FigSize(4)*0.28) 250 FigSize(5)/2], ...
    'String', 'טבלת תרגום לגורמי הסיכון', ...
    'Style', 'text',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on',...
    'BackgroundColor',hData{1}.colorVec);

uicontrol('Parent', htab(4), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.5)-130 round(FigSize(4)*0.12) 120 FigSize(5)], ...
    'String', 'ערוך מיקום קובץ', ...
    'Callback', @EditSettingFile , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on',...
    'Tag','EditPathTransRiskTable');



uicontrol('Parent', htab(4), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.02) round(FigSize(4)*0.02) 100 FigSize(5)], ...
    'String', 'סגור', ...
    'Callback', @CloseSetting , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on');
%%   Define default content for the Tab 5
yourdata =[ {' '} {' '}];
columnname =   {'שם גיליון','מיקום הקובץ'};
columnformat = {'char','char'};
columneditable =  [false false ];
hTable.table_Data_RiskTable = uitable( htab(5),'Units','normalized','Position',...
    [0 0.6 1 0.2], 'Data', yourdata,...
    'ColumnName', columnname,...
    'ColumnFormat', columnformat,...
    'ColumnWidth',{'auto',round(FigSize(3)*0.7)},...
    'ColumnEditable', columneditable,...
    'RowName',[]);

%hTable.table_Data_RiskTable.Position(3) = hTable.table_Data_RiskTable.Extent(3);
hTable.table_Data_RiskTable.Position(4) = hTable.table_Data_RiskTable.Extent(4);

jScroll_table_Data_RiskTable = findjobj(hTable.table_Data_RiskTable);
jTable_table_Data_RiskTable = jScroll_table_Data_RiskTable.getViewport.getView;
jTable_table_Data_RiskTable.setAutoResizeMode(jTable_table_Data_RiskTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);

uicontrol('Parent', htab(5), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.5)-200 round(FigSize(4)*0.7) 250 FigSize(5)/2], ...
    'String', 'טבלת גורמי סיכון', ...
    'Style', 'text',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on',...
    'BackgroundColor',hData{1}.colorVec);

uicontrol('Parent', htab(5), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.5)-130 round(FigSize(4)*0.52) 120 FigSize(5)], ...
    'String', 'ערוך מיקום קובץ', ...
    'Callback', @EditSettingFile , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on',...
    'Tag','EditPathRiskTable');


uicontrol('Parent', htab(5), ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.02) round(FigSize(4)*0.02) 100 FigSize(5)], ...
    'String', 'סגור', ...
    'Callback', @CloseSetting , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on');



if (exist('DataSetting.mat','file'))
    
    hTable.table_Data_DefaultValue.Data=DataSet.table_Data_DefaultValue.Data;
    hTable.table_Data_missingValue.Data=DataSet.table_Data_missingValue.Data;
    hTable.table_Data_hist_update.Data=DataSet.table_Data_hist_update.Data;
    hTable.table_Data_hist.Data=DataSet.table_Data_hist.Data;
    hTable.table_Data_ahzakot.Data=DataSet.table_Data_ahzakot.Data;
    hTable.table_Data_Comper_field.Data=DataSet.table_Data_Comper_field.Data;
    hTable.table_Data_translateName.Data=DataSet.table_Data_translateName.Data;
    hTable.table_Data_translateValue.Data=DataSet.table_Data_translateValue.Data;
    hTable.table_Data_translateRisk.Data=DataSet.table_Data_translateRisk.Data;
    hTable.table_Data_RiskTable.Data=DataSet.table_Data_RiskTable.Data;
    
    %     if strcmp(hData{3}.hRadiobuttonStatus,'replace')
    %         set(hRadiobuttonG(1),'SelectedObject',hRadiobuttonG(3));
    %     else
    %         set(hRadiobuttonG(1),'SelectedObject',hRadiobuttonG(2));
    %     end
end


hData{3}=hTable;
guidata(hSettingFig,hData);




end

function Change_Settle_Date_Callback(~,~)


hData = guidata(gcf);

set(hData{2}.DatePick,'String','')
calendar2('DestinationUI', hData{2}.DatePick,'SelectionType', 1,'Weekend',[0 0 0 0 0 1 1],'OutputDateFormat','dd/mm/yyyy');
pressOk='';
while strcmp(pressOk,'')
    pause(1);
    pressOk=get(hData{2}.DatePick,'String');
    
end

if ~isempty(hData{2}.LastDate)
    if (datetime(hData{2}.DatePick.String)>datetime(hData{2}.LastDate) || datetime(hData{2}.DatePick.String)<datetime(hData{2}.FirstDate))
        if isdatetime(hData{2}.LastDate)
            hData{2}.DatePick.String=datestr(hData{2}.LastDate,24);
        else
            hData{2}.DatePick.String=hData{2}.LastDate;
        end
        strErr= 'תאריך שבחרת לא נמצא בטווח התאריכים הקיים בקובץ הנתונים ההיסטוריים. יש לבחור תאריך בטווח התאריכים: ';
        if isdatetime(hData{2}.LastDate)
            strErr= [strErr  char(10) datestr(hData{2}.LastDate,24) ' - ' datestr(hData{2}.FirstDate,24) ];
        else
            strErr= [strErr  char(10) hData{2}.LastDate ' - ' hData{2}.FirstDate ];
        end
        
        errordlg(strErr)
        
    end
    
end


end



function EditSettingFile(source,~)
hData = guidata(gcf);

FigSize=hData{1}.FigSize;
typeS=source.Tag;



hFileSettingFig= figure(...
    'Units', 'pixels',...
    'Toolbar', 'none',...
    'Position', [(round(FigSize(1:2))+round(FigSize(3:4)./4)) round(FigSize(3:4)./2)],...
    'NumberTitle', 'off',...
    'Name', 'מאפייני קובץ',...
    'MenuBar', 'none',...
    'Resize', 'off',...
    'DockControls', 'off',...
    'Color', 0.8*[1 1 1],...
    'CloseRequestFcn',@CloseFig);

icon=imresize(imread('images.jpg'),[FigSize(5) FigSize(5)]);



%       'Position', [round((hPortfolioFig.Position(1)+hPortfolioFig.Position(2)*0.3)) round((hPortfolioFig.Position(2)+hPortfolioFig.Position(4)*0.3)) 100 FigSize(5)], ...

hFileSetting.tag=typeS;


uicontrol('Parent', hFileSettingFig, ...
    'Units', 'pixels', ...
    'Position', [round((hFileSettingFig.Position(3)*0.3)) round((hFileSettingFig.Position(4)*0.5)) FigSize(5) FigSize(5)], ...
    'String', '', ...
    'Callback', @Get_Path , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on',...
    'CData',icon,...
    'Tag','FileSetting');

hFileSetting.path=uicontrol('Parent', hFileSettingFig, ...
    'Units', 'pixels', ...
    'Position', [round((hFileSettingFig.Position(3)*0.5)) round((hFileSettingFig.Position(4)*0.5)) round(hFileSettingFig.Position(3)*0.4) FigSize(5)], ...
    'String', '', ...
    'Style', 'text',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 8,...
    'Enable','on');


DateTitle=uicontrol('Parent', hFileSettingFig, ...
    'Units', 'pixels', ...
    'Position', [round((hFileSettingFig.Position(3)*0.5)) round((hFileSettingFig.Position(4)*0.7)) round(hFileSettingFig.Position(3)*0.4) FigSize(5)], ...
    'String', 'פורמט תאריך', ...
    'Style', 'text',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'BackgroundColor', 0.8*[1 1 1],...
    'Visible','off');



hFileSetting.DatePickformat=uicontrol('Parent', hFileSettingFig, ...
    'Units', 'pixels', ...
    'Position', [round((hFileSettingFig.Position(3)*0.2)) round((hFileSettingFig.Position(4)*0.7)) round(hFileSettingFig.Position(3)*0.2) FigSize(5)], ...
    'String',{'dd/MM/yyyy','MM/dd/yyyy'}, ...
    'Value',1,...
    'Style', 'popup',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'Visible','off');
if strcmp(typeS,'EditPathHistFilePath')
    set(DateTitle, 'Visible','on');
    set( hFileSetting.DatePickformat, 'Visible','on');
end



hFileSetting.sheet=uicontrol('Parent', hFileSettingFig, ...
    'Units', 'pixels', ...
    'Position', [round((hFileSettingFig.Position(3)*0.2)) round((hFileSettingFig.Position(4)*0.2)) round(hFileSettingFig.Position(3)*0.2) FigSize(5)], ...
    'String',{'','',''}, ...
    'Value',1,...
    'Style', 'popup',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'Enable','on');


uicontrol('Parent', hFileSettingFig, ...
    'Units', 'pixels', ...
    'Position', [round((hFileSettingFig.Position(3)*0.05)) round((hFileSettingFig.Position(4)*0.05)) FigSize(5)*3 FigSize(5)], ...
    'String', 'שמור מיקום קובץ', ...
    'Callback', @Save_data, ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on',...
    'Tag','FileSettingSave');

if strcmp(typeS,'editAhzkotPortfolio')
    
    set(hPortfolio.Name,'String',hData{3}.table_Data_ahzakot.Data{([hData{3}.table_Data_ahzakot.Data{:,5}]==1),3})
    set(hPortfolio.sheet,'String',hData{3}.table_Data_ahzakot.Data{([hData{3}.table_Data_ahzakot.Data{:,5}]==1),1})
    set(hPortfolio.path,'String',hData{3}.table_Data_ahzakot.Data{([hData{3}.table_Data_ahzakot.Data{:,5}]==1),2})
elseif (strcmp(typeS,'EditPathHistFilePath'))
    set(hFileSetting.sheet,'String',hData{3}.table_Data_hist.Data{1});
    set(hFileSetting.path,'String',hData{3}.table_Data_hist.Data{2});
    
    
    set(hFileSetting.DatePickformat,'Value',1);
elseif (strcmp(typeS,'EditPathUniqIDField'))
    set(hFileSetting.sheet,'String',hData{3}.table_Data_Comper_field.Data{1});
    set(hFileSetting.path,'String',hData{3}.table_Data_Comper_field.Data{2});
elseif (strcmp(typeS,'EditPathTransFieldName'))
    set(hFileSetting.sheet,'String', hData{3}.table_Data_translateName.Data{1});
    set(hFileSetting.path,'String',hData{3}.table_Data_translateName.Data{2});
elseif (strcmp(typeS,'EditPathTransFieldValue'))
    set(hFileSetting.sheet,'String', hData{3}.table_Data_translateValue.Data{1});
    set(hFileSetting.path,'String',hData{3}.table_Data_translateValue.Data{2});
elseif (strcmp(typeS,'EditPathTransRiskTable'))
    set(hFileSetting.sheet,'String',hData{3}.table_Data_translateRisk.Data{1});
    set(hFileSetting.path,'String',hData{3}.table_Data_translateRisk.Data{2});
elseif (strcmp(typeS,'EditPathRiskTable'))
    set(hFileSetting.sheet,'String',hData{3}.table_Data_RiskTable.Data{1});
    set(hFileSetting.path,'String', hData{3}.table_Data_RiskTable.Data{2});
elseif (strcmp(typeS,'EditPathFileMissingValue'))
    set(hFileSetting.sheet,'String',hData{3}.table_Data_missingValue.Data{([hData{3}.table_Data_missingValue.Data{:,3}]==1),1});
    set(hFileSetting.path,'String',hData{3}.table_Data_missingValue.Data{([hData{3}.table_Data_missingValue.Data{:,3}]==1),2});
elseif (strcmp(typeS,'EditPathFileDefaultValue'))
    set(hFileSetting.sheet,'String',hData{3}.table_Data_DefaultValue.Data{([hData{3}.table_Data_DefaultValue.Data{:,3}]==1),1});
    set(hFileSetting.path,'String', hData{3}.table_Data_DefaultValue.Data{([hData{3}.table_Data_DefaultValue.Data{:,3}]==1),2});
end



hData{5}=hFileSetting;
guidata(hFileSettingFig,hData);


end

function OpenReportConflictsCallback(~,~)
hData = guidata(gcf);


FigSize=hData{1}.FigSize;


hReportConflictsFig = figure(...
    'Units', 'pixels',...
    'Toolbar', 'none',...
    'Position',FigSize(1:4),...
    'NumberTitle', 'off',...
    'Name', 'דוח סתירות',...
    'MenuBar', 'none',...
    'Resize', 'off',...
    'DockControls', 'off',...
    'Color', hData{1}.colorVec);


columnname =   {'שווי הרשומות התקינות [%]','שווי התיק','שווי הרשומות התקינות','הרשומות התקינות [%]','סהכ רשומות בתיק','הרשומות התקינות','שם התיק'} ;
columnformat = {'char','char','char','char','char','char','char'};
columneditable =  [false false false  false false false false];
hReportConflicts.table_C = uitable(hReportConflictsFig,'Units','normalized','Position',...
    [0 0.75 1 0.2], ...
    'Data',hData{7}.ConclusionR,...
    'ColumnName', columnname,...
    'ColumnWidth',{round(FigSize(3)*0.2),'auto',round(FigSize(3)*0.16),round(FigSize(3)*0.14),round(FigSize(3)*0.14),round(FigSize(3)*0.14),'auto'},...
    'ColumnFormat', columnformat,...
    'ColumnEditable', columneditable,...
    'RowName',[]);
%hReportConflicts.table_C.Position(3) = hReportConflicts.table_C.Extent(3);

jScroll_table_C = findjobj(hReportConflicts.table_C);
jTable_table_C = jScroll_table_C.getViewport.getView;
jTable_table_C.setAutoResizeMode(jTable_table_C.AUTO_RESIZE_SUBSEQUENT_COLUMNS);





columnname =   {'ערך סותר','ערך קיים','שדה','שם תיק','שווי נייר','קוד ISIN','שם נייר','מספר נייר'} ;
columnformat = {'char','char','char','char','char','char','char','char'};
columneditable =  [true false false false false false false false];
hReportConflicts.table_ReportConflicts = uitable(hReportConflictsFig,'Units','normalized','Position',...
    [0 0.2 1 0.5], ...
    'Data',hData{7}.Conflict,...
    'ColumnName', columnname,...
    'ColumnFormat', columnformat,...
    'ColumnEditable', columneditable,...
    'RowName',[]);
%hReportConflicts.table_ReportConflicts.Position(3) =hReportConflicts.table_ReportConflicts.Extent(3);
%hTable.table_ReportConflicts.Position(4) = hTable.table_Data_Comper_field.Extent(4);

jScroll = findjobj(hReportConflicts.table_ReportConflicts);
jTable = jScroll.getViewport.getView;
jTable.setAutoResizeMode(jTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);


uicontrol('Parent', hReportConflictsFig, ...
    'Units', 'pixels', ...
    'Position',  [FigSize(3)*0.35 20 FigSize(3)*0.6 50], ...
    'String', 'דוח הסתירות מכיל את הסתירות בערכים של שדות החובה ברשומות הכפולות של הניירות הערך בתיקים שנטענו.', ...
    'Style', 'text',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'BackgroundColor',hData{1}.colorVec,...
    'ForegroundColor',[0 0 0],...
    'Enable','on');

uicontrol('Parent', hReportConflictsFig, ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)-FigSize(3)*0.98) round(FigSize(4)-FigSize(4)*0.98) 100 FigSize(5)], ...
    'String', 'סגור', ...
    'Callback', @CloseWin , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on');

uicontrol('Parent',hReportConflictsFig, ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)-FigSize(3)*0.85) round(FigSize(4)-FigSize(4)*0.98) 100 FigSize(5)], ...
    'String', 'יצוא לאקסל', ...
    'Callback', @ExportExcel , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on');
guidata(hReportConflictsFig,hData);

end

function OpenReportComplitedCallback(~,~)

hData = guidata(gcf);



FigSize=hData{1}.FigSize;

hReportComplitedFig = figure(...
    'Units', 'pixels',...
    'Toolbar', 'none',...
    'Position', FigSize(1:4),...
    'NumberTitle', 'off',...
    'Name', 'דוח השלמות',...
    'MenuBar', 'none',...
    'Resize', 'off',...
    'DockControls', 'off',...
    'Color', hData{1}.colorVec);


uicontrol('Parent', hReportComplitedFig, ...
    'Units', 'pixels', ...
    'Position',  [FigSize(3)*0.35 20 FigSize(3)*0.6 50], ...
    'String', 'דוח השלמות מכיל דוחות עבור הערכים שהושלמו במספר דרכים: קבצי השלמה, קבצי ברירת המחדל או השלמה ידנית.', ...
    'Style', 'text',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'BackgroundColor',hData{1}.colorVec,...
    'ForegroundColor',[0 0 0],...
    'Enable','on');


columnname =   {'שווי הרשומות התקינות [%]','שווי התיק','שווי הרשומות התקינות','הרשומות התקינות [%]','סהכ רשומות בתיק','הרשומות התקינות','שם התיק'} ;
columnformat = {'char','char','char','char','char','char','char'};
columneditable =  [false false false  false false false false];
hReportComplited.table_C = uitable(hReportComplitedFig,'Units','normalized','Position',...
   [0 0.75 1 0.2], ...
    'Data',hData{7}.ConclusionR,...
    'ColumnName', columnname,...
    'ColumnWidth',{round(FigSize(3)*0.2),'auto',round(FigSize(3)*0.16),round(FigSize(3)*0.14),round(FigSize(3)*0.14),round(FigSize(3)*0.14),'auto'},...
    'ColumnFormat', columnformat,...
    'ColumnEditable', columneditable,...
    'RowName',[]);
%hReportComplited.table_C.Position(3) = hReportComplited.table_C.Extent(3);
jScroll_table_C = findjobj(hReportComplited.table_C);
jTable_table_C = jScroll_table_C.getViewport.getView;
jTable_table_C.setAutoResizeMode(jTable_table_C.AUTO_RESIZE_SUBSEQUENT_COLUMNS);



%%   Define default content for the main Tab

tabgp = uitabgroup(hReportComplitedFig,'Position',[.005 .2 0.99 .5],'TabLocation','right');
htabReportComplited(1) = uitab(tabgp,'Title','נתונים שהושלמו מקבצי השלמה','BackgroundColor',hData{1}.colorVec);
htabReportComplited(2) = uitab(tabgp,'Title','נתונים שהושלמו מברירת המחדל','BackgroundColor',hData{1}.colorVec);
htabReportComplited(3) = uitab(tabgp,'Title','נתונים שהושלמו ידנית','BackgroundColor',hData{1}.colorVec);

set(tabgp, 'SelectedTab',htabReportComplited(1) );

%%   Define default content for Tab 1
columnname =   {'ערך שהושלם','שדה','שם קופה','שווי נייר','קוד ISIN','שם נייר','מספר נייר'} ;
columnformat = {'char','char','char','char','char','char','char','char'};
columneditable =  [false false false false false false false false];
hReportComplited.table_Conflicts = uitable(htabReportComplited(1),'Units','normalized','Position',...
    [0 0.1 1 0.8], ...
    'Data',hData{7}.AddedM,...
    'ColumnName', columnname,...
    'ColumnFormat', columnformat,...
    'ColumnEditable', columneditable,...
    'RowName',[]);
%hReportComplited.table_Conflicts.Position(3) = hReportComplited.table_Conflicts.Extent(3);

jScroll_table_Conflicts = findjobj(hReportComplited.table_Conflicts);
jTable_table_Conflicts = jScroll_table_Conflicts.getViewport.getView;
jTable_table_Conflicts.setAutoResizeMode(jTable_table_Conflicts.AUTO_RESIZE_SUBSEQUENT_COLUMNS);


%%   Define default content for Tab 2
columnname =   {'ערך שהושלם','שדה','שם קופה','שווי נייר','קוד ISIN','שם נייר','מספר נייר'} ;
columnformat = {'char','char','char','char','char','char','char'};
columneditable =  [false false false  false false false false];
hReportComplited.table_MissingR = uitable(htabReportComplited(2),'Units','normalized','Position',...
    [0 0.1 1 0.8], ...
    'Data',hData{7}.AddedD,...
    'ColumnName', columnname,...
    'ColumnFormat', columnformat,...
    'ColumnEditable', columneditable,...
    'RowName',[]);
%hReportComplited.table_MissingR.Position(3) = hReportComplited.table_MissingR.Extent(3);

jScroll_table_MissingR = findjobj(hReportComplited.table_MissingR);
jTable_table_MissingR = jScroll_table_MissingR.getViewport.getView;
jTable_table_MissingR.setAutoResizeMode(jTable_table_MissingR.AUTO_RESIZE_SUBSEQUENT_COLUMNS);






%%   Define default content for Tab 3
columnname =   {'ערך שהושלם','שדה','שם קופה','שווי נייר','קוד ISIN','שם נייר','מספר נייר'} ;
columnformat = {'char','char','char','char','char','char','char'};
columneditable =  [false false false  false false false false];
hReportComplited.table_DefaultR = uitable(htabReportComplited(3),'Units','normalized','Position',...
    [0 0.1 1 0.8], ...
    'Data',hData{7}.ManualR,...
    'ColumnName', columnname,...
    'ColumnFormat', columnformat,...
    'ColumnEditable', columneditable,...
    'RowName',[]);
%hReportComplited.table_DefaultR.Position(3) = hReportComplited.table_DefaultR.Extent(3);

jScroll_table_DefaultR = findjobj(hReportComplited.table_DefaultR);
jTable_table_DefaultR = jScroll_table_DefaultR.getViewport.getView;
jTable_table_DefaultR.setAutoResizeMode(jTable_table_DefaultR.AUTO_RESIZE_SUBSEQUENT_COLUMNS);



uicontrol('Parent',hReportComplitedFig, ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)-FigSize(3)*0.98) round(FigSize(4)-FigSize(4)*0.98) 100 FigSize(5)], ...
    'String', 'סגור', ...
    'Callback', @CloseWin , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on');

uicontrol('Parent',hReportComplitedFig, ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)-FigSize(3)*0.85) round(FigSize(4)-FigSize(4)*0.98) 100 FigSize(5)], ...
    'String', 'יצוא לאקסל', ...
    'Callback', @ExportExcel , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on');


guidata(gcf,hData);



end

function OpenReportFaultHistData(~,~)
hData = guidata(gcf);


FigSize=hData{1}.FigSize;


hReportFaultHistFig = figure(...
    'Units', 'pixels',...
    'Toolbar', 'none',...
    'Position', FigSize(1:4),...
    'NumberTitle', 'off',...
    'Name', 'דוח שגויים נתוני שוק',...
    'MenuBar', 'none',...
    'Resize', 'off',...
    'DockControls', 'off',...
    'Color',hData{1}.colorVec);


uicontrol('Parent', hReportFaultHistFig, ...
    'Units', 'normalized', ...
    'Position',  [0.55 0.01 0.4 0.2], ...
    'String', 'הדוח מכיל את רשימת גורמי הסיכון שקיימים בטבלת גורמי הסיכון ולא קיימים בקובץ הנתונים ההיסטוריים.', ...
    'Style', 'text',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'BackgroundColor',hData{1}.colorVec,...
    'ForegroundColor',[0 0 0],...
    'Enable','on');




columnname =   {'גורמי סיכון חסרים בנתוני השוק ההיסטוריים'} ;
columnformat = {'char'};
columneditable =  [false ];
hReportFaultHist.table_C = uitable(hReportFaultHistFig,'Units','normalized','Position',...
    [0 0.3 1 0.4], ...
    'Data',hData{7}.errorRiskData,...
    'ColumnName', columnname,...
    'ColumnFormat', columnformat,...
    'ColumnEditable', columneditable,...
    'RowName',[]);
%hReportFaultHist.table_C.Position(3) = hReportFaultHist.table_C.Extent(3);

jScroll = findjobj(hReportFaultHist.table_C);
jTable = jScroll.getViewport.getView;
jTable.setAutoResizeMode(jTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);


uicontrol('Parent', hReportFaultHistFig, ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.02) round(FigSize(4)*0.02) 100 FigSize(5)], ...
    'String', 'סגור', ...
    'Callback', @CloseWin , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on');



end

function ExportHist(~,~)

hData = guidata(gcf);


[filename, pathname] = uiputfile(...
    {'*.csv';'*.xls';'*.xlsx';'*.*'},...
    'Save as');
if ~isnumeric(filename)
    fullfilename=[pathname filename];
    xlswrite(fullfilename,hData{8}.hist);
end

end

function LoadHist(~,~)

hData = guidata(gcf);
if (exist('DataSetting.mat','file'))
    load('DataSetting.mat')
    hData{3}=DataSet;
end
if size(hData,2)>=7
    if ~isempty(hData{7})
        
        hReport=hData{7};
    end
end

log_error.Data=[{'מספר השגיאה'} {'תאור השגיאה'} ];
log_error.ind=2;

hProgressBar=waitbar(0,'בדיקת תקינות קובץ טבלת גורמי הסיכון...');

if size(hData,2)>=8
    if ~isempty(hData{8})
        hExcelData=hData{8};
    end;
end
if (exist(hData{3}.table_Data_RiskTable.Data{2},'file'))
    [~,~,hExcelData.RiskTable]= xlsread(hData{3}.table_Data_RiskTable.Data{2},hData{3}.table_Data_RiskTable.Data{1});
    
else
    
    strErr= {'קובץ טבלת גורמי הסיכון לא קיים.'};
    
    strErr= [strErr  'נא הגדר מחדש את טבלת גורמי הסיכון וטען מחדש את הנתונים.' ];
    errordlg(strErr)
    delete(hProgressBar)
    return;
    
end

if (exist(hData{3}.table_Data_translateRisk.Data{2},'file'))
    [~,~,hExcelData.translateR]= xlsread(hData{3}.table_Data_translateRisk.Data{2},hData{3}.table_Data_translateRisk.Data{1});
    
    
else
    
    strErr= {'קובץ טבלת התרגום לשמות גורמי הסיכון בקבצי האחזקות לא קיים.'};
    
    strErr= [strErr  'נא הגדר מחדש את טבלת התרגום לערכי השדות בקבצי האחזקות וטען מחדש את הנתונים.' ];
    errordlg(strErr)
    delete(hProgressBar)
    return;
    
end



waitbar(0.3,hProgressBar,'בדיקת תקינות קובץ נתונים היסטוריים...');

if (exist(hData{3}.table_Data_hist.Data{2},'file'))
    [~,~,Datahist]= xlsread(hData{3}.table_Data_hist.Data{2},hData{3}.table_Data_hist.Data{1});
    
    
else
    
    strErr= {'קובץ הנתונים ההיסטוריים לא קיים.'};
    
    strErr= [strErr  'נא הגדר את קובץ הנתונים ההיסטוריים וטען מחדש את הנתונים.' ];
    errordlg(strErr)
    delete(hProgressBar)
    return;
end

waitbar(0.4,hProgressBar,'בדיקת תקינות קובץ נתונים היסטוריים...');




[tempV,ind]=sort(datetime(char(Datahist{2:end,1}),'Format',hData{3}.table_Data_hist.Data{3}),'descend' );

ind=[1;(ind+1)];
Datahist=Datahist(ind,:);
waitbar(0.5,hProgressBar,'ביצוע אינטרפולציה ואקסטרפולציה...');

%Interpolation and extrapolation
for i=2:size(Datahist,2)
    
    ind_incorrect=~cellfun(@isnumeric,Datahist(2:end,i));
    ind_incorrect=[0; ind_incorrect];
    ind_incorrect=find(ind_incorrect==1);
    ind_incorrect_ind=~cellfun(@(x) any(isnan(x)),Datahist(ind_incorrect,i));
    if nnz(ind_incorrect_ind)>0
        
        
        ind_incorrect_f=ind_incorrect(ind_incorrect_ind);
        errorNum=101;
        for ii=1:length(ind_incorrect_f)
            strErr= 'קובץ נתוני השוק מכיל ערכים לא מספריים בתאריך:';
            strErr= [strErr char(10) Datahist{ind_incorrect_f(ii),1}];
            
            strErr= [ strErr char(10) Datahist{1,i}   ' עבור פקטור  '];
            strErr= [ strErr char(10) 'נא תקן נתונים וטען מחדש.'];
            
            
            log_error.Data(log_error.ind,:)={ errorNum strErr};
            log_error.ind=log_error.ind+1;
        end
        Datahist(ind_incorrect_f,i)={nan};
    end
    
    
    
    logic_isnan=[cellfun(@(x) any(isnan(x)),Datahist(2:end,i))];
    ind_isnan=find(cellfun(@(x) any(isnan(x)),Datahist(2:end,i)));
    ind_isnan=ind_isnan+1;
    p=find(diff(ind_isnan)==1);
    q=unique([p';(p+1)']);
    interp_ind= ind_isnan(q);
    rownum=size(Datahist,1);
    if ~isempty(interp_ind)
        
        if interp_ind(1)==2
            ind=find(logic_isnan==0,1,'first');
            Datahist(2:(ind),i)=Datahist(ind+1,i);
            interp_ind(ismember(interp_ind,1:(ind)))=[];
        end
        if ~isempty(interp_ind)
            if interp_ind(end)==rownum
                ind=find(logic_isnan==0,1,'last');
                Datahist((ind+2):rownum,i)=Datahist(ind+1,i);
                interp_ind(ismember(interp_ind,(ind+2):rownum))=[];
            end
        end
    end
    ind_fill=ind_isnan;
    if ~isempty(q)
        ind_fill(q)=[];
    end
    if max(ind_fill)==rownum
        Datahist(rownum,i)=Datahist(rownum-1,i);
        [~,ind]=max(ind_fill);
        ind_fill(ind)=[];
    end
    
    Datahist(ind_fill,i)=Datahist(ind_fill+1,i);
    if ~isempty(interp_ind)
        if length(interp_ind)<(rownum-1)
            indValid=1:rownum;
            indValid(interp_ind)=[];
            dataValid=Datahist(indValid,i);
            Datahist(2:end,i)=num2cell(interp1(indValid(2:end),cell2mat(dataValid(2:end)),2:rownum)');
        end
    end
end

hData{2}.LastDate=Datahist(2,1);
hData{2}.FirstDate=Datahist(end,1);

if datetime(hData{2}.LastDate)>datetime('now')
    strErr= {'קובץ נתוני השוק מכיל נתונים בתאריכים עתידיים לתאריך המחשב. '};
    
    strErr= [strErr  'נא הסר תאריכים עתידיים וטען מחדש.' ];
    errordlg(strErr)
    delete(hProgressBar)
    return;
    
end

if isdatetime(hData{2}.LastDate)
    
    set(hData{2}.DatePick,'String',datestr(hData{2}.LastDate,24));
else
    set(hData{2}.DatePick,'String',hData{2}.LastDate);
end


waitbar(0.7,hProgressBar,'עדכון נתוני השוק... ');


vecCheck=[];
for i=2:size(Datahist,2)
    [row,~]=find(strcmp(Datahist{1,i},hExcelData.translateR));
    
    row=unique(row);
    if any(ismember(row,vecCheck))
        
        row_dop=row(ismember(row,vecCheck));
        
        strErr= 'גורמי הסיכון:';
        for j=1:length(row_dop)
            strErr= [strErr char(10) (hExcelData.translateR{row_dop(j),1})];
        end
        
        strErr=[strErr  char(10) 'מופו למספר עמודות בקובץ הנתונים ההיסטוריים'];
        
        
        
        errorNum=103;
        strErr=[strErr char(10) 'נא תקן את הקובץ או את טבלת התרגום וטען מחדש את הנתונים.'];
        log_error.Data(log_error.ind,:)={ errorNum (strErr)};
        log_error.ind= log_error.ind+1;
        
        
    end
    if any(~ismember(row,vecCheck))
        if length(row)>1
            
            %             strErr= 'גורם הסיכון';
            %             strErr= [strErr char(10) Datahist{1,i}];
            %             strErr= [ strErr char(10) ' מופה למספר עמודות בקובץ הנתונים ההיסטוריים. נא תקן את קובץ הנתונים ההיסטוריים  או את טבלת התרגום וטען מחדש את הנתונים'  ];
            %            errorNum=103;
            %             log_error.Data(log_error.ind,:)={errorNum strErr };
            %             log_error.ind=log_error.ind+1;
            
            
            row=row(~ismember(row,vecCheck));
            
            Datahist{1,i}=hExcelData.translateR{row(1),1};
            vecCheck=[vecCheck row'];
            
        elseif  length(row)==1
            Datahist{1,i}=hExcelData.translateR{row(1),1};
            vecCheck=[vecCheck row'];
            
            
        end
    end
end




if strcmp(hData{3}.hRadiobuttonStatus,'replace')
    hExcelData.hist=Datahist;
else
    ind=zeros((size(hExcelData.hist,2)),1);
    ind(1)=1;
    for i=2:size(hExcelData.hist,2)
        indtemp=find(strcmp(hExcelData.hist{1,i},Datahist(1,2:end)));
        
        if ~isempty(indtemp)
            ind(i)=indtemp(1)+1;
            
        end
    end
    column_empty=cell(size(Datahist,1),1);
    column_empty(:)={nan};
    
    Datahist_temp=cell(size(Datahist,1),size(hExcelData.hist,2));
    for i=1:length(ind)
        if ind(i)>0
            Datahist_temp(:,i)= Datahist(:,ind(i));
        else
            
            Datahist_temp(:,i)= column_empty;
        end
    end
    
    Datahist=Datahist_temp;
    ind=find(datetime(hExcelData.hist(2,1))>=datetime(cell2mat(Datahist(2:end,1)),'Format',hData{3}.table_Data_hist.Data{3}));
    ind=ind+1;
    
    if isempty(ind)
        hExcelData.hist= [hExcelData.hist(1,:) ;Datahist(2:end,:) ; hExcelData.hist(2:end,:)] ;
        
    elseif ind(1)>2
        hExcelData.hist=[hExcelData.hist(1,:) ;Datahist(2:(ind(1)-1),:) ; hExcelData.hist(2:end,:)] ;
        
    end
    
    
end

vecMiss=[];
vecCheck=[];
for i=2:size(hExcelData.RiskTable,1)
    
    
    [row,~]=find(strcmp(hExcelData.RiskTable{i,1},hExcelData.translateR));
    
    row=unique(row);
    if any(ismember(row,vecCheck))
        
        row_dop=row(ismember(row,vecCheck));
        
        strErr= 'גורמי הסיכון:';
        for j=1:length(row_dop)
            strErr= [strErr char(10) (hExcelData.translateR{row_dop(j),1})];
        end
        
        strErr=[strErr  char(10) 'מופו למספר עמודות בטבלת גורמי הסיכון'];
        
        
        
        errorNum=104;
        strErr=[strErr char(10) 'נא תקן את הקובץ או את טבלת התרגום וטען מחדש את הנתונים.'];
        log_error.Data(log_error.ind,:)={ errorNum (strErr)};
        log_error.ind= log_error.ind+1;
        
        
    end
    if any(~ismember(row,vecCheck))
        if length(row)>1
            
            %             strErr= 'גורם הסיכון';
            %             strErr= [strErr char(10) hExcelData.RiskTable{i,1}];
            %             strErr= [ strErr char(10) 'מופה מספר עמודות בטבלת גורמי הסיכון. נא תקן את קובץ או את טבלת התרגום וטען מחדש את הנתונים'  ];
            %             errorNum=104;
            %             log_error.Data(log_error.ind,:)={errorNum (strErr)};
            %             log_error.ind=log_error.ind+1;
            
            
            row=row(~ismember(row,vecCheck));
            
            hExcelData.RiskTable{i,1}=hExcelData.translateR{row(1),1};
            vecCheck=[vecCheck row'];
            
        elseif  length(row)==1
            hExcelData.RiskTable{i,1}=hExcelData.translateR{row(1),1};
            vecCheck=[vecCheck row'];
            
            
        elseif  length(row)==0
            vecMiss=[vecMiss ;(i)];
        end
    end
    
end

if ~isempty(vecMiss)
    strErr= 'גורמי הסיכון:';
    for j=1:length(vecMiss)
        strErr= [strErr char(10) ( hExcelData.RiskTable{vecMiss(j),1})];
    end
    
    strErr=[strErr  char(10) 'בטבלת גורמי הסיכון לא מזוהים בטבלת התרגום. '];
    
    
    
    errorNum=105;
    strErr=[strErr char(10) 'א תקן את טבלת גורמי הסיכון או את טבלת התרגום וטען מחדש את הנתונים.'];
    log_error.Data(log_error.ind,:)={ errorNum (strErr)};
    log_error.ind= log_error.ind+1;
    
end

ind=~cellfun(@(x) any(isnan(x))| any(isempty(x)),hExcelData.RiskTable(1:end,1));

hExcelData.RiskTable=hExcelData.RiskTable(ind==1,:);

ind=zeros((size(hExcelData.hist,2)),1);
ind(1)=1;
ind_r=zeros((size(hExcelData.RiskTable,1)),1);
ind_r(1)=1;

for i=2:size(hExcelData.RiskTable,1)
    indtemp=find(strcmp(hExcelData.RiskTable{i,1},hExcelData.hist(1,1:end)));
    if ~isempty(indtemp)
        
        
        ind_r(i)=1;
        ind(indtemp)=1;
        
    end
end
ind_Risk_miss=find(ind_r==0);
errorRiskData=cell(size(ind_Risk_miss));
if isempty(ind_Risk_miss)
    
    hReport.errorRiskData=errorRiskData;
end
if   any(ind_r==0)
    
    strErr= {'גורמי הסיכון הבאים:'};
    
    for i=1:length(ind_Risk_miss)
        
        strErr= [strErr char(10) hExcelData.RiskTable{ind_Risk_miss(i),1}];
        hReport.errorRiskData(i)=hExcelData.RiskTable(ind_Risk_miss(i),1);
    end
    strErr= [ strErr char(10)  'קיימים בטבלת הגדרת גורמי הסיכון, אינם קיימים בקובץ נתוני השוק ההיסטוריים.  '  ];
    strErr= [ strErr char(10)  'נא תקן את קובץ הנתונים ההיסטוריים או את טבלת התרגום וטען מחדש את הנתונים'  ];
    errordlg(strErr)
    delete(hProgressBar)
    set(hData{2}.btnLoadData,'Enable','off');
    set(hData{2}.btnExportHist,'Enable','on');
    set(hData{2}.btnReportFaultHistData,'Enable','on');
    
    DataSet=hData{3};
    hData{7}=hReport;
    guidata(gcbo,hData);
    save('DataSetting.mat','DataSet');
    return;
end

ind_hist_miss=find(ind==0);
if isempty(ind_hist_miss)
    strErr= 'גורמי הסיכון הבאים:';
    for i=1:length(ind_hist_miss)
        strErr= [strErr char(10) hExcelData.hist{1,ind_hist_miss(i)}];
    end
    strErr= [ strErr char(10)  'קיימים בקובץ נתוני השוק ולא קיימים בטבלת הגדרת גורמי הסיכון. '  ];
    strErr= [ strErr char(10)  'נא תקן את קובץ הנתונים ההיסטוריים או את טבלת התרגום וטען מחדש את הנתונים'  ];
    errorNum=102;
    log_error.Data(log_error.ind,:)={(strErr) errorNum};
    log_error.ind=log_error.ind+1;
    
end

indName=find(strcmp('Factor Name',hExcelData.RiskTable(1,:)));
if isempty(indName)
    indName=1;
end
indClass=find(strcmp('Factor class',hExcelData.RiskTable(1,:)));
indTerm=find(strcmp('Term',hExcelData.RiskTable(1,:)));
indMultiplier=find(strcmp('Multiplier',hExcelData.RiskTable(1,:)));

if ~isempty(indClass)
    incorrect_Class=ismember(cell2mat(hExcelData.RiskTable(2:end,indClass)),{'EQ','FX','IR','SP','CM','EC','RE'});
    incorrect_Class=[1;incorrect_Class];
    incorrect_Class=find(incorrect_Class==0);
    
    
    if ~isempty(incorrect_Class)
        
        
        strErr= 'סוג גורם הסיכון – עמודת Factor Class עבור גורמי סיכון:';
        for i=1:length(incorrect_Class)
            strErr= [strErr char(10) hExcelData.RiskTable{incorrect_Class(i),indName}];
        end
        strErr= [ strErr char(10)  'בטבלת גורמי הסיכון לא מזוהה במערכת.'  ];
        strErr= [ strErr char(10)  'נא תקן את טבלת גורמי הסיכון וטען מחדש את הנתונים.'  ];
        errorNum=106;
        log_error.Data(log_error.ind,:)={errorNum (strErr)};
        log_error.ind=log_error.ind+1;
        
    end
end

if ~isempty(indTerm)
    incorrect_Term=cellfun(@isnumeric,(hExcelData.RiskTable(2:end,indTerm)));
    incorrect_Term=[1;incorrect_Term];
    incorrect_Term=find(incorrect_Term==0);
    
    if ~isempty(incorrect_Term)
        
        
        strErr= 'התקופה הרלוונטית (עמודת Tetm  ) עבור גורמי סיכון:';
        for i=1:length(incorrect_Term)
            strErr= [strErr char(10) hExcelData.RiskTable{incorrect_Term(i),indName}];
        end
        strErr= [ strErr char(10)  'בטבלת גורמי הסיכון לא מזוהה במערכת.'  ];
        strErr= [ strErr char(10)  'נא תקן את טבלת גורמי הסיכון וטען מחדש את הנתונים.'  ];
        errorNum=107;
        log_error.Data(log_error.ind,:)={ errorNum (strErr)};
        log_error.ind=log_error.ind+1;
        
    end
    
end

if ~isempty(indMultiplier)
    incorrect_Multiplier=cellfun(@isnumeric,(hExcelData.RiskTable(2:end,indMultiplier)));
    incorrect_Multiplier=[1;incorrect_Multiplier];
    incorrect_Multiplier=find(incorrect_Multiplier==0);
    
    
    if ~isempty(incorrect_Multiplier)
        
        strErr= 'המכפיל (עמודת multiplier) עבור גורמי סיכון :';
        for i=1:length(incorrect_Multiplier)
            strErr= [strErr char(10) hExcelData.RiskTable{incorrect_Multiplier(i),indName}];
        end
        strErr= [ strErr char(10)  'בטבלת גורמי הסיכון לא מזוהה במערכת.'  ];
        strErr= [ strErr char(10)  'נא תקן את טבלת גורמי הסיכון וטען מחדש את הנתונים.'  ];
        errorNum=108;
        log_error.Data(log_error.ind,:)={errorNum (strErr) };
        log_error.ind=log_error.ind+1;
        
        
    end
    
end


set(hData{2}.btnDatepick,'Enable','on')

set(hData{2}.btnLoadData,'Enable','on');
set(hData{2}.btnExportHist,'Enable','on');
set(hData{2}.btnReportFaultHistData,'Enable','on');



waitbar(0.9,hProgressBar,'שמירת קובץ מערכת של נתוני השוק ...');

pause(0.1);


xlswrite([pwd '\log\LoadHistError' datestr(now,'ddmmyyyy') '.xlsx'],log_error.Data);

ind=strfind(hData{3}.table_Data_hist.Data{2},'\');
path_t=hData{3}.table_Data_hist.Data{2}(1:ind(end));
delete([path_t 'SysHistFile*.*']);
filename=[path_t 'SysHistFile' datestr(now,'ddmmyyyy') '.xlsx'];
% hData{3}.table_Data_hist.Data{2}=filename;
% hData{3}.table_Data_hist.Data{1}='Sheet1';
xlswrite(filename,hExcelData.hist);
DataSet=hData{3};
hData{8}= hExcelData;
hData{7}=hReport;
guidata(gcbo,hData);
save('DataSetting.mat','DataSet');




waitbar(1,hProgressBar,'הטעינה הושלמה בהצלחה!');
pause(2);
delete(hProgressBar);


end


function LoadData(~,~)


hData = guidata(gcf);
if (exist('DataSetting.mat','file'))
    load('DataSetting.mat')
    hData{3}=DataSet;
end
if size(hData,2)>=7
    if ~isempty(hData{7})
        hReport=hData{7};
    end
end
if size(hData,2)>=8
    if ~isempty(hData{8})
        hExcelData=hData{8};
    end
end
log_error.Data=[ {'מספר השגיאה'} {'תאור השגיאה'}];
log_error.ind=2;
hProgressBar=waitbar(0,'בדיקת תקינות קבצי טבלאות תרגום...');

hData{2}.Portfolio.Data={[] [] false};


if (exist(hData{3}.table_Data_translateName.Data{2},'file'))
    [~,~,hExcelData.translateN]= xlsread(hData{3}.table_Data_translateName.Data{2},hData{3}.table_Data_translateName.Data{1});
    
    
else
    
    strErr= {'קובץ טבלת התרגום לשמות השדות בקבצי האחזקות לא קיים.'};
    
    strErr= [strErr  'נא הגדר מחדש את טבלת התרגום לשמות השדות בקבצי האחזקות וטען מחדש את הנתונים.' ];
    errordlg(strErr)
    delete(hProgressBar)
    return;
    
end

if (exist(hData{3}.table_Data_translateValue.Data{2},'file'))
    [~,~,hExcelData.translateV]= xlsread(hData{3}.table_Data_translateValue.Data{2},hData{3}.table_Data_translateValue.Data{1});
    
    
else
    
    strErr= {'קובץ טבלת התרגום לערכי השדות בקבצי האחזקות לא קיים.'};
    
    strErr= [strErr  'נא הגדר מחדש את טבלת התרגום לערכי השדות בקבצי האחזקות וטען מחדש את הנתונים.' ];
    errordlg(strErr)
    delete(hProgressBar)
    return;
    
end



if ~isfield(hExcelData,'RiskTable')
    if (exist(hData{3}.table_Data_RiskTable.Data{2},'file'))
        [~,~,hExcelData.RiskTable]= xlsread(hData{3}.table_Data_RiskTable.Data{2},hData{3}.table_Data_RiskTable.Data{1});
        
        
    else
        
        strErr= {'קובץ טבלת גורמי הסיכון לא קיים.'};
        
        strErr= [strErr  'נא הגדר מחדש את טבלת גורמי הסיכון וטען מחדש את הנתונים.' ];
        errordlg(strErr)
        delete(hProgressBar)
        return;
        
    end
    
    if (exist(hData{3}.table_Data_translateRisk.Data{2},'file'))
        [~,~,hExcelData.translateR]= xlsread(hData{3}.table_Data_translateRisk.Data{2},hData{3}.table_Data_translateRisk.Data{1});
        
        
    else
        
        strErr= {'קובץ טבלת התרגום לשמות גורמי הסיכון בקבצי האחזקות לא קיים.'};
        
        strErr= [strErr  'נא הגדר מחדש את טבלת התרגום לערכי השדות בקבצי האחזקות וטען מחדש את הנתונים.' ];
        errordlg(strErr)
        delete(hProgressBar)
        return;
        
    end
    
    
    
end


waitbar(0.2,hProgressBar ,'בדיקת תקינות קבצי אחזקות...');
checkAr=zeros(1,sum([hData{3}.table_Data_ahzakot.Data{:,4}]==1));
if size(hData{3}.table_Data_ahzakot.Data,1)==0
    strErr= 'לא הגדרו קבצי אחזקות.';
    
    strErr= [strErr  'נא הגדר את קבצי האחזקות וטען מחדש את הנתונים.' ];
    errordlg(strErr)
    delete(hProgressBar)
    return;
elseif sum([hData{3}.table_Data_ahzakot.Data{:,4}]==1)<1
    strErr= 'לא נבחרו קבצי אחזקות לטעינה';
    
    strErr= [strErr  'נא בחר קבצי אחזקות וטען מחדש את הנתונים.' ];
    errordlg(strErr)
    delete(hProgressBar)
    return;
end
j=1;
indexDataAhzakotValid=find([hData{3}.table_Data_ahzakot.Data{:,4}]==1);
for i=1:length(indexDataAhzakotValid)
    if (exist(hData{3}.table_Data_ahzakot.Data{indexDataAhzakotValid(i),2},'file'))
        checkAr(i)=1;
    else
        path_file=hData{3}.table_Data_ahzakot.Data{indexDataAhzakotValid(i),2};
        ind=strfind(path_file,'\');
        
        
        NameArr{j}=path_file((max(ind)+1):end);
        j=j+1;
    end
end

if sum(checkAr)~=length(checkAr)
    
    if (length(checkAr)-sum(checkAr))>1
        strErr= 'קבצי האחזקות הבאים לא קיימים:';
        
        for i=1:(j-1)
            strErr= [strErr char(10) NameArr{i}];
            
        end
        strErr= [ strErr char(10) 'לא קיימים.  נא הגדר מחדש את קבצי האחזקות וטען מחדש את הנתונים.'  ];
        
        errordlg(strErr)
        delete(hProgressBar)
        return;
        
    else
        
        strErr= 'קובץ האחזקות';
        strErr= [strErr NameArr ];
        strErr= [strErr  'לא קיים. נא הגדר מחדש את קובץ האחזקות וטען מחדש את הנתונים.' ];
        errordlg(strErr)
        delete(hProgressBar)
        return;
        
    end
end


if checkAr(1)==1
    path_file=hData{3}.table_Data_ahzakot.Data{indexDataAhzakotValid(1),2};
    sheet_name=hData{3}.table_Data_ahzakot.Data{indexDataAhzakotValid(1),1};
    ind=strfind(path_file,'\');
    filename=path_file((max(ind)+1):end);
    [~,~,hExcelData.Portfolio{1,1}]= xlsread(path_file,sheet_name);
    filenamecolumn=cell(size( hExcelData.Portfolio{1,1},1),1);
    rownum=cell(size( hExcelData.Portfolio{1,1},1),1);
    filenameind=cell(size( hExcelData.Portfolio{1,1},1),1);
    FilledIndicator=cell(size( hExcelData.Portfolio{1,1},1),1);
    
    filenamecolumn(1)={'filename'};
    filenamecolumn(2:end)={filename};
    filenameind(1)={'filename_ind'};
    filenameind(2:end)={1};
    rownum(1)={'rownum'};
    rownum(2:end)=mat2cell((2:length(rownum))',ones(length(rownum)-1,1));
    FilledIndicator(1)={'Filled_Indicator'};
    FilledIndicator(2:end)=mat2cell(ones(length(rownum)-1,1),ones(length(rownum)-1,1));
    hExcelData.Portfolio{1,1}=[filenamecolumn filenameind  rownum FilledIndicator hExcelData.Portfolio{1,1}];
    [hExcelData.Portfolio{1,1},log_error]=MapFieldName(hExcelData.Portfolio{1,1},hExcelData.translateN,filename,log_error,0);
    hExcelData.Portfolio{6,1}(1)={1:size(hExcelData.Portfolio{1,1},2)};
    
end
if length(indexDataAhzakotValid)>1
    for i=2:length(indexDataAhzakotValid)
        if checkAr(i)==0
            continue;
        end
        path_file=hData{3}.table_Data_ahzakot.Data{indexDataAhzakotValid(i),2};
        sheet_name=hData{3}.table_Data_ahzakot.Data{indexDataAhzakotValid(i),1};
        ind=strfind(path_file,'\');
        filename=path_file((max(ind)+1):end);
        [~,~,hExcelDataPortfolio_temp]= xlsread(path_file,sheet_name);
        filenamecolumn=cell(size(hExcelDataPortfolio_temp,1),1);
        rownum=cell(size( hExcelDataPortfolio_temp,1),1);
        filenameind=cell(size(hExcelDataPortfolio_temp,1),1);
        FilledIndicator=cell(size(hExcelDataPortfolio_temp,1),1);
        
        
        filenamecolumn(1)={'filename'};
        filenamecolumn(2:end)={filename};
        filenameind(1)={'filename_ind'};
        filenameind(2:end)={i};
        rownum(1)={'rownum'};
        rownum(2:end)=mat2cell((2:length(rownum))',ones(length(rownum)-1,1));
        FilledIndicator(1)={'Filled_Indicator'};
        FilledIndicator(2:end)=mat2cell(ones(length(rownum)-1,1),ones(length(rownum)-1,1));
        column_ind=[1 2 3 4];
        hExcelDataPortfolio_temp=[filenamecolumn filenameind rownum FilledIndicator hExcelDataPortfolio_temp];
        
        [hExcelDataPortfolio_temp,log_error]=MapFieldName(hExcelDataPortfolio_temp,hExcelData.translateN,filename,log_error,0);
        
        for j=1:size(hExcelDataPortfolio_temp,2)
            
            ind=find(strcmp(hExcelDataPortfolio_temp(1,j),hExcelData.Portfolio{1,1}(1,:)));
            if j==1
                tempPortf=cell(size(hExcelData.Portfolio{1,1},1)+size(hExcelDataPortfolio_temp,1)-1,size(hExcelData.Portfolio{1,1},2));
            else
                tempPortf=cell(size(hExcelData.Portfolio{1,1},1),size(hExcelData.Portfolio{1,1},2));
            end
            
            if ~isempty(ind)
                tempPortf(1:size(hExcelData.Portfolio{1,1},1),1:size(hExcelData.Portfolio{1,1},2))= hExcelData.Portfolio{1,1};
                
                
                tempPortf((end-length(hExcelDataPortfolio_temp(2:end,j))+1):end,ind(1))=hExcelDataPortfolio_temp(2:end,j);
                hExcelData.Portfolio{1,1}=tempPortf;
                column_ind=[column_ind ind(1)];
            else
                tempPortf=[tempPortf tempPortf(:,1)];
                tempPortf(1:size(hExcelData.Portfolio{1,1},1),1:size(hExcelData.Portfolio{1,1},2))= hExcelData.Portfolio{1,1};
                
                tempCol=cell(size(tempPortf,1),1);
                tempCol(1)=hExcelDataPortfolio_temp(1,j);
                tempCol((end-length(hExcelDataPortfolio_temp(2:end,j))+1):end)=hExcelDataPortfolio_temp(2:end,j);
                column_ind=[column_ind size(tempPortf,2)];
                tempPortf(:,end)=tempCol;
                hExcelData.Portfolio{1,1}=tempPortf;
            end
            
        end
        hExcelData.Portfolio{6,1}(i)={column_ind};
        
        
    end
end




waitbar(0.4,hProgressBar,'בדיקת תקינות קבצי השלמה...');



checkAr=zeros(1,size(hData{3}.table_Data_DefaultValue.Data,1));
j=1;
k=1;
for i=1:size(hData{3}.table_Data_DefaultValue.Data,1)
    if (exist(hData{3}.table_Data_DefaultValue.Data{i,2},'file'))
        [~,~,hExcelData.CompletionD{k}]= xlsread(hData{3}.table_Data_DefaultValue.Data{i,2},hData{3}.table_Data_DefaultValue.Data{i,1});
        if ~(isempty(hExcelData.CompletionD{k}))
            checkAr(i)=1;
            k=k+1;
        else
            ind=strfind(hData{3}.table_Data_DefaultValue.Data{i,2},'\');
            NameArr{j}=hData{3}.table_Data_DefaultValue.Data{i,2}((ind(end)+1):end);
            j=j+1;
        end
        
    else
        ind=strfind(hData{3}.table_Data_DefaultValue.Data{i,2},'\');
        NameArr{j}=hData{3}.table_Data_DefaultValue.Data{i,2}((ind(end)+1):end);
        j=j+1;
    end
end
waitbar(0.44,hProgressBar,'ביצוע השלמה אוטומטית של חוסרים...');
if sum(checkAr)~=length(checkAr)
    
    if (length(checkAr)-sum(checkAr))>1
        strErr= 'קבצי נתוני ברירת המחדל:';
        
        for i=1:(length(checkAr)-sum(checkAr))
            strErr= [strErr char(10) NameArr{i}];
            
        end
        strErr= [ strErr char(10) 'לא קיימים.נא הגדר מחדש את קבצי הנתונים ברירת המחדל וטען מחדש את הנתונים.'  ];
        
        errordlg(strErr)
        delete(hProgressBar)
        return;
        
    else
        
        strErr= 'קובץ נתוני ברירת המחדל:';
        strErr= [strErr NameArr ];
        strErr= [strErr  'לא קיים.נא הגדר מחדש את קבצי הנתונים ברירת המחדל וטען מחדש את הנתונים.' ];
        errordlg(strErr)
        delete(hProgressBar)
        return;
        
    end
end

checkAr=zeros(1,size(hData{3}.table_Data_missingValue.Data,1));
j=1;
k=1;
for i=1:size(hData{3}.table_Data_missingValue.Data,1)
    if (exist(hData{3}.table_Data_missingValue.Data{i,2},'file'))
        [~,~,hExcelData.CompletionM{k}]= xlsread(hData{3}.table_Data_missingValue.Data{i,2},hData{3}.table_Data_missingValue.Data{i,1});
        if ~(isempty(hExcelData.CompletionM{k}))
            checkAr(i)=1;
            k=k+1;
        else
            ind=strfind(hData{3}.table_Data_missingValue.Data{i,2},'\');
            NameArr{j}=hData{3}.table_Data_missingValue.Data{i,2}((ind(end)+1):end);
            j=j+1;
        end
        
    else
        ind=strfind(hData{3}.table_Data_missingValue.Data{i,2},'\');
        NameArr{j}=hData{3}.table_Data_missingValue.Data{i,2}((ind(end)+1):end);
        j=j+1;
    end
end
waitbar(0.48,hProgressBar,'ביצוע השלמה אוטומטית של חוסרים...');
if sum(checkAr)~=length(checkAr)
    
    if (length(checkAr)-sum(checkAr))>1
        strErr= 'קבצי נתוני ההשלמה: ';
        
        for i=1:(length(checkAr)-sum(checkAr))
            strErr= [strErr char(10) NameArr{i}];
            
        end
        strErr= [ strErr char(10) 'לא קיימים. נא הגדר מחדש את קבצי נתוני ההשלמה וטען מחדש את הנתונים.'  ];
        
        errordlg(strErr)
        delete(hProgressBar)
        return;
        
    else
        
        strErr= 'קובץ נתוני ההשלמה:';
        strErr= [strErr NameArr ];
        strErr= [strErr  'לא קיים. נא הגדר מחדש את קובץ ההשלמה וטען מחדש את הנתונים.' ];
        errordlg(strErr)
        delete(hProgressBar)
        return;
        
    end
end


waitbar(0.5,hProgressBar,'ביצוע השלמה אוטומטית של חוסרים...');

if (exist([pwd '\Completion\MustField.xlsx'],'file'))
    [~,~,hconfig.MustField]=xlsread( [pwd '\Completion\MustField.xlsx']) ;
else
    strErr= {'קובץ המערכת המגדיר את שדות החובה לא קיים.'};
    
    strErr= [strErr  'נא פנה למנהל המערכת.' ];
    errordlg(strErr)
    delete(hProgressBar)
    return;
end


if (exist(hData{3}.table_Data_Comper_field.Data{2},'file'))
    [~,~,hconfig.UniqeIdentifier]=xlsread( hData{3}.table_Data_Comper_field.Data{2}, hData{3}.table_Data_Comper_field.Data{1}) ;
else
    errorNum=209;
    strErr= 'קובץ המערכת המגדיר את שדות ההתאמה לא קיים';
    
    strErr= [strErr  'נא הגדר את הקובץ וטען מחדש את הנתונים.' ];
    log_error.Data(log_error.ind,:)={ errorNum (strErr)};
    log_error.ind= log_error.ind+1;
    
    
    hconfig.UniqeIdentifier=[];
end



for i=1:size(hExcelData.CompletionM,2)
    
    path_file= hData{3}.table_Data_missingValue.Data{i,2};
    ind=strfind(path_file,'\');
    filename=path_file((max(ind)+1):end);
    [hExcelData.CompletionM{i},log_error]=MapFieldName(hExcelData.CompletionM{i},hExcelData.translateN,filename,log_error,1);
    
end

for i=1:size(hExcelData.CompletionD,2)
    
    path_file=  hData{3}.table_Data_DefaultValue.Data{i,2} ;
    ind=strfind(path_file,'\');
    filename=path_file((max(ind)+1):end);
    
    
    [hExcelData.CompletionD{i},log_error]=MapFieldName(hExcelData.CompletionD{i},hExcelData.translateN,filename,log_error,2);
end


k=1;
m=1;
hExcelData.Portfolio{2,1}=[ {' '} {' '} {' '} {' '}];
hExcelData.Portfolio{3,1}=[ {' '} {' '} {' '} {' '} {' '}];
hExcelData.Portfolio{4,1}=[ {' '} {' '} {' '} {' '}];
hExcelData.Portfolio{5,1}=[ {' '} {' '} {' '} {' '} ];

indID=find(strcmp('Security_ID',hExcelData.Portfolio{1,1}(1,:)));
indType=find(strcmp('Security_Type',hExcelData.Portfolio{1,1}(1,:)));
ind_Pdate=find(strcmp('Data_Date',hExcelData.Portfolio{1,1}(1,:)));
ind_Pname=find(strcmp('Portfolio_Name',hExcelData.Portfolio{1,1}(1,:)));
ind_PId=find(strcmp('Portfolio_ID',hExcelData.Portfolio{1,1}(1,:)));
ind_Underlying_Factor=find(strcmp('Underlying_Factor_Name',hExcelData.Portfolio{1,1}(1,:)));
ind_Security_Currency=find(strcmp('Security_Currency',hExcelData.Portfolio{1,1}(1,:)));
ind_Underlying_Asset=find(strcmp('Underlying_Asset_Currency',hExcelData.Portfolio{1,1}(1,:)));




%create unique ID for Portfolios and filling the windows of choosing Portfolios

if ~isempty(ind_Pdate) && ~isempty(ind_Pname)
    tempPortf=cell(size(hExcelData.Portfolio{1,1},1),size(hExcelData.Portfolio{1,1},2)+1);
    tempPortf(1:size(hExcelData.Portfolio{1,1},1),1:size(hExcelData.Portfolio{1,1},2))= hExcelData.Portfolio{1,1};
    tempCol=cell(size(tempPortf,1),1);
    tempCol(1)={'uniqueIdPortfolio'};
    tempCol(2:end)=strcat((hExcelData.Portfolio{1,1}(2:end,ind_Pname)) ,(hExcelData.Portfolio{1,1}(2:end,ind_Pdate)));
    
    tempPortf(:,end)=tempCol;
    
    ind_Pname_valid=~cellfun('isempty',hExcelData.Portfolio{1,1}(1:end,ind_Pname));
    ind_Pdate_valid=~cellfun('isempty',hExcelData.Portfolio{1,1}(1:end,ind_Pdate));
    hExcelData.Portfolio{1,1}=tempPortf(ind_Pname_valid & ind_Pdate_valid,:);
    
    [~,ind_un,~]=unique(hExcelData.Portfolio{1,1}(2:end,end));
    for i=1:length(ind_un)
        hData{2}.Portfolio.Data{i,1}=cell2mat(hExcelData.Portfolio{1,1}(ind_un(i)+1,ind_Pdate));
        hData{2}.Portfolio.Data{i,2}=cell2mat(hExcelData.Portfolio{1,1}(ind_un(i)+1,ind_Pname));
        hData{2}.Portfolio.Data{i,3}=false;
    end
    clear tempCol tempPortf;
    
end






for j=2:size(hExcelData.Portfolio{1,1},1)
    %check correctness of critical field but not "must" field that need for the pricing stage
    if ~isempty(ind_PId)
        
        checkVlaue=checkCorectVal(hExcelData.Portfolio{1,1}(j,ind_PId),'num',hExcelData);
        if  isempty(checkVlaue)
            strErr= ['השדה  Portfolio_ID בקובץ '];
            
            strErr= [strErr char(10) cell2mat(hExcelData.Portfolio{1,1}(j,1))];
            strErr= [strErr char(10) 'בשורה מספר '];
            strErr= [strErr char(10) num2str(cell2mat(hExcelData.Portfolio{1,1}(j,3)))];
            strErr= [strErr char(10) 'לא תקין'];
            errorNum=205;
            log_error.Data(log_error.ind,:)={errorNum (strErr)   };
            log_error.ind= log_error.ind+1;
            
        end
  
    end
    
    if ~isempty(ind_Pname)
        
        checkVlaue=checkCorectVal(hExcelData.Portfolio{1,1}(j,ind_Pname),'txt',hExcelData);
        if  isempty(checkVlaue)
            strErr= ['השדה  Portfolio_Name בקובץ '];
            
            strErr= [strErr char(10) cell2mat(hExcelData.Portfolio{1,1}(j,1))];
            strErr= [strErr char(10) 'בשורה מספר '];
            strErr= [strErr char(10) num2str(cell2mat(hExcelData.Portfolio{1,1}(j,3)))];
            strErr= [strErr char(10) 'לא תקין'];
            errorNum=206;
            log_error.Data(log_error.ind,:)={ errorNum (strErr)};
            log_error.ind= log_error.ind+1;
            
        end

    end
    
    if ~isempty(ind_Pdate)
        
        
        checkVlaue=checkCorectVal(hExcelData.Portfolio{1,1}(j,ind_Pdate),'date',hExcelData);
        if  isempty(checkVlaue)
            strErr= 'השדה  Data_Date בקובץ ';
            
            strErr= [strErr char(10) cell2mat(hExcelData.Portfolio{1,1}(j,1))];
            strErr= [strErr char(10) 'בשורה מספר '];
            strErr= [strErr char(10) num2str(cell2mat(hExcelData.Portfolio{1,1}(j,3)))];
            strErr= [strErr char(10) 'לא תקין'];
            errorNum=207;
            log_error.Data(log_error.ind,:)={errorNum (strErr) };
            log_error.ind= log_error.ind+1;
        end
  
    end
    
    if ~isempty(indID)
        
        
        checkVlaue=checkCorectVal(hExcelData.Portfolio{1,1}(j,indID),'num',hExcelData);
        if  isempty(checkVlaue)
            strErr= 'השדה  Security_ID בקובץ ';
            
            strErr= [strErr char(10) cell2mat(hExcelData.Portfolio{1,1}(j,1))];
            strErr= [strErr char(10) 'בשורה מספר '];
            strErr= [strErr char(10) num2str(cell2mat(hExcelData.Portfolio{1,1}(j,3)))];
            strErr= [strErr char(10) 'לא תקין'];
            errorNum=208;
            log_error.Data(log_error.ind,:)={errorNum (strErr) };
            log_error.ind= log_error.ind+1;
       
        end
 
    end
  
    if  ~isempty(ind_Pname) && ~isempty(ind_Pdate)
        
        if isempty(indType)
            hExcelData.Portfolio{2,1}(k,:) =[ {j} {0} {-1}  {'Security_Type'}];
            k=k+1;
            continue;
        else
            checkVlaue=checkCorectVal(hExcelData.Portfolio{1,1}(j,indType), 'categorical',hExcelData);
            if  isempty(checkVlaue)
                if ~isempty(indID)
                    hExcelData.Portfolio{2,1}(k,:) =[ {j} {0} hExcelData.Portfolio{1,1}(j,indID)   {'Security_Type'}];
                    
                    k=k+1;
                    
                else
                    hExcelData.Portfolio{2,1}(k,:) =[ {j} {0} {-1}   {'Security_Type'}];
                    
                    k=k+1;
                end
                continue;
            else
                hExcelData.Portfolio{1,1}(j,indType)=checkVlaue;
            end
        end
        
        
        
        
        if ~isempty(indID)
            dupid=find(cell2mat(hExcelData.Portfolio{1,1}(2:end,indID))==cell2mat(hExcelData.Portfolio{1,1}(j,indID)));
            dupid=dupid+1;
            security_id=hExcelData.Portfolio{1,1}(j,indID);
        else
            dupid=[];
            security_id=-1;
        end
        
        %check  which field is must according to the Security_Type  value
        
        [~,col]=find(strcmp(  hExcelData.Portfolio{1,1}(j,indType),hconfig.MustField(1,:)));
        if length(col)==1
            for l=2:size(hconfig.MustField(:,col),1)
                if unique(isnan(cell2mat(hconfig.MustField(l,col))))
                    continue;
                end
                
                indField=find(strcmp(hconfig.MustField(l,col),hExcelData.Portfolio{1,1}(1,:)));
                if isempty(indField)
                    hExcelData.Portfolio{2,1}(k,:) =[ {j} {length(dupid)} security_id  hconfig.MustField(l,col)];
                    k=k+1;
                    continue;
                end
                
                %Handling conflicts values of the Must fields
                if length(dupid)>1 && ~ismember(hconfig.MustField(l,col),{'Security_Book_Value','Number_of_Units','Valuation_Date_Principal','Portfolio_Name','Portfolio_ID','Portfolio_Type','Security_Fair_Value'})
                    
                    
                    if j==dupid(1)
                        if  ismember(hconfig.MustField(l,col),hExcelData.translateV(:,1))
                            for ii=1:length(dupid)
                                
                                
                                [row,~]=find(strcmp(hExcelData.Portfolio{1,1}(dupid(ii),indField),hExcelData.translateV));
                                
                                row=unique(row);
                                if ~isempty(row)
                                
                               hExcelData.Portfolio{1,1}(dupid(ii),indField)=hExcelData.translateV(row(1),2);
                                    
                                end
                            end
                            
                        end
                    end
                    
                    
                    testCheck_temp=hExcelData.Portfolio{1,1}(dupid,indField);
                    testCheck_temp=testCheck_temp(~cellfun(@(x) any(isnan(x)),testCheck_temp));
                    if iscellstr(testCheck_temp)
                        testCheck=testCheck_temp;
                    else
                        
                        testCheck=cell2mat(testCheck_temp);
                    end
                    
                    
                    
                    if length(unique(testCheck))>1
                        unique_val=unique(testCheck);
                        if isnumeric(unique_val)
                            unique_val=unique_val(unique_val~=hExcelData.Portfolio{1,1}(j,indField));
                        else
                            unique_val=unique_val(~strcmp(hExcelData.Portfolio{1,1}(j,indField),unique_val));
                        end
                        
                        
                        hExcelData.Portfolio{3,1}(m,:)=[ {j} security_id  hconfig.MustField(l,col) hExcelData.Portfolio{1,1}(j,indField) unique_val(1)];
                        m=m+1;
                    end
                    
                    
                end
                
                
                if ~cellfun(@(x) any(isnan(x)),hExcelData.Portfolio{1,1}(j,indField))
                    
                    checkVlaue=checkCorectVal(hExcelData.Portfolio{1,1}(j,indField), hconfig.MustField(l,1),hExcelData);
                    if  isempty(checkVlaue)
                        hExcelData.Portfolio{2,1}(k,:) =[ {j} {length(dupid)} security_id  hconfig.MustField(l,col)];
                        k=k+1;
                        hExcelData.Portfolio{1,1}(j,4)={0};
                    elseif strcmp(hconfig.MustField(l,1),'categorical')
                        hExcelData.Portfolio{1,1}(j,indField)=checkVlaue;
                    end
                else
                    hExcelData.Portfolio{2,1}(k,:) =[ {j} {length(dupid)} security_id  hconfig.MustField(l,col)];
                    k=k+1;
                    hExcelData.Portfolio{1,1}(j,4)={0};
                end
                
                
            end
            
            
        end
        
        
    end
end





if  ~isempty(ind_Pname) && ~isempty(ind_Pdate)
       
    indRM=1;
    indRD=1;
    if ~ismember('',strtrim(hExcelData.Portfolio{2,1}(1,4)))
        
        
        for j=1:size(hExcelData.Portfolio{2,1},1)
            [~,IndF_P]=find(strcmp((hExcelData.Portfolio{2,1}(j,4)),hExcelData.Portfolio{1,1}(1,:)));
            
            hExcelData=autoCompliteValue(hExcelData.Portfolio{2,1}(j,4),hExcelData.Portfolio{2,1}(j,3),j,IndF_P,hExcelData,hconfig);
            waitbar(0.5+0.4/size(hExcelData.Portfolio{2,1},1)*j,hProgressBar,'ביצוע השלמה אוטומטית של חוסרים...');
            
            
        end
        
        celda=hExcelData.Portfolio{2,1};
        hExcelData.Portfolio{2,1}=reshape( celda(~cellfun('isempty',celda)), [], size(hExcelData.Portfolio{2,1},2));
    end
    
    for j=2:size(hExcelData.Portfolio{1,1},1)
        
        %check if any field is missing for each record
        if ~ismember('',strtrim(hExcelData.Portfolio{2,1}(1,4)))
            ind= find(j==cell2mat(hExcelData.Portfolio{2,1}(:,1)));
            
            if ~isempty(ind)
                hExcelData.Portfolio{1,1}(j,4)={0};
            end
        end
        
        
        [~,col]=find(strcmp( hExcelData.Portfolio{1,1}(j,indType),hconfig.MustField(1,:)));
        
        if length(col)==1
            for l=2:size(hconfig.MustField(:,col),1)
                if unique(isnan(cell2mat(hconfig.MustField(l,col))))
                    continue;
                end
                if ismember(hconfig.MustField(l,col),{'Underlying_Factor_Name','Security_Currency','Underlying_Asset_Currency'})
                    ind=find(strcmp(hconfig.MustField(l,col),{'Underlying_Factor_Name','Security_Currency','Underlying_Asset_Currency'}));
                    vaildValue=0;
                    switch ind
                        case 1
                            if ~isempty(ind_Underlying_Factor)
                                if  ~cellfun(@(x) any(isnan(x)),hExcelData.Portfolio{1,1}(j,ind_Underlying_Factor))
                                    [row,~]=  find(strcmp(hExcelData.Portfolio{1,1}(j,ind_Underlying_Factor),hExcelData.translateR));
                                    vaildValue=1;
                                end
                            end
                        case 2
                            if ~isempty(ind_Security_Currency)
                                if  ~cellfun(@(x) any(isnan(x)),hExcelData.Portfolio{1,1}(j,ind_Security_Currency))
                                    [row,~]=   find(strcmp(hExcelData.Portfolio{1,1}(j,ind_Security_Currency),hExcelData.translateR));
                                    vaildValue=1;
                                end
                            end
                            
                        case 3
                            if ~isempty(ind_Underlying_Asset)
                                if  ~cellfun(@(x) any(isnan(x)),hExcelData.Portfolio{1,1}(j,ind_Underlying_Asset))
                                    [row,~]=  find(strcmp(hExcelData.Portfolio{1,1}(j,ind_Underlying_Asset),hExcelData.translateR));
                                    vaildValue=1;
                                end
                            end
                    end
                    if vaildValue==1
                        if ~isempty(row)
                            
                            ind_hist=find(strcmp(hExcelData.translateR{row(1),1},hExcelData.hist(1,:)));
                            if isempty(ind_hist)
                                
                                strErr= 'גורם הסיכון:';
                                
                                strErr= [strErr char(10) hExcelData.translateR{row(1),1}];
                                strErr= [strErr char(10) 'לא נמצא בקובץ נתוני השוק'];
                                strErr= [strErr char(10) 'כתוצאה מכך לא ניתן לתמחר את המכשירים מסוג:'];
                                strErr= [strErr char(10) hExcelData.Portfolio{1,1}(j,indType)];
                                strErr= [strErr char(10) 'שנמצא בקובץ אחזקות הבא:'];
                                strErr= [strErr char(10) hExcelData.Portfolio{1,1}(j,1)];
                                strErr= [strErr char(10) 'בתיק:'];
                                
                                strErr= [strErr char(10) hExcelData.Portfolio{1,1}(j,ind_Pname)];
                                
                                errorNum=201;
                                log_error.Data(log_error.ind,:)={errorNum (strErr) };
                                log_error.ind= log_error.ind+1;
                                hExcelData.Portfolio{1,1}(j,4)={-1};
                            end
                            
                        end
                    end
                    
                    
                    
                    
                    
                    
                    
                end
                
            end
        end
    end
    
    
    
end




hReport.AddedD=cell(1,7);
hReport.AddedM=cell(1,7);
hReport.MissR=cell(1,8);
hReport.Conflict=cell(1,8);
hReport.ManualR=cell(1,7);
hReport.ConclusionR=cell(1,7);

indName=find(strcmp('Security_Name',hExcelData.Portfolio{1,1}(1,:)));
indISIN=find(strcmp('ISIN',hExcelData.Portfolio{1,1}(1,:)));
indBookVal=find(strcmp('Security_Book_Value',hExcelData.Portfolio{1,1}(1,:)));
indPortfolio=find(strcmp('Portfolio_Name',hExcelData.Portfolio{1,1}(1,:)));


celda=hExcelData.Portfolio{2,1};
hExcelData.Portfolio{2,1}=reshape( celda(~cellfun('isempty',celda)), [], size(hExcelData.Portfolio{2,1},2));

hExcelData.Portfolio{4,1}=hExcelData.Portfolio{4,1}(2:end,:);
hExcelData.Portfolio{5,1}=hExcelData.Portfolio{5,1}(2:end,:);

ind_ID_prot=find(strcmp('uniqueIdPortfolio',hExcelData.Portfolio{1,1}(1,:)));
[un_id_value,ind_un,~]=unique(hExcelData.Portfolio{1,1}(2:end,ind_ID_prot));
if ~isempty(ind_un)
    ind_un=ind_un+1;
    ConclusionR_temp=cell(length(ind_un),7);
    
    for k=1:length(ind_un)
        ConclusionR_temp(k,1)={[hExcelData.Portfolio{1,1}{ind_un(k),indPortfolio} ' ' hExcelData.Portfolio{1,1}{ind_un(k),ind_Pdate}]};
        ind_un_temp=find(strcmp(hExcelData.Portfolio{1,1}(ind_un(k),ind_ID_prot),hExcelData.Portfolio{1,1}(:,ind_ID_prot)));
        ind_correct_temp=find(cell2mat(hExcelData.Portfolio{1,1}(ind_un_temp,4))==1);
        if ~isempty(ind_correct_temp)
            num_correct_rec=length(ind_correct_temp);
        else
            num_correct_rec=0;
        end
        num_total_rec=length(ind_un_temp);
        ConclusionR_temp(k,2)={num_correct_rec};
        ConclusionR_temp(k,3)={num_total_rec};
        ConclusionR_temp(k,4)={num_correct_rec/num_total_rec*100};
        
        corrrect_rec_bookVal_tmp=cell2mat(hExcelData.Portfolio{1,1}(ind_un_temp(ind_correct_temp),indBookVal));
        corrrect_rec_bookVal_tmp=corrrect_rec_bookVal_tmp(~isnan(corrrect_rec_bookVal_tmp));
        if ~isempty(corrrect_rec_bookVal_tmp)
            sum_corrrect_rec_bookVal=sum(corrrect_rec_bookVal_tmp);
        else
            sum_corrrect_rec_bookVal=0;
            
        end
        total_rec_bookVal=cell2mat(hExcelData.Portfolio{1,1}(ind_un_temp,indBookVal));
        total_rec_bookVal=total_rec_bookVal(~isnan(total_rec_bookVal));
        
        sum_total_rec_bookVal=sum(total_rec_bookVal);
        ConclusionR_temp(k,4)={num_correct_rec/num_total_rec*100};
        ConclusionR_temp(k,5)={sprintf('%25f',sum_corrrect_rec_bookVal)};
        ConclusionR_temp(k,6)={sprintf('%25f',sum_total_rec_bookVal)};
        ConclusionR_temp(k,7)={sum_corrrect_rec_bookVal/sum_total_rec_bookVal*100};
        
    end
    hReport.ConclusionR=fliplr(ConclusionR_temp);
    clear ConclusionR_temp;
end



AddedD_Temp=cell(size(hExcelData.Portfolio{5,1},1),7);

if size(AddedD_Temp,1)>0
    
    AddedD_Temp(:,1)= hExcelData.Portfolio{5,1}(:,2);
    if ~isempty(indName)
        
        AddedD_Temp(:,2)=hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{5,1}(:,1)),indName);
    end
    
    
    
    if ~isempty(indISIN)
        
        AddedD_Temp(:,3)=hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{5,1}(:,1)),indISIN);
        
    end
    
    
    if ~isempty(indBookVal)
        
        
        AddedD_Temp(:,4)=hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{5,1}(:,1)),indBookVal);
        
    end
    if ~isempty(indPortfolio)
        
        
        AddedD_Temp(:,5)= hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{5,1}(:,1)),indPortfolio);
        
    end
    
    AddedD_Temp(:,6:7)= hExcelData.Portfolio{5,1}(:,3:4);
    
    hReport.AddedD=fliplr(AddedD_Temp);
    clear AddedD_Temp;
end
AddedM_Temp=cell(size(hExcelData.Portfolio{4,1},1),7);

if size(AddedM_Temp,1)>0
    
    AddedM_Temp(:,1)=hExcelData.Portfolio{4,1}(:,2);
    if ~isempty(indName)
        
        AddedM_Temp(:,2)=hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{4,1}(:,1)),indName);
    end
    
    
    if ~isempty(indISIN)
        
        AddedM_Temp(:,3)=hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{4,1}(:,1)),indISIN);
        
    end
    if ~isempty(indBookVal)
        
        AddedM_Temp(:,4)=hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{4,1}(:,1)),indBookVal);
        
    end
    if ~isempty(indPortfolio)
        
        
        
        AddedM_Temp(:,5)= hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{4,1}(:,1)),indPortfolio) ;
        
    end
    
    AddedM_Temp(:,6:7)= hExcelData.Portfolio{4,1}(:,3:4) ;
    hReport.AddedM=fliplr(AddedM_Temp(2:end,:));
    clear AddedM_Temp;
end
MissR_Temp=cell(size(hExcelData.Portfolio{2,1},1),6);

if size(MissR_Temp,1)>0
    
    MissR_Temp=cell(size(hExcelData.Portfolio{2,1},1),6);
    MissR_Temp(:,1)=hExcelData.Portfolio{2,1}(:,3);
    if ~isempty(indName)
        
        MissR_Temp(:,2)=hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{2,1}(:,1)),indName);
        
    end
    
    if ~isempty(indISIN)
        
        MissR_Temp(:,3)=hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{2,1}(:,1)),indISIN);
        
    end
    
    if ~isempty(indBookVal)
        
        
        MissR_Temp(:,4)=hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{2,1}(:,1)),indBookVal);
        
    end
    if ~isempty(indPortfolio)
        
        
        MissR_Temp(:,5)= hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{2,1}(:,1)),indPortfolio);
        
    end
    
    MissR_Temp(:,6)=hExcelData.Portfolio{2,1}(:,4);
    MissR_Temp(:,7)=hExcelData.Portfolio{2,1}(:,1);
    MissR_Temp(:,8)=num2cell(repmat(i,size(hExcelData.Portfolio{2,1},1),1));
    
    hReport.MissR=fliplr(MissR_Temp(1:end,:));
    clear MissR_Temp;
end

Conflict_Temp=cell(size(hExcelData.Portfolio{3,1},1),7);
if size(Conflict_Temp,1)>1
    
    
    
    Conflict_Temp=cell(size(hExcelData.Portfolio{3,1},1),8);
    Conflict_Temp(:,1)=hExcelData.Portfolio{3,1}(:,2);
    
    if ~isempty(indName)
        
        Conflict_Temp(:,2)= hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{3,1}(:,1)),indName) ;
    end
    
    
    if ~isempty(indISIN)
        
        Conflict_Temp(:,3)= hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{3,1}(:,1)),indISIN) ;
        
    end
    
    
    if ~isempty(indBookVal)
        
        Conflict_Temp(:,4)=hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{3,1}(:,1)),indBookVal) ;
    end
    
    
    if ~isempty(indPortfolio)
        
        Conflict_Temp(:,5)=hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{3,1}(:,1)),indPortfolio);
        
    end
    
    
    Conflict_Temp(:,6)= hExcelData.Portfolio{3,1}(:,3) ;
    Conflict_Temp(:,7)= hExcelData.Portfolio{3,1}(:,4) ;
    Conflict_Temp(:,8)= hExcelData.Portfolio{3,1}(:,5) ;
    
    
    
    
    hReport.Conflict=fliplr(Conflict_Temp(2:end,:));
    clear Conflict_Temp;
end


hReport.ManualMissR=[cell(size(hReport.MissR,1),1) hReport.MissR(:,3:end) ];













hData{7}= hReport;
hData{8}=  hExcelData;
hData{9}=hconfig;

waitbar(0.9,hProgressBar,'בנית דוח חוסרים...');

xlswrite([pwd '\log\LoadDataError' datestr(now,'ddmmyyyy') '.xlsx'],log_error.Data);


waitbar(1,hProgressBar,'הטעינה הושלמה בהצלחה!');
pause(2);
delete(hProgressBar);

guidata(gcbo,hData);

set(hData{2}.btnDatepick,'Enable','on')
set(hData{2}.btnReportComplited,'Enable','on')
set(hData{2}.btnGUIMissingData,'Enable','on')
set(hData{2}.btnReportMissing,'Enable','on')
set(hData{2}.btnReportConflicts,'Enable','on')


end

function OpenManualMissingReportCallback(~,~)
hData = guidata(gcf);


FigSize=hData{1}.FigSize;

SC = get(0, 'ScreenSize');
MaxMonitorX = SC(3);
MaxMonitorY = SC(4);

hManualMissingFig = figure(...
    'Units', 'pixels',...
    'Toolbar', 'none',...
    'Position', FigSize(1:4),...
    'NumberTitle', 'off',...
    'Name', 'השלמה ידנית',...
    'MenuBar', 'none',...
    'Resize', 'off',...
    'DockControls', 'off',...
    'Tag','ManualMissingFig',...
    'Color', hData{1}.colorVec,...
    'CloseRequestFcn',@CloseFigMain);


columnname =   {'ערך להשלמה','שדה בו חסר הערך','שם קופה','שווי נייר','קוד ISIN','שם נייר','מספר נייר'} ;
columnformat = {'char','char','char','char','char','char','char'};
columneditable =  [true false false false false false false];
javaaddpath('TableSorter.jar'); 
usejava('swing');
try
 table_ManualMissing = uitable('v0',hManualMissingFig, 'Position',[2 FigSize(4)*0.3 FigSize(3)-4 FigSize(4)*0.4 ], 'Data',hData{7}.ManualMissR, 'ColumnNames',columnname);
catch
%      table_ManualMissing = uitable(hManualMissingFig,'Units','normalized','Position',...
%     [0 0.4 1 0.5], ...
%     'Data',hData{7}.ManualMissR,...
%     'ColumnName', columnname,...
%     'ColumnFormat', columnformat,...
%     'ColumnEditable', columneditable,...
%     'RowName',[]);
    table_ManualMissing = uitable(hManualMissingFig, 'Position',[0.3*FigSize(2) 0.4*FigSize(1) MaxMonitorX*0.5 MaxMonitorY*0.3 ], 'Data',hData{7}.ManualMissR, 'ColumnNames',columnname);

end;

set(table_ManualMissing,'units','normalized');
  table_ManualMissing.DataChangedCallback=@ManualMissingCheckValidValue;

if size(hData{7}.ManualMissR,2)>0
  for i=2:(size(hData{7}.ManualMissR,2))
  table_ManualMissing.setEditable(i,false);
  end
end


jtable = table_ManualMissing.getTable;

jscroll = jtable.getParent.getParent;
jscroll.setRowHeader([]);

 %jtableHeader=jtable.getTableHeader();
     

      % Fix for JTable focus bug : see http://bugs.sun.com/bugdatabase/view_bug.do;:WuuT?bug_id=4709394
      % Taken from: http://xtargets.com/snippets/posts/show/37
      jtable.putClientProperty('terminateEditOnFocusLost', java.lang.Boolean.TRUE);

      % We want to use sorter.
     
%       if ~isempty(which('TableSorter'))
%           % Add TableSorter as TableModel listener
%           sorter = TableSorter(jtable.getModel());  %(table.getTableModel);
%           %tablePeer = UitablePeer(sorter);  % This is not accepted by UitablePeer... - see comment above
%           jtable.setModel(sorter);
%           sorter.setTableHeader(jtable.getTableHeader());
% 
%           % Set the header tooltip (with sorting instructions)
%           jtable.getTableHeader.setToolTipText('<html>&nbsp;<b>Click</b> to sort up; <b>Shift-click</b> to sort down<br>&nbsp;<b>Ctrl-click</b> (or <b>Ctrl-Shift-click</b>) to sort secondary&nbsp;<br>&nbsp;<b>Click again</b> to change sort direction<br>&nbsp;<b>Click a third time</b> to return to unsorted view<br>&nbsp;<b>Right-click</b> to select entire column</html>');
%       else
%           % Set the header tooltip (no sorting instructions...)
%           jtable.getTableHeader.setToolTipText('<html>&nbsp;<b>Click</b> to select entire column<br>&nbsp;<b>Ctrl-click</b> (or <b>Shift-click</b>) to select multiple columns&nbsp;</html>');
%       end

    
      % Enable multiple row selection, auto-column resize, and auto-scrollbars
      scroll = table_ManualMissing.TableScrollPane;
      scroll.setVerticalScrollBarPolicy(scroll.VERTICAL_SCROLLBAR_AS_NEEDED);
      scroll.setHorizontalScrollBarPolicy(scroll.HORIZONTAL_SCROLLBAR_AS_NEEDED);
      jtable.setSelectionMode(javax.swing.ListSelectionModel.MULTIPLE_INTERVAL_SELECTION);
      jtable.setAutoResizeMode(jtable.AUTO_RESIZE_SUBSEQUENT_COLUMNS)


              jtable.setName('ManualMissingTbl');

      % Move the selection to first table cell (if any data available)
      if (jtable.getRowCount > 0)
          jtable.changeSelection(0,0,false,false);
      end

uicontrol('Parent', hManualMissingFig, ...
    'Units', 'pixels', ...
    'Position', [5 round(FigSize(4)*0.02) 200 FigSize(5)], ...
    'String', 'השלם נתונים וסגור', ...
    'Callback', @CloseWinManualMissig , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on');

uicontrol('Parent', hManualMissingFig, ...
    'Units', 'pixels', ...
    'Position', [220 round(FigSize(4)*0.02) 100 FigSize(5)], ...
    'String', 'בטל', ...
    'Callback', @CloseWin , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on');

hData{6}=table_ManualMissing;
guidata(hManualMissingFig,hData);

guidata(gcbo,hData);
end

function OpenReportMissingCallback(~,~)

hData = guidata(gcf);


FigSize=hData{1}.FigSize;


hReportMissingFig = figure(...
    'Units', 'pixels',...
    'Toolbar', 'none',...
    'Position', FigSize(1:4),...
    'NumberTitle', 'off',...
    'Name', 'דוח חוסרים',...
    'MenuBar', 'none',...
    'Resize', 'off',...
    'DockControls', 'off',...
    'Color', hData{1}.colorVec);


uicontrol('Parent', hReportMissingFig, ...
    'Units', 'pixels', ...
    'Position',  [FigSize(3)*0.35 20 FigSize(3)*0.6 50], ...
    'String', 'דוח חוסרים מכיל את החוסרים הקיימים בשדות החובה עבור כל הניירות הקיימים בתיקים שנטענו', ...
    'Style', 'text',...
    'HorizontalAlignment', 'right',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'BackgroundColor',hData{1}.colorVec,...
    'ForegroundColor',[0 0 0],...
    'Enable','on');





columnname =   {'שווי הרשומות התקינות [%]','שווי התיק','שווי הרשומות התקינות','הרשומות התקינות [%]','סהכ רשומות בתיק','הרשומות התקינות','שם התיק'} ;
columnformat = {'char','char','char','char','char','char','char'};
columneditable =  [false false false  false false false false];
hReportMissing.table_C = uitable(hReportMissingFig,'Units','normalized','Position',...
    [0 0.75 1 0.2], ...
    'Data',hData{7}.ConclusionR,...
    'ColumnName', columnname,...
    'ColumnWidth',{round(FigSize(3)*0.2),'auto',round(FigSize(3)*0.16),round(FigSize(3)*0.14),round(FigSize(3)*0.14),round(FigSize(3)*0.14),'auto'},...
    'ColumnFormat', columnformat,...
    'ColumnEditable', columneditable,...
    'RowName',[]);
%hReportMissing.table_C.Position(3) = hReportMissing.table_C.Extent(3);

jScroll_table_C = findjobj(hReportMissing.table_C);
jTable_table_C = jScroll_table_C.getViewport.getView;
jTable_table_C.setAutoResizeMode(jTable_table_C.AUTO_RESIZE_SUBSEQUENT_COLUMNS);



yourdata =[ {' '} {' '} {' '} {' '}  {' '} {' '} ];
columnname =   {'שדה בו חסר הערך','שם תיק','שווי נייר','קוד ISIN','שם נייר','מספר נייר'} ;
columnformat = {'char','char','char','char','char','char'};
columneditable =  [true false false false false false ];
hReportMissing.table_ReportMissing = uitable(hReportMissingFig,'Units','normalized','Position',...
    [0 0.2 1 0.5], ...
    'Data',hData{7}.MissR(:,3:end)  ,...
    'ColumnName', columnname,...
    'ColumnFormat', columnformat,...
    'CellEditCallback', @EditReportMissing , ...
    'ColumnEditable', columneditable,...
    'RowName',[]);
%hReportMissing.table_ReportMissing.Position(3) =hReportMissing.table_ReportMissing.Extent(3);
%hTable.table_ReportMissing.Position(4) = hTable.table_Data_Comper_field.Extent(4);



jScroll = findjobj(hReportMissing.table_ReportMissing);
jTable = jScroll.getViewport.getView;
jTable.setAutoResizeMode(jTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);



uicontrol('Parent', hReportMissingFig, ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.02) round(FigSize(4)*0.02) 100 FigSize(5)], ...
    'String', 'סגור', ...
    'Callback', @CloseWin , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on');

uicontrol('Parent',hReportMissingFig, ...
    'Units', 'pixels', ...
    'Position', [round(FigSize(3)*0.15) round(FigSize(4)*0.02) 100 FigSize(5)], ...
    'String', 'יצוא לאקסל', ...
    'Callback', @ExportExcel , ...
    'Style', 'pushbutton',...
    'HorizontalAlignment', 'center',...
    'FontName', 'arial',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'Enable','on');
guidata(hReportMissingFig,hData);


end

function CloseWinManualMissig(~,~)
hData = guidata(gcf);

Data=cell(hData{6}.getData);
close(gcf);
ind=find(cellfun(@(x) any(~isempty(x)),Data(:,1)));
ind_type=find(strcmp(Data(ind,2),'Security_Type'));
ind_only_type=ind(ind_type);
ind(ind_type)=[];
ind_other=ind;
[~,ind_un]=unique(cell2mat(Data(ind_only_type,7)));
ind_type_un=ind_only_type(ind_un);
ind=[ind_other ;ind_type_un ];
row_ind=cell2mat(hData{8}.Portfolio{2,1}(ind,1));
indmiss=[];
log_error.Data=[ {'מספר השגיאה'} {'תאור השגיאה'}];
log_error.ind=2;

hProgressBar=waitbar(0,'השלמת הנתונים...');

for i=1:length(ind)
   
    waitbar(0.4/length(ind)*i,hProgressBar,'השלמת הנתונים...');

    ind_row_type=find(strcmp(Data(ind(i),2),hData{9}.MustField(:,2)));
    if ~isempty(ind_row_type)
        type=hData{9}.MustField(ind_row_type,1);
        
        Results=checkCorectVal(Data(ind(i),1),type,hData{8});
        
        
        if  ~isempty(Results)
            
            if ~strcmp(type,'categorical')
                
                Results=Data(ind(i),1);
                
            end
            
            
            IndF_P=find(strcmp(Data(ind(i),2),hData{8}.Portfolio{1,1}(1,:)));
            IndPortID=find(strcmp('Security_ID',hData{8}.Portfolio{1,1}(1,:)));
            s_Id=hData{8}.Portfolio{1,1}(row_ind(i),IndPortID);
            [indID,~]=find(cell2mat(s_Id)==cell2mat(hData{8}.Portfolio{1,1}(2:end,IndPortID)));
            indID=indID+1;
            if strcmp(Data(ind(i),2),'Security_Type')
                
                hData{8}.Portfolio{1,1}(indID,IndF_P)=Results;
                indmiss_temp=find( cell2mat(hData{8}.Portfolio{2,1}(:,3))==cell2mat(s_Id) & strcmp(Data(ind(i),2),hData{8}.Portfolio{2,1}(:,4)));
                indmiss=[indmiss;indmiss_temp];
                Data(indmiss_temp,1)=Results;
                hData{7}.ManualR=[hData{7}.ManualR; Data(indmiss_temp,:)];
                indType=IndF_P;
                row_ind=cell2mat(hData{8}.Portfolio{2,1}(indmiss,1));
                k_init=size(hData{8}.Portfolio{2,1},1)+1;
                k=k_init;
                for j=1:length(indmiss)
                    [~,col]=find(strcmp(  hData{8}.Portfolio{1,1}(row_ind(j),indType),hData{9}.MustField(1,:)));
                    if length(col)==1
                        for l=2:size(hData{9}.MustField(:,col),1)
                            if unique(isnan(cell2mat(hData{9}.MustField(l,col))))
                                continue;
                            end
                            
                            indField=find(strcmp(hData{9}.MustField(l,col),hData{8}.Portfolio{1,1}(1,:)));
                            if isempty(indField)
                                hData{8}.Portfolio{2,1}(k,:) =[ {row_ind(j)} {-1} s_Id  hData{9}.MustField(l,col)];
                                k=k+1;
                                continue;
                            end
                            
                            
                            
                            if ~cellfun(@(x) any(isnan(x)),hData{8}.Portfolio{1,1}(row_ind(j),indField))
                                
                                checkVlaue=checkCorectVal(hData{8}.Portfolio{1,1}(row_ind(j),indField), hData{9}.MustField(l,1),hData{8});
                                if  isempty(checkVlaue)
                                    hData{8}.Portfolio{2,1}(k,:) =[ {row_ind(j)} {-1} s_Id  hData{9}.MustField(l,col)];
                                    k=k+1;
                                    hData{8}.Portfolio{1,1}(row_ind(j),4)={0};
                                elseif strcmp(hData{9}.MustField(l,1),'categorical')
                                    hData{8}.Portfolio{1,1}(row_ind(j),indField)=checkVlaue;
                                end
                            else
                                hData{8}.Portfolio{2,1}(k,:) =[ {row_ind(j)} {-1} s_Id  hData{9}.MustField(l,col)];
                                k=k+1;
                                hData{8}.Portfolio{1,1}(row_ind(j),4)={0};
                            end
                            
                            
                        end
                        
                        
                    end
                    
                end
                for j=k_init:size(hData{8}.Portfolio{2,1},1)
                    [~,IndF_P]=find(strcmp((hData{8}.Portfolio{2,1}(j,4)),hData{8}.Portfolio{1,1}(1,:)));
                    
                    hData{8}=autoCompliteValue(hData{8}.Portfolio{2,1}(j,4),hData{8}.Portfolio{2,1}(j,3),j,IndF_P,hData{8},hData{9});
                end
                
        
        
                
                
            elseif ~ismember(Data(ind(i),2),{'Security_Book_Value','Number_of_Units','Valuation_Date_Principal','Portfolio_Name','Portfolio_ID','Portfolio_Type','Security_Fair_Value'})
                indmiss_temp=find( cell2mat(hData{8}.Portfolio{2,1}(:,3))==cell2mat(s_Id) & strcmp(Data(ind(i),2),hData{8}.Portfolio{2,1}(:,4)));
                indmiss=[indmiss;indmiss_temp];
                Data(indmiss_temp,1)=Results;
                hData{7}.ManualR=[hData{7}.ManualR; Data(indmiss_temp,:)];
                row_ind_temp=cell2mat(hData{8}.Portfolio{2,1}(indmiss,1));
                if isempty(IndF_P)
                    hData{8}.Portfolio{1,1}(1,end+1)=Data(ind(i),2);
                    hData{8}.Portfolio{1,1}(row_ind_temp,end)=Results;
                else
                    hData{8}.Portfolio{1,1}(row_ind_temp,IndF_P)=Results;
                end
            else 
                indmiss_temp=find( cell2mat(hData{8}.Portfolio{2,1}(:,3))==cell2mat(s_Id) & strcmp(Data(ind(i),2),hData{8}.Portfolio{2,1}(:,4)));
                row_ind_temp=cell2mat(hData{8}.Portfolio{2,1}(indmiss_temp,1));
                if  ~isempty(hData{9}.UniqeIdentifier)
                    
                    
                    if length(indmiss_temp)==1
                        
                        
                        
                        if isempty(IndF_P)
                            hData{8}.Portfolio{1,1}(1,end+1)=Data(ind(i),2);
                            hData{8}.Portfolio{1,1}(row_ind(i),end)=Results;
                        else
                            hData{8}.Portfolio{1,1}(row_ind(i),IndF_P)=Results;
                        end
                        indmiss=[indmiss; ind(i)];
                        
                        Data(ind(i),1)=Results;
                        hData{7}.ManualR=[hData{7}.ManualR; Data(ind(i),:)];
                        continue;
                        
                    end
                    
                    
                    
                    UniqueID_P=num2str(cell2mat(s_Id));
                    UniqueID_M=cell(length(row_ind_temp),1);
                    UniqueID_M(:)=s_Id;
                    
                    for m=1:size(hData{9}.UniqeIdentifier)
                        
                        
                        col_P=find(strcmp(hData{9}.UniqeIdentifier(m),hData{8}.Portfolio{1,1}(1,:)));
                        
                        if  isempty(col_P)
                            continue;
                        end
                        
                       
                        if  ~cellfun(@(x) any(isnan(x)),hData{8}.Portfolio{1,1}(row_ind(i),col_P))
                            UniqueID_P=strcat(UniqueID_P,cell2string(hData{8}.Portfolio{1,1}(row_ind(i),col_P)));
                        end
                        
                        
                       
                            
                            for ii=1:length(row_ind_temp)
                                if  ~cellfun(@(x) any(isnan(x)),hData{8}.Portfolio{1,1}(row_ind_temp(ii),col_P))
                                    UniqueID_M(ii)={strcat(cell2string(UniqueID_M(ii)),cell2string(hData{8}.Portfolio{1,1}(row_ind_temp(ii),col_P)))};
                                end
                            end
                   
                        
                        
                    end
                    
                    testCheck=strcmp(UniqueID_P,UniqueID_M(:));
                   
                    
                    ind_t=find(testCheck);
                    
                    
                    
                    if isempty(IndF_P)
                        hData{8}.Portfolio{1,1}(1,end+1)=Data(ind(i),2);
                        hData{8}.Portfolio{1,1}(row_ind_temp(ind_t),end)=Results;
                    else
                        hData{8}.Portfolio{1,1}(row_ind_temp(ind_t),IndF_P)=Results;
                    end
                    
                    indmiss=[indmiss; indmiss_temp(ind_t)];
                    
                    Data(indID(ind_t),1)=Results;
                    hData{7}.ManualR=[hData{7}.ManualR; Data(indmiss_temp(ind_t),:)];
                    continue;
                else
                    
                    
                    if length(indmiss_temp)==1
                        
                        
                        if isempty(IndF_P)
                            hData{8}.Portfolio{1,1}(1,end+1)=Data(ind(i),2);
                            hData{8}.Portfolio{1,1}(row_ind(i),end)=Results;
                        else
                            hData{8}.Portfolio{1,1}(row_ind(i),IndF_P)=Results;
                        end
                        indmiss=[indmiss; ind(i)];
                        
                        Data(ind(i),1)=Results;
                        hData{7}.ManualR=[hData{7}.ManualR; Data(ind(i),:)];
                        continue;
                    else
                       

                        if isempty(IndF_P)
                            hData{8}.Portfolio{1,1}(1,end+1)=Data(ind(i),2);
                            
                            hData{8}.Portfolio{1,1}(row_ind_temp,end)=Results;
                        else
                            hData{8}.Portfolio{1,1}(row_ind_temp,IndF_P)=Results;
                        end
                        indmiss=[indmiss; indmiss_temp];
                        
                        Data(indmiss_temp,1)=Results;
                        hData{7}.ManualR=[hData{7}.ManualR; Data(indmiss_temp,:)];
                        continue;
                    end
                end
            end
            
            
            
            
        end
    end
end

if ~isempty(indmiss)
    hData{8}.Portfolio{2,1}(indmiss,:)=cell(length(indmiss), size(hData{8}.Portfolio{2,1},2));
    celda= hData{8}.Portfolio{2,1};
    hData{8}.Portfolio{2,1}=reshape( celda(~cellfun('isempty',celda)), [], size(hData{8}.Portfolio{2,1},2));
%     
%     hData{7}.MissR(indmiss,:)=cell(length(indmiss),size(hData{7}.MissR,2));
%     celda=hData{7}.MissR;
%     hData{7}.MissR=reshape( celda(~cellfun('isempty',celda)), [], size(hData{7}.MissR,2));
%     
%     hData{7}.ManualMissR(indmiss,:)=cell(length(indmiss),(size(hData{7}.ManualMissR,2)));
%     celda= hData{7}.ManualMissR(:,2:end);
%     
%     celda_tmp=reshape( celda(~cellfun('isempty',celda)), [], (size(hData{7}.ManualMissR,2)-1));
%     hData{7}.ManualMissR =[cell(size(celda_tmp,1),1) celda_tmp];
%     
    

hData{7}.AddedD=cell(1,7);
hData{7}.AddedM=cell(1,7);
hData{7}.MissR=cell(1,8);



indName=find(strcmp('Security_Name',hData{8}.Portfolio{1,1}(1,:)));
indISIN=find(strcmp('ISIN',hData{8}.Portfolio{1,1}(1,:)));
indBookVal=find(strcmp('Security_Book_Value',hData{8}.Portfolio{1,1}(1,:)));
indPortfolio=find(strcmp('Portfolio_Name',hData{8}.Portfolio{1,1}(1,:)));





AddedD_Temp=cell(size(hData{8}.Portfolio{5,1},1),7);

if size(AddedD_Temp,1)>0
    
    AddedD_Temp(:,1)= hData{8}.Portfolio{5,1}(:,2);
    if ~isempty(indName)
        
        AddedD_Temp(:,2)=hData{8}.Portfolio{1,1}(cell2mat(hData{8}.Portfolio{5,1}(:,1)),indName);
    end
    
    
    
    if ~isempty(indISIN)
        
        AddedD_Temp(:,3)=hData{8}.Portfolio{1,1}(cell2mat(hData{8}.Portfolio{5,1}(:,1)),indISIN);
        
    end
    
    
    if ~isempty(indBookVal)
        
        
        AddedD_Temp(:,4)=hData{8}.Portfolio{1,1}(cell2mat(hData{8}.Portfolio{5,1}(:,1)),indBookVal);
        
    end
    if ~isempty(indPortfolio)
        
        
        AddedD_Temp(:,5)= hData{8}.Portfolio{1,1}(cell2mat(hData{8}.Portfolio{5,1}(:,1)),indPortfolio);
        
    end
    
    AddedD_Temp(:,6:7)= hData{8}.Portfolio{5,1}(:,3:4);
    
    hData{7}.AddedD=fliplr(AddedD_Temp);
    clear AddedD_Temp;
end
AddedM_Temp=cell(size(hData{8}.Portfolio{4,1},1),7);

if size(AddedM_Temp,1)>0
    
    AddedM_Temp(:,1)=hData{8}.Portfolio{4,1}(:,2);
    if ~isempty(indName)
        
        AddedM_Temp(:,2)=hData{8}.Portfolio{1,1}(cell2mat(hData{8}.Portfolio{4,1}(:,1)),indName);
    end
    
    
    if ~isempty(indISIN)
        
        AddedM_Temp(:,3)=hData{8}.Portfolio{1,1}(cell2mat(hData{8}.Portfolio{4,1}(:,1)),indISIN);
        
    end
    if ~isempty(indBookVal)
        
        AddedM_Temp(:,4)=hData{8}.Portfolio{1,1}(cell2mat(hData{8}.Portfolio{4,1}(:,1)),indBookVal);
        
    end
    if ~isempty(indPortfolio)
        
        
        
        AddedM_Temp(:,5)= hData{8}.Portfolio{1,1}(cell2mat(hData{8}.Portfolio{4,1}(:,1)),indPortfolio) ;
        
    end
    
    AddedM_Temp(:,6:7)= hData{8}.Portfolio{4,1}(:,3:4) ;
    hData{7}.AddedM=fliplr(AddedM_Temp(1:end,:));
    clear AddedM_Temp;
end
MissR_Temp=cell(size(hData{8}.Portfolio{2,1},1),6);

if size(MissR_Temp,1)>0
    
    MissR_Temp=cell(size(hData{8}.Portfolio{2,1},1),6);
    MissR_Temp(:,1)=hData{8}.Portfolio{2,1}(:,3);
    if ~isempty(indName)
        
        MissR_Temp(:,2)=hData{8}.Portfolio{1,1}(cell2mat(hData{8}.Portfolio{2,1}(:,1)),indName);
        
    end
    
    if ~isempty(indISIN)
        
        MissR_Temp(:,3)=hData{8}.Portfolio{1,1}(cell2mat(hData{8}.Portfolio{2,1}(:,1)),indISIN);
        
    end
    
    if ~isempty(indBookVal)
        
        
        MissR_Temp(:,4)=hData{8}.Portfolio{1,1}(cell2mat(hData{8}.Portfolio{2,1}(:,1)),indBookVal);
        
    end
    if ~isempty(indPortfolio)
        
        
        MissR_Temp(:,5)= hData{8}.Portfolio{1,1}(cell2mat(hData{8}.Portfolio{2,1}(:,1)),indPortfolio);
        
    end
    
    MissR_Temp(:,6)=hData{8}.Portfolio{2,1}(:,4);
    MissR_Temp(:,7)=hData{8}.Portfolio{2,1}(:,1);
    MissR_Temp(:,8)=num2cell(repmat(i,size(hData{8}.Portfolio{2,1},1),1));
    
    hData{7}.MissR=fliplr(MissR_Temp(1:end,:));
    clear MissR_Temp;
end

hData{7}.ManualMissR=[cell(size(hData{7}.MissR,1),1) hData{7}.MissR(:,3:end) ];



end


if ~isempty(ind)
    if sum(cellfun('isempty',hData{7}.ManualR(1,:)))==size(hData{7}.ManualR(1,:),2)
        hData{7}.ManualR=hData{7}.ManualR(2:end,:);
    end
    
    %check if any field is missing for each record
    
    
    indType=find(strcmp('Security_Type',hData{8}.Portfolio{1,1}(1,:)));
    ind_Pname=find(strcmp('Portfolio_Name',hData{8}.Portfolio{1,1}(1,:)));
    ind_Underlying_Factor=find(strcmp('Underlying_Factor_Name',hData{8}.Portfolio{1,1}(1,:)));
    ind_Security_Currency=find(strcmp('Security_Currency',hData{8}.Portfolio{1,1}(1,:)));
    ind_Underlying_Asset=find(strcmp('Underlying_Asset_Currency',hData{8}.Portfolio{1,1}(1,:)));
    
     waitbar(0.4,hProgressBar,'חישוב מחדש של הדוחות...');
    for j=2:size(hData{8}.Portfolio{1,1},1)
     waitbar(0.4+0.5/(size(hData{8}.Portfolio{1,1},1)-1)*j,hProgressBar,'חישוב מחדש של הדוחות...');

        if size(hData{8}.Portfolio{2,1},1)>=1
            if ~ismember('',strtrim(hData{8}.Portfolio{2,1}(1,4)))
                ind= find(j==cell2mat(hData{8}.Portfolio{2,1}(:,1)));
                
                if ~isempty(ind)
                    hData{8}.Portfolio{1,1}(j,4)={0};
                else
                    hData{8}.Portfolio{1,1}(j,4)={1};
                end
            end
        end     
            
            [~,col]=find(strcmp( hData{8}.Portfolio{1,1}(j,indType),hData{9}.MustField(1,:)));
            
            if length(col)==1
                for l=2:size(hData{9}.MustField(:,col),1)
                    if unique(isnan(cell2mat(hData{9}.MustField(l,col))))
                        continue;
                    end
                    if ismember(hData{9}.MustField(l,col),{'Underlying_Factor_Name','Security_Currency','Underlying_Asset_Currency'})
                        ind=find(strcmp(hData{9}.MustField(l,col),{'Underlying_Factor_Name','Security_Currency','Underlying_Asset_Currency'}));
                        vaildValue=0;
                        switch ind
                            case 1
                                if ~isempty(ind_Underlying_Factor)
                                    if  ~cellfun(@(x) any(isnan(x)),hData{8}.Portfolio{1,1}(j,ind_Underlying_Factor))
                                        [row,~]=  find(strcmp(hData{8}.Portfolio{1,1}(j,ind_Underlying_Factor),hData{8}.translateR));
                                        vaildValue=1;
                                    end
                                end
                            case 2
                                if ~isempty(ind_Security_Currency)
                                    if  ~cellfun(@(x) any(isnan(x)),hData{8}.Portfolio{1,1}(j,ind_Security_Currency))
                                        [row,~]=   find(strcmp(hData{8}.Portfolio{1,1}(j,ind_Security_Currency),hData{8}.translateR));
                                        vaildValue=1;
                                    end
                                end
                                
                            case 3
                                if ~isempty(ind_Underlying_Asset)
                                    if  ~cellfun(@(x) any(isnan(x)),hData{8}.Portfolio{1,1}(j,ind_Underlying_Asset))
                                        [row,~]=  find(strcmp(hData{8}.Portfolio{1,1}(j,ind_Underlying_Asset),hData{8}.translateR));
                                        vaildValue=1;
                                    end
                                end
                        end
                        if vaildValue==1
                            if ~isempty(row)
                                
                                ind_hist=find(strcmp(hData{8}.translateR{row(1),1},hData{8}.hist(1,:)));
                                if isempty(ind_hist)
                                    
                                    strErr= 'גורם הסיכון:';
                                    
                                    strErr= [strErr char(10) hData{8}.translateR{row(1),1}];
                                    strErr= [strErr char(10) 'לא נמצא בקובץ נתוני השוק'];
                                    strErr= [strErr char(10) 'כתוצאה מכך לא ניתן לתמחר את המכשירים מסוג:'];
                                    strErr= [strErr char(10) hData{8}.Portfolio{1,1}(j,indType)];
                                    strErr= [strErr char(10) 'שנמצא בקובץ אחזקות הבא:'];
                                    strErr= [strErr char(10) hData{8}.Portfolio{1,1}(j,1)];
                                    strErr= [strErr char(10) 'בתיק:'];
                                    
                                    strErr= [strErr char(10) hData{8}.Portfolio{1,1}(j,ind_Pname)];
                                    
                                    errorNum=201;
                                    log_error.Data(log_error.ind,:)={errorNum (strErr) };
                                    log_error.ind= log_error.ind+1;
                                    hData{8}.Portfolio{1,1}(j,4)={-1};
                                end
                                
                            end
                        end
                        
                    end
                    
                end
            end
        
    end
    
    
   
    
    
    %Recalculate the  Conclusion report
    
    indBookVal=find(strcmp('Security_Book_Value',hData{8}.Portfolio{1,1}(1,:)));
    ind_ID_prot=find(strcmp('uniqueIdPortfolio',hData{8}.Portfolio{1,1}(1,:)));
    [un_id_value,ind_un,~]=unique(hData{8}.Portfolio{1,1}(2:end,ind_ID_prot));
    if ~isempty(ind_un)
        ind_un=ind_un+1;
        ConclusionR_temp=cell(length(ind_un),7);
        
        for k=1:length(ind_un)
            ConclusionR_temp(k,1)=un_id_value(k);
            ind_un_temp=find(strcmp(hData{8}.Portfolio{1,1}(ind_un(k),ind_ID_prot),hData{8}.Portfolio{1,1}(:,ind_ID_prot)));
            ind_correct_temp=find(cell2mat(hData{8}.Portfolio{1,1}(ind_un_temp,4))==1);
            if ~isempty(ind_correct_temp)
                num_correct_rec=length(ind_correct_temp);
            else
                num_correct_rec=0;
            end
            num_total_rec=length(ind_un_temp);
            ConclusionR_temp(k,2)={num_correct_rec};
            ConclusionR_temp(k,3)={num_total_rec};
            ConclusionR_temp(k,4)={num_correct_rec/num_total_rec*100};
            
            corrrect_rec_bookVal_tmp=cell2mat(hData{8}.Portfolio{1,1}(ind_un_temp(ind_correct_temp),indBookVal));
            corrrect_rec_bookVal_tmp=corrrect_rec_bookVal_tmp(~isnan(corrrect_rec_bookVal_tmp));
            if ~isempty(corrrect_rec_bookVal_tmp)
                sum_corrrect_rec_bookVal=sum(corrrect_rec_bookVal_tmp);
            else
                sum_corrrect_rec_bookVal=0;
                
            end
            total_rec_bookVal=cell2mat(hData{8}.Portfolio{1,1}(ind_un_temp,indBookVal));
            total_rec_bookVal=total_rec_bookVal(~isnan(total_rec_bookVal));
            
            sum_total_rec_bookVal=sum(total_rec_bookVal);
            ConclusionR_temp(k,4)={num_correct_rec/num_total_rec*100};
            ConclusionR_temp(k,5)={sum_corrrect_rec_bookVal};
            ConclusionR_temp(k,6)={sum_total_rec_bookVal};
            ConclusionR_temp(k,7)={sum_corrrect_rec_bookVal/sum_total_rec_bookVal*100};
            
        end
        hData{7}.ConclusionR=fliplr(ConclusionR_temp);
        clear ConclusionR_temp;
    end
end
xlswrite([pwd '\log\ManualCompError' datestr(now,'ddmmyyyy') '.xlsx'],log_error.Data);
waitbar(1,hProgressBar,'השלמת הנתונים הסתיימה בהצלחה!');
pause(2);
delete(hProgressBar);

handles=findall(0,'type','figure');
h_fig=findobj(handles,'Name','כלי תמחור ואומדן סיכונים');
guidata(h_fig,hData);
hData{6}=[];
clear('findjobj') ;
end

function Results=checkCorectVal(varCheck,type,hExcelData)

Results=[];
if iscell(type)
    type_check=cell2mat(type);
else
    type_check=type;
end
switch type_check
    case 'num'
        try
            if isstr(cell2mat(varCheck))
                
                if ~isempty(str2num(cell2mat(varCheck)))
                    Results=isnumeric(str2num(cell2mat(varCheck)));
                else
                    
                    Results=[];
                    return;
                end
            else
                Results=isnumeric((cell2mat(varCheck)));
            end
        catch
            Results=[];
            return;
            
        end
        if Results==0
            Results=[];
        end
        return;
    case 'txt'
        Results=1;
        return;
    case 'date'
        try
            str = datestr(datenum(varCheck,'dd/mm/yyyy'),24);
            Results = isequal(str,cell2mat(varCheck));
        catch
        end
        
        
        return;
    case 'categorical'
        
        [row,~]=find(strcmp(strtrim(varCheck),hExcelData.translateV));
        row=unique(row);
        if ~isempty(row)
            
            Results=hExcelData.translateV(row(1),2);
            
            return;
        end
    case 'categorical_RiskFactor'
        [row,~]=find(strcmp(strtrim(varCheck),hExcelData.translateR));
        row=unique(row);
        if ~isempty(row)
            Results=hExcelData.translateR(row(1),1);
            return;
        end
end


end



function Results=cell2string(X)
if iscellstr(X)
    Results=X{:};
else
    Results=num2str(cell2mat(X));
end
end

function CloseWin(~,~)
close(gcf);

clear('findjobj') 


end

function CloseFig(~,~)
hData = guidata(gcf);




indexDefaultValue=find([hData{3}.table_Data_DefaultValue.Data{:,3}]==1);
indexMissingValue=find([hData{3}.table_Data_missingValue.Data{:,3}]==1);
indexAhzakot=find([hData{3}.table_Data_ahzakot.Data{:,5}]==1);


if ~isempty(indexDefaultValue)
    for i=1:length(indexDefaultValue)
        hData{3}.table_Data_DefaultValue.Data{indexDefaultValue(i),3}=false;
    end
end


if ~isempty(indexMissingValue)
    for i=1:length(indexMissingValue)
        hData{3}.table_Data_missingValue.Data{indexMissingValue(i),3}=false;
    end
end
if ~isempty(indexAhzakot)
    for i=1:length(indexAhzakot)
        hData{3}.table_Data_ahzakot.Data{indexAhzakot(i),5}=false;
    end
end

set(hData{3}.btnEditPortfolio,'Enable','off');
set(hData{3}.btnDeletePortfolio,'Enable','off');
set(hData{3}.btnEditFileDefaultValue,'Enable','off')
set(hData{3}.btnDeleteFileDefaultValue,'Enable','off')
set(hData{3}.btnEditFileMissingValue,'Enable','off');
set(hData{3}.btnDeleteFileMissingValue,'Enable','off');
close(gcf);
clear('findjobj') ;
end

function ExportExcel(~,~)


hData = guidata(gcf);
filename=[pwd '\Reports\MissingReport'  datestr(now,'ddmmyyyyHHMMSS') '.xlsx'];
warning('off');
xlswrite(filename,fliplr([  {'ערך סותר','ערך קיים','שדה','שם קופה','שווי נייר','קוד ISIN','שם נייר','מספר נייר'} ;(hData{7}.Conflict)]),'דוח סתירות');
xlswrite(filename,fliplr([ {'ערך שהושלם','שדה','שם קופה','שווי נייר','קוד ISIN','שם נייר','מספר נייר'} ; (hData{7}.AddedM)]),'הושלמו מקבצי השלמה');
xlswrite(filename,fliplr([ {'ערך שהושלם','שדה','שם קופה','שווי נייר','קוד ISIN','שם נייר','מספר נייר'} ;(hData{7}.AddedD)]),'הושלמו מערכי ברירת המחדל');
xlswrite(filename,fliplr([  {'ערך שהושלם','שדה','שם קופה','שווי נייר','קוד ISIN','שם נייר','מספר נייר'} ;(hData{7}.ManualR)]),'נתונים שהושלמו ידנית');
xlswrite(filename,fliplr([  {'שדה בו חסר הערך','שם קופה','שווי נייר','קוד ISIN','שם נייר','מספר נייר'} ;(hData{7}.MissR(:,3:end))]),'נתונים חסרים');

xls_delete_sheets(filename);
guidata(gcf,hData);

end

function ManualMissingCheckValidValue(mtable, eventdata)

try
hfig=findobj('Tag','ManualMissingFig');

   hData = guidata(hfig); 
catch
    return;
end

if ~ishandle(mtable),
    return;
end


jtable=mtable.getTable;

eventDetails = eventdata.getEvent;
modifiedColIdx = eventDetails.getColumn+1;
modifiedRowIdx = eventDetails.getFirstRow+1;
if modifiedColIdx>=0 && modifiedRowIdx>=0
    Data = cell(mtable.getData);
    newValue = Data(modifiedRowIdx,modifiedColIdx);
  
end
if strcmp(newValue,'')
    return;
end

if cellfun(@isempty,newValue)
    return;
end
ind_row_type=find(strcmp(Data(modifiedRowIdx,2),hData{9}.MustField(:,2)));

if ~isempty(ind_row_type)
    type=hData{9}.MustField(ind_row_type,1);
    
    Results=checkCorectVal(Data(modifiedRowIdx,1),type,hData{8});
    
    
    if  ~isempty(Results)
        
        if strcmp(type,'categorical')
            
            Data(modifiedRowIdx,1)=Results;
            jtable.setValueAt(java.lang.String(Results),modifiedRowIdx-1,0); 
        end
    else
        Data(modifiedRowIdx,1)=cell(1);
        strErr= {'הערך שהוזן לא חוקי, נא הזן ערך חוקי לפי סוג השדה'};
              jtable.setValueAt(java.lang.String(''),modifiedRowIdx-1,0); 

     
        errordlg(strErr)
    end
else
    Data(modifiedRowIdx,1)=cell(1);
    strErr= {'הערך שהוזן לא חוקי, נא הזן ערך חוקי לפי סוג השדה'};
                jtable.setValueAt(java.lang.String(''),modifiedRowIdx-1,0); 

    errordlg(strErr)
end

end


function xls_delete_sheets(xlsfile,sheets)
%
% Delete worksheets in Excel file
%
%
%USAGE
%-----
% xls_delete_sheets(xlsfile)
% xls_delete_sheets(xlsfile,sheets)
%
%
%INPUT
%-----
% - XLSFILE: name of the Excel file
% - SHEETS : cell array with the worksheet names, or matrix with positive
%   integers to tell which worksheets are going to be protected. If
%   SHEETS=[], all empty sheets will be deleted.
%
%
%OUTPUT
%------
% - XLSFILE will be edited
%
%
% Based on "How do I delete worksheets in my Excel file using MATLAB?"
% (http://www.mathworks.com/support/solutions/en/data/1-21EPB4/index.html?solution=1-21EPB4)
%
%
% See also XLS_CHECK_IF_OPEN
%

% Guilherme Coco Beltramini (guicoco@gmail.com)
% 2012-Dec-30, 05:29 pm


% Input
%==========================================================================
if exist(xlsfile,'file')~=2
    fprintf('%s not found.\n',xlsfile)
    return
end
if nargin<2
    sheets = [];
end


% Close Excel file
%-----------------
tmp = xls_check_if_open(xlsfile,'close');
if tmp~=0 && tmp~=10
    fprintf('%s could not be closed.\n',xlsfile)
    return
end


% The full path is required for the command "workbooks.Open" to work
% properly
%-------------------------------------------------------------------
if isempty(strfind(xlsfile,filesep))
    xlsfile = fullfile(pwd,xlsfile);
end


% Read Excel file
%==========================================================================
%[type,sheet_names] = xlsfinfo(xlsfile);      % get information returned by XLSINFO on the workbook
Excel      = actxserver('Excel.Application'); % open Excel as a COM Automation server
set(Excel,'Visible',0);                       % make the application invisible
% or ExcelApp.Visible = 0;
set(Excel,'DisplayAlerts',0);                 % make Excel not display alerts (e.g., sound and confirmation)
% or Excel.Application.DisplayAlerts = false; % or 0
Workbooks  = Excel.Workbooks;                 % get a handle to Excel's Workbooks
Workbook   = Workbooks.Open(xlsfile);         % open an Excel Workbook and activate it
Sheets     = Excel.ActiveWorkBook.Sheets;     % get the sheets in the active Workbook
num_sheets = Sheets.Count;                    % number of worksheets
num_sheets_orig = num_sheets;


% Get sheets to delete
%==========================================================================
if ischar(sheets)
    sheets = {sheets};
end
if iscell(sheets)
    sheetidx = 1:length(sheets);
elseif isnumeric(sheets) && ~isempty(sheets) && ...
        isvector(sheets)==1 && all(floor(sheets)==ceil(sheets))
    sheetidx = sort(sheets,'descend');  % it is easier to go backwards
    sheetidx(sheetidx<1) = [];          % minimum sheet index is 1
    sheetidx(sheetidx>num_sheets) = []; % maximum sheet index is num_sheets
elseif isnumeric(sheets) && isempty(sheets)
    % sheets = [];
else
    disp('Invalid input for SHEETS.')
    xls_save_and_close
    return
end


% Delete sheets
%==========================================================================
try
    
    if ~isempty(sheets)
        
        % Delete selected worksheets
        %----------------------------
        for ss=sheetidx
            
            if num_sheets>1 % there must be at least 1 sheet
                
                if iscell(sheets)
                    invoke(get(Sheets,'Item',sheets{ss}),'Delete')
                else
                    invoke(get(Sheets,'Item',ss),'Delete')
                    %Sheets.Item(ss).Delete;
                end
                num_sheets = num_sheets - 1;
                
            else
                if iscell(sheets)
                    tmp = sheets{ss};
                    if ~strcmp(tmp,Sheets.Item(1).Name) % sheet does not exist
                        break
                    end
                else
                    tmp = Sheets.Item(1).Name;
                end
                fprintf('%s will not be deleted. There must be at least 1 worksheet.\n',tmp)
                break
            end
            
        end
        
    else
        
        % Delete the empty worksheets
        %----------------------------
        
        % Loop over sheets
        for ss=num_sheets:-1:1 % it is easier to go backwards
            %if Excel.WorksheetFunction.CountA(Sheets.Item(ss).Cells)==0
            % count the number of non-empty cells
            % COUNTA applies to Excel 2013, 2011 for Mac, 2010, 2007, 2003, XP, 2000
            if Sheets.Item(ss).UsedRange.Count == 1 && ...
                    strcmp(Sheets.Item(ss).UsedRange.Rows.Address,'$A$1') && ...
                    isnan(Sheets.Item(ss).Range('A1').Value)
                % If the sheet is empty or contains 1 non-empty cell,
                % UsedRange.Count=1. So the three conditions above check if the
                % sheet is really empty (there is nothing even in the first cell).
                if num_sheets>1
                    Sheets.Item(ss).Delete;
                    num_sheets = num_sheets - 1;
                else
                    fprintf('%s will not be deleted. There must be at least 1 worksheet.\n',Sheets.Item(1).Name)
                end
            end
        end
        
    end
    
catch ME
    disp(ME.message)
end

xls_save_and_close

% if num_sheets_orig>num_sheets
%     if num_sheets_orig-num_sheets>1
%       %  fprintf('%d worksheets were deleted.\n',num_sheets_orig-num_sheets)
%     else
%        % fprintf('1 worksheet was deleted.\n')
%     end
% else
%    % disp('Nothing was done.')
% end


% Save and close
%==========================================================================
    function xls_save_and_close
        Workbook.Save;   % save the workbook
        Workbooks.Close; % close the workbook
        Excel.Quit;      % quit Excel
        % or invoke(Excel,'Quit');
        delete(Excel);   % delete the handle to the ActiveX Object
        clear Excel Workbooks Workbook Sheets
    end

end


function isopen = xls_check_if_open(xlsfile,action)
%
% Determine if Excel file is open. If it is open in MS Excel, it can be
% closed.
%
%
%USAGE
%-----
% isopen = xls_check_if_open(xlsfile)
% isopen = xls_check_if_open(xlsfile,action)
%
%
%INPUT
%-----
% - XLSFILE: name of the Excel file
% - ACTION : 'close' (closes file if it is open) or '' (do nothing)
%   Option 'close' only works with MS Excel.
%
%
%OUTPUT
%------
% - ISOPEN:
%   1  if XLSFILE is open
%   0  if XLSFILE is not open
%   10 if XLSFILE was closed
%   11 if XLSFILE is open and could not be closed
%   -1 if an error occurred
%
%
% Based on "How can I determine if an XLS-file is open in Microsoft Excel,
% without using DDE commands, using MATLAB 7.7 (R2008b)?"
% (www.mathworks.com/support/solutions/en/data/1-954SDY/index.html)
%

% Guilherme Coco Beltramini (guicoco@gmail.com)
% 2012-Dec-30, 05:21 pm

isopen = -1;

% Input
%==========================================================================

if nargin<2
    action = '';
end

if exist(xlsfile,'file')~=2
    fprintf('%s not found.\n',xlsfile)
    return
end

% The full path is required because of "Workbooks.Item(ii).FullName"
if isempty(strfind(xlsfile,filesep))
    xlsfile = fullfile(pwd,xlsfile);
end

switch action
    case ''
        close = 0;
    case 'close'
        close = 1;
    otherwise
        disp('Unknown option for ACTION.')
        return
end


% 1) Using DDE commands
%==========================================================================
% isopen = ddeinit('Excel',excelfile);
% if isopen~=0
%     isopen = 1;
% end
% But now DDEINIT has been deprecated, so ignore this option.


% 2) Using ActiveX commands
%==========================================================================
if close
    try
        
        % Check if an Excel server is running
        %------------------------------------
        Excel = actxGetRunningServer('Excel.Application');
        
        isopen = 0;
        
        Workbooks = Excel.Workbooks; % get the names of all open Excel files
        for ii = 1:Workbooks.Count
            if strcmp(xlsfile,Workbooks.Item(ii).FullName)
                isopen = 11;
                Workbooks.Item(ii).Save % save changes
                %Workbooks.Item(ii).SaveAs(filename) % save changes with a different file name
                %Workbooks.Item(ii).Saved = 1; % if you don't want to save
                Workbooks.Item(ii).Close; % close the Excel file
                isopen = 10;
                break
            end
        end
        
    catch ME
        % If Excel is not running, "actxGetRunningServer" will result in error
        if ~strcmp(ME.identifier,'MATLAB:COM:norunningserver')
            disp(ME.message)
            close = 0; % => use FOPEN
        else
            isopen = 0;
        end
    end
    
end


% 3) Using FOPEN
%==========================================================================
if ~close
    if exist(xlsfile,'file')==2 % if xlsfile does not exist, it will be created by FOPEN
        fid = fopen(xlsfile,'a');
        if fid==-1 % MATLAB is unable to open the file
            if strcmp(action,'close') % asked to close but an error occurred
                isopen = 11;
            else
                isopen = 1;
            end
        else
            isopen = 0;
            fclose(fid);
        end
    end
end
end


function [ExcelTbl,log_error]=MapFieldName(ExcelTbl,translateN,filename,log_error,type)
header=ExcelTbl(1,:);
vecCheck=[];
addcolumn=[];

for i=1:length(header)
    [row,~]=find(strcmp(header(i),translateN));
    
    if ~isempty(row)
        row=unique(row);
        
        
        if any(ismember(row,vecCheck))
            
            
            row_dop=row(ismember(row,vecCheck));
            
            strErr= 'שמות השדות במערכת:';
            for j=1:length(row_dop)
                strErr= [strErr char(10) cell2mat(translateN(row_dop(j),1))];
            end
            switch(type)
                case 0
                    strErr=[strErr  char(10) 'מופו למספר עמודות בקובץ האחזקות :'];
                    errorNum=202;
                case 1
                    strErr=[strErr  char(10) 'מופו למספר עמודות בקובץ ההשלמה:'];
                    errorNum=203;
                case 2
                    strErr=[strErr  char(10) 'מופו למספר עמודות בקובץ הנתונים ברירת המחדל:'];
                    errorNum=204;
            end
            strErr= [strErr char(10) filename ];
            
            
            
            strErr=[strErr char(10) 'נא תקן את הקובץ או את טבלת התרגום וטען מחדש את הנתונים.'];
            log_error.Data(log_error.ind,:)={ errorNum (strErr)};
            log_error.ind= log_error.ind+1;
        end
        if any(~ismember(row,vecCheck))
            
            
            row=row(~ismember(row,vecCheck));
            if length(row)>1
                ExcelTbl(1,i) =translateN(row(1),1);
                for j=2:length(row)
                    columntmp=[translateN(row(j),1) ; ExcelTbl(2:end,i)];
                    addcolumn=[addcolumn columntmp ];
                    
                end
            else
                ExcelTbl(1,i) =translateN(row,1);
                
            end
            vecCheck=[vecCheck row'];
        end
        
    end
end



%check if exsist in files critical field but not "must" field that need for the pricing stage


if type==0
    indID=find(strcmp('Security_ID',ExcelTbl(1,:)),1);
    ind_Pdate=find(strcmp('Data_Date',ExcelTbl(1,:)),1);
    ind_Pname=find(strcmp('Portfolio_Name',ExcelTbl(1,:)),1);
    ind_PId=find(strcmp('Portfolio_ID',ExcelTbl(1,:)),1);
    errorNum=2;
    if isempty(ind_PId)
        
        strErr='השדה Portfolio_ID לא קיים בקובץ ';
        strErr= [strErr char(10) filename ];
        errorNum=210;
        
        log_error.Data(log_error.ind,:)={errorNum (strErr) };
        log_error.ind= log_error.ind+1;
    end
    if isempty(ind_Pname)
        
        strErr='השדה Portfolio_Name לא קיים בקובץ ';
        strErr= [strErr char(10) filename ];
        errorNum=211;
        log_error.Data(log_error.ind,:)={errorNum (strErr) };
        log_error.ind= log_error.ind+1;
    end
    
    if isempty(ind_Pdate)
        
        strErr='השדה Data_Date לא קיים בקובץ ';
        strErr= [strErr char(10) filename ];
        errorNum=212;
        log_error.Data(log_error.ind,:)={errorNum (strErr) };
        log_error.ind= log_error.ind+1;
    end
    
    if isempty(indID)
        
        strErr='השדה Security_ID לא קיים בקובץ ';
        strErr= [strErr char(10) filename ];
        errorNum=213;
        log_error.Data(log_error.ind,:)={errorNum (strErr) };
        log_error.ind= log_error.ind+1;
    end
end



ExcelTbl=[ExcelTbl addcolumn];





end


function hExcelData=autoCompliteValue(field_name,s_Id,ind,IndF_P,hExcelData,hconfig)

indRM=size(hExcelData.Portfolio{4,1},1);
indRD=size(hExcelData.Portfolio{5,1},1);
indRM=indRM+1;
indRD=indRD+1;
for k=1:size(hExcelData.CompletionM,2)
    [~,IndF_M]=find(strcmp(field_name,hExcelData.CompletionM{k}(1,:)));
    
    if isempty(IndF_M)
        continue;
    end
    
    [~,IndID_M]=find(strcmp('Security_ID',hExcelData.CompletionM{k}(1,:)));
    if isempty(IndID_M)
        continue;
    end
    
    
    
    
    if  ~isempty(hconfig.UniqeIdentifier)
        
        [indIDM,~]=find(cell2mat(s_Id)==cell2mat(hExcelData.CompletionM{k}(2:end,IndID_M)));
        indIDM=indIDM+1;
        if length(indIDM)<1
            continue;
        end
        
        
        if length(indIDM)==1
            
            if cellfun(@(x) any(isnan(x))| any(isempty(x)),hExcelData.CompletionM{k}(indIDM,IndF_M))
                continue;
            end
            
            if isempty(IndF_P)
                hExcelData.Portfolio{1,1}(1,end+1)=field_name;
                hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{2,1}(ind,1)),end)=hExcelData.CompletionM{k}(indIDM,IndF_M);
            else
                hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{2,1}(ind,1)),IndF_P)=hExcelData.CompletionM{k}(indIDM,IndF_M);
            end
            hExcelData.Portfolio{4,1}(indRM,:)=[ hExcelData.Portfolio{2,1}(ind,1) s_Id field_name hExcelData.CompletionM{k}(indIDM,IndF_M)];
            
            indRM=indRM+1;
            hExcelData.Portfolio{2,1}(ind,:)=[ {''} {''} {''} {''}];
            return;
            
        end
        
        
        
        UniqueID_P=num2str(cell2mat(s_Id));
        UniqueID_M=cell(length(indIDM),1);
        UniqueID_M(:)=s_Id;
        for m=1:size(hconfig.UniqeIdentifier)
            
            
            [~,col_M]=find(strcmp(hconfig.UniqeIdentifier(m),hExcelData.CompletionM{k}(1,:)));
            [~,col_P]=find(strcmp(hconfig.UniqeIdentifier(m),hExcelData.Portfolio{1,1}(1,:)));
            
            if (isempty(col_M) ||  isempty(col_P) )
                continue;
            end
            
            if ~isempty(find(strcmp(hconfig.UniqeIdentifier(m),hExcelData.translateV(:,1))))
                
                [row,~]=find(strcmp(hExcelData.Portfolio{1,1}(hExcelData.Portfolio{2,1}(ind,1),col_P),hExcelData.translateV));
                if ~(length(row)==1)
                    continue;
                end
                hExcelData.Portfolio{1,1}(hExcelData.Portfolio{2,1}(ind,1),col_P)=hExcelData.translateV(row,2);
                for h=1:length(indIDM)
                    
                    [row,~]=find(strcmp(hExcelData.CompletionM{k}(indIDM(h),col_M),hExcelData.translateV));
                    if ~(length(row)==1)
                        continue;
                    end
                    hExcelData.CompletionM{k}(indIDM(h),col_M)=hExcelData.translateV(row,2);
                end
            end
            UniqueID_P=strcat(UniqueID_P,cell2string(hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{2,1}(ind,1)),col_P)));
         
            for ii=1:length(indIDM)
                
                UniqueID_M(ii)={strcat(cell2string(UniqueID_M(ii)),cell2string(hExcelData.CompletionM{k}(indIDM(ii),col_M)))};
                
            end
            
        end
        
        testCheck=strcmp(UniqueID_P,UniqueID_M);
        
        
        ind_t=find(testCheck);
        if ~(length(ind_t)==1)
            continue;
        end
        
        if cellfun(@(x) any(isnan(x))| any(isempty(x)),hExcelData.CompletionM{k}(indIDM(ind_t),IndF_M))
            continue;
        end
        
        if isempty(IndF_P)
            hExcelData.Portfolio{1,1}(1,end+1)=field_name;
            hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{2,1}(ind,1)),end)=hExcelData.CompletionM{k}(indIDM(ind_t),IndF_M);
        else
            hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{2,1}(ind,1)),IndF_P)=hExcelData.CompletionM{k}( indIDM(ind_t),IndF_M);
        end
        hExcelData.Portfolio{4,1}(indRM,:)=[ hExcelData.Portfolio{2,1}(ind,1) s_Id field_name hExcelData.CompletionM{k}(indIDM(ind_t),IndF_M)];
        
        indRM=indRM+1;
        hExcelData.Portfolio{2,1}(ind,:)=[ {''} {''} {''} {''}];
        return;
    else
        
        
        [row,~]=find(strcmp(s_Id,hExcelData.CompletionM{k}(:,IndID_M)));
        if length(row)==1
            
            if cellfun(@(x) any(isnan(x))| any(isempty(x)),hExcelData.CompletionM{k}(row,IndF_M))
                continue;
            end
            
            if isempty(IndF_P)
                hExcelData.Portfolio{1,1}(1,end+1)=field_name;
                hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{2,1}(ind,1)),end)=hExcelData.CompletionM{k}(row,IndF_M);
            else
                hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{2,1}(ind,1)),IndF_P)=hExcelData.CompletionM{k}(row,IndF_M);
            end
            hExcelData.Portfolio{4,1}(indRM,:)=[ hExcelData.Portfolio{2,1}(ind,1) s_Id field_name hExcelData.CompletionM{k}(row,IndF_M)];
            
            indRM=indRM+1;
            hExcelData.Portfolio{2,1}(ind,:)=[ {''} {''} {''} {''}];
            return;
        else
            continue;
        end
    end
end

for k=1:size(hExcelData.CompletionD,2)
    [~,IndF_D]=find(strcmp(field_name,hExcelData.CompletionD{k}(1,:)));
    
    if isempty(IndF_D)
        continue;
    end
    
    [~,IndID_D]=find(strcmp('Security_ID',hExcelData.CompletionD{k}(1,:)));
    if isempty(IndID_D)
        continue;
    end
    
    
    
    if  ~isempty(hconfig.UniqeIdentifier)
        
        [indIDD,~]=find(cell2mat(s_Id)==cell2mat(hExcelData.CompletionD{k}(2:end,IndID_D)));
        indIDD=indIDD+1;
        if length(indIDD)<1
            continue;
        end
        
        
        if length(indIDD)==1
            
            if cellfun(@(x) any(isnan(x))| any(isempty(x)),hExcelData.CompletionD{k}(indIDD,IndF_D))
                continue;
            end
            
            if isempty(IndF_P)
                hExcelData.Portfolio{1,1}(1,end+1)=field_name;
                hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{2,1}(ind,1)),end)=hExcelData.CompletionD{k}(indIDD,IndF_D);
            else
                
                hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{2,1}(ind,1)),IndF_P)=hExcelData.CompletionD{k}(indIDD,IndF_D);
                
            end
            hExcelData.Portfolio{5,1}(indRD,:)=[ hExcelData.Portfolio{2,1}(ind,1) s_Id field_name hExcelData.CompletionD{k}(indIDD,IndF_D)];
            indRD=indRD+1;
            hExcelData.Portfolio{2,1}(ind,:)=[ {''} {''} {''} {''}];
            return;
            
        end
        
        
        
        UniqueID_P=num2str(cell2mat(s_Id));
        UniqueID_D=num2str(cell2mat(s_Id));
        for m=1:size(hconfig.UniqeIdentifier)
            
            
            [~,col_D]=find(strcmp(hconfig.UniqeIdentifier(m),hExcelData.CompletionD{k}(1,:)));
            [~,col_P]=find(strcmp(hconfig.UniqeIdentifier(m),hExcelData.Portfolio{1,1}(1,:)));
            
            if (isempty(col_D) ||  isempty(col_P) )
                continue;
            end
            
            if ~isempty(find(strcmp(hconfig.UniqeIdentifier(m),hExcelData.translateV(:,1))))
                
                [row,~]=find(strcmp(hExcelData.Portfolio{1,1}(hExcelData.Portfolio{2,1}(ind,1),col_P),hExcelData.translateV));
                if ~(length(row)==1)
                    continue;
                end
                hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{2,1}(ind,1)),col_P)=hExcelData.translateV(row,2);
                for h=1:length(indIDD)
                    
                    [row,~]=find(strcmp(hExcelData.CompletionD{k}(indIDD(h),col_D),hExcelData.translateV));
                    if ~(length(row)==1)
                        continue;
                    end
                    hExcelData.CompletionD{k}(indIDD(h),col_D)=hExcelData.translateV(row,2);
                end
            end
            UniqueID_P=strcat(UniqueID_P,cell2string(hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{2,1}(ind,1)),col_P)));
            UniqueID_D_tmp=UniqueID_D;
            UniqueID_D={strcat(UniqueID_D_tmp,cell2string(hExcelData.CompletionD{k}(indIDD(1),col_D)))};
            for ii=2:length(indIDD)
                
                UniqueID_D=[ UniqueID_D; {strcat(UniqueID_D_tmp,cell2string(hExcelData.CompletionD{k}(indIDD(ii),col_D)))}];
                
            end
        end
        
        
        testcheck=strcmp(UniqueID_P,UniqueID_D);
        
        ind_t=find((testcheck));
        if ~(length(ind_t)==1)
            continue;
        end
        
        if cellfun(@(x) any(isnan(x))| any(isempty(x)),hExcelData.CompletionD{k}(indIDD(ind_t),IndF_D))
            continue;
        end
        
        if isempty(IndF_P)
            hExcelData.Portfolio{1,1}(1,end+1)=field_name;
            hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{2,1}(ind,1)),end)=hExcelData.CompletionD{k}(indIDD(ind_t),IndF_D);
        else
            hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{2,1}(ind,1)),IndF_P)=hExcelData.CompletionD{k}( indIDD(ind_t),IndF_D);
        end
        hExcelData.Portfolio{5,1}(indRD,:)=[ hExcelData.Portfolio{2,1}(ind,1) s_Id field_name hExcelData.CompletionD{k}( indIDD(ind_t),IndF_D)];
        
        indRD=indRD+1;
        hExcelData.Portfolio{2,1}(ind,:)=[ {''} {''} {''} {''}];
        return;
    else
        
        
        [row,~]=find(strcmp(s_Id,hExcelData.CompletionD{k}(:,IndID_D)));
        if length(row)==1
            if cellfun(@(x) any(isnan(x))| any(isempty(x)),hExcelData.CompletionD{k}(row,IndF_D))
                continue;
            end
            
            if isempty(IndF_P)
                hExcelData.Portfolio{1,1}(1,end+1)=field_name;
                hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{2,1}(ind,1)),end)=hExcelData.CompletionD{k}(row,IndF_D);
            else
                hExcelData.Portfolio{1,1}(cell2mat(hExcelData.Portfolio{2,1}(ind,1)),IndF_P)=hExcelData.CompletionD{k}(row,IndF_D);
            end
            hExcelData.Portfolio{5,1}(indRD,:)=[ hExcelData.Portfolio{2,1}(ind,1) s_Id field_name hExcelData.CompletionD{k}(row,IndF_D)];
            
            indRD=indRD+1;
            hExcelData.Portfolio{2,1}(ind,:)=[ {''} {''} {''} {''}];
            return;
        else
            continue;
        end
    end
end
end




function hist_action_mode_selection(source,callbackdata)

if   strcmp(callbackdata.NewValue.Tag,'replace')
    choice = questdlg('האם אתה בטוח שאתה מעוניין למחוק את כל נתוני השוק הקיימים, במהלך טעינת הנתונים ההיסטוריים?', ...
        '','כן','לא','כן');
    switch(choice)
        case 'כן'
            return;
        case 'לא'
            h=findobj('Tag','RadiobuttonG');
            set(h,'SelectedObject',callbackdata.OldValue);
            
    end
    
    
end

end

function CloseFigMain(~,~)

%clc;
clearvars;
delete(gcf)
end


