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

clc
clear all
close all

OPT={'Z', 'H'}; % optimize Zurzach and Hungary batches
PL=0;           % PL = 0 optimize geochemical parameters no plot, PL = 1 plot of the optimized parameters  

%The parameters
%Zurzach
Z.X0=[-11 -11.78]; %corrosion (Rapp), Equilibrium constant(KirC)
Z.BL=[-14 -25];    
Z.BU=[-7  -8];

%Hungary
H.X0=[-11 -11.78];     
H.BL=[-14 -25];
H.BU=[-7  -8];

%The measuraments 
%Zurzach
Z.M(:,1)=[0      7      14     28     49     105];     %DAYS
Z.M(:,2)=[0.00   2.88   7.08   11.36  13.26  22.16];   %H2 headspace
Z.M(:,3)=[7.8850 7.5100 8.0950 7.8600 8.1900 8.1550];  %pH 

%Hungary
H.M(:,1)=[0      7      14     28     49      105  ];  %DAYS
H.M(:,2)=[0.00   5.41   6.69   18.14  16.60   25.48];  %H2 headspace
H.M(:,3)=[7.5400 7.7550 7.4600 7.1000 7.2050  6.8900]; %pH

%    initial pH,    pe,      ironcontent (gFe0), water,   Cl,         S6,          C
Z.I=[7.8850     1.959459E+00 9.810390E-02       0.075347 6.305000E+00 4.775500E+01 4.270000E+01];       
H.I=[7.5400     2.314189E+00 9.950940E-02       0.075243 4.400000E+00 5.737850E+02 9.912500E+01];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% do not modify below, unless you know what you are doing...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

maxn=100000;
kstop=10;
pcento=0.1;
peps=0.001;
iseed=-1;
iniflg=0;
ngs=2;
positionVector(1,:)=[0.08 0.08 0.35 0.82];
positionVector(2,:)=[0.58 0.08 0.35 0.82];
if PL==1
load 'BPAR'   % the vector with the optimized parameters  
graphwid=18.5; %18.5, TOC Art 25 
graphhei=9;   %15.5 for 4 rows/14 for 3 rows/9 for 2 rows/6 single row /TOC 11
fsize=8;
figure('Name','Zurzach-Hungary','NumberTitle','off','PaperSize', [graphwid graphhei],'PaperPositionMode','manual');%'Visible','off'
set(gcf, 'Color', 'w');
end
for nstep=1:length(OPT)
load BATCH_SZ %the file containing the phreeqc input template
%change pH,pe,ironcontent in the input file
BATCH{3}=horzcat('pH ',num2str(eval(horzcat(OPT{nstep},'.I(1)'))));
BATCH{4}=horzcat('pe ',num2str(eval(horzcat(OPT{nstep},'.I(2)'))));
ftime=(eval(horzcat(OPT{nstep},'.M(end,1)')));
BATCH{33}=horzcat('-step ',num2str(ftime*86400,'% .0f'),' in ',num2str(ftime,'% .0f'));
BATCH{6}=horzcat('-water ',num2str(eval(horzcat(OPT{nstep},'.I(4)'))));
BATCH{8}=horzcat('Cl ',num2str(eval(horzcat(OPT{nstep},'.I(5)'))));
BATCH{9}=horzcat('S(6) ',num2str(eval(horzcat(OPT{nstep},'.I(6)'))));
BATCH{10}=horzcat('C ',num2str(eval(horzcat(OPT{nstep},'.I(7)'))));
%evaluate measuraments and fixed parameters
M=eval(horzcat(OPT{nstep},'.M'));
ic=eval(horzcat(OPT{nstep},'.I(3)'));
if PL==0
%evaluate PARAMETERS
x0=eval(horzcat(OPT{nstep},'.X0'));
bl=eval(horzcat(OPT{nstep},'.BL'));
bu=eval(horzcat(OPT{nstep},'.BU'));
%save informations
save('INPUT','BATCH','M','ic');
%run optimization
[bestx,bestf] = sceua(x0,bl,bu,maxn,kstop,pcento,peps,ngs,iseed,iniflg);
%update array
if exist('BPAR')==1;
    load 'BPAR'; 
