function angle = calculateangle(x,y)
% compute the gradient orientation in a specific location of an image
% the range is [0,2*pi)

% input
% x: gradient of the horizontal direction 
% y: gradient of the vertical direction 

% output
% angle: the gradient orientation

if x* y > 0
    if x > 0
        angle = atan( y/x);
    else
        angle = pi + atan( y/x);
    end
elseif x* y < 0
    if x > 0
        angle = 2*pi+ atan(y/x);
    else
        angle = pi + atan( y/x);
    end
else
    if x == 0
        if y >= 0
            angle = pi/2;
        else
            angle = 3*pi/2;
        end
    else
        if x > 0
            angle = 0;
        else
            angle = pi;
        end
    end
end
end
