close all;
clear all;
x=imread('1.jpg');        %��ȡͼ��
x=rgb2gray(x);            %��ͼ��ת��Ϊ�Ҷ�ͼ
subplot(3,2,1);imshow(x);title('ԭͼ');

f=fft2(x);                %���и���Ҷ�任
Fs=fftshift(f);            %�Ը���Ҷ�任���ͼ���������ת����û����һ���Ļ�������Ƶ����͵����Ľ�
F1=log(abs(Fs)+1);         %ȡģ���������� 
subplot(3,2,2);imshow(F1,[]);title('����Ҷ�任Ƶ��ͼ');

x_result = gauss(Fs,20);
subplot(3,2,4);imshow(x_result);title('��˹��ͨ�˲������ͼƬ');

x_result = gausshigh(Fs,10);
subplot(3,2,6);imshow(x_result);title('��˹��ͨ�˲������ͼƬ');

function [image_result] =gauss(image_fftshift,D0)
[width,high] = size(image_fftshift);
D = zeros(width,high);
%����һ��width�У�high�����飬���ڱ�������ص㵽����Ҷ�任���ĵľ���

for i=1:width
    for j=1:high
        D(i,j) = sqrt((i-width/2)^2+(j-high/2)^2);
%���ص㣨i,j��������Ҷ�任���ĵľ���
        H = exp(-1/2*(D(i,j).^2)/(D0*D0));
%��˹��ͨ�˲�����
        image_fftshift(i,j)= H*image_fftshift(i,j);
%���˲������������ص㱣�浽��Ӧ����
    end
end

F1=log(abs(image_fftshift)+1);         %ȡģ���������� 
subplot(3,2,3);imshow(F1,[]);title('��ͨ�˲����Ƶ��');

image_result = ifftshift(image_fftshift);%��ԭ�㷴�任��ԭʼλ��
image_result = uint8(real(ifft2(image_result)));
end
%real��������ȡ������ʵ����
%uint8�������ڽ����ص���ֵת��Ϊ�޷���8λ������ifft����������Ҷ�任

function [g] =gausshigh (g , D0)
[N1,N2]=size(g);
n=2;
d0=D0; 
%d0����ֹƵ��
n1=fix(N1/2);
n2=fix(N2/2);
%n1��n2ָ���ĵ�����꣬fix������������ 0  ȡ��
for i=1:N1
  for j=1:N2
      d=sqrt((i-n1)^2+(j-n2)^2);
      h=1-exp(-d*d/(2*d0*d0));
      result(i,j)=h*g(i,j);
  end
end

F1=log(abs(result)+1);         %ȡģ���������� 
subplot(3,2,5);imshow(F1,[]);title('��ͨ�˲����Ƶ��');

result=ifftshift(result);
g = uint8(real(ifft2(result)));
end
