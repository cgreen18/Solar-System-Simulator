function beginSim(hObject,eventdata,handles,planetMat,fig3Handle)

close(fig3Handle);
%% Data
 
    % Input Data
 
        
% initial setting
 
C = planetMat(:,1);            % Center of Planet orbit
R =  planetMat(:,2);             % Mean Radius (of planet or moon)
Ap = planetMat(:,3);           % Apoapsis (furthest point in orbit) (measured from surface of planet)
Per = planetMat(:,4);   % Periapsis (closest point in orbit) (measured from surface of planet)
SMin = planetMat(:,5);   %Semi-minor
dayL = planetMat(:,6);   %day length or rotation speed
yearL = planetMat(:,7);   %year length or orbit period

   
t = .01:.01:400*pi;    %base time

%adjustments

SMaj = (Ap + Per)/2;    %average between ap and per

U = [1, 0, 0];  % Semi-Major Axis direction (unit vector)
NV = [0,0,1];  % Normal vector to elliptical plane (unit vector)
V = cross(NV,U);

[X,Y,Z]=sphere;    % Reference sphere     
 
 
  cla(handles.axes1)
 axes(handles.axes1)
              
xPoints = [];
yPoints = [];
zPoints = [];
%%
%calculating orbit for each planet
for n =1:length(SMaj)
    xPoints = [xPoints;C(n)+ SMaj(n) * cos(t/yearL(n)) * U(1) + SMin(n) * sin(t/yearL(n)) * V(1)+((Ap(n)-Per(n))/2)];
    
    yPoints = [yPoints; C(n)+ SMaj(n) * cos(t/yearL(n)) * U(2) + SMin(n) * sin(t/yearL(n)) * V(2)];
    zPoints =[zPoints; C(n)+ SMaj(n) * cos(t/yearL(n)) * U(3) + SMin(n) * sin(t/yearL(n)) * V(3)];
end

%plot the orbits
for v=1:length(SMaj)
    plot3(xPoints(v,:),yPoints(v,:),zPoints(v,:));
    hold on;
end
%%

%set axes based on values
[maxSMAJ,maxIndex] = max(SMaj);
[maxAp, maxApInd] = max(Per);
maxSMin = max(SMin)
if(maxAp > 100000)
    axesLims = [-maxAp - (maxAp/5),maxAp+(maxAp/5)]
elseif(maxSMAJ > 200000)
    axesLims = [-maxSMAJ - (maxSMAJ/5),maXSMAJ+(maxSMAJ/5)];
elseif(maxSMin > 100000)
    axesLims = [-maxSMin - (maxSMin/5),maxSMin + (maxSMin/5)];
else
   axesLims = [-120000,120000];
end

%set axes
xlim(axesLims);
ylim(axesLims);
zlim(axesLims);
axis on;
box off;
handles.axes.XColor = [1,1,1];
handles.axes.YColor = [1,1,1];
handles.axes.ZColor = [1,1,1];
set(handles.axes1,'color',[0,0,0]);

hold on;    
planetBin = [];

%load images
water = imread('water.jpg');
venus= imread('venus.jpg');
earth = imread('Earth2.jpg');
earthMoon =imread('earthmoon.jpg');
sun = imread('sun.jpg');
moon1 = imread('moon1.jpg');
moon2 =imread('Mmoon.jpg');
moon3 = imread('Nmoon1.jpg');
moon4 = imread('jmoon1.jpg');
moon5 = imread('jmoon2.jpg');
moon6 = imread('jmoon3.jpg');
moon7 = imread('jmoon4.jpg');
moon8 = imread('jmoon14.jpg');
moon9 = imread('jupiter.jpg');
images = {water,venus,earth,earthMoon,sun,moon1,moon2,moon3,moon4,moon5,moon6,moon7,moon8,moon9};
for i = 1:length(images)
   images{i} = imresize(images{i},[500 500]);   %normalize size to 500x500 (x3)
end
%%
%put the right image onto each planet (surface)
for b =1:length(SMaj)
   planetBin(b) = surface(R(b)*X,R(b)*Y,R(b)*Z);
   set(planetBin(b),'FaceColor','texture','cdata',im2double(images{b}),'EdgeColor','none');
end
%%
%simulation for loop
for v = 2*pi:(pi/220):2000*pi
    
    %time shift based on GUI speed slider
     quickShift = get(handles.speedSlider,'Value'); 
     pause((3.05- quickShift)/5);   %1-3   
 
     %magnification shift based on GUI magnification slider
     magnif = get(handles.sizeSlider,'Value');
     newAxesLims = axesLims-axesLims*((magnif-2)/1.5);
     xlim(newAxesLims);
     ylim(newAxesLims);
     zlim(newAxesLims);  
    
     %iterates through each planet
  for b=1:length(SMaj)
      %moves planet along orbit
    set(planetBin(b),'xdata',R(b)*X +xPoints(b,round(v*yearL(b)*220)),...
            'ydata',R(b)*Y +yPoints(b,round(v*yearL(b)*220)),'zdata',R(b)*Z +zPoints(b,round(v*yearL(b)*220)));
     
        %rotates image on planet
        set(planetBin(b),'facecolor','texture',...
                 'cdata',circshift(im2double(images{planetMat(b,8)}),...
                 [0, round(length(images{planetMat(b,8)})*(v*(dayL(b)/2.1)/(2*pi))) 0]),...
                 'edgecolor','none');
        drawnow;   
        
  end

end



%%                                  
 