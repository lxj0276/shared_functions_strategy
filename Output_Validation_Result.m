function[validation_result]=Output_Validation_Result(vali_struct)
% output the validation result : annret maxdd sharpe
validation_result=zeros(3,15);
for dumi=1:5
    index=vali_struct(dumi).index;
    for dumj=1:3
        tb=index(dumj).tableK;
        row=dumj;
        col=((dumi-1)*3+1):(dumi*3);
        validation_result(row,col)=table2array(tb(end,{'annret','maxdd','sharp'}));
    end
end