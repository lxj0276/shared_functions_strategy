function[returns,netval,points]=earnings_mt3h(positions,signals,clsprc,tscost)


idx1=abs(signals)~=0;
idx2=[abs(positions(1:end-1)-positions(2:end))==1;0];
sigpos=find(idx1);
points=(clsprc(2:end)-clsprc(1:(end-1))).*positions(2:end);
points=[0;points];
singlepos=find(idx2);

lencls=length(clsprc);
returns=zeros(lencls,1);
netval=zeros(lencls,1);

lensig=length(sigpos);
netval(1:sigpos(1))=1;
netval(sigpos(1))=1;
for i=1:lensig
    head=sigpos(i)+1;
    if i==lensig
        tail=lencls;
    else
        tail=sigpos(i+1);
    end
    openprc=cumsum(points(head-1:tail-1))+clsprc(head-1);    
    closeprc=clsprc(head:tail);
    returns(head:tail)=points(head:tail)./openprc;
    netval(head:tail)=netval(head-1)*(1+(closeprc./clsprc(head-1)-1).*positions(head:tail)...
                        -tscost*(1+idx1(head:tail)*(clsprc(tail)/clsprc(head-1))).*(positions(head:tail)~=0)); % | idx2(head:tail)~=0));
    if positions(head-1)==0
        netval(head-1)=netval(head-1)-tscost;
    end
end
netval(sigpos(1))=1-tscost;
points(sigpos)=points(sigpos)-2*tscost*clsprc(sigpos);
points(singlepos)=points(singlepos)+tscost*clsprc(singlepos);

returns(sigpos)=returns(sigpos)-2*tscost;
returns(singlepos)=returns(singlepos)+tscost;
