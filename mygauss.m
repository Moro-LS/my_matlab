close all;
clear all;
x=imread('1.jpg');        %读取图像
x=rgb2gray(x);            %将图像转换为灰度图
subplot(3,2,1);imshow(x);title('原图');

f=fft2(x);                %进行傅里叶变换
Fs=fftshift(f);            %对傅里叶变换后的图像进行象限转换，没有这一步的话，最终频率最低点在四角
F1=log(abs(Fs)+1);         %取模并进行缩放 
subplot(3,2,2);imshow(F1,[]);title('傅里叶变换频谱图');

x_result = gauss(Fs,20);
subplot(3,2,4);imshow(x_result);title('高斯低通滤波处理后图片');

x_result = gausshigh(Fs,10);
subplot(3,2,6);imshow(x_result);title('高斯高通滤波处理后图片');

function [image_result] =gauss(image_fftshift,D0)
[width,high] = size(image_fftshift);
D = zeros(width,high);
%创建一个width行，high列数组，用于保存各像素点到傅里叶变换中心的距离

for i=1:width
    for j=1:high
        D(i,j) = sqrt((i-width/2)^2+(j-high/2)^2);
%像素点（i,j）到傅里叶变换中心的距离
        H = exp(-1/2*(D(i,j).^2)/(D0*D0));
%高斯低通滤波函数
        image_fftshift(i,j)= H*image_fftshift(i,j);
%将滤波器处理后的像素点保存到对应矩阵
    end
end

F1=log(abs(image_fftshift)+1);         %取模并进行缩放 
subplot(3,2,3);imshow(F1,[]);title('低通滤波后的频谱');

image_result = ifftshift(image_fftshift);%将原点反变换回原始位置
image_result = uint8(real(ifft2(image_result)));
end
%real函数用于取复数的实部；
%uint8函数用于将像素点数值转换为无符号8位整数；ifft函数反傅里叶变换

function [g] =gausshigh (g , D0)
[N1,N2]=size(g);
n=2;
d0=D0; 
%d0是终止频率
n1=fix(N1/2);
n2=fix(N2/2);
%n1，n2指中心点的坐标，fix（）函数是往 0  取整
for i=1:N1
  for j=1:N2
      d=sqrt((i-n1)^2+(j-n2)^2);
      h=1-exp(-d*d/(2*d0*d0));
      result(i,j)=h*g(i,j);
  end
end

F1=log(abs(result)+1);         %取模并进行缩放 
subplot(3,2,5);imshow(F1,[]);title('高通滤波后的频谱');

result=ifftshift(result);
g = uint8(real(ifft2(result)));
end
