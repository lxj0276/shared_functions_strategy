function[positions]=calc_positions(signals,type)
% type=-1 short only : if the first sig is buy then it will be ignored
% type=1 long only : if the first sig is sell then it will be ignored
% type=0 long short
% works ONLY for the type of signal£º1 -1 1 -1 ...,not 1 1 ... or -1 -1 ...

N=length(signals);
positions=zeros([N,1]);
sigpos=find(signals~=0);
if ~isempty(sigpos)
    firstsig=signals(sigpos(1));
    count=(firstsig==-1);
    len=length(sigpos);
    for i=1:len
        if i==len
            End=N;
        else
            End=sigpos(i+1);
        end
        positions((sigpos(i)+1):End)=(-1)^count;
        if signals(sigpos(i))~=signals(End)
            count=count+1;
        end
    end
    idx=(positions~=0);
    positions(idx)=(positions(idx)+type)/(1+(type~=0));
end