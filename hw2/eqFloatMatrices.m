% compares matrices with float values
function res = eqFloatMatrices(A,B,tol)
   res= max(abs(A(:) - B(:))) < tol;
end