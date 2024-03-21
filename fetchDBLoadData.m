function data2 = fetchDBLoadData(startDate, endDate)

% Set preferences with setdbprefs.
s.DataReturnFormat = 'structure';
s.ErrorHandling = 'store';
s.NullNumberRead = 'NaN';
s.NullNumberWrite = 'NaN';
s.NullStringRead = 'null';
s.NullStringWrite = 'null';
setdbprefs(s)

% Make connection to database.  Note that the password has been omitted.
% Using ODBC driver.
conn = database('Excel Files','','');
% Read data from database.
if nargin == 2
    startDate = datestr(startDate, 'yyyy-mm-dd');
    endDate = datestr(endDate, 'yyyy-mm-dd');
    e = exec(conn,['SELECT Date, ' ...
    '	Hr_End, ' ...
    '	Dry_Bulb, ' ...
    '	Dew_Point, ' ...
    '	System_Load, ' ...
    '	Reg_Service_Price, ' ...
    '	Reg_Capacity_Price ' ...
    'FROM `''ISO NE CA$''` WHERE Date BETWEEN #' startDate '# AND #' endDate '#  ']);
else
    e = exec(conn,['SELECT Date, ' ...
    '	Hr_End, ' ...
    '	Dry_Bulb, ' ...
    '	Dew_Point, ' ...
    '	System_Load, ' ...
    '	Reg_Service_Price, ' ...
    '	Reg_Capacity_Price ' ...
    'FROM `''ISO NE CA$''`']);
end
e = fetch(e);

% Assign data to output variable.
if isscalar(e.Data) && iscellstr(e.Data) && strcmp(e.Data{1}, 'No Data')
    warning('fetchDBLoadData:NoData','No data retrieved');
    data2 = struct('Date',{''},'Hr_End',[],'Dry_Bulb',[],'Dew_Point',[],'System_Load',[],'NumDate',[]);
else
    data2 = e.Data;
    data2.NumDate = datenum(data2.Date, 'yyyy-mm-dd') + (data2.Hr_End-1)/24;
end

% Close database connection.
close(conn)