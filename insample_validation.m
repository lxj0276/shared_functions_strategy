%% in sample validation 月末强平
function[errors]=insample_validation(indices,types,type,tscost,skips,trains,ends,windowsize,func)
%用每月最优参数计算的最优结果
temp=load('bestpara_all');
bestpara_all=temp(1).bestpara_all;

lenind=length(indices);
lentp=length(types);

tic

validation_result=struct('index',struct());
errors=zeros(lentp,lenind);
for dumind=1:lenind
    index=indices{dumind};
    skip=skips(dumind);
    train=trains(dumind);
    dtend=ends(dumind);    
    
    file=strcat('D:\Works\Strategies\Trend Following\指数日度数据\day',index,'.csv');
    data=csvread(file,0,0);
    idx1=(data(:,1)>=skip)  & (data(:,1)<=dtend);
    idx2=(data(:,1)>=train) & (data(:,1)<=dtend);
    trddata  =data(idx1,:);
    trddate=trddata(:,1);
    validate=data(idx2,1);
    clear('data');
    
    firstlen=sum(idx1)-sum(idx2);
    months=floor(validate/100);
    monthend=find([months(1:end-1)~=months(2:end);true])+firstlen; %注意要加firstlen
    totlen=length(months);
    monthlen=length(monthend);
    
    indicator_para=bestpara_all(dumind).index;   
    validation_index=struct('tableK',{});    
    for dumt=1:lentp
        signals=zeros(totlen,1);
        positions=zeros(totlen,1);
        points=zeros(totlen,1);
        returns=zeros(totlen,1);
        bestparas=indicator_para(dumt).bestparas;
        try
            for dumi=1:monthlen
                
                if dumi==1
                    head=firstlen+1;
                else
                    head=monthend(dumi-1)+1;
                end
                tail=monthend(dumi);
                toskip=trddate(head);
                theparas=bestparas(dumi+1,:); %当月使用当月计算的最有参数，bestpara的第一行为training数据的最优参数
                [monsigs,monpos]=func(trddata(head-windowsize:tail,:),theparas,toskip,type,0); %加windowsize是为了保证提取数据足够长，用以计算
                opnprc=trddata(head:tail,2);
                clsprc=trddata(head:tail,5);
                [monrets,~,monpts]=earnings_general_open(monpos,monsigs,opnprc,clsprc,tscost);
                posidx=(head-firstlen):(tail-firstlen);
                %diff=tail-head;
                signals(posidx)  =monsigs;%(end-diff:end);
                positions(posidx)=monpos;%(end-diff:end);
                returns(posidx)  =monrets;%(end-diff:end);
                points(posidx)   =monpts;%(end-diff:end);
            end
        catch
            errors(dumt,dumind)=1;
        end
        netval=cumprod(1+returns); %净值未分段，不是整体，因而需要通过收益率重新计算
        tableK=array2table([validate,signals,positions,points,returns,netval],'VariableNames',...
            {'date','signals','positions','points','returns','netval'});
        indicators=validation_indicators(tableK);
        tmptb=[tableK indicators];
        validation_index(dumt).tableK=tmptb;
    end
    validation_result(dumind).index=validation_index;
end


toc
%%
validation_result_in=validation_result;
save('validation_result_in','validation_result_in')