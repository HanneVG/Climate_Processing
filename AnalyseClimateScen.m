%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script reads historical climate data as well as future climate
% data (as generated by the pertubation tool), 
% and analyses & vizualizes climate characteristics
%
% TO DO before running script
%   - Give each scenario you run a name in variable 'NameMat'
%
% Author: Hanne Van Gaelen
% Last Update: 15/02/2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. READ IN CLIMATE DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%1.1 Read in Historical climate data (used as input of perturbation tool)
%-------------------------------------------------------------------------
% Define datapath of historical dataserie (=input of perturbation tool)
    DatapathHist=uigetdir('C:\','Select directory with input of perturbation tool=historical data');

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
% specify in which path all perturbed climate files are stored
Datapathpert=uigetdir('C:\','Select directory with perturbed climate series');

% climate data
[EToFut,RainFut,TminFut,TmaxFut,nFut]=ReadPertSeries(Datapathpert);

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

% create matrix with names of all climate scenario 
NameMat={'Hist', 'Fut1','Fut2','Fut3','Fut4','Fut5','Fut6','Fut9','Hs','Hw','L','M'};
%NameMat={'Hist', 'Fut1','Fut2','Fut3','Fut4','Fut5','Fut6','Fut9'};

nsc=length(NameMat); % number of scenarios

if nsc==nFut+1
    % NameMat is has enough names for all scnearios
else 
    error('NameMat has not enough names for all scenarios')
end   

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

    for sc=1:nsc % write subtotal data in next columns
        EToYearTot(:,sc+1)=EToYearTots{1,sc}(:,2);
        RainYearTot(:,sc+1)=RainYearTots{1,sc}(:,2);
        TminYearTot(:,sc+1)=TminYearTots{1,sc}(:,2);
        TmaxYearTot(:,sc+1)=TmaxYearTots{1,sc}(:,2);
        
        EToMonthTot(:,sc+2)=EToMonthTots{1,sc}(:,3);
        RainMonthTot(:,sc+2)=RainMonthTots{1,sc}(:,3);
        TminMonthTot(:,sc+2)=TminMonthTots{1,sc}(:,3);
        TmaxMonthTot(:,sc+2)=TmaxMonthTots{1,sc}(:,3);   

        EToSeasonTot(:,sc+2)=EToSeasonTots{1,sc}(:,3);
        RainSeasonTot(:,sc+2)=RainSeasonTots{1,sc}(:,3);
        TminSeasonTot(:,sc+2)=TminSeasonTots{1,sc}(:,3);
        TmaxSeasonTot(:,sc+2)=TmaxSeasonTots{1,sc}(:,3);  
    end

% Aridity on different timesteps  
AridityYearTot(:,1)=EToYearTot(:,1); % copy names
AridityMonthTot(:,1:2)=EToMonthTot(:,1:2);
AriditySeasonTot(:,1:2)=EToSeasonTot(:,1:2);

AridityYearTot(:,2:nsc+1)= RainYearTot(:,2:nsc+1)./EToYearTot(:,2:nsc+1); % calculate aridity
AridityMonthTot(:,3:nsc+2)= RainMonthTot(:,3:nsc+2)./EToMonthTot(:,3:nsc+2);
AriditySeasonTot(:,3:nsc+2)=  RainSeasonTot(:,3:nsc+2)./EToSeasonTot(:,3:nsc+2); 
    
% mean monthy values over all years
EToMonthAvg(1:12,1)=1:12;
RainMonthAvg(1:12,1)=1:12;
TminMonthAvg(1:12,1)=1:12;
TmaxMonthAvg(1:12,1)=1:12;

EToMonthMed(1:12,1)=1:12;
RainMonthMed(1:12,1)=1:12;
TminMonthMed(1:12,1)=1:12;
TmaxMonthMed(1:12,1)=1:12;
AridityMonthMed(1:12,1)=1:12;

for m=1:12 % loop trough all months
    EToM=EToMonthTot(EToMonthTot(:,2)==m,:);
    RainM=RainMonthTot(RainMonthTot(:,2)==m,:);
    TminM=TminMonthTot(TminMonthTot(:,2)==m,:);
    TmaxM=TmaxMonthTot(TmaxMonthTot(:,2)==m,:);
    AridityM=AridityMonthTot(AridityMonthTot(:,2)==m,:);
    
    EToMonthAvg(m,2:nsc+1)=mean(EToM(:,3:nsc+2));
    RainMonthAvg(m,2:nsc+1)=mean(RainM(:,3:nsc+2));
    TminMonthAvg(m,2:nsc+1)=mean(TminM(:,3:nsc+2));
    TmaxMonthAvg(m,2:nsc+1)=mean(TmaxM(:,3:nsc+2));
    
    EToMonthMed(m,2:nsc+1)=median(EToM(:,3:nsc+2));
    RainMonthMed(m,2:nsc+1)=median(RainM(:,3:nsc+2));
    TminMonthMed(m,2:nsc+1)=median(TminM(:,3:nsc+2));
    TmaxMonthMed(m,2:nsc+1)=median(TmaxM(:,3:nsc+2));
    AridityMonthMed(m,2:nsc+1)=median(AridityM(:,3:nsc+2));
    
end

clear sc 
clear EToYearTots EToMonthTots EToSeasonTots
clear RainYearTots  RainMonthTots RainSeasonTots
clear TminYearTots TminMonthTots TminSeasonTots
clear TmaxYearTots TmaxMonthTots TmaxSeasonTots
clear EToM RainM TminM TmaxM

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5. CALCULATE STATS & VIZUALIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 5.1 YEARLY
%--------------------------------------------------------------------------
% STATS
EToStatsYear(1,1:nsc)=mean(EToYearTot(:,2:nsc+1));
RainStatsYear(1,1:nsc)=mean(RainYearTot(:,2:nsc+1));
TminStatsYear(1,1:nsc)=mean(TminYearTot(:,2:nsc+1));
TmaxStatsYear(1,1:nsc)=mean(TmaxYearTot(:,2:nsc+1));
AridityStatsYear(1,1:nsc)=mean(AridityYearTot(:,2:nsc+1));

EToStatsYear(2,1:nsc)=std(EToYearTot(:,2:nsc+1));
RainStatsYear(2,1:nsc)=std(RainYearTot(:,2:nsc+1));
TminStatsYear(2,1:nsc)=std(TminYearTot(:,2:nsc+1));
TmaxStatsYear(2,1:nsc)=std(TmaxYearTot(:,2:nsc+1));
AridityStatsYear(2,1:nsc)=std(AridityYearTot(:,2:nsc+1));

EToStatsYear(3,1:nsc)=median(EToYearTot(:,2:nsc+1));
RainStatsYear(3,1:nsc)=median(RainYearTot(:,2:nsc+1));
TminStatsYear(3,1:nsc)=median(TminYearTot(:,2:nsc+1));
TmaxStatsYear(3,1:nsc)=median(TmaxYearTot(:,2:nsc+1));
AridityStatsYear(3,1:nsc)=median(AridityYearTot(:,2:nsc+1));

EToStatsYear(4,1:nsc)=min(EToYearTot(:,2:nsc+1));
RainStatsYear(4,1:nsc)=min(RainYearTot(:,2:nsc+1));
TminStatsYear(4,1:nsc)=min(TminYearTot(:,2:nsc+1));
TmaxStatsYear(4,1:nsc)=min(TmaxYearTot(:,2:nsc+1));
AridityStatsYear(4,1:nsc)=min(AridityYearTot(:,2:nsc+1));

EToStatsYear(5,1:nsc)=max(EToYearTot(:,2:nsc+1));
RainStatsYear(5,1:nsc)=max(RainYearTot(:,2:nsc+1));
TminStatsYear(5,1:nsc)=max(TminYearTot(:,2:nsc+1));
TmaxStatsYear(5,1:nsc)=max(TmaxYearTot(:,2:nsc+1));
AridityStatsYear(5,1:nsc)=min(AridityYearTot(:,2:nsc+1));

%VIZUALIZE
f1=figure('name','Yearly statistics');
    subplot(5,1,1, 'fontsize',10);%ETo
        boxplot(EToYearTot(:,2:nsc+1),'labels',NameMat)
        ylabel('Annual ETo (mm/year)')
        hold on
        line (xlim, [EToStatsYear(3,1),EToStatsYear(3,1)],'LineStyle','--','Color','k')
        title('Yearly statistics')
    subplot(5,1,2, 'fontsize',10);%Rainfall
        boxplot(RainYearTot(:,2:nsc+1),'labels',NameMat)
        hold on
        line (xlim, [RainStatsYear(3,1),RainStatsYear(3,1)],'LineStyle','--','Color','k')
        ylabel('Annual rainfall (mm/year)')
    subplot(5,1,3, 'fontsize',10);%Aridity
        boxplot(AridityYearTot(:,2:nsc+1),'labels',NameMat)
        hold on
        line (xlim, [AridityStatsYear(3,1),AridityStatsYear(3,1)],'LineStyle','--','Color','k')
        ylabel('Annual aridity (mm/mm)')
    subplot(5,1,4, 'fontsize',10);%Tmin
        boxplot(TminYearTot(:,2:nsc+1),'labels',NameMat)
        hold on
        line (xlim, [TminStatsYear(3,1),TminStatsYear(3,1)],'LineStyle','--','Color','k')
        ylabel('Yearly average of Tmin (�C)')
    subplot(5,1,5, 'fontsize',10);%Tmax
        boxplot(TmaxYearTot(:,2:nsc+1),'labels',NameMat)
        hold on
        line (xlim, [TmaxStatsYear(3,1),TmaxStatsYear(3,1)],'LineStyle','--','Color','k')
        xlabel('Climate Scenario')
        ylabel('Yearly average of Tmax (�C)')


% 5.2 WINTER SEASON
%--------------------------------------------------------------------------
% STATS
EToWinter=EToSeasonTot(EToSeasonTot(:,2)==1,:); % Select only seasonal values of winter
RainWinter=RainSeasonTot(RainSeasonTot(:,2)==1,:);
TminWinter=TminSeasonTot(TminSeasonTot(:,2)==1,:);
TmaxWinter=TmaxSeasonTot(TmaxSeasonTot(:,2)==1,:);
AridityWinter=AriditySeasonTot(AriditySeasonTot(:,2)==1,:);

EToStatsWinter(1,1:nsc)=mean(EToWinter(:,3:nsc+2)); % calculate stats
RainStatsWinter(1,1:nsc)=mean(RainWinter(:,3:nsc+2));
TminStatsWinter(1,1:nsc)=mean(TminWinter(:,3:nsc+2));
TmaxStatsWinter(1,1:nsc)=mean(TmaxWinter(:,3:nsc+2));
AridityStatsWinter(1,1:nsc)=mean(AridityWinter(:,3:nsc+2));

EToStatsWinter(2,1:nsc)=std(EToWinter(:,3:nsc+2));
RainStatsWinter(2,1:nsc)=std(RainWinter(:,3:nsc+2));
TminStatsWinter(2,1:nsc)=std(TminWinter(:,3:nsc+2));
TmaxStatsWinter(2,1:nsc)=std(TmaxWinter(:,3:nsc+2));
AridityStatsWinter(2,1:nsc)=std(AridityWinter(:,3:nsc+2));

EToStatsWinter(3,1:nsc)=median(EToWinter(:,3:nsc+2));
RainStatsWinter(3,1:nsc)=median(RainWinter(:,3:nsc+2));
TminStatsWinter(3,1:nsc)=median(TminWinter(:,3:nsc+2));
TmaxStatsWinter(3,1:nsc)=median(TmaxWinter(:,3:nsc+2));
AridityStatsWinter(3,1:nsc)=median(AridityWinter(:,3:nsc+2));

EToStatsWinter(4,1:nsc)=min(EToWinter(:,3:nsc+2));
RainStatsWinter(4,1:nsc)=min(RainWinter(:,3:nsc+2));
TminStatsWinter(4,1:nsc)=min(TminWinter(:,3:nsc+2));
TmaxStatsWinter(4,1:nsc)=min(TmaxWinter(:,3:nsc+2));
AridityStatsWinter(4,1:nsc)=min(AridityWinter(:,3:nsc+2));

EToStatsWinter(5,1:nsc)=max(EToWinter(:,3:nsc+2));
RainStatsWinter(5,1:nsc)=max(RainWinter(:,3:nsc+2));
TminStatsWinter(5,1:nsc)=max(TminWinter(:,3:nsc+2));
TmaxStatsWinter(5,1:nsc)=max(TmaxWinter(:,3:nsc+2));
AridityStatsWinter(5,1:nsc)=max(AridityWinter(:,3:nsc+2));

% VIZUALIZE
f2=figure('name','Winter statistics');
    subplot(5,1,1, 'fontsize',10);%ETo
        boxplot(EToWinter(:,3:nsc+2),'labels',NameMat)
        hold on
        line (xlim, [EToStatsWinter(3,1),EToStatsWinter(3,1)],'LineStyle','--','Color','k')
        ylabel('Seasonal ETo (mm/season)')
        title('Winter statistics')
    subplot(5,1,2, 'fontsize',10);%Rainfall
        boxplot(RainWinter(:,3:nsc+2),'labels',NameMat)
        hold on
        line (xlim, [RainStatsWinter(3,1),RainStatsWinter(3,1)],'LineStyle','--','Color','k')
        ylabel('Seasonal rainfall (mm/season)')
    subplot(5,1,3, 'fontsize',10);% Aridity 
        boxplot(AridityWinter(:,3:nsc+2),'labels',NameMat)
        hold on
        line (xlim, [AridityStatsWinter(3,1),AridityStatsWinter(3,1)],'LineStyle','--','Color','k')
        ylabel('Seasonal aridity (mm/mm)')
    subplot(5,1,4, 'fontsize',10);%Tmin
        boxplot(TminWinter(:,3:nsc+2),'labels',NameMat)
        hold on
        line (xlim, [TminStatsWinter(3,1),TminStatsWinter(3,1)],'LineStyle','--','Color','k')
        ylabel('Seasonal average of Tmin (�C)')
    subplot(5,1,5, 'fontsize',10);%Tmax
        boxplot(TmaxWinter(:,3:nsc+2),'labels',NameMat)
        hold on
        line (xlim, [TmaxStatsWinter(3,1),TmaxStatsWinter(3,1)],'LineStyle','--','Color','k')
        xlabel('Climate Scenario')
        ylabel('Seasonal average of Tmax (�C)')

% 5.3 SUMMER SEASON
%--------------------------------------------------------------------------
% STATS
EToSummer=EToSeasonTot(EToSeasonTot(:,2)==3,:); % Select only seasonal values of Summer
RainSummer=RainSeasonTot(RainSeasonTot(:,2)==3,:);
TminSummer=TminSeasonTot(TminSeasonTot(:,2)==3,:);
TmaxSummer=TmaxSeasonTot(TmaxSeasonTot(:,2)==3,:);
AriditySummer=AriditySeasonTot(AriditySeasonTot(:,2)==3,:);

EToStatsSummer(1,1:nsc)=mean(EToSummer(:,3:nsc+2)); % calculate stats
RainStatsSummer(1,1:nsc)=mean(RainSummer(:,3:nsc+2));
TminStatsSummer(1,1:nsc)=mean(TminSummer(:,3:nsc+2));
TmaxStatsSummer(1,1:nsc)=mean(TmaxSummer(:,3:nsc+2));
AridityStatsSummer(1,1:nsc)=mean(AriditySummer(:,3:nsc+2));

EToStatsSummer(2,1:nsc)=std(EToSummer(:,3:nsc+2));
RainStatsSummer(2,1:nsc)=std(RainSummer(:,3:nsc+2));
TminStatsSummer(2,1:nsc)=std(TminSummer(:,3:nsc+2));
TmaxStatsSummer(2,1:nsc)=std(TmaxSummer(:,3:nsc+2));
AridityStatsSummer(2,1:nsc)=std(AriditySummer(:,3:nsc+2));

EToStatsSummer(3,1:nsc)=median(EToSummer(:,3:nsc+2));
RainStatsSummer(3,1:nsc)=median(RainSummer(:,3:nsc+2));
TminStatsSummer(3,1:nsc)=median(TminSummer(:,3:nsc+2));
TmaxStatsSummer(3,1:nsc)=median(TmaxSummer(:,3:nsc+2));
AridityStatsSummer(3,1:nsc)=median(AriditySummer(:,3:nsc+2));

EToStatsSummer(4,1:nsc)=min(EToSummer(:,3:nsc+2));
RainStatsSummer(4,1:nsc)=min(RainSummer(:,3:nsc+2));
TminStatsSummer(4,1:nsc)=min(TminSummer(:,3:nsc+2));
TmaxStatsSummer(4,1:nsc)=min(TmaxSummer(:,3:nsc+2));
AridityStatsSummer(4,1:nsc)=min(AriditySummer(:,3:nsc+2));

EToStatsSummer(5,1:nsc)=max(EToSummer(:,3:nsc+2));
RainStatsSummer(5,1:nsc)=max(RainSummer(:,3:nsc+2));
TminStatsSummer(5,1:nsc)=max(TminSummer(:,3:nsc+2));
TmaxStatsSummer(5,1:nsc)=max(TmaxSummer(:,3:nsc+2));
AridityStatsSummer(5,1:nsc)=max(AriditySummer(:,3:nsc+2));

% VIZUALIZE
f3=figure('name','Summer statistics');
    subplot(5,1,1, 'fontsize',10);%ETo
        boxplot(EToSummer(:,3:nsc+2),'labels',NameMat)
        hold on
        line (xlim, [EToStatsSummer(3,1),EToStatsSummer(3,1)],'LineStyle','--','Color','k')
        ylabel('Seasonal ETo (mm/season)')
        title('Summer statistics')
    subplot(5,1,2, 'fontsize',10);%Rainfall
        boxplot(RainSummer(:,3:nsc+2),'labels',NameMat)
        hold on
        line (xlim, [RainStatsSummer(3,1),RainStatsSummer(3,1)],'LineStyle','--','Color','k')
        ylabel('Seasonal rainfall (mm/season)')
    subplot(5,1,3, 'fontsize',10);%Aridity
        boxplot(AriditySummer(:,3:nsc+2),'labels',NameMat)
        hold on
        line (xlim, [AridityStatsSummer(3,1),AridityStatsSummer(3,1)],'LineStyle','--','Color','k')
        ylabel('Seasonal aridity (mm/mm)')
    subplot(5,1,4, 'fontsize',10);%Tmin
        boxplot(TminSummer(:,3:nsc+2),'labels',NameMat)
        hold on
        line (xlim, [TminStatsSummer(3,1),TminStatsSummer(3,1)],'LineStyle','--','Color','k')
        ylabel('Seasonal average of Tmin (�C)')
    subplot(5,1,5, 'fontsize',10);%Tmax
        boxplot(TmaxSummer(:,3:nsc+2),'labels',NameMat)
        hold on
        line (xlim, [TmaxStatsSummer(3,1),TmaxStatsSummer(3,1)],'LineStyle','--','Color','k')        
        xlabel('Climate Scenario')
        ylabel('Seasonal average of Tmax (�C)')


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 6. ANALYZE MEANS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 6.1 MEAN CHANGES
%-------------------------------------------------------------------------
MeanYear=[EToStatsYear(1,:);RainStatsYear(1,:);AridityStatsYear(1,:);TminStatsYear(1,:);TmaxStatsYear(1,:)];
MeanSummer=[EToStatsSummer(1,:);RainStatsSummer(1,:);AridityStatsSummer(1,:);TminStatsSummer(1,:);TmaxStatsSummer(1,:)];
MeanWinter=[EToStatsWinter(1,:);RainStatsWinter(1,:);AridityStatsWinter(1,:);TminStatsWinter(1,:);TmaxStatsWinter(1,:)];

[a,b]=size(MeanYear);
MeanChangeYear=NaN(a,b);
[a,b]=size(MeanSummer);
MeanChangeSummer=NaN(a,b);
[a,b]=size(MeanWinter);
MeanChangeWinter=NaN(a,b);

for i=1:nsc
    MeanChangeYear(:,i)=MeanYear(:,i)-MeanYear(:,1);
    MeanChangeSummer(:,i)=MeanSummer(:,i)-MeanSummer(:,1);
    MeanChangeWinter(:,i)=MeanWinter(:,i)-MeanWinter(:,1);
end

clear i a b 

% 6.2 MEAN MONTHLY VALUE
%-------------------------------------------------------------------------

f4=figure('name','Monthly ETo averages'); %#ok<NASGU>
        P=plot(EToMonthAvg(:,1),EToMonthAvg(:,2),EToMonthAvg(:,1),EToMonthMed(:,2));
        set(P,{'LineStyle'},{'-';'--'})
        set(P,{'Color'},{'k';'k'})
        set(P,{'LineWidth'},{1.5;1.5}) 
        hold on
        plot(EToMonthAvg(:,1),EToMonthAvg(:,3:nsc+1));
        xlabel('Month','fontsize',10);
        ylabel('Average Monthly ETo (mm)','fontsize',10);
        axisy=ylim;
        axis([0,13,axisy(1,1),axisy(1,2)]);
        ax=gca;
        ax.XTick=1:12;
    

f5=figure('name','Monthly Rainfall averages'); %#ok<NASGU>
        P=plot(RainMonthAvg(:,1),RainMonthAvg(:,2),RainMonthAvg(:,1),RainMonthMed(:,2));
        set(P,{'LineStyle'},{'-';'--'})
        set(P,{'Color'},{'k';'k'})
        set(P,{'LineWidth'},{1.5;1.5})    
        hold on
        plot(RainMonthAvg(:,1),RainMonthAvg(:,3:nsc+1));
        xlabel('Month','fontsize',10);
        ylabel('Average Monthly Rain (mm)','fontsize',10);
        axisy=ylim;
        axis([0,13,axisy(1,1),axisy(1,2)]);
        ax=gca;
        ax.XTick=1:12;
   
       
 f6=figure('name','Monthly average Tmin'); %#ok<NASGU>
        P=plot(TminMonthAvg(:,1),TminMonthAvg(:,2),TminMonthAvg(:,1),TminMonthMed(:,2));
        set(P,{'LineStyle'},{'-';'--'})
        set(P,{'Color'},{'k';'k'})
        set(P,{'LineWidth'},{1.5;1.5})      
        hold on
        plot(TminMonthAvg(:,1),TminMonthAvg(:,3:nsc+1));
        xlabel('Month','fontsize',10);
        ylabel('Monthly average Tmin (�C)','fontsize',10);
        axisy=ylim;
        axis([0,13,axisy(1,1),axisy(1,2)]);
        ax=gca;
        ax.XTick=1:12;
      

f7=figure('name','Monthly average Tmax'); %#ok<NASGU>
        P=plot(TmaxMonthAvg(:,1),TmaxMonthAvg(:,2),TmaxMonthAvg(:,1),TmaxMonthMed(:,2));
        set(P,{'LineStyle'},{'-';'--'})
        set(P,{'Color'},{'k';'k'})
        set(P,{'LineWidth'},{1.5;1.5})   
        hold on
        plot(TmaxMonthAvg(:,1),TmaxMonthAvg(:,3:nsc+1));
        xlabel('Month','fontsize',10);
        ylabel('Monthly average Tmax (�C)','fontsize',10);
        axisy=ylim;
        axis([0,13,axisy(1,1),axisy(1,2)]);
        ax=gca;
        ax.XTick=1:12;
        

% 6.3 MEAN MONTHLY VALUE ALL (GREYSCALE)
%-------------------------------------------------------------------------
GreyCol='[0.6 0.6 0.6]';
colorstruct=cell(nsc-1,1);
for i=1:7
    colorstruct(i,1)={GreyCol};
end
for i=8:nsc-1
colorstruct(i,1)={'[1 0 0]'};
end

f8=figure('name','Monthly averages');
    subplot(2,2,1, 'fontsize',10);%Rain RCP8.5
        P=plot(RainMonthAvg(:,1),RainMonthAvg(:,3:nsc+1));
        set(P,{'Color'},colorstruct)
        hold on
        P=plot(RainMonthAvg(:,1),RainMonthAvg(:,2));
        set(P,{'LineStyle'},{'-'})
        set(P,{'Color'},{'k'})
        set(P,{'LineWidth'},{1.5})    
        xlabel('Month','fontsize',8);
        ylabel('Average Monthly Rain (mm)','fontsize',8);
        axis([1,12,0,150]);
        ax=gca;
        ax.XTick=1:12;
        set(gca,'box','off')

    subplot(2,2,2, 'fontsize',10);%ETo RCP8.5   
        P=plot(EToMonthAvg(:,1),EToMonthAvg(:,3:nsc+1));
        set(P,{'Color'},colorstruct)       
        hold on
        P=plot(EToMonthAvg(:,1),EToMonthAvg(:,2));
        set(P,{'LineStyle'},{'-'})
        set(P,{'Color'},{'k'})
        set(P,{'LineWidth'},{1.5}) 
        xlabel('Month','fontsize',8);
        ylabel('Average Monthly ETo (mm)','fontsize',8);
        axisy=ylim;
        axis([1,12,axisy(1,1),150]);
        ax=gca;
        ax.XTick=1:12;  
        set(gca,'box','off')
        
    subplot(2,2,3, 'fontsize',10);%Tmin RCP8.5
        P=plot(TminMonthAvg(:,1),TminMonthAvg(:,3:nsc+1));
        set(P,{'Color'},colorstruct)
        hold on
        P=plot(TminMonthAvg(:,1),TminMonthAvg(:,2));
        set(P,{'LineStyle'},{'-'})
        set(P,{'Color'},{'k'})
        set(P,{'LineWidth'},{1.5})      
        xlabel('Month','fontsize',8);
        ylabel('Monthly average Tmin (�C)','fontsize',8);
        axisy=ylim;
        axis([1,12,axisy(1,1),axisy(1,2)]);
        ax=gca;
        ax.XTick=1:12;
        set(gca,'box','off')       
        
    subplot(2,2,4, 'fontsize',10);%Tmax - RCP8.5
        P=plot(TmaxMonthAvg(:,1),TmaxMonthAvg(:,3:nsc+1));
        set(P,{'Color'},colorstruct)
        hold on 
        P=plot(TmaxMonthAvg(:,1),TmaxMonthAvg(:,2));
        set(P,{'LineStyle'},{'-'})
        set(P,{'Color'},{'k'})
        set(P,{'LineWidth'},{1.5})   
        xlabel('Month','fontsize',8);
        ylabel('Monthly average Tmax (�C)','fontsize',8);
        axisy=ylim;
        axis([1,12,axisy(1,1),30]);
        ax=gca;
        ax.XTick=1:12;
        set(gca,'box','off')        

% 6.4 MEDIAN MONTHLY VALUE ALL (GREYSCALE)
%-------------------------------------------------------------------------
GreyCol='[0.6 0.6 0.6]';
colorstruct=cell(nsc-1,1);
Line={'--',':','-.','-'};

linestruct=cell(nsc-1,1);
for i=1:7
    colorstruct(i,1)={GreyCol};
    linestruct(i,1)={'-'};
end
for i=8:nsc-1
colorstruct(i,1)={'[1 0 0]'};
linestruct(i,1)=Line(1,i-7);
end

f9=figure('name','Monthly medians');
    subplot(4,2,1, 'fontsize',10);%Rain RCP8.5
        P=plot(RainMonthMed(:,1),RainMonthMed(:,3:nsc+1));
        set(P,{'Color'},colorstruct)
        set(P,{'LineStyle'},linestruct)
        hold on
        P=plot(RainMonthMed(:,1),RainMonthMed(:,2));
        set(P,{'LineStyle'},{'-'})
        set(P,{'Color'},{'k'})
        set(P,{'LineWidth'},{1.5})    
        xlabel('Month','fontsize',8);
        ylabel('Median total rainfall (mm)','fontsize',8);
        axis([1,12,0,150]);
        ax=gca;
        ax.XTick=1:12;
        set(gca,'box','off')
        b=ylim;
        text(1.2,b(1,2)-10,'(a)','HorizontalAlignment','left')

    subplot(4,2,3, 'fontsize',10);%ETo RCP8.5   
        P=plot(EToMonthMed(:,1),EToMonthMed(:,3:nsc+1));
        set(P,{'Color'},colorstruct)       
        set(P,{'LineStyle'},linestruct)
        hold on
        P=plot(EToMonthMed(:,1),EToMonthMed(:,2));
        set(P,{'LineStyle'},{'-'})
        set(P,{'Color'},{'k'})
        set(P,{'LineWidth'},{1.5}) 
        xlabel('Month','fontsize',8);
        ylabel('Median total ET_{0} (mm)','fontsize',8);
        axisy=ylim;
        axis([1,12,axisy(1,1),150]);
        ax=gca;
        ax.XTick=1:12;  
        set(gca,'box','off')
        b=ylim;
        text(1.2,b(1,2)-10,'(b)','HorizontalAlignment','left')
        
    subplot(4,2,2, 'fontsize',10);%Tmin RCP8.5
        P=plot(TminMonthMed(:,1),TminMonthMed(:,3:nsc+1));
        set(P,{'Color'},colorstruct)
        set(P,{'LineStyle'},linestruct)
        hold on
        P=plot(TminMonthMed(:,1),TminMonthMed(:,2));
        set(P,{'LineStyle'},{'-'})
        set(P,{'Color'},{'k'})
        set(P,{'LineWidth'},{1.5})      
        xlabel('Month','fontsize',8);
        ylabel('Median average T_{min} (�C)','fontsize',8);
        axisy=ylim;
        axis([1,12,axisy(1,1),axisy(1,2)]);
        ax=gca;
        ax.XTick=1:12;
        set(gca,'box','off')       
        b=ylim;
        text(1.2,b(1,2)-1.5,'(d)','HorizontalAlignment','left')
        
    subplot(4,2,4, 'fontsize',10);%Tmax - RCP8.5
        P=plot(TmaxMonthMed(:,1),TmaxMonthMed(:,3:nsc+1));
        set(P,{'Color'},colorstruct)
        set(P,{'LineStyle'},linestruct)
        hold on 
        P=plot(TmaxMonthMed(:,1),TmaxMonthMed(:,2));
        set(P,{'LineStyle'},{'-'})
        set(P,{'Color'},{'k'})
        set(P,{'LineWidth'},{1.5})   
        xlabel('Month','fontsize',8);
        ylabel('Median average T_{max} (�C)','fontsize',8);
        axisy=ylim;
        axis([1,12,axisy(1,1),30]);
        ax=gca;
        ax.XTick=1:12;
        set(gca,'box','off')  
        b=ylim;
        text(1.2,b(1,2)-2,'(e)','HorizontalAlignment','left')
        
    subplot(4,2,5, 'fontsize',10);%Aridity - RCP8.5
        P=plot(AridityMonthMed(:,1),AridityMonthMed(:,3:nsc+1));
        set(P,{'Color'},colorstruct)
        set(P,{'LineStyle'},linestruct)
        hold on 
        P=plot(AridityMonthMed(:,1),AridityMonthMed(:,2));
        set(P,{'LineStyle'},{'-'})
        set(P,{'Color'},{'k'})
        set(P,{'LineWidth'},{1.5})   
        xlabel('Month','fontsize',8);
        ylabel('Median aridity index (-)','fontsize',8);
        axis([1,12,0,6]);
        ax=gca;
        ax.XTick=1:12;
        set(gca,'box','off')  
        b=ylim;
        text(1.1,b(1,2)-0.5,'(c)','HorizontalAlignment','left')
                
        %align_Ylabels(gcf)
        
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 7. SAVE OUTPUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         

% Define datapath to save figures & other output 
    DatapathOutput=uigetdir('C:\','Select directory to store output of climate scenario comparison');

% save publication figure (f9)
         fig=f9;
         fig.PaperUnits='centimeters';
         fig.PaperPosition=[0 0 16 20];
         fig.PaperSize=[16 20];
         %filename=fullfile(DatapathOutput,'WeatherGCM_600dpi');
         %filename2=fullfile(DatapathOutput,'WeatherGCM_300dpi');
         filename=fullfile(DatapathOutput,'WeatherSynth_600dpi');
         filename2=fullfile(DatapathOutput,'WeatherSynth_300dpi');         
         print(filename,'-dpdf','-r600')
         print(filename2,'-dpdf','-r300')     
    
    
% medians year/summer/winter
YearMedian=[EToStatsYear(3,:);RainStatsYear(3,:);AridityStatsYear(3,:);TminStatsYear(3,:);TmaxStatsYear(3,:)];
SummerMedian=[EToStatsSummer(3,:);RainStatsSummer(3,:);AridityStatsSummer(3,:);TminStatsSummer(3,:);TmaxStatsSummer(3,:)];    
WinterMedian=[EToStatsWinter(3,:);RainStatsWinter(3,:);AridityStatsWinter(3,:);TminStatsWinter(3,:);TmaxStatsWinter(3,:)];  
    
    
% save figures
filename='Yearly climate statistics';
filename=fullfile(DatapathOutput,filename);
savefig(f1,filename)         

filename='Winter climate statistics';
filename=fullfile(DatapathOutput,filename);
savefig(f2,filename)   

filename='Summer climate statistics';
filename=fullfile(DatapathOutput,filename);
savefig(f3,filename)   

% filename='Monthly ETo averages';
% filename=fullfile(DatapathOutput,filename);
% savefig(f4,filename)   
% 
% filename='Monthly Rainfall averages';
% filename=fullfile(DatapathOutput,filename);
% savefig(f5,filename)
% 
% filename='Monthly average Tmin';
% filename=fullfile(DatapathOutput,filename);
% savefig(f6,filename)   
% 
% filename='Monthly average Tmax';
% filename=fullfile(DatapathOutput,filename);
% savefig(f7,filename)

filename='Monthly averages clim par';
filename=fullfile(DatapathOutput,filename);
savefig(f8,filename)

filename='Monthly median clim par';
filename=fullfile(DatapathOutput,filename);
savefig(f9,filename)

clear f1 f2 f3 f4 f5 f6 f7 f8 f9

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 8. EXTRA: ANALYSE EARLY SPRING AVERAGE TEMPERATURE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Calculate average temperature 

TavgMat=(TminMat+TmaxMat)/2;

% Define early spring months
EarlySpringMonth=zeros(length(TimeHist),nsc);
SpringMonth=zeros(length(TimeHist),nsc);
SummerMonth=zeros(length(TimeHist),nsc);

TimeScen=repmat(TimeFut,1,nsc);
TimeScen(:,1)=TimeHist;

for i=1:nsc
    
    EarlySpringMonth(month(TimeScen(:,i))==2,i)=1;
    EarlySpringMonth(month(TimeScen(:,i))==3,i)=1;
    EarlySpringMonth(month(TimeScen(:,i))==4,i)=1;
    
    SpringMonth(month(TimeScen(:,i))==3,i)=1;
    SpringMonth(month(TimeScen(:,i))==4,i)=1;
    SpringMonth(month(TimeScen(:,i))==5,i)=1;  
    
    SummerMonth(month(TimeScen(:,i))==6,i)=1;
    SummerMonth(month(TimeScen(:,i))==7,i)=1;
    SummerMonth(month(TimeScen(:,i))==8,i)=1;     
    
end

EarlySpringMonth(EarlySpringMonth==0)=2;
SpringMonth(SpringMonth==0)=2;
SummerMonth(SummerMonth==0)=2;

% Calculate average over(early) spring or summer months 
T24Avg2=cell(1,nsc); % initialize variables
T35Avg2=cell(1,nsc);
T68Avg2=cell(1,nsc);

maxYear=max(year(TimeHist));
minYear=min(year(TimeHist));
nYear=(maxYear-minYear)+1;

T24Avg=NaN(nYear,nsc);
T35Avg=NaN(nYear,nsc);
T68Avg=NaN(nYear,nsc);

for i=1:nsc 
T24Avg2{1,i}=accumarray([year(TimeScen(:,1)),EarlySpringMonth(:,1)],TavgMat(:,i),[],@mean,NaN);
T35Avg2{1,i}=accumarray([year(TimeScen(:,1)),SpringMonth(:,1)],TavgMat(:,i),[],@mean,NaN);
T68Avg2{1,i}=accumarray([year(TimeScen(:,1)),SummerMonth(:,1)],TavgMat(:,i),[],@mean,NaN);
end

  for i=1:nsc        
      T24Avg(:,i)=T24Avg2{1,i}(minYear:maxYear,1);
      T35Avg(:,i)=T35Avg2{1,i}(minYear:maxYear,1);
      T68Avg(:,i)=T68Avg2{1,i}(minYear:maxYear,1);
  end
      
% Calculate average over all years
T24AvgStat=NaN(2,nsc); %initialize
T35AvgStat=NaN(2,nsc);
T68AvgStat=NaN(2,nsc);

T24AvgStatDelta=NaN(2,nsc);
T35AvgStatDelta=NaN(2,nsc);
T68AvgStatDelta=NaN(2,nsc);

T24AvgStat(1,1:nsc)=mean(T24Avg(:,1:nsc));
T24AvgStat(2,1:nsc)=median(T24Avg(:,1:nsc));

T35AvgStat(1,1:nsc)=mean(T35Avg(:,1:nsc));
T35AvgStat(2,1:nsc)=median(T35Avg(:,1:nsc));

T68AvgStat(1,1:nsc)=mean(T68Avg(:,1:nsc));
T68AvgStat(2,1:nsc)=median(T68Avg(:,1:nsc));

for i=1:2
T24AvgStatDelta(i,1:nsc)=T24AvgStat(i,1:nsc)-T24AvgStat(i,1);
T35AvgStatDelta(i,1:nsc)=T35AvgStat(i,1:nsc)-T35AvgStat(i,1);
T68AvgStatDelta(i,1:nsc)=T68AvgStat(i,1:nsc)-T68AvgStat(i,1);
end

% calculate how much sowing date would change (see literature)
SowingDateChange(1,1:3)={'Maize','Sugarbeet','Forest'};
SowingDateChange(2,1)={T24AvgStatDelta(1,1:nsc)*3.5};
SowingDateChange(2,2)={T24AvgStatDelta(1,1:nsc)*3.3};
SowingDateChange(2,3)={T24AvgStatDelta(1,1:nsc)*6.6};

SowingDateChange(3,1)={mean(SowingDateChange{2,1}(1,2:nsc))};
SowingDateChange(3,2)={mean(SowingDateChange{2,2}(1,2:nsc))};
SowingDateChange(3,3)={mean(SowingDateChange{2,3}(1,2:nsc))};

clear i T24Avg2 T35Avg2 T68Avg2 maxYear minYear SpringMonth 
