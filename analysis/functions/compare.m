function [] = compare(newbdx,newbdy,convratio,ind)
    minval = min(newbdy);
    dd = (newbdy == minval);
    allx = newbdx(dd);
    minx = allx(1);
    peakpt = [minx,minval];
    stdnewbdx = newbdx-peakpt(1);
    stdnewbdy = newbdy-peakpt(2);
    if ind == 2
        stdnewbdx = stdnewbdx * convratio;
        stdnewbdy = stdnewbdy * convratio;
    end
    heighty = max(stdnewbdy);
    R1 = 0.05;
    [xx1,yy1,R1,H] = attractor3d(R1,heighty);
    yy1 = -yy1+heighty; 

    R2 = 0.01;
    [xx2,yy2,R2,H] = attractor3d(R2,heighty);
    yy2 = -yy2+heighty; 
    
    figure()
    hold on;
%     plot(stdpeakx,stdpeaky,'o');
    plot(stdnewbdx,stdnewbdy,'o');axis equal;plot(xx1,yy1);plot(xx2,yy2);
    legend('data','polyfit','0.05','0.01')

    pause




end