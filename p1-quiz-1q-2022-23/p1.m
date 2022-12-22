clearvars
close all

%Geometry
width=19;    %cm
height=11;   %cm
Force=12;    %N

[nodes,elem]=generaReixa(width,height);

numNod=size(nodes,1);
numElem=size(elem,1);
ndim=size(nodes,2);
  
numbering=0;
plotElementsOld(nodes, elem, numbering);
hold on
%Select the nodes
nodesLeft = find(nodes(:,1) < -8.99);
nodesRight = find(nodes(:,1) > 8.99);
nodesTop = find(nodes(:,2) > 4.99);
nodesBot = find(nodes(:,2) < -4.99);

plot(nodes(nodesLeft,1),nodes(nodesLeft,2),'o','MarkerFaceColor','red',...
    'markersize',10)
plot(nodes(nodesRight,1),nodes(nodesRight,2),'o','MarkerFaceColor','green',...
    'markerSize',10)
plot(nodes(nodesTop,1),nodes(nodesTop,2),'o','MarkerFaceColor','blue',...
    'markerSize',10)
plot(nodes(nodesBot,1),nodes(nodesBot,2),'o','MarkerFaceColor','magenta',...
    'markerSize',10)
hold off

%%
%Real constants: Materials and sections area
Area=0.2;        %section Area (in mm^2)
Y=10065.0;       %Young modulus, in N/cm^2    
A=Area*ones(1,numElem);
E=Y*ones(1,numElem);

%Assembly
u=zeros(ndim*numNod,1);
Q=zeros(ndim*numNod,1);
K=zeros(ndim*numNod);

for e=1:numElem
    Ke=planeLinkStiffMatrix(nodes,elem,e,E,A);
    rows=[ndim*elem(e,1)-1,ndim*elem(e,1),ndim*elem(e,2)-1,ndim*elem(e,2)];
    cols=rows;
    K(rows,cols)=K(rows,cols)+Ke; %Assembly
end

%BC
%Natural B.C.: Loads
Q(2*nodesRight-1) = Force;

%Essential B.C.
fixedNods=[2*nodesLeft'-1, 2*nodesLeft', 2*nodesTop', 2*nodesBot'];
fixedNods=unique(fixedNods);
u(fixedNods)=0;

%Reduced system
freeNods=setdiff(1:ndim*numNod,fixedNods);
Qm=Q(freeNods,1)-K(freeNods,fixedNods)*u(fixedNods);
Km=K(freeNods,freeNods);

%Solve the reduced system
um=Km\Qm;
u(freeNods)=um;

%Print out displacements
displacements = [u(1:2:end),u(2:2:end)];

%Post-process
%Show the original structure and the deformed one
esc=5; %scale factor to magnify displacements
%plotPlaneNodElemDespl(nodes, elem, u, esc)
plotDeformedTruss(nodes, elem, u, esc)
[val,idx]=max(displacements); %compute the maximum value for the
                              %components of each column and gives
                              %that component of the column 

fprintf('Part (a)\n')                             
fprintf('The maximum x-displacement is: %11.4e, (at Node:%2d)\n',...
    val(1),idx(1))
fprintf('Hint: the maximum y-displacment is: %11.4e, (at Node:%2d)\n\n',...
    val(2),idx(2))

%Reaction forces
R = K*u-Q;
reactForces = [R(1:2:end),R(2:2:end)];
normReactForces = sqrt(reactForces(:,1).^2 + reactForces(:,2).^2);
avReactForcesX = sum(reactForces(:,1))/numNod;
fprintf('Part (b)\n')
fprintf('The maximum modulus of the reacton forces |Fr| is: %11.4e\n',...
    max(normReactForces))
fprintf('Hint. The mean value of the x-reaction force is: %11.4e\n\n',...
    avReactForcesX)

Stress = linkAxialStress(nodes,elem,u,E,A);
avStress = sum(Stress)/numElem;
fprintf('Maximum value of the stress: %11.4e\n',max(Stress))
fprintf('Hint. The mean value of the stress vector is: %11.4e\n',...
    avStress)
