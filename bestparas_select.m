function[bestparas,bestsigs]=bestparas_select(thedata,lowers,uppers,stepsize,tp,trainend,paraskip)
% 对单一参数、单一指标寻优
if strcmp(tp,'annret')
    tpcol=7;
elseif strcmp(tp,'sharp')
    tpcol=9;
elseif strcmp(tp,'calmar')
    tpcol=10;
end

allparas=TestParasGen(lowers,uppers,stepsize);
[paralen,~]=size(allparas);

% thedata 应为包含 等长的 table 的 struct
tempdata=thedata(paralen).tableK;
date=table2array(tempdata(:,1));
train=(date<trainend); %底数据
test =(date>=trainend);  %寻优数据
months=floor(date(test)/100);
monthend=find([months(1:end-1)~=months(2:end);1]);
monthlen=length(monthend);
datalen=length(months);
paranum=length(stepsize);

bestparas=zeros(monthlen+1,paranum);
bestsigs=zeros(datalen,4); % date sig pos tp

% 由底数据寻找第一个最优参数
maxindval=-inf;
bestidx=0;
trainlen=sum(train);
for dumj=1:paralen
    if paraskip(dumj)
        continue;
    end
    currentK=thedata(dumj).tableK;
    indval=table2array(currentK(trainlen,tpcol));
    if indval>maxindval
        maxindval=indval;
        bestidx=dumj;
    end    
end
bestparas(1,:)=allparas(bestidx,:);

for dumi=1:monthlen  
    if dumi==1
        head=1;
    else
        head=monthend(dumi-1)+1;
    end
    tail=monthend(dumi);
    
    validationK=thedata(bestidx).tableK;
    validationK=validationK(test,:);
    % 提取最有参数对应的仓位、信号，但不能直接用作外推结果，因为其只是整体信号数据的一部分（此月所对应的部分），不是改月单独跑的结果
    % 该月发的信号可能在整体总被过滤掉，若需外推仓位信息，需要重新以该最有参数计算
    posidx=head:tail;
    bestsigs(posidx,1:3)=table2array(validationK(posidx,1:3));
    bestsigs(posidx,end)=maxindval;
    
    maxindval=-inf;
    bestidx=0;
    for dumj=1:paralen       
        if paraskip(dumj)
            continue;
        end
        currentK=thedata(dumj).tableK;
        indval=table2array(currentK(tail+trainlen,tpcol));
        if indval>maxindval
            maxindval=indval;
            bestidx=dumj;
        end
    end
%     if dumi==1
%         continue %最后一个月的bestpara 用不到，不再输出
%     else
%         bestparas(dumi,:)=allparas(bestidx,:);
%     end
    bestparas(dumi+1,:)=allparas(bestidx,:);
end