function[bestparas,bestsigs]=bestparas_select(thedata,lowers,uppers,stepsize,tp,trainend,paraskip)
% �Ե�һ��������һָ��Ѱ��
if strcmp(tp,'annret')
    tpcol=7;
elseif strcmp(tp,'sharp')
    tpcol=9;
elseif strcmp(tp,'calmar')
    tpcol=10;
end

allparas=TestParasGen(lowers,uppers,stepsize);
[paralen,~]=size(allparas);

% thedata ӦΪ���� �ȳ��� table �� struct
tempdata=thedata(paralen).tableK;
date=table2array(tempdata(:,1));
train=(date<trainend); %������
test =(date>=trainend);  %Ѱ������
months=floor(date(test)/100);
monthend=find([months(1:end-1)~=months(2:end);1]);
monthlen=length(monthend);
datalen=length(months);
paranum=length(stepsize);

bestparas=zeros(monthlen+1,paranum);
bestsigs=zeros(datalen,4); % date sig pos tp

% �ɵ�����Ѱ�ҵ�һ�����Ų���
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
    % ��ȡ���в�����Ӧ�Ĳ�λ���źţ�������ֱ���������ƽ������Ϊ��ֻ�������ź����ݵ�һ���֣���������Ӧ�Ĳ��֣������Ǹ��µ����ܵĽ��
    % ���·����źſ����������ܱ����˵����������Ʋ�λ��Ϣ����Ҫ�����Ը����в�������
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
%         continue %���һ���µ�bestpara �ò������������
%     else
%         bestparas(dumi,:)=allparas(bestidx,:);
%     end
    bestparas(dumi+1,:)=allparas(bestidx,:);
end