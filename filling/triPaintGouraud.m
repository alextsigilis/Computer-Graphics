function Y = triPaintGouraud(X, V, C)

Y = X;

[M,N] = size(X);

% Sort the vertices by ascending ordinate.
[~,I] = sort(V(:,2));
V = V(I,:);
C = C(I,:);

% Compute ykmin, ykmax, xkmin, xkmax
ykmin = min([V(:,2) circshift(V(:,2),-1)], [], 2);
ykmax = max([V(:,2) circshift(V(:,2),-1)], [], 2);
xkmin = min([V(:,1) circshift(V(:,1),-1)], [], 2);
xkmax = max([V(:,1) circshift(V(:,1),-1)], [], 2);

% Compute the y_min, y_max and x_min, x_max
ymin = min(ykmin);
ymax = max(ykmax);
xmin = min(xkmin);
xmax = max(xkmax);

% Set the colours for each edge
edgeColor = zeros(3,2,3);

edgeColor(1,1,:) = C(1,:);
edgeColor(1,2,:) = C(2,:);

edgeColor(2,1,:) = C(2,:);
edgeColor(2,2,:) = C(3,:);

edgeColor(3,1,:) = C(1,:);
edgeColor(3,2,:) = C(3,:);

% Compute the slope coefficients for each edge
m = ( circshift(V(:,2),-1) - V(:,2) ) ./ ( circshift(V(:,1),-1) - V(:,1) );

% The active point & edge list
Q = [];

% If there is a top horizontal edge
if V(1,2) == V(2,2)
    % Initialize the active point & edge list
    Q = [3 V(1,1); 2 V(2,1)];
% Otherwise 
else
    % Initialize the active point & edge list
    Q = [1 V(1,1); 3 V(1,1)];
end




for y=ymin:ymax
    
    % Sort by x-coordinate of active point
    [~,I] = sort(Q(:,2));
    Q = Q(I,:);
    
    
    % Compute the color of the first active point.
    edgeA = Q(1,1);
    C1 = edgeColor(edgeA,1,:);
    C2 = edgeColor(edgeA,2,:);
    lambda = (ykmax(edgeA)-y) / (ykmax(edgeA)-ykmin(edgeA));
    A = lambda * C1 + (1-lambda)*C2;
    
    % Compute the color of the second active point.
    edgeB = Q(2,1);
    C1 = edgeColor(edgeB,1,:);
    C2 = edgeColor(edgeB,2,:);
    lambda = (ykmax(edgeB)-y) / (ykmax(edgeB)-ykmin(edgeB));
    B = lambda * C1 + (1-lambda)*C2;
    
    % Paint the triangle
    alpha = round(Q(1,2)); 
    beta = round(Q(2,2));
    
    Y(y,alpha,:) = A;
    Y(y,beta,:) = B;
    for x=round(alpha):round(beta)
        Y(y,x,:) = colorInterp(A,B,alpha,beta,x);
    end
    
    % Find edges to add and edges to remove
    ne = find(ykmin == y+1);
    re = find(ykmax == y+1);
    
    % Remove intersection points with removed edges.
    if size(re,1) == 1
        Q = Q( (Q(:,1)~= re), : );
    end
    
    % Update x-coordinate of remaining points
    Q(:,2) = Q(:,2) + 1 ./ m(Q(:,1));
    
    % Find the lower verteces of the new edges
    np = V(ne,1);
    
    % Add the new point to the list
    Q = [Q; ne np];
    
end

end
