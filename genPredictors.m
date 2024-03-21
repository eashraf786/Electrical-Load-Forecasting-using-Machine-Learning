function [X, dates, labels] = genPredictors(data, holidays) % data=system load data, holidays = list of holiday dates

dates = data.NumDate; %extract NumDate column from data to be stored as dates
if isempty(holidays) %if user has not provided list of holidays
    holidays = createHolidayDates(min(dates), max(dates)); %create list of holidays
else
    holidays = datenum(holidays); %convert holiday dates to number format
end

prevDaySameHourLoad = [NaN(24,1); data.System_Load(1:end-24)];  %24 Hr lagged load input
prevWeekSameHourLoad = [NaN(168,1); data.System_Load(1:end-168)]; %168 Hr ie 1 week lagged load input
prev24HrAveLoad = filter(ones(1,24)/24, 1, data.System_Load); %previous 24 Hr average load

dayOfWeek = weekday(dates); %storing day of week in form of numbers 1 to 7

isWorkingDay = ~ismember(floor(dates),holidays) & ~ismember(dayOfWeek,[1 7]); %storing 1 if working day and 0 if not
%final predictor matrix containing all 8 variables
X = [data.Dry_Bulb data.Dew_Point data.Hr_End dayOfWeek isWorkingDay prevWeekSameHourLoad prevDaySameHourLoad prev24HrAveLoad];
labels = {'DryBulb', 'DewPoint', 'Hour', 'Weekday', 'IsWorkingDay', 'PrevWeekSameHourLoad', 'prevDaySameHourLoad', 'prev24HrAveLoad'};