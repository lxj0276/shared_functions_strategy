function[valresults,idxresults]=Output_Insample_Best(indices,types,paraskip)
% 提取所有样本内最优结果
tic
lenind=length(indices);
lentp=length(types);

valresults=zeros(lentp,3*lenind);
idxresults=zeros(lentp,lenind);
for dumi =1:lenind
    
    indexdata=load(strcat('insp_data',indices{dumi}));
    thedata=indexdata(1).parasdata;
    paranum=length(thedata);
    
    maxvals=zeros(lentp,1);
    bestidx=zeros(lentp,1);
    results=zeros(lentp,3);
    
    for dumj=1:paranum
        if paraskip(dumj)
            continue;
        end
        currentK=thedata(dumj).tableK;
        indvals=table2array(currentK(end,types));        
        for dumk=1:lentp
            if indvals(dumk)>maxvals(dumk)
                maxvals(dumk)=indvals(dumk);
                bestidx(dumk)=dumj;
            end
        end
    end
    idxresults(:,dumi)=bestidx;
    
    for dumk=1:lentp
        currentK=thedata(bestidx(dumk)).tableK;
        vals=table2array(currentK(end,{'annret','maxdd','sharp'}));        
        results(dumk,:)=vals;
    end
    head=(dumi-1)*3+1;
    tail=dumi*3;
    valresults(:,head:tail)=results;
end
toc
