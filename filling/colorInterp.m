function color = colorInterp(A,B,a,b,x)

lambda = (b-x) / (b-a);

color = lambda*A + (1-lambda)*B;

end

