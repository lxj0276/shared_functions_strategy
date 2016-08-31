function[indicators]=validation_indicators(tableK)

Kreturns=table2array(tableK(:,5));
Knetval=table2array(tableK(:,6));
len=length(Knetval);

vols=zeros(len,1);
averet=cumsum(Kreturns);
maxdds=zeros(len-1,1);
maxdraw=zeros(len,1);
maxret=-inf;
for dum_i=2:len
    if Knetval(dum_i)>maxret
        maxret=Knetval(dum_i);
    end
    maxdds(dum_i-1)=Knetval(dum_i)/maxret-1;
    maxdraw(dum_i)=min(maxdds(1:(dum_i-1)));
    vols(dum_i)=std(Kreturns(1:dum_i));
    averet(dum_i)=averet(dum_i)/dum_i;
end
maxdd=maxdraw;
annret=averet*240;
sharp=annret./(vols*sqrt(240));
calmar=abs(annret./maxdd);
idx=maxdd==0;
calmar(idx)=NaN;
indicators=array2table([annret,maxdd,sharp,calmar],'VariableNames',{'annret','maxdd','sharp','calmar'});
