function y = mymod(x,n)
y = mod(x,n);
y(x==0) = y(x==0) + n;
% y(x==n) = 1;
end