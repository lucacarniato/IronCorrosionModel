% Copyright (c) 2019 Luca Carniato

% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:

% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.

% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

function f=functn(nopt,x)
load INPUT;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BATCH{37}=['-parms ' num2str(10^x(1)) ' ' num2str(10^x(2)) ' ' num2str(ic)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%number of group measuraments
ngrp=size(M,2)-1;
%write input file
fid=fopen('BATCH_IN.txt', 'w+');
for i=1:size(BATCH,1)
    fprintf(fid,'%s\n',BATCH{i});
end
fclose(fid);
%run the model
[s,w]=dos('RUN.bat');
%import results
sim=importdata('conc.txt');sim=sim.data;
for i=2:size(M,1) %for all the measuraments
    ind=find(sim(:,1)==M(i,1));
    for j=1:ngrp
        if isempty(ind)==0&&isnan(M(i,j+1))==0
            s=s+1;
            if j==1
            r(s)=(log(M(i,j+1))-log(sim(ind,j+1)))^2; %log transform H2
            else
            r(s)=(M(i,j+1)-sim(ind,j+1))^2;           %Do not log transform pH
            end
        end
    end
end
f=sum(r);
end


