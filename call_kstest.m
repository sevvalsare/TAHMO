%% KS Test function proceed in data_comparison.m
%%The p-value <𝛼 indicates that we should reject the null hypothesis.This tells us that there is a significant difference between the measurements taken by TAHMO stations and other station

function p = call_kstest(F,O,F_thres,O_thres);

[h,p1] = kstest2(F,O);
[h,p2] = kstest2(F_thres,O_thres)
p = [p1,p2];

end


