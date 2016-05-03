function [ im_blend ] = poissonBlend(im_s, mask_s, im_background)
%POISSONBLEND Summary of this function goes here
%   Detailed explanation goes here

[m, n, c] = size(im_background);

[y x] = find(mask_s);
length = size(y, 1);

im2var = zeros(m, n);
for i = 1:length
    im2var(y(i), x(i)) = i;
end

A = sparse(4*length, length);
b = zeros(4*length, 1);
dir = [0 1;1 0;0 -1;-1 0];%right, down, left, up

im_blend = im_background;
for k=1:c
    e=1;
    for i=1:length
        for dirr = 1:4
            yy = y(i) + dir(dirr, 1);
            xx = x(i) + dir(dirr, 2);

            if(mask_s(yy, xx))
                A(e, im2var(yy, xx)) = -1;
                A(e, im2var(y(i), x(i))) = 1;
                b(e, 1) = im_s(y(i), x(i), k) - im_s(yy, xx, k);
            else
                A(e, im2var(y(i), x(i))) = 1;
                b(e, 1) = im_s(y(i), x(i), k) - im_s(yy, xx, k) + im_background(yy, xx, k);
            end
            
            e = e + 1;
        end
    end
    
    v = lscov(A, b);
    
    for i=1:length
        im_blend(y(i), x(i), k) = v(im2var(y(i), x(i)));
    end
    
end




end