end
eval(horzcat('BPAR.',OPT{nstep},' = bestx;'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear 'x0'
clear 'bl'
clear 'bu'
clear 'M'
clear 'ic'
save('BPAR','BPAR')
else
%plot stuff
x(1)=eval(horzcat('BPAR.',OPT{nstep},'(1);'));
x(2)=eval(horzcat('BPAR.',OPT{nstep},'(2);'));
% experiment specific variables
BATCH{3}=horzcat('pH ',num2str(eval(horzcat(OPT{nstep},'.I(1)'))));
BATCH{4}=horzcat('pe ',num2str(eval(horzcat(OPT{nstep},'.I(2)'))));
ftime=(eval(horzcat(OPT{nstep},'.M(end,1)')));
BATCH{33}=horzcat('-step ',num2str(ftime*86400,'% .0f'),' in ',num2str(ftime,'% .0f'));
BATCH{6}=horzcat('-water ',num2str(eval(horzcat(OPT{nstep},'.I(4)'))));
BATCH{8}=horzcat('Cl ',num2str(eval(horzcat(OPT{nstep},'.I(5)'))));
BATCH{9}=horzcat('S(6) ',num2str(eval(horzcat(OPT{nstep},'.I(6)'))));
BATCH{10}=horzcat('C ',num2str(eval(horzcat(OPT{nstep},'.I(7)'))));
% parameters
%BATCH{37}=['-parms ' num2str(10^x(1)) ' 1.659587E-12 ' num2str(ic)];
BATCH{37}=['-parms ' num2str(10^x(1)) ' ' num2str(10^x(2)) ' ' num2str(ic)];
OPT{nstep}
cr=10^x(1)*1000*86400*1000
%keq=10^x(2)
lifetime=(1/55.845)/(10^x(1))/(86400*365)
%write input file
fid=fopen('BATCH_IN.txt', 'w+');
for i=1:size(BATCH,1)
    fprintf(fid,'%s\n',BATCH{i});
end
fclose(fid);
%run the model
[s,w]=dos('RUN');
%import results
sim=importdata('conc.txt');sim=sim.data;
%axeses limitis
h2l=[0 30];
%h2l=[0 max(max(sim(:,2)),max(M(:,2)))*1.1];
phl=[3 10]; %phl=[4 max(max(sim(:,3)),max(M(:,3)))*1.1];
dlim=[0 ftime*1.1];
%plot data
subplot('Position',positionVector(nstep,:))
[haxes,hline1,hline2] = plotyy(sim(:,1),sim(:,2),sim(:,1),sim(:,3),'plot');   %H2, pH
set(haxes,{'ycolor'},{'k';'k'});
set(hline1,'LineStyle','-','Color','k');
set(hline2,'LineStyle','--','Color','k');
% FIRST AXSES
set(haxes(1),'YLim',h2l);
set(haxes(1),'XLim',dlim);
set(haxes(1),'YTick',[]);
% SECOND AXSES
set(haxes(2),'YLim',phl);
set(haxes(2),'XLim',dlim);
set(haxes(2),'YTick',[]);
clear 'sim'
hold on
[haxes,hline1,hline2] = plotyy(M(:,1),M(:,2),M(:,1),M(:,3));                    %H2,pH
set(haxes,{'ycolor'},{'k';'k'});
set(hline1,'LineStyle','none','Marker','+','MarkerEdgeColor','k','MarkerFaceColor','k');
set(hline2,'LineStyle','none','Marker','*','MarkerEdgeColor','k','MarkerFaceColor','k');
% FIRST AXSES
set(haxes(1),'YLim',h2l);
set(haxes(1),'XLim',dlim);
set(haxes(1),'YTick',[h2l(1):ceil(h2l(2)/5):h2l(2)]); %H2
% SECOND AXSES
set(haxes(2),'YLim',phl);
set(haxes(2),'XLim',dlim);
set(haxes(2),'YTick',[phl(1):1:phl(2)]);%PH
% REMOVE TICK MARKS
set(haxes(1),'Box','Off')
set(haxes(2),'Box','Off')
%AXES LABELS
set(get(haxes(1),'Ylabel'),'String','mL H_2 headspace','fontsize',fsize);
set(get(haxes(2),'Ylabel'),'String','pH','fontsize',fsize);
set(get(haxes(1),'Xlabel'),'String','days','fontsize',fsize);
title(OPT{nstep},'fontsize',fsize,'FontName','Times')
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%save bplot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if PL==0
save('BPAR','BPAR');
else
% saveas(gcf, 'test.emf')
% export_fig test2.emf -painters -m3.125
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%