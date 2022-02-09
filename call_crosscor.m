%% Cross correlation function proceed in data_comparison.m

function cx = call_crosscor(F,O,F_thres,O_thres);

correlation = xcorr(F,O,'coeff');
corr_0 = correlation(length(F));
corr_1 = correlation(length(F)+1); %other one goes one step further
corr_2 = correlation(length(F)-1);

corr_all = [corr_0 corr_1 corr_2];
corr = max(corr_all);  % \take into account max value
%%logaritmic
correlation = xcorr(F_thres,O_thres,'coeff');
corrlog_0 = correlation(length(F_thres));
corrlog_1 = correlation(length(F_thres)+1); %other one goes one step further
corrlog_2 = correlation(length(F_thres)-1);

corrlog_all = [corrlog_0 corrlog_1 corrlog_2];
corrlog = max(corrlog_all);  % \take into account max value

cx = [corr,corrlog];

end
