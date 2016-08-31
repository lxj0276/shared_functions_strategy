function[testparas]=TestParasGen(lowers,uppers,stepsize)

paranum=length(stepsize);
parastot=floor((uppers-lowers)./stepsize)+1;
temp=cumprod(parastot);
repttimes=[1,temp(1:end-1)];
totlen=prod(parastot);
testparas=zeros(totlen,paranum);
idx=ones(1,paranum);
for dumi=1:paranum 
    %idx=preidx;
    idx(dumi)=0;
    reptidx=zeros(totlen,1); %to mark wich part should be used in reptmat
    reptnum=prod(parastot(:,idx==1));
    paras=linspace(lowers(dumi),uppers(dumi),parastot(dumi));
    for dumj=1:parastot(dumi)
        testparas((dumj-1)*reptnum+1:dumj*reptnum,dumi)=paras(dumj)*ones(reptnum,1);       
        reptidx((dumj-1)*reptnum+1:dumj*reptnum,:)=1;
    end    
    torept=testparas(reptidx==1,dumi);
    testparas(:,dumi)=repmat(torept,repttimes(dumi),1);
end