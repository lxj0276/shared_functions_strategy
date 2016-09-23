function[errors]=calc_inspdata(indices,lowers,uppers,stepsize,skips,type,tscost,starts,ends,paraskip,func)

tic
lenind=length(indices);
errors=zeros(1,lenind);
for dumi=1:lenind
    index=indices{dumi};
    file=strcat('D:\Works\Strategies\Trend Following\指数日度数据\day',index,'.csv');
    data=csvread(file,0,0);
    
    idx=(data(:,1)>=starts(dumi)) & (data(:,1)<=ends(dumi));
    trddata=data(idx,:);
    skip=skips(dumi);
    
    try
        [parasdata]=calc_allpara(trddata,lowers,uppers,stepsize,skip,type,tscost,paraskip,func);
    catch
        parasdata=NaN;
        errors(dumi)=1;
    end
    save(strcat('insp_data',indices{dumi}),'parasdata','-v7.3');
end
toc