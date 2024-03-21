y = readmatrix('WeekLoadData.xlsm','Sheet','To be filtered','Range','A1:C2005');
data2 = zeros(24,3); %initialization with zeros
c=1; %hourly load data counter
for i=1:12:size(y) %run for loop through data, storing only hourly load data
    data2(c,1) = y(i,1)-(9.5/24); %adjusting time-shift by subtracting 9.5 hrs
    %storing hour no. in seperate column
    if(mod(c,24)==0) 
        data2(c,1) = data2(c,1)-1;
        data2(c,2) = 24;
    else
    data2(c,2) = mod(c,24);
    end
    data2(c,3) = y(i,3); %storing load data
    c=c+1;
end
data2=dataset(data2(:,1),data2(:,2),data2(:,3)); %converting to dataset
data2=set(data2,'VarNames',{'Date','Hr_End','System_Load'}); %setting variable names
save WeekLoadData.mat data2 %save dataset in .mat file