function y= DAloadForecasting(date, temperature, isHoliday)
date = datenum(date); %convert date to number format
if date < 7e5 %if date is in excel numeric date format
    date = x2mdate(date); %convert to MATLAB numeric date format
end
if ischar(isHoliday) %if isHoliday is a word
    if strcmpi(isHoliday(1),'N') %if its first letter is 'N'
        isWorkingDay = true;
    else %if its a holiday
        isWorkingDay = false;
    end
else
    isWorkingDay = ~isHoliday; %if operator has entered 0 or 1
end
%if the day is neither a holiday nor a weekend, isWorkingDay will be true
isWorkingDay = logical(isWorkingDay) & ~ismember(weekday(date),[1 7]);
s = load('WeekLoadData.mat'); %load historical load data of 7 days
data2 = s.data2;
sl = data2.System_Load; %extract load data column from .mat file

ave24 = filter(ones(24,1)/24, 1, sl); %previous 24 hr average load data
%load predictors are previous week same day load, previous day load, prev 24 hr average load
loadPredictors = [sl(1:24) sl(end-23:end) ave24(end-23:end)];
X = [temperature (1:24)' weekday(date)*ones(24,1) isWorkingDay*ones(24,1) loadPredictors];
model1 = load('My_BestNNModel.mat'); %load saved NN model
y1 = sim(model1.net, X')'; %perform the load forecasting
% Create load profile plot
fig = clf;
if isdeployed %if plot inserted in Excel app
   set(fig,'Visible','off') %don't display MATLAB figure window 
end
plot(y1/1e3, '.-');
xlabel('Hour');
ylabel('Load (x1000 MW)');
title(sprintf('Load Forecast Profile for %s', datestr(date)))
grid on;
print -dmeta %insert the plot as image in Excel app
y = y1;