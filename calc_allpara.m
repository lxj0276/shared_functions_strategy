function[parasdata]=calc_allpara(data,lowers,uppers,stepsize,skip,type,tscost,paraskip,func)
alldate=data(:,1);
mark=(alldate>=skip);
date=data(mark,1);
opnprc=data(mark,2);
clsprc=data(mark,5);

parasdata=struct('tableK',{});
allparas=TestParasGen(lowers,uppers,stepsize);
[paranum,~]=size(allparas);

for dumi=1:paranum
    if paraskip(dumi)
        continue;
    end
    paras=allparas(dumi,:);
    [signals,positions]=func(data,paras,skip,type);
    [returns,netval,points]=earnings_general_open(positions,signals,opnprc,clsprc,tscost);
    tableK=array2table([date signals,positions,points,returns,netval],'VariableNames',...
        {'date','signals','positions','points','returns','netval'});
    indicators=validation_indicators(tableK);
    tmptb=[tableK indicators];
    parasdata(dumi).tableK=tmptb;
end
