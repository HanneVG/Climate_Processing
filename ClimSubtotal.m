%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script calculates 10-daily, monthly, seasonal and yearly subtotals 
% of series of climatic data
%
% Author: Hanne Van Gaelen
% Last Update: 08/12/2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function[YearTot,MonthTot,DecadeTot,SeasonTot,YMonthTot,YMDecadeTot,YSeasonTot]=ClimSubtotal(Dates,DailyValues,fun)

% 1. PREPARATION
% -------------------------------------------------------------------------
[~,nseries]=size(DailyValues);
[nTime,~]=size(Dates);

% Determine decades (10-daily period)
    Decade=NaN(nTime,1);
    for i=1:nTime;
        if day(Dates(i,1))/10<=1
            Decade(i,1)=1;
        elseif day(Dates(i,1))/10<=2
            Decade(i,1)=2;
        else
            Decade(i,1)=3;
        end
    end
 
% Determine the season (1=winter, 2=spring, 3= summer, 4=fall)   
    Season=NaN(nTime,1);
    doy=(datenum(Dates) - datenum(year(Dates),1,1)) + 1;
    
    for i=1:nTime;
        if leapyear(year(Dates(i,1)))==0 % no leapyear
            if doy(i,1)<80      % doy 80=21/3
                Season(i,1)=1;
            elseif doy(i,1)<172 % doy 172=21/6
                Season(i,1)=2;
            elseif doy(i,1)<264 % doy 264=21/9
                Season(i,1)=3;
            elseif doy (i,1)<355 % doy 255=21/12
                Season(i,1)=4;
            elseif doy(i,1)<=365
                Season(i,1)=1;
            end
        elseif leapyear(year(Dates(i,1)))==1 % leapyear
             if doy(i,1)<81      % doy 80=21/3
                Season(i,1)=1;
            elseif doy(i,1)<173 % doy 172=21/6
                Season(i,1)=2;
            elseif doy(i,1)<265 % doy 264=21/9
                Season(i,1)=3;
            elseif doy (i,1)<356 % doy 255=21/12
                Season(i,1)=4;
            elseif doy(i,1)<=366
                Season(i,1)=1;
            end             
        end    
     end

% 2. CALCULATION
% -------------------------------------------------------------------------    
if strcmp(fun,'sum')==1 % Calculate subtotals
     for i=1:nseries %loop trough all series
         % Yearly subtotals
             YearTot{i}=accumarray(year(Dates),DailyValues(:,i),[],@sum,NaN);

         % Monthly subtotals
             MonthTot{i}=accumarray(month(Dates),DailyValues(:,i),[],@sum,NaN);
         
        % Decade subtotals
             DecadeTot{i}=accumarray(Decade,DailyValues(:,i),[],@sum,NaN);
         
        % Season subtotals
             SeasonTot{i}=accumarray(Season,DailyValues(:,i),[],@sum,NaN);
            
         % Monthly subtotals for each year 
             YMonthTot{i}=accumarray([year(Dates),month(Dates)],DailyValues(:,i),[],@sum,NaN);

         % 10-daily subtotals for each month & year 
             YMDecadeTot{i}=accumarray([year(Dates),month(Dates), Decade],DailyValues(:,i),[],@sum,NaN);
             
         % Season subtotals for each year 
             YSeasonTot{i}=accumarray([year(Dates),Season],DailyValues(:,i),[],@sum,NaN);

     end

elseif strcmp(fun,'mean')==1% Calculate average
     for i=1:nseries %loop trough all series
         % Yearly average
             YearTot{i}=accumarray(year(Dates),DailyValues(:,i),[],@mean,NaN);

         % Monthly subtotals
             MonthTot{i}=accumarray(month(Dates),DailyValues(:,i),[],@mean,NaN);
         
         % Decade subtotals
             DecadeTot{i}=accumarray(Decade,DailyValues(:,i),[],@mean,NaN);
         
         % Season subtotals
             SeasonTot{i}=accumarray(Season,DailyValues(:,i),[],@mean,NaN);

         % Monthly average for each year 
             YMonthTot{i}=accumarray([year(Dates),month(Dates)],DailyValues(:,i),[],@mean,NaN);

         % 10-daily average for each month & year
             YMDecadeTot{i}=accumarray([year(Dates),month(Dates), Decade],DailyValues(:,i),[],@mean,NaN);
             
         % Season average for each year 
             YSeasonTot{i}=accumarray([year(Dates),Season],DailyValues(:,i),[],@mean,NaN);
     end
else
    error('Subtotal function not recognized')
end

% 2. CLEAN UP RESULT MATRIX
% -------------------------------------------------------------------------     

% 2.1 FOR ALL 
% Determine position of results
    minMonth=month(Dates(1,1));
    minYear=year(Dates(1,1));
    minDecade=Decade(1,1);
    minSeason=Season(1,1);
    maxYear=year(Dates(nTime,1));
    nYear=(maxYear-minYear)+1;

% Remove years that are not in timeseries
   for i=1:nseries % loop trough all series and remove empty years
      YearTot{1,i}=YearTot{1,i}(minYear:maxYear,:);
      YMonthTot{1,i}=YMonthTot{1,i}(minYear:maxYear,:);
      YMDecadeTot{1,i}=YMDecadeTot{1,i}(minYear:maxYear,:,:);
      YSeasonTot{1,i}=YSeasonTot{1,i}(minYear:maxYear,:);
   end

