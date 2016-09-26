function[returns,netval,points]=earnings_general_open(positions,signals,opnprc,clsprc,tscost)
% 只考虑在K线结尾发信号的情况，即abs(signal)==1，不考虑时时发信号
% works only for the case of entering at open price !!!!!!!! 第二根K线开盘进出

if positions(1)~=0 %考虑到仓位信号信息可能为截断，即signal(1)~=0 但是 positions(1)~=0,此时该signal无效
    signals(1)=0;
end

totlen=length(signals);
sigpos=find(signals~=0);
lensig=length(sigpos);

netval=ones(totlen,1);
returns=zeros(totlen,1);
points=zeros(totlen,1);
lastkcprc=0;
cumnetval=1;

if ~isempty(sigpos)
    
    positions(1:sigpos(1))=0;    
    for i=1:lensig
        if sigpos(i)==totlen %最后一根K线发信号的情况
            continue
        end
        
        head=sigpos(i)+1;
        if i==lensig
            tail=totlen;
        else
            tail=sigpos(i+1);
        end
        
        kcprc=opnprc(head);
        if positions(head-1)==0 %是否是入场开仓，cp=0为入场开仓，cp=1可能为head所在K线为离场位置
            cp=0;
        else
            cp=1;
        end
        if positions(head)==0 %是否有反转持仓
            empty=1;
        else
            empty=0;
        end
        
        if cp
            netval_begin=cumnetval*( 1+(kcprc/lastkcprc-1)*positions(head-1)-tscost*kcprc/lastkcprc-tscost*abs(positions(head-1)) );
        else
            netval_begin=netval(head-1);
        end
        if empty
            netval(head:tail)=netval_begin;
            returns(head)=netval(head)/netval(head-1)-1;
            cumnetval=netval_begin;
            points(head)=points(head) + (kcprc-clsprc(head-1))*positions(head-1);
            points(head)=points(head)-( abs(positions(head-1)) + abs(positions(head)) )*tscost*kcprc;
            continue;
        end
        
        netprc=clsprc(head:tail);
        netval(head:tail)=netval_begin*(1 + (netprc/kcprc-1).*positions(head:tail)-tscost*abs(positions(head-1)+1-cp));
        lastkcprc=kcprc;
        cumnetval=netval_begin; % 只累计到此次head之前
        returns(head:tail)=netval(head:tail)./netval((head-1):(tail-1))-1;
        tmpprc=clsprc((head-1):(tail-1));
        tmpprc(1)=kcprc;
        points(head:tail)=(clsprc(head:tail)-tmpprc).*positions(head:tail);
        points(head)=points(head) + (kcprc-clsprc(head-1))*positions(head-1);
        points(head)=points(head)-( abs(positions(head-1)) + abs(positions(head)) )*tscost*kcprc;
        
        if (tail==totlen) && (sigpos(end)==totlen) && (positions(end)~=0) %最后一根K线发信号,视为数据末尾强制平仓，以收盘价平仓
            netval(tail)=netval_begin*(1 + (netprc(end)/kcprc-1)*positions(tail)-tscost-tscost*clsprc(end)/kcprc);
            returns(tail)=netval(tail)/netval(tail-1)-1;
            points(tail)=(clsprc(tail)-clsprc(tail-1))*positions(tail)-tscost*clsprc(tail);
        end
    end
    
end