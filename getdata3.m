%Gets data from the user on the orbit dimensions and the period of the
%planet
%Plots the orbit in a subplot

function getdata3(hObject,eventdata,handles,planetMat,fig2Handle)

%close the last figure
close(fig2Handle);

%create a new figure
fig3Handle = figure('Name','Planet description');

%right/apoapsis slider
apSlid = uicontrol(fig3Handle,'Style','slider','Min',0,...
    'Max',300000,'Value',75000,'Position',[200 335 30 70],'SliderStep',[.1 .1]);
apText1 = uicontrol('style','text','String','Slide the bar to modify the "right" distance',...
    'Position',[15 370 175 35]);
apsprintf = sprintf('The current "right" distance is: %i mi',get(apSlid,'Value'));
apText2 = uicontrol('style','text','String',apsprintf,'Position',[15 340 150 35]);
planetMat(end,3) = get(apSlid,'Value');

%left/periapsis slider
perSlid = uicontrol(fig3Handle,'Style','slider','Min',0,...
    'Max',300000,'Value',75000,'Position',[200 250 30 70],'Sliderstep',[.1 .1]);
perText1 = uicontrol('style','text','String','Slide the bar to modify the "left" distance',...
    'Position',[15 270 175 50]);
persprintf = sprintf('The current "left" distance is %i mi',get(perSlid,'Value'));
perText2 = uicontrol('style','text','String',persprintf,'Position',[15 255 150 35]);
planetMat(end,4) = get(perSlid,'Value');

%semi-minor axis slider
sminSlid = uicontrol(fig3Handle,'Style','slider','Min',0,...
    'Max',300000,'Value',75000,'Position',[200 165 30 70],'Sliderstep',[.1 .1]);
sminText1 = uicontrol('style','text','String','Slide the bar to modify the semi-minor axis ("width" of ellipse)',...
    'Position',[15 180 175 50]);
sminsprintf = sprintf('The current semi-minor axis is %i mi',get(sminSlid,'Value'));
sminText2 = uicontrol('style','text','String',sminsprintf,'Position',[15 165 150 35]);
planetMat(end,5) = get(sminSlid,'Value');

%orbit period slider
yearSlid = uicontrol(fig3Handle,'Style','slider','Min',.01,...
    'Max',2,'Value',1,'Position',[200 80 30 70],'Sliderstep',[.01 .1]);
yearText1 = uicontrol('style','text','String','Slide the bar to modify the length of a year in orbits per minute',...
    'Position',[15 100 175 50]);
yearsprintf = sprintf('The current year length is %2.2f orbits per minute',get(yearSlid,'Value'));
yearText2 = uicontrol('style','text','String',yearsprintf,'Position',[15 80 150 35]);
planetMat(end,7) = get(yearSlid,'Value');

%another planet pushbutton
newPlanPush = uicontrol(fig3Handle,'Style','pushbutton','String','Make another planet!',...
    'Position', [10 10 100 50],'Callback',{@getData2,handles,planetMat});

%begin simulation pushbutton
beginSimPush = uicontrol(fig3Handle,'Style','pushbutton','String','Begin Simulation!',...
    'Position', [150 10 100 50],'Callback',{@beginSim,handles,planetMat,fig3Handle});


%creates subplot
plot2 = subplot(1,2,2);
plot3(1,1,1);
xlim([-3000000,3000000]);
ylim([-3000000,3000000]);
zlim([-3000000,3000000]);
plot2.Color = 'k';
plot2.Box = 'off';
xPoints = [];
yPoints = [];
zPoints = [];

%calculations for plotting
SMaj = (planetMat(end,3) + planetMat(end,4))/2;    %average between ap and per

U = [1, 0, 0];  % Semi-Major Axis direction (unit vector)
NV = [0,0,1];  % Normal vector to elliptical plane (unit vector)
V = cross(NV,U);

%basic numbers for timing in plotting
yearL = 100;
t = 0:.5:100*2*pi;

for v =1:1000
   
    %update textboxes
    apsprintf = sprintf('The current apoapsis is: %i mi',get(apSlid,'Value'));
    set(apText2,'String',apsprintf);
    persprintf = sprintf('The current periapsis is %i mi',get(perSlid,'Value'));
    set(perText2,'String',persprintf);
    sminsprintf = sprintf('The current semi-minor axis is %i mi',get(sminSlid,'Value'));
    set(sminText2,'String',sminsprintf);
    yearsprintf = sprintf('The current year length is %2.2f orbits per minute',get(yearSlid,'Value'));
    set(yearText2,'String',yearsprintf);
    
    %update planetMat
    planetMat(end,3) = get(apSlid,'Value');
    Ap = planetMat(end,3);
    planetMat(end,4) = get(perSlid,'Value');
    Per = planetMat(end,4);
    planetMat(end,5) = get(sminSlid,'Value');
    SMin = planetMat(end,5);
    SMaj = (planetMat(end,3) + planetMat(end,4))/2; 
    yearL = get(yearSlid,'Value');
    planetMat(end,7) = yearL;
    set(newPlanPush,'Callback',{@getData2,handles,planetMat});
    set(beginSimPush,'Callback',{@beginSim,handles,planetMat,fig3Handle});

    %replot points based on values from sliders
    xPoints = SMaj * cos(t/yearL) * U(1) + SMin * sin(t/yearL) * V(1)+((Ap-Per)/2);
    yPoints = SMaj * cos(t/yearL) * U(2) + SMin * sin(t/yearL) * V(2);
    zPoints = SMaj * cos(t/yearL) * U(3) + SMin * sin(t/yearL) * V(3);
    
   
    %plot the points 
    plot3(xPoints,yPoints,zPoints,'w');
    xlim([-300000,300000]);
    ylim([-300000,300000]);
    zlim([-300000,300000]);
    plot2.Color = 'k';
    plot2.Box = 'off';
    
    drawnow;
    
    
    
end


end