% 2.2 FOR YEARLY/MONTHLY/DECADE/SEASONAL VALUES 

   for i=1:nseries % loop trough all series and add year numbers 
     YearTot{1,i}(:,2)= YearTot{1,i}(:,1);
     YearTot{1,i}(:,1)= minYear:maxYear; 

     MonthTot{1,i}(:,2)= MonthTot{1,i}(:,1);
     MonthTot{1,i}(:,1)= 1:12; 

     DecadeTot{1,i}(:,2)= DecadeTot{1,i}(:,1);
     DecadeTot{1,i}(:,1)= 1:3; 

     SeasonTot{1,i}(:,2)= SeasonTot{1,i}(:,1);
     SeasonTot{1,i}(:,1)= 1:4; 

   end
  
% 2.3 FOR MONTHLY VALUES PER YEAR  
  
  % Put data in one column for monthly totals
  for i=1:nseries % loop trough all series
      
      j=1;% first year (maybe not all months complete)
      startindex=1;
      YMonthTot2{1,i}(1:startindex+((12-minMonth)),1)=minYear;% Write year
      YMonthTot2{1,i}(1:startindex+((12-minMonth)),2)=minMonth:12;% Write month
      YMonthTot2{1,i}(1:startindex+((12-minMonth)),3)=YMonthTot{1,i}(j,minMonth:12);% Read all months of first year and write them away
      startindex=startindex+((12-minMonth)+1);
      
      for j=2:nYear % loop trough all other years
            YMonthTot2{1,i}(startindex:startindex+11,1)=(minYear+j)-1;% Write year
            YMonthTot2{1,i}(startindex:startindex+11,2)=1:12;% Write month
            YMonthTot2{1,i}(startindex:startindex+11,3)=YMonthTot{1,i}(j,1:12);% Read all 12 months of year j and writes them away
            startindex=startindex+12;
      end   
  end
  YMonthTot=YMonthTot2;
  clear YMonthTot2 startindex j i 

% 2.4 FOR DECADE VALUES PER MONTH AND PER YEAR
     % Put data in one column for 10-daily data
    for i=1:nseries % loop trough the 11 variabelen
      
      j=1;% first year (maybe not all months complete)
      startindex=1;
      YMDecadeTot2{1,i}(1:startindex+((12-minMonth)),1,1:3)=minYear;% Write year
      YMDecadeTot2{1,i}(1:startindex+((12-minMonth)),2,1:3)=[minMonth:12;minMonth:12;minMonth:12].';% Write month
      YMDecadeTot2{1,i}(1:startindex+((12-minMonth)),3,1:3)=YMDecadeTot{1,i}(j,minMonth:12,1:3);% Read all months of first year and writes 3 corresponding decades
      startindex=startindex+((12-minMonth)+1);
      
      for j=2:nYear % loop trough all other years
            YMDecadeTot2{1,i}(startindex:startindex+11,1,1:3)=(minYear+j)-1;% Write year
            YMDecadeTot2{1,i}(startindex:startindex+11,2,1:3)=[1:12;1:12;1:12].';% Write month
            YMDecadeTot2{1,i}(startindex:startindex+11,3,1:3)=YMDecadeTot{1,i}(j,1:12,1:3);% Read all 12 months of year j and writes 3 corresponding decades
            startindex=startindex+12;
      end

      %loop trough all year-month combinations
      a=size(YMDecadeTot2{1,1});%Determine number of months
      nm=a(1,1);
      	m=1;% first month (maybe not all three decades complete)
             startindex=1;
             YMDecadeTot3{1,i}(1:startindex+2,1)=YMDecadeTot2{1,i}(m,1);% Write year
             YMDecadeTot3{1,i}(1:startindex+2,2)=YMDecadeTot2{1,i}(m,2);% Write month n
             YMDecadeTot3{1,i}(1:startindex+2,3)=minDecade:3;% Write decade numbers
             YMDecadeTot3{1,i}(1:startindex+2,4)=YMDecadeTot2{1,i}(m,3,1:3); % Write data of the decades
             startindex=startindex+((3-minDecade)+1);
          for m=2:nm % for all other months            
             YMDecadeTot3{1,i}(startindex:startindex+2,1)=YMDecadeTot2{1,i}(m,1);% Write year
             YMDecadeTot3{1,i}(startindex:startindex+2,2)=YMDecadeTot2{1,i}(m,2);% Write month
             YMDecadeTot3{1,i}(startindex:startindex+2,3)=1:3;% Write decade numbers
             YMDecadeTot3{1,i}(startindex:startindex+2,4)=YMDecadeTot2{1,i}(m,3,1:3);% Write data of the 3 decades 
             startindex=startindex+3;% go to next three decades
          end      
   end
   YMYMDecadeTot=YMDecadeTot3;
   clear YMDecadeTot2 YMDecadeTot3 startindex i nm m 

% 2.4 FOR SEASON VALUES PER YEAR
  
  % Put data in one column for season totals
  for i=1:nseries % loop trough all series
      
      j=1;% first year (maybe not all seasons complete)
      startindex=1;
      YSeasonTot2{1,i}(1:startindex+((4-minSeason)),1)=minYear;% Write year
      YSeasonTot2{1,i}(1:startindex+((4-minSeason)),2)=minSeason:4;% Write season
      YSeasonTot2{1,i}(1:startindex+((4-minSeason)),3)=YSeasonTot{1,i}(j,minSeason:4);% Read all seasons of first year and write them away
      startindex=startindex+((4-minSeason)+1);
      
      for j=2:nYear % loop trough all other years
            YSeasonTot2{1,i}(startindex:startindex+3,1)=(minYear+j)-1;% Write year
            YSeasonTot2{1,i}(startindex:startindex+3,2)=1:4;% Write season
            YSeasonTot2{1,i}(startindex:startindex+3,3)=YSeasonTot{1,i}(j,1:4);% Read all 4 seasons of year j and writes them away
            startindex=startindex+4;
      end   
  end
  YSeasonTot=YSeasonTot2;
  clear YSeasonTot2 startindex j i 
end


 


  
  

 