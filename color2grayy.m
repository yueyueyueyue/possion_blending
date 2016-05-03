function [ im_gr ] = color2grayy( im_rgb )
%COLOR2GRAY Summary of this function goes here������ʹ��RGB����ͨ�������ģ�û��Ч��
%   Ŀ��ͼ���ݶ����sͨ����vͨ���Ķ�Ӧ�ݶȵ����ֵ��ǿ����ϻҶ�ͼ
    %im_rgb = rgb2hsv(im_rgb);
    %im_rgb = rgb2hsv(im_rgb);%�任��hsv���ݶȽ�����
    im_rgb1 = im_rgb(:, :, 1);
    im_rgb2 = im_rgb(:, :, 2);
    im_rgb3 = im_rgb(:, :, 3);
    figure(55);
    subplot(1,3,1), imshow(im_rgb1);
    subplot(1,3,2), imshow(im_rgb2);
    subplot(1,3,3), imshow(im_rgb3);
    
    im_gray = rgb2gray( im_rgb );
    [m, n, c] = size(im_rgb);
    mA = ( m*(n - 1) + (m - 1)*n ) + 1;
    nA = m*n;
    A = sparse([], [], [], mA, nA, 2*mA - 1);
    b = zeros(mA, 1);
    
    %���Ի�
    im2var = zeros(m ,n);
    im2var(:) = 1:m*n;
    
    e=1;
    %Xgradient of three channel
    %for k = 1:c
        for i=1:m
            for j=1:n-1
                A(e, im2var(i, j)) = -1;
                A(e, im2var(i,j+1)) = 1;
                t1 = abs(im_rgb(i, j+1, 1) - im_rgb(i, j, 1));
                %t1 = 0;
                t2 = abs(im_rgb(i, j+1, 2) - im_rgb(i, j, 2));
                t3 = abs(im_rgb(i, j+1, 3) - im_rgb(i, j, 3));
                if(t1>t2 && t1>t3) 
                    b(e, 1) = im_rgb(i, j+1, 1) - im_rgb(i, j, 1);
                elseif(t2>t3)
                    b(e, 1) = im_rgb(i, j+1, 2) - im_rgb(i, j, 2);
                else
                    b(e, 1) = im_rgb(i, j+1, 3) - im_rgb(i, j, 3);
                end
                e = e+1;
            end
        end
    %end
    %Ygradient of three channel
    %for k = 1:c
        for i=1:m-1
            for j=1:n
                A(e, im2var(i,j)) = -1;
                A(e, im2var(i+1,j)) = 1;
                t1 = abs(im_rgb(i+1, j, 1) - im_rgb(i, j, 1));
                %t1 = 0;
                t2 = abs(im_rgb(i+1, j, 2) - im_rgb(i, j, 2));
                t3 = abs(im_rgb(i+1, j, 3) - im_rgb(i, j, 3));
                if(t1>t2 && t1>t3) 
                    b(e, 1) = im_rgb(i+1, j, 1) - im_rgb(i, j, 1);
                elseif(t2>t3)
                    b(e, 1) = im_rgb(i+1, j, 2) - im_rgb(i, j, 2);
                else
                    b(e, 1) = im_rgb(i+1, j, 3) - im_rgb(i, j, 3);
                end
                e = e+1;
            end
        end
    %end
    %intensity of gray
    
    
    A(e, 1) = 1;
    b(e, 1) = im_gray(1, 1);
    
    v = lscov(A, b);
    
    im_gr = zeros(m, n);
    for i = 1:m
        for j = 1:n
            im_gr(i, j) = v(im2var(i, j));
        end
    end
    
end