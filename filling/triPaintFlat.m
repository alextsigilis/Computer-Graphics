function Y = triPaintFlat(X, V, C)

N = size(X,2);
Y = X;

% Compute the flat colour 
% as the median of the colours of the verices
colour = mean(C,1);

% Sort the vertices by ascending ordinate.
[~,I] = sort(V(:,2));
V = V(I,:);

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

% Compute the slope coefficients for each edge
m = ( circshift(V(:,2),-1) - V(:,2) ) ./ ( circshift(V(:,1),-1) - V(:,1) );

% Initialize active point and edge list
%       If there is a top horizontal edge
Q = [];
if sum(ykmin==ymin) == 3
    Q = [3 V(1,1); 2 V(2,1)];
else
    Q = [1 V(1,1); 3 V(1,1)];
end

for y=ymin:ymax
    
    % Sort by x-coordinate of active point
    [~,I] = sort(Q(:,2));
    Q = Q(I,:);
    
    x1 = round(Q(1,2));
    x2 = round(Q(2,2));
    for x=x1:x2
        Y(y,x,:) =  colour;
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
