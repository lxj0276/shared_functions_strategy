function[returns,netval,points]=earnings_general_open(positions,signals,opnprc,clsprc,tscost)
% ֻ������K�߽�β���źŵ��������abs(signal)==1��������ʱʱ���ź�
% works only for the case of entering at open price !!!!!!!! �ڶ���K�߿��̽���

if positions(1)~=0 %���ǵ���λ�ź���Ϣ����Ϊ�ضϣ���signal(1)~=0 ���� positions(1)~=0,��ʱ��signal��Ч
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
        if sigpos(i)==totlen %���һ��K�߷��źŵ����
            continue
        end
        
        head=sigpos(i)+1;
        if i==lensig
            tail=totlen;
        else
            tail=sigpos(i+1);
        end
        
        kcprc=opnprc(head);
        if positions(head-1)==0 %�Ƿ����볡���֣�cp=0Ϊ�볡���֣�cp=1����Ϊhead����K��Ϊ�볡λ��
            cp=0;
        else
            cp=1;
        end
        if positions(head)==0 %�Ƿ��з�ת�ֲ�
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
        cumnetval=netval_begin; % ֻ�ۼƵ��˴�head֮ǰ
        returns(head:tail)=netval(head:tail)./netval((head-1):(tail-1))-1;
        tmpprc=clsprc((head-1):(tail-1));
        tmpprc(1)=kcprc;
        points(head:tail)=(clsprc(head:tail)-tmpprc).*positions(head:tail);
        points(head)=points(head) + (kcprc-clsprc(head-1))*positions(head-1);
        points(head)=points(head)-( abs(positions(head-1)) + abs(positions(head)) )*tscost*kcprc;
        
        if (tail==totlen) && (sigpos(end)==totlen) && (positions(end)~=0) %���һ��K�߷��ź�,��Ϊ����ĩβǿ��ƽ�֣������̼�ƽ��
            netval(tail)=netval_begin*(1 + (netprc(end)/kcprc-1)*positions(tail)-tscost-tscost*clsprc(end)/kcprc);
            returns(tail)=netval(tail)/netval(tail-1)-1;
            points(tail)=(clsprc(tail)-clsprc(tail-1))*positions(tail)-tscost*clsprc(tail);
        end
    end
    
end