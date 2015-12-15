%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script reads historical climate data as well as future climate
% data (as generated by the pertubation tool), 
% and analyses & vizualizes climate characteristics
%
%
% Author: Hanne Van Gaelen
% Last Update: 11/12/2015
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

AridityYearTot(:,2:nscen+1)= RainYearTot(:,2:nscen+1)./EToYearTot(:,2:nscen+1); % calculate aridity
AridityMonthTot(:,3:nscen+2)= RainMonthTot(:,3:nscen+2)./EToMonthTot(:,3:nscen+2);
AriditySeasonTot(:,3:nscen+2)=  RainSeasonTot(:,3:nscen+2)./EToSeasonTot(:,3:nscen+2); 
    
% mean monthy values over all years
EToMonthAvg(1:12,1)=1:12;
RainMonthAvg(1:12,1)=1:12;
TminMonthAvg(1:12,1)=1:12;
TmaxMonthAvg(1:12,1)=1:12;

EToMonthMed(1:12,1)=1:12;
RainMonthMed(1:12,1)=1:12;
TminMonthMed(1:12,1)=1:12;
TmaxMonthmed(1:12,1)=1:12;

for m=1:12 % loop trough all months
    EToM=EToMonthTot(EToMonthTot(:,2)==m,:);
    RainM=RainMonthTot(RainMonthTot(:,2)==m,:);
    TminM=TminMonthTot(TminMonthTot(:,2)==m,:);
    TmaxM=TmaxMonthTot(TmaxMonthTot(:,2)==m,:);
    
    EToMonthAvg(m,2:nscen+1)=mean(EToM(:,3:nscen+2));
    RainMonthAvg(m,2:nscen+1)=mean(RainM(:,3:nscen+2));
    TminMonthAvg(m,2:nscen+1)=mean(TminM(:,3:nscen+2));
    TmaxMonthAvg(m,2:nscen+1)=mean(TmaxM(:,3:nscen+2));
    
    EToMonthMed(m,2:nscen+1)=median(EToM(:,3:nscen+2));
    RainMonthMed(m,2:nscen+1)=median(RainM(:,3:nscen+2));
    TminMonthMed(m,2:nscen+1)=median(TminM(:,3:nscen+2));
    TmaxMonthMed(m,2:nscen+1)=median(TmaxM(:,3:nscen+2));
    
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
EToStatsYear(1,1:nscen)=mean(EToYearTot(:,2:nscen+1));
RainStatsYear(1,1:nscen)=mean(RainYearTot(:,2:nscen+1));
TminStatsYear(1,1:nscen)=mean(TminYearTot(:,2:nscen+1));
TmaxStatsYear(1,1:nscen)=mean(TmaxYearTot(:,2:nscen+1));
AridityStatsYear(1,1:nscen)=mean(AridityYearTot(:,2:nscen+1));

EToStatsYear(2,1:nscen)=std(EToYearTot(:,2:nscen+1));
RainStatsYear(2,1:nscen)=std(RainYearTot(:,2:nscen+1));
TminStatsYear(2,1:nscen)=std(TminYearTot(:,2:nscen+1));
TmaxStatsYear(2,1:nscen)=std(TmaxYearTot(:,2:nscen+1));
AridityStatsYear(2,1:nscen)=std(AridityYearTot(:,2:nscen+1));

EToStatsYear(3,1:nscen)=median(EToYearTot(:,2:nscen+1));
RainStatsYear(3,1:nscen)=median(RainYearTot(:,2:nscen+1));
TminStatsYear(3,1:nscen)=median(TminYearTot(:,2:nscen+1));
TmaxStatsYear(3,1:nscen)=median(TmaxYearTot(:,2:nscen+1));
AridityStatsYear(3,1:nscen)=median(AridityYearTot(:,2:nscen+1));

EToStatsYear(4,1:nscen)=min(EToYearTot(:,2:nscen+1));
RainStatsYear(4,1:nscen)=min(RainYearTot(:,2:nscen+1));
TminStatsYear(4,1:nscen)=min(TminYearTot(:,2:nscen+1));
TmaxStatsYear(4,1:nscen)=min(TmaxYearTot(:,2:nscen+1));
AridityStatsYear(4,1:nscen)=min(AridityYearTot(:,2:nscen+1));

