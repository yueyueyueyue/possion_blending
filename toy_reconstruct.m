function [ oI ] = toy_reconstruct( sI )
%TOY_RECONSTRUCT Summary of this function goes here
%   Detailed explanation goes here

[m, n] = size(sI);

%Av=B
mA = m*(n-1)+(m-1)*n+1;
nA = m*n;
A = sparse([], [], [], mA, nA, mA*2-1);%最后一行只有一个1

b = zeros(mA, 1);

im2var = zeros(m,n);
im2var(1:m*n) = 1:m*n;
%matlab 按列游走
%%即生成     
%           1 4 7 
%           2 5 8
%           3 6 9
%这样子的

e = 1;
for y = 1:m
    for x = 1:n-1
        A(e, im2var(y, x)) = -1;
        A(e, im2var(y, x+1)) = 1;
        b(e, 1) = sI(y, x+1) - sI(y, x);
        e = e+1;
    end
end%Xgradient
for y = 1:m-1
    for x = 1:n
        A(e, im2var(y, x)) = -1;
        A(e, im2var(y+1, x)) = 1;
        b(e, 1) = sI(y+1, x) - sI(y, x);
        e = e+1;
    end
end%Ygradient
A(e, 1) = 1;
b(e, 1 ) = sI(1, 1);%the first be the same
%b(e, 1 ) = 0;
v = lscov(A, b);
%v(find(v<0))=0;
%v(find(v>1))=1;%没必要，不会超过[0,1]的，因为超过了肯定没有不超过优


oI = zeros(m, n);
for y = 1:m
    for x = 1:n
        oI(y, x) = v(im2var(y, x));
    end
end

figure(19), subplot(1, 2, 1), hold off, imshow(sI);
figure(19), subplot(1, 2, 2), hold off, imshow(oI);

end

