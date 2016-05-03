% starter script for project 3
DO_TOY = false;
DO_BLEND = true;
DO_MIXED  = false;
DO_COLOR2GRAY = false;

if DO_TOY 
    toyim = im2double(imread('./samples/toy_problem.png')); 
    % im_out should be approximately the same as toyim
    im_out = toy_reconstruct(toyim);
    %figure(25), hold off, imshow(im_out)
    error = sqrt(sum( (toyim(:)-im_out(:)).^2 ));
    disp(['Error: ' num2str(error)])
end

if DO_BLEND || DO_MIXED %读图片
    im_background = imresize(im2double(imread('./samples/mountains.jpg')), 0.5, 'bilinear');
    im_object = imresize(im2double(imread('./samples/jupiter.jpg')), 0.5, 'bilinear');

    % get source region mask from the user
    objmask = getMask(im_object);
    % align im_s and mask_s with im_background
    [im_s, mask_s] = alignSource(im_object, objmask, im_background);
end

if DO_BLEND  
    % blend
    im_blend = poissonBlend(im_s, mask_s, im_background);
    figure(3),subplot(1, 2, 1), hold off, imshow(im_blend)
end

if DO_MIXED
    % blend
    im_blend = mixedBlend(im_s, mask_s, im_background);
    figure(3), subplot(1, 2, 2), hold off, imshow(im_blend);
end

if DO_COLOR2GRAY
    im_rgb = im2double(imread('./samples/colorBlindTest35.png'));
    im_gray = rgb2gray(im_rgb);%灰度图
    im_gr = color2gray(im_rgb);%重建所得结果
    im_gr_scale= mat2gray(im_gr);%放缩过的结果
   
    %figure(11), hold off, imagesc(im_gray), axis image, colormap gray
    %figure(9), hold off, imagesc(im_gr), axis image, colormap gray
    %figure(90), hold off, imshow(im_gr), axis image, colormap gray
    figure(71),imshow(im_gray);
    figure(72),imshow(im_gr);
    figure(73),imshow(im_gr_scale);
    
    %figure(4), imshow(im_gr);
end