EToStatsYear(5,1:nscen)=max(EToYearTot(:,2:nscen+1));
RainStatsYear(5,1:nscen)=max(RainYearTot(:,2:nscen+1));
TminStatsYear(5,1:nscen)=max(TminYearTot(:,2:nscen+1));
TmaxStatsYear(5,1:nscen)=max(TmaxYearTot(:,2:nscen+1));
AridityStatsYear(5,1:nscen)=min(AridityYearTot(:,2:nscen+1));

%VIZUALIZE
figure('name','Yearly statistics')
    subplot(5,1,1, 'fontsize',10);%ETo
        boxplot(EToYearTot(:,2:nscen+1),'labels',NameMat)
        ylabel('Annual ETo (mm/year)')
        title('Yearly statistics')
    subplot(5,1,2, 'fontsize',10);%Rainfall
        boxplot(RainYearTot(:,2:nscen+1),'labels',NameMat)
        ylabel('Annual rainfall (mm/year)')
    subplot(5,1,3, 'fontsize',10);%Aridity
        boxplot(AridityYearTot(:,2:nscen+1),'labels',NameMat)
        ylabel('Annual aridity (mm/mm)')
    subplot(5,1,4, 'fontsize',10);%Tmin
        boxplot(TminYearTot(:,2:nscen+1),'labels',NameMat)
        ylabel('Yearly average of Tmin (�C)')
    subplot(5,1,5, 'fontsize',10);%Tmax
        boxplot(TmaxYearTot(:,2:nscen+1),'labels',NameMat)
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

EToStatsWinter(1,1:nscen)=mean(EToWinter(:,3:nscen+2)); % calculate stats
RainStatsWinter(1,1:nscen)=mean(RainWinter(:,3:nscen+2));
TminStatsWinter(1,1:nscen)=mean(TminWinter(:,3:nscen+2));
TmaxStatsWinter(1,1:nscen)=mean(TmaxWinter(:,3:nscen+2));
AridityStatsWinter(1,1:nscen)=mean(AridityWinter(:,3:nscen+2));

EToStatsWinter(2,1:nscen)=std(EToWinter(:,3:nscen+2));
RainStatsWinter(2,1:nscen)=std(RainWinter(:,3:nscen+2));
TminStatsWinter(2,1:nscen)=std(TminWinter(:,3:nscen+2));
TmaxStatsWinter(2,1:nscen)=std(TmaxWinter(:,3:nscen+2));
AridityStatsWinter(2,1:nscen)=std(AridityWinter(:,3:nscen+2));

EToStatsWinter(3,1:nscen)=median(EToWinter(:,3:nscen+2));
RainStatsWinter(3,1:nscen)=median(RainWinter(:,3:nscen+2));
TminStatsWinter(3,1:nscen)=median(TminWinter(:,3:nscen+2));
TmaxStatsWinter(3,1:nscen)=median(TmaxWinter(:,3:nscen+2));
AridityStatsWinter(3,1:nscen)=median(AridityWinter(:,3:nscen+2));

EToStatsWinter(4,1:nscen)=min(EToWinter(:,3:nscen+2));
RainStatsWinter(4,1:nscen)=min(RainWinter(:,3:nscen+2));
TminStatsWinter(4,1:nscen)=min(TminWinter(:,3:nscen+2));
TmaxStatsWinter(4,1:nscen)=min(TmaxWinter(:,3:nscen+2));
AridityStatsWinter(4,1:nscen)=min(AridityWinter(:,3:nscen+2));

EToStatsWinter(5,1:nscen)=max(EToWinter(:,3:nscen+2));
RainStatsWinter(5,1:nscen)=max(RainWinter(:,3:nscen+2));
TminStatsWinter(5,1:nscen)=max(TminWinter(:,3:nscen+2));
TmaxStatsWinter(5,1:nscen)=max(TmaxWinter(:,3:nscen+2));
AridityStatsWinter(5,1:nscen)=max(AridityWinter(:,3:nscen+2));

