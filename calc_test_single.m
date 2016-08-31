function[tableK]=calc_test_single(data,paras,tscost,type,skip,func)
date=data(:,1);
opnprc=data(:,2);
clsprc=data(:,5);
start=find(date>=skip,1);

[signals,positions]=func(data,paras,skip,type);
[returns,netval,points]=earnings_general_open(positions,signals,opnprc(start:end),clsprc(start:end),tscost);
tableK=array2table([date(start:end) signals,positions,points,returns,netval],'VariableNames',...
    {'date','signals','positions','points','returns','netval'});
indicators=validation_indicators(tableK);
tableK=[tableK indicators];