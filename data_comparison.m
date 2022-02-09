%%Nash–Sutcliffe model efficiency coefficient && KS-TEST && Cross Correlation
clc;clear all;close all;
%% Data 1 - Data 2 - Annual
data_TAHMO = readtable('timeseries.csv');
data_1_daily = callTAHMO(data_TAHMO);  %get the daily TAHMO precipitation data

data_CHIRPS = readtable('ee-chart-chirps.csv');
data_2_daily = str2double(string(data_CHIRPS.precipitation)); %get the daily CHIRPS precipitation data

data_GSMAP = readtable('ee-chart-gsmap.csv');
data_3_daily = str2double(string(data_GSMAP.rain)); %get the daily GSMAP precipitation data

%% choose the data
data_1_daily(isnan(data_1_daily)) = 0; %replace NaN's in table with zero
data_2_daily(isnan(data_2_daily)) = 0; 
data_3_daily(isnan(data_3_daily)) = 0; 

data_1 = data_1_daily;
data_2_all = [data_2_daily,data_3_daily]; %chirps and gsmap 

%% months
months = [31 28 31 30 31 30 31 31 30 31 30 31];  
months_leap = [31 29 31 30 31 30 31 31 30 31 30 31]; %%for 2020
%% Parameters
nom = 0;
denom = 0;
jan = 1; %first month
tot_months = 12;
last  = months(jan); % last month
start = 1;
dates = string(data_GSMAP.date);
year = 2020; %leap year
i = 1;
j = 1;
efficiency =[];
kstest = [];
kstest_log = [];

%% MAIN LOOP
for a = 1:length(data_2_all(1,:))
    data_2 = data_2_all(:,a)
    while i <= length(data_1)-30
        
        if str2num(dates{i}(end-3:end)) == year && jan == 2 %months february
            last = last+1;
        end
        for i = start : last %%length(data_1_daily)
                      
                nom = nom + (data_1(i) - data_2(i))^2;
                denom = denom + (data_1(i) - mean(data_1(start:last)))^2 ;
                          
                if i == last && jan ~= tot_months  %months other than december
                    eff = 1 - (nom/denom);
                    efficiency(j,a) = eff;
                    %define monthly values and logaritmic version
                    F = data_1(start:last);
                    O = data_2(start:last);
                    [idx_F] = F > 1;
                    F_temp = log(F(idx_F));
                    F_thres = F; %zeros(1,length(F));
                    F_thres(idx_F) = F_temp;
                    [idx_O] = O > 1;
                    O_temp = log(O(idx_O));
                    O_thres = O; %zeros(1,length(O));
                    O_thres(idx_O) = O_temp;
                    %kstest
                    p = call_kstest(F,O,F_thres,O_thres);
                    kstest (j,a) = p(1);
                    kstest_log (j,a) = p(2);
                    %croscorrelation
                    cx = call_crosscor(F,O,F_thres,O_thres);
                    crosscor (j,a) = cx(1);
                    crosscor_log (j,a) = cx(2);

                    j = j+1;
                    fprintf('month comlepted\n')
                    eff = 0;
                    start = last+1;
                    jan = jan+1;
                    last = last + months(jan);
                    
                elseif i == last && jan == tot_months    %months december
                    eff = 1 - (nom/denom);
                    efficiency(j,a) = eff;
                    %define monthly values and logaritmic version
                    F = data_1(start:last);
                    O = data_2(start:last);
                    [idx_F] = F > 1;
                    F_temp = log(F(idx_F));
                    F_thres = F; %zeros(1,length(F));
                    F_thres(idx_F) = F_temp;
                    [idx_O] = O > 1;
                    O_temp = log(O(idx_O));
                    O_thres = O; %zeros(1,length(O));
                    O_thres(idx_O) = O_temp;
                    %kstest
                    p = call_kstest(F,O,F_thres,O_thres);
                    kstest (j,a) = p(1);
                    kstest_log (j,a) = p(2);
                    %croscorrelation
                    cx = call_crosscor(F,O,F_thres,O_thres);
                    crosscor (j,a) = cx(1);
                    crosscor_log (j,a) = cx(2);
                    
                    j = j+1;
                    fprintf('year comlepted\n')
                    eff = 0;
                    start = last+1;
                    jan = 1;
                    last = last + months(jan);
                end
                
            end
        end
        nom = 0;
        denom = 0;
        jan = 1; %first month
        last  = months(jan); % last month
        start = 1;
        i = 1;
        j = 1;
    end

%% create table

month = [(1:12),(1:12),(1:12),(1:12)]';
years = repelem([{2018}, {2019}, {2020},{2021}], [12 12 12 12])';
results = table(month,years,efficiency,kstest,kstest_log,crosscor,crosscor_log);

%% write to excel

filename = 'comparisonresults.xlsx';
writetable(results,filename,'Sheet',1,'Range','A1')


