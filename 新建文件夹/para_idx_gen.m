function[idx,paras]=para_idx_gen(lower,upper,stepsize,indicator)

paralen=length(stepsize);
paralens=ceil((upper-lower)./stepsize)+1;

if strcmp(indicator,'MACD')
    X=paralens(1);  % short
    Y=paralens(2);  % long
    Z=paralens(3);  % m
    para1=lower(1):stepsize(1):upper(1);
    para2=lower(2):stepsize(2):upper(2);
    para3=lower(3):stepsize(3):upper(3);    
    count=0;
    for z=1:Z
        for y=1:Y
            for x=1:X                
                if para1(x)>=para2(y)
                    continue
                else
                    count=count+1;
                end
            end
        end
    end    
    idx=zeros(count,1);
    paras=zeros(count,paralen);    
    newcount=1;
    for z=1:Z
        for y=1:Y
            for x=1:X
                if para1(x)>=para2(y)
                    continue
                end
                idx(newcount,:)=(z-1)*X*Y+(y-1)*X+x;            
                paras(newcount,:)=[para1(x),para2(y),para3(z)];
                newcount=newcount+1;
            end
        end
    end    
elseif strcmp(indicator,'MA') || strcmp(indicator,'Turtle') || strcmp(indicator,'Boll')
    X=paralens(1);  % short
    Y=paralens(2);  % long
    para1=lower(1):stepsize(1):upper(1);
    para2=lower(2):stepsize(2):upper(2);
    isBoll=strcmp(indicator,'Boll');
    if isBoll
        count=X*Y;
    else
        count=0;
        for y=1:Y
            for x=1:X
                if para1(x)>=para2(y)
                    continue
                else
                    count=count+1;
                end
            end
        end
    end
    idx=zeros(count,1);
    paras=zeros(count,paralen);    
    newcount=1;
    for y=1:Y
        for x=1:X
            if para1(x)>=para2(y) && ~isBoll
                continue
            end
            idx(newcount,:)=(y-1)*X+x;
            paras(newcount,:)=[para1(x),para2(y)];
            newcount=newcount+1;
        end
    end
end