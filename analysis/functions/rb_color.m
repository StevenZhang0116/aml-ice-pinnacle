function [color] = rb_color(n,N)
    if n < N/2
        green = (n-1)/(N/2);
        red = 1-green;
        color = [red,green,0];
    else 
        blue = (n-N/2)/(N/2);
        green = 1-blue;
        color = [0,green,blue];
    end
end