%% TAHMO data for 5min interval is converted to daily interval
%% Data 1 - TAHMO
function data_1_daily = callTAHMO(TAHMO);
data_1 = TAHMO;
dates = string(data_1.Timestamp);
prep = str2double(string(data_1.pr)); %precipitation data is converted string to double
start_year = str2num(dates{1}(end-3:end)); %convert char to num to find starting year

%% MAIN LOOP %convert data to day scale
year = start_year;
sum = 0;
month = 1;
sum_day = [];
j =1;
day = 1;
for i = 1:size(data_1,1)
    if str2num(dates{i}(end-3:end)) == year 
        if str2num(dates{i}(1:2)) == month
            if str2num(dates{i}(end-6:end-5)) == day
                sum = prep(i)+sum ;
            else %next day
                sum_day(j) = sum;
                sum = 0;
                j = j+1;
                day = day +1;
            end
        else  %next month
            sum_day(j) = sum;
            month = month +1;
            i = i-1;
            day = 1;
            j =j+1;
        end
    else  %next year 
        sum_day(j) = sum;
        year = year +1 ;
        month = 1;
        i = i-1;
        day = 1;
        j =j+1;
    end
   
end

data_1_daily = sum_day';  

end
