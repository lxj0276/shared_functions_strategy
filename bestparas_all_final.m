function[errors]=bestparas_all_final(indices,types,lowers,uppers,stepsize,trains,paraskip)
%% select all bestparas
%生成所有指数、对应所有指标的月度最优参数

lenind=length(indices);
lentp=length(types);
errors=zeros(lentp,lenind);

tic

bestpara_all=struct('index',struct());
for dumi =1:lenind
    indexdata=load(strcat('alldata',indices{dumi}));
    thedata=indexdata(1).parasdata;
    trainend=trains(dumi);
    indicator_para=struct('bestparas',[],'bestsigs',[]);
    for dumj=1:lentp
        tp=types{dumj};
        try
            [bestparas,bestsigs]=bestparas_select(thedata,lowers,uppers,stepsize,tp,trainend,paraskip);
            indicator_para(dumj).bestparas=bestparas;
            indicator_para(dumj).bestsigs=bestsigs;
        catch
            indicator_para(dumj).bestparas=NaN;
            indicator_para(dumj).bestsigs=NaN;
            errors(dumj,dumi)=1;
        end
    end
    bestpara_all(dumi).index=indicator_para;
end

toc

%%
save('bestpara_all','bestpara_all','-v7.3')


