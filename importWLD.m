folder = 'D:\PROJECT\Electricity Load Forecasting';
filename = 'WeekLoadData.xlsm';
sheetname = 'Oct Data';
data2 = dataset('XLSFile', sprintf('%s\\%s',folder,filename), 'Sheet', sheetname);
save([folder '\WeekLoadData30.mat'], 'data2');