
function[EToAll,RainfallAll,TminAll,TmaxAll,nfile]= ReadPertSeries()

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. DEFINE DATAPATH 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% specify in which path all perturbed climate files are stored
Datapath=uigetdir('C:\','Select directory with perturbed climate series');


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. READ ALL FILES & WRITE DATA IN A STRUCTURE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% 2.1 Read ET0 files
%--------------------------------------------------------------------------

%Define which type of files should be read (* is wild character)
Datafile=dir(fullfile(Datapath,'ETo*.txt'));

    %order these files according to their number 
        %convert to matrix
        Filefields = fieldnames(Datafile);
        
        DatafileMat=struct2cell(Datafile);
        DatafileMat=DatafileMat';
        
        %sort
        DatafileMatSort=sortrows(DatafileMat,2);        % use date timestamp to sort files (=proxy for number) 
        
        %convert back to structure
        DatafileSort=cell2struct(DatafileMatSort,Filefields,2);
        
        %replace old datastructure with sorted
        Datafile=DatafileSort;
        
        clear DatafileSort DatafileMat DatafileMatSort Filefields

%Define the format of data in this files
Readingformat = '%f' ; 

%Define the number of files
nfile=length(Datafile);

% initialize results matrix
EToAll = cell(3,nfile);

%loop over all files with ET0
for filenumb=1:nfile
   
    filename=Datafile(filenumb).name; %retrieve filename
    filenamefull=fullfile(Datapath, filename); % create exact reference to file (with folders)
    EToAll{1,filenumb}=filename;

    %open file for reading    
        fid = fopen(filenamefull); 
            if fid==-1 % check if file was really opened
                disp ('ET0 File could not be opened')
            else    
                %carry on, file can now be read
            end

    %read this file    
       %read headerline
            TextLine=fgetl(fid);% read the first line (name of climate model run)
            LineData=sscanf(TextLine,'%s'); % extract text from this textline
            EToAll{2,filenumb}= LineData; %save the text 
            clear TextLine


       %read real data line by line
            linecounter = 1; %linecounter is an indicator of on which row data should be save
            TextLine=fgetl(fid); %get a textline from the file 
                 
                %Loop over the rest of the file
                    while isempty(TextLine)==0 %as long there is no blank space in TextLine (blank space indicating the end of file)
                        try
                        LineData=sscanf(TextLine,Readingformat); % read number from the textline
                        EToAll{3,filenumb}(linecounter,1) = LineData'; % write the data of this line
                        TextLine=fgetl(fid); %get the next line 
                        linecounter = linecounter+1;% go to the next line
                        catch
                            break %if an error occurs in the block between try and catch (should only be at end of file, but can also be caused by invalid data)
                        end
                    end
               
   %close the file again before next file is read
   fclose (fid);
      
end

% 2.2 Read rainfall files
%--------------------------------------------------------------------------

%Define which type of files should be read (* is wild character)
Datafile=dir(fullfile(Datapath,'rainfall*.txt'));

    %order these files according to there number 
        %convert to matrix
        Filefields = fieldnames(Datafile);
        
        DatafileMat=struct2cell(Datafile);
        DatafileMat=DatafileMat';
        
        %sort
        DatafileMatSort=sortrows(DatafileMat,2);        % use date timestamp to sort files (=proxy for number) 
        
        %convert back to structure
        DatafileSort=cell2struct(DatafileMatSort,Filefields,2);
        
        %replace old datastructure with sorted
        Datafile=DatafileSort;
        
        clear DatafileSort DatafileMat DatafileMatSort Filefields

%Define the format of data in this files
Readingformat = '%f' ; 

%Define the number of files
nfile=length(Datafile);

% initialize results matrix
RainfallAll = cell(3,nfile);

%loop over all files with rainfall
for filenumb=1:nfile
   
    filename=Datafile(filenumb).name; %retrieve filename
    filenamefull=fullfile(Datapath, filename); % create exact reference to file (with folders)
    RainfallAll{1,filenumb}=filename;

    %open file for reading    
        fid = fopen(filenamefull); 
            if fid==-1 % check if file was really opened
                disp ('Rainfall File could not be opened')
            else    
                %carry on, file can now be read
            end

    %read this file    
       %read headerline
            TextLine=fgetl(fid);% read the first line (name of climate model run)
            LineData=sscanf(TextLine,'%s'); % extract text from this textline
            RainfallAll{2,filenumb}= LineData; %save the text 
            clear TextLine


       %read real data line by line
            linecounter = 1; %linecounter is an indicator of on which row data should be save
            TextLine=fgetl(fid); %get a textline from the file 
                 
                %Loop over the rest of the file
                    while isempty(TextLine)==0 %as long there is no blank space in TextLine (blank space indicating the end of file)
                        try
                        LineData=sscanf(TextLine,Readingformat); % read number from the textline
                        RainfallAll{3,filenumb}(linecounter,1) = LineData'; % write the data of this line
                        TextLine=fgetl(fid); %get the next line 
                        linecounter = linecounter+1;% go to the next line
                        catch
                            break %if an error occurs in the block between try and catch (should only be at end of file, but can also be caused by invalid data)
                        end
                    end
               
   %close the file again before next file is read
   fclose (fid);
      
end

% 2.3 Read Tmin files
%--------------------------------------------------------------------------

%Define which type of files should be read (* is wild character)
Datafile=dir(fullfile(Datapath,'min_temperature*.txt'));

    %order these files according to there number 
        %convert to matrix
        Filefields = fieldnames(Datafile);
        
        DatafileMat=struct2cell(Datafile);
        DatafileMat=DatafileMat';
        
        %sort
        DatafileMatSort=sortrows(DatafileMat,2);        % use date timestamp to sort files (=proxy for number) 
        
        %convert back to structure
        DatafileSort=cell2struct(DatafileMatSort,Filefields,2);
        
        %replace old datastructure with sorted
        Datafile=DatafileSort;
        
        clear DatafileSort DatafileMat DatafileMatSort Filefields

%Define the format of data in this files
Readingformat = '%f' ; 

%Define the number of files
nfile=length(Datafile);

% initialize results matrix
TminAll = cell(3,nfile);

%loop over all files with Tmin
for filenumb=1:nfile
   
    filename=Datafile(filenumb).name; %retrieve filename
    filenamefull=fullfile(Datapath, filename); % create exact reference to file (with folders)
    TminAll{1,filenumb}=filename;

    %open file for reading    
        fid = fopen(filenamefull); 
            if fid==-1 % check if file was really opened
                disp ('Tmin File could not be opened')
            else    
                %carry on, file can now be read
            end

    %read this file    
       %read headerline
            TextLine=fgetl(fid);% read the first line (name of climate model run)
            LineData=sscanf(TextLine,'%s'); % extract text from this textline
            TminAll{2,filenumb}= LineData; %save the text 
            clear TextLine


       %read real data line by line
            linecounter = 1; %linecounter is an indicator of on which row data should be save
            TextLine=fgetl(fid); %get a textline from the file 
                 
                %Loop over the rest of the file
                    while isempty(TextLine)==0 %as long there is no blank space in TextLine (blank space indicating the end of file)
                        try
                        LineData=sscanf(TextLine,Readingformat); % read number from the textline
                        TminAll{3,filenumb}(linecounter,1) = LineData'; % write the data of this line
                        TextLine=fgetl(fid); %get the next line 
                        linecounter = linecounter+1;% go to the next line
                        catch
                            break %if an error occurs in the block between try and catch (should only be at end of file, but can also be caused by invalid data)
                        end
                    end
               
   %close the file again before next file is read
   fclose (fid);
      
end

% 2.1 Read Tmax files
%--------------------------------------------------------------------------

%Define which type of files should be read (* is wild character)
Datafile=dir(fullfile(Datapath,'max_temperature*.txt'));

    %order these files according to there number 
        %convert to matrix
        Filefields = fieldnames(Datafile);
        
        DatafileMat=struct2cell(Datafile);
        DatafileMat=DatafileMat';
        
        %sort
        DatafileMatSort=sortrows(DatafileMat,2);        % use date timestamp to sort files (=proxy for number) 
        
        %convert back to structure
        DatafileSort=cell2struct(DatafileMatSort,Filefields,2);
        
        %replace old datastructure with sorted
        Datafile=DatafileSort;
        
        clear DatafileSort DatafileMat DatafileMatSort Filefields

%Define the format of data in this files
Readingformat = '%f' ; 

%Define the number of files
nfile=length(Datafile);

% initialize results matrix
TmaxAll = cell(3,nfile);

%loop over all files with Tmax
for filenumb=1:nfile
   
    filename=Datafile(filenumb).name; %retrieve filename
    filenamefull=fullfile(Datapath, filename); % create exact reference to file (with folders)
    TmaxAll{1,filenumb}=filename;

    %open file for reading    
        fid = fopen(filenamefull); 
            if fid==-1 % check if file was really opened
                disp ('Tmax File could not be opened')
            else    
                %carry on, file can now be read
            end

    %read this file    
       %read headerline
            TextLine=fgetl(fid);% read the first line (name of climate model run)
            LineData=sscanf(TextLine,'%s'); % extract text from this textline
            TmaxAll{2,filenumb}= LineData; %save the text 
            clear TextLine


       %read real data line by line
            linecounter = 1; %linecounter is an indicator of on which row data should be save
            TextLine=fgetl(fid); %get a textline from the file 
                 
                %Loop over the rest of the file
                    while isempty(TextLine)==0 %as long there is no blank space in TextLine (blank space indicating the end of file)
                        try
                        LineData=sscanf(TextLine,Readingformat); % read number from the textline
                        TmaxAll{3,filenumb}(linecounter,1) = LineData'; % write the data of this line
                        TextLine=fgetl(fid); %get the next line 
                        linecounter = linecounter+1;% go to the next line
                        catch
                            break %if an error occurs in the block between try and catch (should only be at end of file, but can also be caused by invalid data)
                        end
                    end
               
   %close the file again before next file is read
   fclose (fid);
      
end

clear TextLine Readingformat LineData linecounter filenumb filenamefull filename fid Datapath datafile

end

