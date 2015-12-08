%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script reads historical climate data, as well as future climate
% data, and analyses & vizualizes climate characteristics
%
%
% Author: Hanne Van Gaelen
% Last Update: 08/12/2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. READ IN CLIMATE DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%1.1 Read in Historical climate data (used as input of perturbation tool)
%-------------------------------------------------------------------------
% Define datapath of historical dataseries & Timeseries
% models
    DatapathHist=uigetdir('C:\','Select directory with input of perturbation tool');

% Rainfall data
    filenamefull=fullfile(DatapathHist,'P1.txt'); 
    RainHist= importdata(filenamefull); 

% ET0 data    
    filenamefull=fullfile(DatapathHist,'ETo1.txt'); 
    EToHist= importdata(filenamefull); 

% Tmin data
    filenamefull=fullfile(DatapathHist,'Tmin1.txt'); 
    TminHist= importdata(filenamefull); 

% Tmax data
    filenamefull=fullfile(DatapathHist,'Tmax1.txt'); 
    TmaxHist= importdata(filenamefull); 
    
% Time data (based on timeseries of Tmax)
    filenamefull=fullfile(DatapathHist,'time_Tmax1.txt');   
    fid = fopen(filenamefull);
    TimeHist=textscan(fid,'%{yyyy-MM-dd}D %s');
    TimeHist=TimeHist{1,1};
    TimeHist.Format = 'dd-MM-yyyy';
    fclose(fid);   
    
clear fid filenamefull ans DatapathHist

%1.1 Read in Future climate data (output of the perturbation tool)
%-------------------------------------------------------------------------
% climate data
[EToFut,RainFut,TminFut,TmaxFut,nFut]=ReadPertSeries();

% generate time data
Start=datetime(2035,1,1);       % Start date 
End=datetime(2064,12,30);       % End date 
TimeFut=Start:1:End;
TimeFut=TimeFut.';

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. WRITE ALL DATA IN A MATRIX (NOT STRUCTURE)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% put all data (historical & future) together in a matrix (not a structure)
EToMat=[EToHist,cell2mat(EToFut(3,:))];
RainMat=[RainHist,cell2mat(RainFut(3,:))];
TminMat=[TminHist,cell2mat(TminFut(3,:))];
TmaxMat=[TmaxHist,cell2mat(TmaxFut(3,:))];

% create matrix with names of all climate scenario (numbers, not yet
% climate model names)
NameMat={'Hist'};
for i=1:nFut
    new=['Fut' num2str(i)];
    NameMat{1,i+1}=new;
end

% number of scenarios
nscen=length(NameMat); 

clear new i EToFut RainFut TminFut TmaxFut EToHist RainHist TminHist TmaxHist nFut
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. CALCULATE YEARLY, MONTHLY, SEASONAL SUBTOTALS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%calculate subtotals 
[EToYearTots,~,~,~,EToMonthTots,~,EToSeasonTots]=ClimSubtotal(TimeHist,EToMat,'sum');
[RainYearTots,~,~,~,RainMonthTots,~,RainSeasonTots]=ClimSubtotal(TimeHist,RainMat,'sum');
[TminYearTots,~,~,~,TminMonthTots,~,TminSeasonTots]=ClimSubtotal(TimeHist,TminMat,'mean');
[TmaxYearTots,~,~,~,TmaxMonthTots,~,TmaxSeasonTots]=ClimSubtotal(TimeHist,TmaxMat,'mean');

%reorganize data in matrix in stead of structure
    EToYearTot(:,1)=EToYearTots{1,1}(:,1); % Write year in first colum
    RainYearTot(:,1)=RainYearTots{1,1}(:,1);
    TminYearTot(:,1)=TminYearTots{1,1}(:,1);
    TmaxYearTot(:,1)=TmaxYearTots{1,1}(:,1);

    EToMonthTot(:,1:2)=EToMonthTots{1,1}(:,1:2); % Write year & month in first two colums
    RainMonthTot(:,1:2)=RainMonthTots{1,1}(:,1:2);
    TminMonthTot(:,1:2)=TminMonthTots{1,1}(:,1:2);
    TmaxMonthTot(:,1:2)=TmaxMonthTots{1,1}(:,1:2);

    EToSeasonTot(:,1:2)=EToSeasonTots{1,1}(:,1:2);% Write year & season in first two colums
    RainSeasonTot(:,1:2)=RainSeasonTots{1,1}(:,1:2);
    TminSeasonTot(:,1:2)=TminSeasonTots{1,1}(:,1:2);
    TmaxSeasonTot(:,1:2)=TmaxSeasonTots{1,1}(:,1:2);

    for sc=1:nscen % write subtotal data in next columns
        EToYearTot(:,sc+1)=EToYearTots{1,sc}(:,2);
        RainYearTot(:,sc+1)=RainYearTots{1,sc}(:,2);
        TminYearTot(:,sc+1)=TminYearTots{1,sc}(:,2);
        TmaxYearTot(:,sc+1)=TminYearTots{1,sc}(:,2);

        EToMonthTot(:,sc+2)=EToMonthTots{1,sc}(:,3);
        RainMonthTot(:,sc+2)=RainMonthTots{1,sc}(:,3);
        TminMonthTot(:,sc+2)=TminMonthTots{1,sc}(:,3);
        TmaxMonthTot(:,sc+2)=TmaxMonthTots{1,sc}(:,3);   

        EToSeasonTot(:,sc+2)=EToSeasonTots{1,sc}(:,3);
        RainSeasonTot(:,sc+2)=RainSeasonTots{1,sc}(:,3);
        TminSeasonTot(:,sc+2)=TminSeasonTots{1,sc}(:,3);
        TmaxSeasonTot(:,sc+2)=TmaxSeasonTots{1,sc}(:,3);  
    end

clear sc 
clear EToYearTots EToMonthTots EToSeasonTots
clear RainYearTots RainMonthTots RainSeasonTots
clear TminYearTots TminMonthTots TminSeasonTots
clear TmaxYearTots TmaxMonthTots TmaxSeasonTots

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5. CALCULATE YEARLY STATS & VIZUALIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 5.1 STATS of YEARLY VALUES
%--------------------------------------------------------------------------
EToStatsYear(1,1:nscen)=mean(EToYearTot(:,2:nscen+1));
RainStatsYear(1,1:nscen)=mean(RainYearTot(:,2:nscen+1));
TminStatsYear(1,1:nscen)=mean(TminYearTot(:,2:nscen+1));
TmaxStatsYear(1,1:nscen)=mean(TmaxYearTot(:,2:nscen+1));

EToStatsYear(2,1:nscen)=std(EToYearTot(:,2:nscen+1));
RainStatsYear(2,1:nscen)=std(RainYearTot(:,2:nscen+1));
TminStatsYear(2,1:nscen)=std(TminYearTot(:,2:nscen+1));
TmaxStatsYear(2,1:nscen)=std(TmaxYearTot(:,2:nscen+1));

EToStatsYear(3,1:nscen)=median(EToYearTot(:,2:nscen+1));
RainStatsYear(3,1:nscen)=median(RainYearTot(:,2:nscen+1));
TminStatsYear(3,1:nscen)=median(TminYearTot(:,2:nscen+1));
TmaxStatsYear(3,1:nscen)=median(TmaxYearTot(:,2:nscen+1));

EToStatsYear(4,1:nscen)=min(EToYearTot(:,2:nscen+1));
RainStatsYear(4,1:nscen)=min(RainYearTot(:,2:nscen+1));
TminStatsYear(4,1:nscen)=min(TminYearTot(:,2:nscen+1));
TmaxStatsYear(4,1:nscen)=min(TmaxYearTot(:,2:nscen+1));

EToStatsYear(5,1:nscen)=max(EToYearTot(:,2:nscen+1));
RainStatsYear(5,1:nscen)=max(RainYearTot(:,2:nscen+1));
TminStatsYear(5,1:nscen)=max(TminYearTot(:,2:nscen+1));
TmaxStatsYear(5,1:nscen)=max(TmaxYearTot(:,2:nscen+1));

% 5.2 VIZUALIZE
%--------------------------------------------------------------------------

figure('name','Yearly statistics')
    subplot(4,1,1, 'fontsize',10);%ETo
        boxplot(EToYearTot(:,2:nscen+1),'labels',NameMat)
        xlabel('Climate Scenario')
        ylabel('Annual ETo (mm/year)')
        title('Yearly statistics')
    subplot(4,1,2, 'fontsize',10);%Rainfall
        boxplot(RainYearTot(:,2:nscen+1),'labels',NameMat)
        xlabel('Climate Scenario')
        ylabel('Annual rainfall (mm/year)')
    subplot(4,1,3, 'fontsize',10);%Tmin
        boxplot(TminYearTot(:,2:nscen+1),'labels',NameMat)
        xlabel('Climate Scenario')
        ylabel('Yearly average of Tmin (�C)')
    subplot(4,1,4, 'fontsize',10);%Tmax
        boxplot(TmaxYearTot(:,2:nscen+1),'labels',NameMat)
        xlabel('Climate Scenario')
        ylabel('Yearly average of Tmax (�C)')
    

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 6. CALCULATE SEASONAL STATS & VIZUALIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 6.1 WINTER SEASON
%--------------------------------------------------------------------------
% STATS
EToWinter=EToSeasonTot(EToSeasonTot(:,2)==1,:); % Select only seasonal values of winter
RainWinter=RainSeasonTot(RainSeasonTot(:,2)==1,:);
TminWinter=TminSeasonTot(TminSeasonTot(:,2)==1,:);
TmaxWinter=TmaxSeasonTot(TmaxSeasonTot(:,2)==1,:);

EToStatsWinter(1,1:nscen)=mean(EToWinter(:,3:nscen+2)); % calculate stats
RainStatsWinter(1,1:nscen)=mean(RainWinter(:,3:nscen+2));
TminStatsWinter(1,1:nscen)=mean(TminWinter(:,3:nscen+2));
TmaxStatsWinter(1,1:nscen)=mean(TmaxWinter(:,3:nscen+2));

EToStatsWinter(2,1:nscen)=std(EToWinter(:,3:nscen+2));
RainStatsWinter(2,1:nscen)=std(RainWinter(:,3:nscen+2));
TminStatsWinter(2,1:nscen)=std(TminWinter(:,3:nscen+2));
TmaxStatsWinter(2,1:nscen)=std(TmaxWinter(:,3:nscen+2));

EToStatsWinter(3,1:nscen)=median(EToWinter(:,3:nscen+2));
RainStatsWinter(3,1:nscen)=median(RainWinter(:,3:nscen+2));
TminStatsWinter(3,1:nscen)=median(TminWinter(:,3:nscen+2));
TmaxStatsWinter(3,1:nscen)=median(TmaxWinter(:,3:nscen+2));

EToStatsWinter(4,1:nscen)=min(EToWinter(:,3:nscen+2));
RainStatsWinter(4,1:nscen)=min(RainWinter(:,3:nscen+2));
TminStatsWinter(4,1:nscen)=min(TminWinter(:,3:nscen+2));
TmaxStatsWinter(4,1:nscen)=min(TmaxWinter(:,3:nscen+2));

EToStatsWinter(5,1:nscen)=max(EToWinter(:,3:nscen+2));
RainStatsWinter(5,1:nscen)=max(RainWinter(:,3:nscen+2));
TminStatsWinter(5,1:nscen)=max(TminWinter(:,3:nscen+2));
TmaxStatsWinter(5,1:nscen)=max(TmaxWinter(:,3:nscen+2));

% VIZUALIZE
figure('name','Winter statistics')
    subplot(4,1,1, 'fontsize',10);%ETo
        boxplot(EToWinter(:,3:nscen+2),'labels',NameMat)
        ylabel('Seasonal ETo (mm/season)')
        title('Winter statistics')
    subplot(4,1,2, 'fontsize',10);%Rainfall
        boxplot(RainWinter(:,3:nscen+2),'labels',NameMat)
        ylabel('Seasonal rainfall (mm/season)')
    subplot(4,1,3, 'fontsize',10);%Tmin
        boxplot(TminWinter(:,3:nscen+2),'labels',NameMat)
        ylabel('Seasonal average of Tmin (�C)')
    subplot(4,1,4, 'fontsize',10);%Tmax
        boxplot(TmaxWinter(:,3:nscen+2),'labels',NameMat)
        xlabel('Climate Scenario')
        ylabel('Seasonal average of Tmax (�C)')

% 6.2 SUMMER SEASON
%--------------------------------------------------------------------------
% STATS
EToSummer=EToSeasonTot(EToSeasonTot(:,2)==3,:); % Select only seasonal values of Summer
RainSummer=RainSeasonTot(RainSeasonTot(:,2)==3,:);
TminSummer=TminSeasonTot(TminSeasonTot(:,2)==3,:);
TmaxSummer=TmaxSeasonTot(TmaxSeasonTot(:,2)==3,:);

EToStatsSummer(1,1:nscen)=mean(EToSummer(:,3:nscen+2)); % calculate stats
RainStatsSummer(1,1:nscen)=mean(RainSummer(:,3:nscen+2));
TminStatsSummer(1,1:nscen)=mean(TminSummer(:,3:nscen+2));
TmaxStatsSummer(1,1:nscen)=mean(TmaxSummer(:,3:nscen+2));

EToStatsSummer(2,1:nscen)=std(EToSummer(:,3:nscen+2));
RainStatsSummer(2,1:nscen)=std(RainSummer(:,3:nscen+2));
TminStatsSummer(2,1:nscen)=std(TminSummer(:,3:nscen+2));
TmaxStatsSummer(2,1:nscen)=std(TmaxSummer(:,3:nscen+2));

EToStatsSummer(3,1:nscen)=median(EToSummer(:,3:nscen+2));
RainStatsSummer(3,1:nscen)=median(RainSummer(:,3:nscen+2));
TminStatsSummer(3,1:nscen)=median(TminSummer(:,3:nscen+2));
TmaxStatsSummer(3,1:nscen)=median(TmaxSummer(:,3:nscen+2));

EToStatsSummer(4,1:nscen)=min(EToSummer(:,3:nscen+2));
RainStatsSummer(4,1:nscen)=min(RainSummer(:,3:nscen+2));
TminStatsSummer(4,1:nscen)=min(TminSummer(:,3:nscen+2));
TmaxStatsSummer(4,1:nscen)=min(TmaxSummer(:,3:nscen+2));

EToStatsSummer(5,1:nscen)=max(EToSummer(:,3:nscen+2));
RainStatsSummer(5,1:nscen)=max(RainSummer(:,3:nscen+2));
TminStatsSummer(5,1:nscen)=max(TminSummer(:,3:nscen+2));
TmaxStatsSummer(5,1:nscen)=max(TmaxSummer(:,3:nscen+2));

% VIZUALIZE
figure('name','Summer statistics')
    subplot(4,1,1, 'fontsize',10);%ETo
        boxplot(EToSummer(:,3:nscen+2),'labels',NameMat)
        ylabel('Seasonal ETo (mm/season)')
        title('Summer statistics')
    subplot(4,1,2, 'fontsize',10);%Rainfall
        boxplot(RainSummer(:,3:nscen+2),'labels',NameMat)
        ylabel('Seasonal rainfall (mm/season)')
    subplot(4,1,3, 'fontsize',10);%Tmin
        boxplot(TminSummer(:,3:nscen+2),'labels',NameMat)
        ylabel('Seasonal average of Tmin (�C)')
    subplot(4,1,4, 'fontsize',10);%Tmax
        boxplot(TmaxSummer(:,3:nscen+2),'labels',NameMat)
        xlabel('Climate Scenario')
        ylabel('Seasonal average of Tmax (�C)')
