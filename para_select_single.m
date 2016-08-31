function[bestparas,bestsigs]=para_select_single(thedata,lowers,uppers,stepsize,indicator,tp)
% thedata is a stuct with key 'index'
if strcmp(tp,'annret')
    tpcol=7;
elseif strcmp(tp,'sharp')
    tpcol=9;
elseif strcmp(tp,'calmar')
    tpcol=10;
end

[idx,allparas]=para_idx_gen(lowers,uppers,stepsize,indicator);
% allparas=TestParasGen(lowers,uppers,stepsize);
% [paralen,~]=size(allparas);
% idx=(1:paralen)';

tempdata=thedata(idx(1)).tableK;
date=table2array(tempdata(:,1));
months=floor(date/100);
monthend=find([months(1:end-1)~=months(2:end);1]);
monthlen=length(monthend);
datalen=length(months);
paralen=length(stepsize);

bestparas=zeros(monthlen,paralen);
bestsigs=zeros(datalen,4); % date sig tp
lenidx=length(idx);
maxindval=-inf;
bestidx=0;
for dumi=1:length(monthend)    
    if dumi==1
        head=1;
    else
        head=monthend(dumi-1)+1;
    end
    tail=monthend(dumi);
    
    if dumi>1
        validationK=thedata(bestidx).tableK;
        bestsigs(head:tail,1:3)=table2array(validationK(head:tail,1:3));
        bestsigs(head:tail,end)=maxindval;
    end
        
    maxindval=-inf;
    bestidx=0;
    for dumj=1:lenidx        
        currentK=thedata(idx(dumj)).tableK;
        currentpara=allparas(dumj,:);
        indval=table2array(currentK(tail,tpcol));
        if indval>maxindval
            maxindval=indval;
            bestparas(dumi,:)=currentpara;
            bestidx=idx(dumj);
        end
    end
end
