err = 0;
c=0;
sdate='2022-10-12'; edate = '2022-10-16';
for i=datenum(sdate):datenum(edate)
    if(i~=datenum('2022-05-30'))
        [y, mape] = DAloadForecasting3(i, 'N');
    else
    [y, mape] = DAloadForecasting3(i, 'Y');
    end
    if(mape<3)
        c=c+1;
    end
    err = err + mape;
    avg = err/(i-datenum(sdate)+1);
    fprintf('Avg MAPE = %f\n',avg);
    fprintf('Good MAPE = %d\n',c);
end
disp("MAPE less than 3% : "+c+" times");