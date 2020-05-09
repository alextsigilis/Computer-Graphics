function I = paintObject(V,F,C,D,painter)

M = 1200; N = 1200;

L = size(V,1);
K = size(F,1);

I = ones(M,N,3);

% Sort the triangle by depth
depth = zeros(K,1);
depth(:) = mean( D(F(:,:)), 2);                 % The depth of a triangle is the mean of the depths of it's verices.
[depth, ord] = sort(depth,'descend');			% Sort the depth in ascending order.
F = F(ord,:);                                   % Sort the triangles by depth.

if painter==0 % then paint flat
    for i=1:K
        idx = F(i,:);
        vert = V(idx,:);
        colour = C(idx,:);
        I = triPaintFlat(I,vert,colour);
    end
elseif painter==1  % Paint with linear interpolation
    for i=1:K
        idx = F(i,:);
        vert = V(idx,:);
        colour = C(idx,:);
        I = triPaintGouraud(I,vert,colour);
    end
else
    disp('You must enter either 0-for flat or 1 for Gouraud');
end

end
