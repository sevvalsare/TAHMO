%%Evaluates how consistent the methods are with the tahmo station

%% Read the excel
filename = 'comparisonresults.xlsx';
[num, txt,raw] = xlsread(filename);

%% Nash–Sutcliffe efficiency 
th_ns = 0; %efficiency should be positive
rs_ns = [];
for j = 3:4
    for i = 1: length(num)
        if num(i,j) > 0
            rs_ns(i,j-2) = 1;
        else
            rs_ns(i,j-2) = 0;
        end
    end
end
rs_ns_all =max(rs_ns,[],2);
%% ks test results
th_ks = 0.05 ;%threshold of ks test which is alpha =0.05. p > alpha is desired.
rs_ks = [];
rs_ks_all = [];
for j = 5:8
    for i = 1: length(num)
        if num(i,j) >= th_ks
            rs_ks(i,j-4) = 1;
        else
            rs_ks(i,j-4) = 0;
        end
    end
end
% rs_ks_all(:,1) = max(rs_ks(:,1),rs_ks(:,3)); %get the best result from ks test and log version for chirps
% rs_ks_all(:,2) = max(rs_ks(:,2),rs_ks(:,4)); %for gsmap
rs_ks_all = max(rs_ks,[],2);

%% crosscor results
th_cor = 0.5; %threshold of cross cor r>threshold is desired.
rs_cor = [];
rs_cor_all = [];
for j = 9:12
    for i = 1: length(num)
        if num(i,j) >= th_cor
            rs_cor(i,j-8) = 1;
        else
            rs_cor(i,j-8) = 0;
        end
    end
end
% rs_cor_all(:,1) = max(rs_cor(:,1),rs_cor(:,3)); %get the best result from ks test and log version for chirps
% rs_cor_all(:,2) = max(rs_cor(:,2),rs_cor(:,4)); %for gsmap
rs_cor_all = max(rs_cor,[],2);
%% compare data fit
output = [rs_ns_all ,rs_ks_all, rs_cor_all];
fit = [];
for  i =1: length(output)
    fit(i,1) = sum(output(i,:))/size(output(1,:),2);
end
         
%% write to same excel file
writematrix(fit,filename,'Sheet',1,'Range','N1');
