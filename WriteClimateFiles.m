%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script reads data generated by the climate perturbation tools, and
% writes it to txt files that can be used as drafts for AquaCrop input files
%
%
% Author: Hanne Van Gaelen
% Last Update: 08/12/2015
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. DEFINE DATAPATH 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% specify in which path all perturbed climate files are stored
DatapathIn=uigetdir('C:\','Select directory with perturbed climate series');

% specify the path with the excelfile where output should be stored
DatapathOut=uigetdir('C:\','Select directory to store excel output file of generated climate');

% specify the path where the draft AquaCrop text files should be stored
DatapathOut2=uigetdir('C:\','Select directory to store AquaCrop files of generated climate');


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. READ IN CLIMATE FILES  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[EToAll,RainfallAll,TminAll,TmaxAll,nfile]= ReadPertSeries(DatapathIn);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. WRITE MATRIXES TO EXCEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

EToMat=cell2mat(EToAll(3,:));
RainfallMat=cell2mat(RainfallAll(3,:));
TminMat=cell2mat(TminAll(3,:));
TmaxMat=cell2mat(TmaxAll(3,:));

name='All clim.xlsx';
filename = fullfile(DatapathOut, name);

xlswrite(filename,EToMat,'Fut_ETo','E7');
xlswrite(filename,RainfallMat,'Fut_Rainfall','E7');
xlswrite(filename,TminMat,'Fut_Tmin','E7');
xlswrite(filename,TmaxMat,'Fut_Tmax','E7');

clear name filename

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. WRITE DATA TO AquaCrop Files (without headers)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for futnumb=1:nfile % loop over all climates

% ET0 file
%-------------------------------------------------------------------------- 
    filename=['Plankbeek_Fut',num2str(futnumb),'.ETO'];
    filenamefullOut=fullfile(DatapathOut2, filename); % create empty textfile and open it
    fid = fopen(filenamefullOut,'w');
    fprintf(fid,'%.3f\r\n',EToMat(:,futnumb));%print results in this file
    fclose(fid);    
    
% Rainfall file
%--------------------------------------------------------------------------    
    filename=['Plankbeek_Fut',num2str(futnumb),'.PLU'];
    filenamefullOut=fullfile(DatapathOut2, filename); % create empty textfile and open it
    fid = fopen(filenamefullOut,'w');
    fprintf(fid,'%.3f\r\n',RainfallMat(:,futnumb));%print results in this file
    fclose(fid);      
    
% Temperature file
%--------------------------------------------------------------------------       
    TempMat=[TminMat(:,futnumb),TmaxMat(:,futnumb)];
    
    filename=['Plankbeek_Fut',num2str(futnumb),'.TMP'];
    filenamefullOut=fullfile(DatapathOut2, filename); % create empty textfile and open it
    dlmwrite(filenamefullOut,TempMat,'precision','%12.3f' ,'delimiter',' ','newline','pc')   
    
% Txtfile with temperatures (to calculate maturity data with CalcDate
% script'
%--------------------------------------------------------------------------     
    filename=['Fut',num2str(futnumb),'Temp.txt'];
    filenamefullOut=fullfile(DatapathOut2, filename); % create empty textfile and open it
    dlmwrite(filenamefullOut,TempMat,'precision','%12.3f' ,'delimiter',' ','newline','pc')  
    
clear TempMat
    
end