% VIZUALIZE
figure('name','Winter statistics')
    subplot(5,1,1, 'fontsize',10);%ETo
        boxplot(EToWinter(:,3:nscen+2),'labels',NameMat)
        ylabel('Seasonal ETo (mm/season)')
        title('Winter statistics')
    subplot(5,1,2, 'fontsize',10);%Rainfall
        boxplot(RainWinter(:,3:nscen+2),'labels',NameMat)
        ylabel('Seasonal rainfall (mm/season)')
    subplot(5,1,3, 'fontsize',10);% Aridity 
        boxplot(AridityWinter(:,3:nscen+2),'labels',NameMat)
        ylabel('Seasonal aridity (mm/mm)')
    subplot(5,1,4, 'fontsize',10);%Tmin
        boxplot(TminWinter(:,3:nscen+2),'labels',NameMat)
        ylabel('Seasonal average of Tmin (�C)')
    subplot(5,1,5, 'fontsize',10);%Tmax
        boxplot(TmaxWinter(:,3:nscen+2),'labels',NameMat)
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

EToStatsSummer(1,1:nscen)=mean(EToSummer(:,3:nscen+2)); % calculate stats
RainStatsSummer(1,1:nscen)=mean(RainSummer(:,3:nscen+2));
TminStatsSummer(1,1:nscen)=mean(TminSummer(:,3:nscen+2));
TmaxStatsSummer(1,1:nscen)=mean(TmaxSummer(:,3:nscen+2));
AridityStatsSummer(1,1:nscen)=mean(AriditySummer(:,3:nscen+2));

EToStatsSummer(2,1:nscen)=std(EToSummer(:,3:nscen+2));
RainStatsSummer(2,1:nscen)=std(RainSummer(:,3:nscen+2));
TminStatsSummer(2,1:nscen)=std(TminSummer(:,3:nscen+2));
TmaxStatsSummer(2,1:nscen)=std(TmaxSummer(:,3:nscen+2));
AridityStatsSummer(2,1:nscen)=std(AriditySummer(:,3:nscen+2));

EToStatsSummer(3,1:nscen)=median(EToSummer(:,3:nscen+2));
RainStatsSummer(3,1:nscen)=median(RainSummer(:,3:nscen+2));
TminStatsSummer(3,1:nscen)=median(TminSummer(:,3:nscen+2));
TmaxStatsSummer(3,1:nscen)=median(TmaxSummer(:,3:nscen+2));
AridityStatsSummer(3,1:nscen)=median(AriditySummer(:,3:nscen+2));

EToStatsSummer(4,1:nscen)=min(EToSummer(:,3:nscen+2));
RainStatsSummer(4,1:nscen)=min(RainSummer(:,3:nscen+2));
TminStatsSummer(4,1:nscen)=min(TminSummer(:,3:nscen+2));
TmaxStatsSummer(4,1:nscen)=min(TmaxSummer(:,3:nscen+2));
AridityStatsSummer(4,1:nscen)=min(AriditySummer(:,3:nscen+2));

EToStatsSummer(5,1:nscen)=max(EToSummer(:,3:nscen+2));
RainStatsSummer(5,1:nscen)=max(RainSummer(:,3:nscen+2));
TminStatsSummer(5,1:nscen)=max(TminSummer(:,3:nscen+2));
TmaxStatsSummer(5,1:nscen)=max(TmaxSummer(:,3:nscen+2));
AridityStatsSummer(5,1:nscen)=max(AriditySummer(:,3:nscen+2));

