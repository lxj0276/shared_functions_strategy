function[returns,netval,points]=earnings_general_open(positions,signals,opnprc,clsprc,tscost)
% do NOT consider case of abs(signal)>1
% works only for the case of entering at open price !!!!!!!! 第二天开盘进出
totlen=length(signals);
sigpos=find(signals~=0);
lensig=length(sigpos);

netval=ones(totlen,1);
returns=zeros(totlen,1);
points=zeros(totlen,1);
lastkcprc=0;

for i=1:lensig
    if sigpos(i)==totlen %最后一根K线发信号的情况
        continue
    end
    
    if i==1
        cp=0;
    else
        cp=1;
    end
    
    head=sigpos(i)+1;
    kcprc=opnprc(head);
    
    if i==lensig
        tail=totlen;
    else
        tail=sigpos(i+1);
    end
    
    if cp
        netval_begin=cumnetval*(1+(kcprc/lastkcprc-1)*positions(head-1)-tscost*(kcprc/lastkcprc+1)*abs(positions(head-1)));
    else
        netval_begin=netval(head-1);
    end
    
    netprc=clsprc(head:tail);
    netval(head:tail)=netval_begin*(1 + (netprc/kcprc-1).*positions(head:tail)-tscost*abs(positions(head-1)+1-cp));
    lastkcprc=kcprc;
    cumnetval=netval_begin; % 只累计到此次head之前
    
    returns(head:tail)=netval(head:tail)./netval((head-1):(tail-1))-1;
    returns(head)=returns(head);
    returns(tail)=returns(tail);
    tmpprc=clsprc((head-1):(tail-1));
    tmpprc(1)=kcprc;
    points(head:tail)=(clsprc(head:tail)-tmpprc).*positions(head:tail);
    points(head)=points(head)+kcprc-clsprc(head-1);
    points(head)=points(head)-(abs(positions(head-1))+cp)*tscost*kcprc;
end