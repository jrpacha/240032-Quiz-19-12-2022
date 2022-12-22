function [nod, elem]=generaReixa(width,high)
if (mod(width,2)==0 || mod(high,2)==0 )
    disp('STOP: width and high must be even numbers');
    return;
end
nodx=-width/2:width/2; 
nody=-high/2:high/2;
npfilesx=length(nodx)/2;
npfilesy=length(nody)/2;
nod=[];
kj=0;
ki=0;
for j=1:length(nody)
    if(mod(j,2)==0)
        for i=1:2:length(nodx)            
            nod=[nod; nodx(i), nody(j)];
        end
    else
        for i=2:2:length(nodx)
            nod=[nod; nodx(i), nody(j)];
        end
    end
end
%elements
elem=[];
for i=1:length(nody)-1
    for j=1:npfilesx
        if(mod(i,2)==0) 
            if (j==1)
                elem=[elem; (i-1)*npfilesx+j, i*npfilesx+j];
            else
                elem=[elem; (i-1)*npfilesx+j,i*npfilesx+j-1];
                elem=[elem; (i-1)*npfilesx+j, i*npfilesx+j];
            end

        else
            if (j==npfilesx)
                elem=[elem; (i-1)*npfilesx+j, i*npfilesx+j];
            else
                elem=[elem; (i-1)*npfilesx+j,i*npfilesx+j];
                elem=[elem; (i-1)*npfilesx+j, i*npfilesx+j+1];
            end
        end
    end
end