% VIZUALIZE
f=figure('name','Summer statistics')
    subplot(5,1,1, 'fontsize',10);%ETo
        boxplot(EToSummer(:,3:nscen+2),'labels',NameMat)
        ylabel('Seasonal ETo (mm/season)')
        title('Summer statistics')
    subplot(5,1,2, 'fontsize',10);%Rainfall
        boxplot(RainSummer(:,3:nscen+2),'labels',NameMat)
        ylabel('Seasonal rainfall (mm/season)')
    subplot(5,1,3, 'fontsize',10);%Aridity
        boxplot(AriditySummer(:,3:nscen+2),'labels',NameMat)
        ylabel('Seasonal aridity (mm/mm)')
    subplot(5,1,4, 'fontsize',10);%Tmin
        boxplot(TminSummer(:,3:nscen+2),'labels',NameMat)
        ylabel('Seasonal average of Tmin (�C)')
    subplot(5,1,5, 'fontsize',10);%Tmax
        boxplot(TmaxSummer(:,3:nscen+2),'labels',NameMat)
        xlabel('Climate Scenario')
        ylabel('Seasonal average of Tmax (�C)')
    annotation(f,'line',[0.18 0.18],[0.91 0.10])

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 6. ANALYZE MEANS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 6.1 MEAN CHANGES
%-------------------------------------------------------------------------
MeanYear=[EToStatsYear(1,:);RainStatsYear(1,:);AridityStatsYear(1,:);TminStatsYear(1,:);TmaxStatsYear(1,:)];
MeanSummer=[EToStatsSummer(1,:);RainStatsSummer(1,:);AridityStatsSummer(1,:);TminStatsSummer(1,:);TmaxStatsSummer(1,:)];
MeanWinter=[EToStatsWinter(1,:);RainStatsWinter(1,:);AridityStatsWinter(1,:);TminStatsWinter(1,:);TmaxStatsWinter(1,:)];

for i=1:nscen
    MeanChangeYear(:,i)=MeanYear(:,i)-MeanYear(:,1);
    MeanChangeSummer(:,i)=MeanSummer(:,i)-MeanSummer(:,1);
    MeanChangeWinter(:,i)=MeanWinter(:,i)-MeanWinter(:,1);
end

% 6.1 MEAN MONTHLY VALUE
%-------------------------------------------------------------------------
figure('name','Monthly ETo averages')
    subplot(2,1,1, 'fontsize',10);%RCP8.5
        P=plot(EToMonthAvg(:,1),EToMonthAvg(:,2),EToMonthAvg(:,1),EToMonthMed(:,2));
        set(P,{'LineStyle'},{'-';'--'})
        set(P,{'Color'},{'k';'k'})
        set(P,{'LineWidth'},{1.5;1.5}) 
        hold on
        plot(EToMonthAvg(:,1),EToMonthAvg(:,3:11));
        xlabel('Month','fontsize',10);
        ylabel('Average Monthly ETo (mm)','fontsize',10);
        axisy=ylim;
        axis([0,13,axisy(1,1),axisy(1,2)]);
        ax=gca;
        ax.XTick=1:12;
        title('RCP 8.5');
    subplot(2,1,2, 'fontsize',10);%RCP4.5
        P=plot(EToMonthAvg(:,1),EToMonthAvg(:,2),EToMonthAvg(:,1),EToMonthMed(:,2));
        set(P,{'LineStyle'},{'-';'--'})
        set(P,{'Color'},{'k';'k'})
        set(P,{'LineWidth'},{1.5;1.5})   
        hold on
        plot(EToMonthAvg(:,1),EToMonthAvg(:,12:nscen+1));
        xlabel('Month','fontsize',10);
        ylabel('Average Monthly ETo (mm)','fontsize',10);
        axisy=ylim;
        axis([0,13,axisy(1,1),axisy(1,2)]);
        ax=gca;
        ax.XTick=1:12;
        title('RCP 4.5');        

