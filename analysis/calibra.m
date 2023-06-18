%--------------------------------------------------------------------------
% Calibration function
%
% Steven Zhang, Courant Institute
% Updated Jan 2023
%--------------------------------------------------------------------------


function [convratio] = calibra(basepath,subfolder,calind)    
    if calind == 1
        caliimg = 'calibration.JPG';
        
        f = imread([basepath,subfolder,caliimg]);
        
        figure()
        set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
        imshow(f)
        h = imdistline;
        fcn = makeConstrainToRectFcn('imline',get(gca,'XLim'),get(gca,'YLim'));
        setDragConstraintFcn(h,fcn);
        
        distinpixel = input('value from read: ');
        distincm = input('centimeter used: ');
        convratio = distincm/distinpixel; % cm/pixel
    elseif calind == 2
        convratio = 3.7420e-04; % cm/pixel
    end

    close
end