clearvars
close all

[X,Y] = meshgrid(-5:0.5:5);
Z = zeros(size(X));
[elem,nodes] = surf2patch(X,Y,Z);
nodes = nodes(:,1:2);

kc1 = 0.74;
kc2 = 0.016;

tempLeft = -10;
tempRight  = 26;

elemN = 343;
nodHint = 111;

numNod=size(nodes,1);
numElem=size(elem,1);
%numbering=1;
numbering=0;
%figure()
plotElementsOld(nodes,elem,numbering);

indLeft=find(nodes(:,1) < -4.99);
indRight=find(nodes(:,1) > 4.99);
hold on
plot(nodes(indLeft,1),nodes(indLeft,2),'o','MarkerFaceColor','red',...
    'MarkerSize',10)
plot(nodes(indRight,1),nodes(indRight,2),'o','MarkerFaceColor','blue',...
    'MarkerSize',10)
hold off

% Part(a)
K=zeros(numNod);
F=zeros(numNod,1);
for e=1:numElem
    if e > 200
        a11 = kc2;
    else
        a11 = kc1;
    end
    a12 = 0; a21 = a12; a22 = a11; a00 = 0; f = 0;
    coeff = [a11,a12,a21,a22,a00,f];
    [Ke,Fe]=bilinearQuadElement(coeff,nodes,elem,e);
    %
    % Assemble the elements
    %
    rows=[elem(e,1); elem(e,2); elem(e,3); elem(e,4)];
    colums= rows;
    K(rows,colums)=K(rows,colums)+Ke; %assembly
    if (coeff(6) ~= 0)
        F(rows)=F(rows)+Fe;
    end
end 

%Boundary Conditions (BC)
%Impose Boundary Conditions for this example. In this case only essential 
%and natural BC are considered. We will do a thermal example for convection 
%BC (mixed).
%indRigth=[3;6;9];
%indLeft=[1;4;7];

fixedNodes=[indLeft',indRight']; %Fixed Nodes (global num.)
freeNodes = setdiff(1:numNod,fixedNodes); %Complementary of fixed nodes

% ------------ Natural BC
Q=zeros(numNod,1); %initialize Q vector
Q(freeNodes)=0; %all of them are zero


% ------------ Essential BC
u=zeros(numNod,1); %initialize u vector
u(indRight)=tempRight; %all of them are zero
u(indLeft)=tempLeft;
Fm=F(freeNodes)-K(freeNodes,fixedNodes)*u(fixedNodes);%here u can be 
                                                      %different from zero 
                                                      % modify the linear system, this is only valid if BC = 0.
%Reduced system
Km=K(freeNodes,freeNodes);
Fm=Fm+Q(freeNodes);%only for fixed nodes
%Compute the solution
%solve the System
um = Km\Fm;
u(freeNodes) = um;

nodsElemN = elem(elemN,:);
meanTempElemN = sum(u(nodsElemN))/size(elem,2);

fprintf('Part (a)\n')
fprintf('Average temperature of element %d: %11.4e\n',...
    elemN,meanTempElemN)
fprintf('Hint. the temperature at node %d is: %11.4e\n',nodHint,u(nodHint))


clear K F Q u;
% Part (b)
K=zeros(numNod);
F=zeros(numNod,1);
for e=1:numElem
    if e > 300
        a11 = kc2;
    else
        a11 = kc1;
    end
    a12 = 0; a21 = a12; a22 = a11; a00 = 0; f = 0;
    coeff = [a11,a12,a21,a22,a00,f];
    [Ke,Fe]=bilinearQuadElement(coeff,nodes,elem,e);
    %
    % Assemble the elements
    %
    rows=[elem(e,1); elem(e,2); elem(e,3); elem(e,4)];
    colums= rows;
    K(rows,colums)=K(rows,colums)+Ke; %assembly
    if (coeff(6) ~= 0)
        F(rows)=F(rows)+Fe;
    end
end 

%Boundary Conditions (BC)
%Impose Boundary Conditions for this example. In this case only essential 
%and natural BC are considered. We will do a thermal example for convection 
%BC (mixed).
%indRigth=[3;6;9];
%indLeft=[1;4;7];

fixedNodes=[indLeft',indRight']; %Fixed Nodes (global num.)
freeNodes = setdiff(1:numNod,fixedNodes); %Complementary of fixed nodes

% ------------ Natural BC
Q=zeros(numNod,1); %initialize Q vector
Q(freeNodes)=0; %all of them are zero


% ------------ Essential BC
u=zeros(numNod,1); %initialize u vector
u(indRight)=tempRight; %all of them are zero
u(indLeft)=tempLeft;
Fm=F(freeNodes)-K(freeNodes,fixedNodes)*u(fixedNodes);%here u can be 
                                                      %different from zero 
                                                      % modify the linear system, this is only valid if BC = 0.
%Reduced system
Km=K(freeNodes,freeNodes);
Fm=Fm+Q(freeNodes);%only for fixed nodes
%Compute the solution
%solve the System
um = Km\Fm;
u(freeNodes) = um;

nodsElemN = elem(elemN,:);
meanTempElemN = sum(u(nodsElemN))/size(elem,2);

fprintf('Part (b)\n')
fprintf('Average temperature of element %d: %11.4e\n',...
    elemN,meanTempElemN)
fprintf('Hint. the temperature at node %d is: %11.4e\n',nodHint,u(nodHint))