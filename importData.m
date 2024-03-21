folder = 'D:\PROJECT\Electricity Load Forecasting';
sheetname = 'ISO NE CA';
yr = 2018;
data2 = dataset('XLSFile', sprintf('%s\\%d_smd_hourly.xlsx',folder,yr), 'Sheet', sheetname);
data2.Year = yr * ones(length(data2),1);

for yr = 2019:2022

    x = dataset('XLSFile', sprintf('%s\\%d_smd_hourly.xlsx',folder,yr), 'Sheet', sheetname);
    x.Year = yr*ones(length(x),1);
    data2 = [data2; x];
end
data2.NumDate = datenum(data2.Date, 'mm/dd/yyyy') + (data2.Hr_End-1)/24;
save([folder '\' genvarname(sheetname) '_Data4.5SEP.mat'], 'data2');