figure('name','Monthly Rainfall averages')
    subplot(2,1,1, 'fontsize',10);%RCP8.5
        P=plot(RainMonthAvg(:,1),RainMonthAvg(:,2),RainMonthAvg(:,1),RainMonthMed(:,2));
        set(P,{'LineStyle'},{'-';'--'})
        set(P,{'Color'},{'k';'k'})
        set(P,{'LineWidth'},{1.5;1.5})    
        hold on
        plot(RainMonthAvg(:,1),RainMonthAvg(:,3:11));
        xlabel('Month','fontsize',10);
        ylabel('Average Monthly Rain (mm)','fontsize',10);
        axisy=ylim;
        axis([0,13,axisy(1,1),axisy(1,2)]);
        ax=gca;
        ax.XTick=1:12;
        title('RCP 8.5');
    subplot(2,1,2, 'fontsize',10);%RCP4.5
        P=plot(RainMonthAvg(:,1),RainMonthAvg(:,2),RainMonthAvg(:,1),RainMonthMed(:,2));
        set(P,{'LineStyle'},{'-';'--'})
        set(P,{'Color'},{'k';'k'})
        set(P,{'LineWidth'},{1.5;1.5})   
        hold on
        plot(RainMonthAvg(:,1),RainMonthAvg(:,12:nscen+1));
        xlabel('Month','fontsize',10);
        ylabel('Average Monthly Rain (mm)','fontsize',10);
        axisy=ylim;
        axis([0,13,axisy(1,1),axisy(1,2)]);
        ax=gca;
        ax.XTick=1:12;
        title('RCP 4.5');     
       
 figure('name','Monthly average Tmin')
    subplot(2,1,1, 'fontsize',10);%RCP8.5
        P=plot(TminMonthAvg(:,1),TminMonthAvg(:,2),TminMonthAvg(:,1),TminMonthMed(:,2));
        set(P,{'LineStyle'},{'-';'--'})
        set(P,{'Color'},{'k';'k'})
        set(P,{'LineWidth'},{1.5;1.5})      
        hold on
        plot(TminMonthAvg(:,1),TminMonthAvg(:,3:11));
        xlabel('Month','fontsize',10);
        ylabel('Monthly average Tmin (�C)','fontsize',10);
        axisy=ylim;
        axis([0,13,axisy(1,1),axisy(1,2)]);
        ax=gca;
        ax.XTick=1:12;
        title('RCP 8.5');
    subplot(2,1,2, 'fontsize',10);%RCP4.5
        P=plot(TminMonthAvg(:,1),TminMonthAvg(:,2),TminMonthAvg(:,1),TminMonthMed(:,2));
        set(P,{'LineStyle'},{'-';'--'})
        set(P,{'Color'},{'k';'k'})
        set(P,{'LineWidth'},{1.5;1.5})     
        hold on
        plot(TminMonthAvg(:,1),TminMonthAvg(:,12:nscen+1));
        xlabel('Month','fontsize',10);
        ylabel('Monthly average Tmin (�C)','fontsize',10);
        axisy=ylim;
        axis([0,13,axisy(1,1),axisy(1,2)]);
        ax=gca;
        ax.XTick=1:12;
        title('RCP 4.5');        

figure('name','Monthly average Tmax')
    subplot(2,1,1, 'fontsize',10);%RCP8.5
        P=plot(TmaxMonthAvg(:,1),TmaxMonthAvg(:,2),TmaxMonthAvg(:,1),TmaxMonthMed(:,2));
        set(P,{'LineStyle'},{'-';'--'})
        set(P,{'Color'},{'k';'k'})
        set(P,{'LineWidth'},{1.5;1.5})   
        hold on
        plot(TmaxMonthAvg(:,1),TmaxMonthAvg(:,3:11));
        xlabel('Month','fontsize',10);
        ylabel('Monthly average Tmax (�C)','fontsize',10);
        axisy=ylim;
        axis([0,13,axisy(1,1),axisy(1,2)]);
        ax=gca;
        ax.XTick=1:12;
        title('RCP 8.5');
    subplot(2,1,2, 'fontsize',10);%RCP4.5
        P=plot(TmaxMonthAvg(:,1),TmaxMonthAvg(:,2),TmaxMonthAvg(:,1),TmaxMonthMed(:,2));
        set(P,{'LineStyle'},{'-';'--'})
        set(P,{'Color'},{'k';'k'})
        set(P,{'LineWidth'},{1.5;1.5})      
        hold on
        plot(TmaxMonthAvg(:,1),TmaxMonthAvg(:,12:nscen+1));
        xlabel('Month','fontsize',10);
        ylabel('Monthly average Tmax (�C)','fontsize',10);
        axisy=ylim;
        axis([0,13,axisy(1,1),axisy(1,2)]);
        ax=gca;
        ax.XTick=1:12;
        title('RCP 4.5');          
