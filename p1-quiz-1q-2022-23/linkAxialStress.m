function Stress = linkAxialStress(nodes,elem,u,E,A)
% u --> displacement vector
% E --> Young modulus
% A --> element section Area

ndim = size(nodes,2);
numElem = size(elem,1);
Forces = zeros(1,numElem);
Stress = zeros(1,numElem);

for e = 1:numElem
    x1 = nodes(elem(e,1),1);   %node coordinates
    x2 = nodes(elem(e,2),1);
    y1 = nodes(elem(e,1),2);
    y2 = nodes(elem(e,2),2); 
    ux1 = u(elem(e,1)*ndim-1); %node displacements
    uy1 = u(elem(e,1)*ndim);
    ux2 = u(elem(e,2)*ndim-1);
    uy2 = u(elem(e,2)*ndim);
    % vector components  
    x21 = x2-x1;
    y21 = y2-y1;
    Le = sqrt(x21*x21+y21*y21); %element length
    ux21 = ux2-ux1;
    uy21 = uy2-uy1;
    %projection of the relative displacement on the element axis
    d = (x21*ux21+y21*uy21)/Le; 
    Forces(e) = E(e)*A(e)*d/Le;
    Stress(e) = Forces(e)/A(e);
 end