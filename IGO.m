function z = IGO(I,order)
[rows,cols] = size(I);

%Method one, MATLAB bulit-in function, imgradientxy
% 'sobel'	Sobel gradient operator (default)
% 'prewitt'	Prewitt gradient operator
% 'central' Central difference gradient: dI/dx = (I(x+1)- I(x-1))/2
% 'intermediate' Intermediate difference gradient: dI/dx = I(x+1) - I(x)
[Gx1,Gy1] = imgradientxy(I,'intermediate');

[Gx2,~] = imgradientxy(Gx1,'intermediate');
[~,Gy2] = imgradientxy(Gy1,'intermediate');

[Gx3,~] = imgradientxy(Gx2,'intermediate');
[~,Gy3] = imgradientxy(Gy2,'intermediate');

Fai = zeros(rows,cols);
if order==1
    for i = 1: rows
        for j = 1:cols
            Fai(i,j) = (calculateangle((Gx1(i,j)), (Gy1(i,j))));
        end
    end
elseif order==2
    for i = 1: rows
        for j = 1:cols
            Fai(i,j) = (calculateangle((Gx2(i,j)), (Gy2(i,j))));
        end
    end
elseif order==3
    for i = 1: rows
        for j = 1:cols
            Fai(i,j) = (calculateangle((Gx3(i,j)), (Gy3(i,j))));
        end
    end
end

ImageSize = rows*cols;
fai = reshape(Fai,ImageSize,1);
z = cos(fai)+1j*sin(fai);
% z = exp(1j*fai);
z(isnan(z)) = 0;