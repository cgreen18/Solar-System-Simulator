%Gets data on the radius, rotation speed, and image to use from the user
%Plots it in a subplot

function getData2(hObject,eventdata,handles,planetMat)   

global imCounter;   %index of image to use within cell array images
imCounter = 1;

planetMat = [planetMat; zeros(1,8)];   %create a default zero row in planetMat for this new planet
planetMat(end,8) = imCounter;


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
global images;
images = {water,venus,earth,earthMoon,sun,moon1,moon2,moon3,moon4,moon5,moon6,moon7,moon8,moon9};
for i = 1:length(images)
   images{i} = imresize(images{i},[500 500]);   %normalize size to 500x500 (x3)
end

%%
%create figure and UIControls
%figure
fig2Handle = figure('Name','Planet description');

%radius slider
radSlid = uicontrol(fig2Handle,'Style','slider','Min',1000,...
    'Max',25000,'Value',7500,'Position',[200 325 30 80],'SliderStep',[.1 .1]);
radText1 = uicontrol('style','text','String','Slide the bar to modify the radius (mi). i.e. Earth''s is 4,000 mi.',...
    'Position',[15 370 175 35]);
radsprintf = sprintf('The current radius is: %i mi',get(radSlid,'Value'));
radText2 = uicontrol('style','text','String',radsprintf,'Position',[15 320 150 35]);
planetMat(end,2) = get(radSlid,'Value');

%rotation speed slider
rotatSlid = uicontrol(fig2Handle,'Style','slider','Min',.5,...
    'Max',30,'Value',10,'Position',[200 225 30 80],'Sliderstep',[.1 .1]);
rotatText1 = uicontrol('style','text','String','Slide the bar to modify the speed of rotation in rotations per five minutes (1-60) ',...
    'Position',[15 250 175 50]);
rotatsprintf = sprintf('The current rotation speed is: %2.1f rpm',get(rotatSlid,'Value')/5);
rotatText2 = uicontrol('style','text','String',rotatsprintf,'Position',[15 220 150 35]);
planetMat(end,6) = get(rotatSlid,'Value');

%change image pushbutton
imagePop = uicontrol(fig2Handle,'Style','pushbutton','String','Different Image',...
    'Position',[10 150 100 50],'Callback',@newImage);

%move on to getdata3
orbitPush = uicontrol(fig2Handle,'Style','pushbutton','String','Describe Orbit',...
    'Position', [10 10 100 50],'Callback',{@getdata3,handles,planetMat,fig2Handle});

drawnow;
%%

%creates subplot
plot2 = subplot(1,2,2);
plot3(1,1,1);
xlim([-30000,30000]);
ylim([-30000,30000]);
zlim([-30000,30000]);
plot2.Color = 'k';
plot2.Box = 'off';

%reference sphere
[X Y Z] = sphere;
 
%simulation for loop
for v = 2*pi:(pi/220):2000*pi
    
    radius = get(radSlid,'Value'); %get current radius value
    radsprintf = sprintf('The current radius is: %i mi',round(radius));  
    set(radText2,'String',radsprintf);    %update textbox
    
    rotationSpeed = get(rotatSlid,'Value');  %get current rotation value
    rotatsprintf = sprintf('The current rotation speed is: %2.1f rpm',round(rotationSpeed)/5);
    set(rotatText2,'String',rotatsprintf);  %update textbox
    
    planet = surface(radius*X,radius*Y,radius*Z);   %recreate surface
   
    %columns describe... [center, radius, apoapsis, periapsis, semi-Minor, dayLength, yearLength]
    
    %update planetMat
    planetMat(end,2) = radius;
    planetMat(end,6) = rotationSpeed;
    planetMat(end,8) = imCounter;
    %update the callback so that it passes the updated planetMat
    set(orbitPush,'Callback',{@getdata3,handles,planetMat,fig2Handle});

    %reset image on planet based on imCounter
    set(planet,'FaceColor','texture','cdata',...
       im2double(images{imCounter}),'EdgeColor','none');   
   
   %rotate planet based on time (v) and the rotation speed
   set(planet,'facecolor','texture',...
                 'cdata',circshift(im2double(images{imCounter}),...
                 [0, round(length(images{imCounter})*(v*(rotationSpeed/2.1)/(2*pi))) 0]),...   
                 'edgecolor','none');

   drawnow;
   
end


%callback for the different image pushbutton
%increments the global variable imCounter by +1
function newImage(hObject,handles,eventdata)
    imCounter = imCounter + 1;
    if (imCounter > length(images))
        imCounter = 1;
    end
end

end


