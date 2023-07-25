function [p,opt_deg] = degree_check(peak_x,peak_y,rr,maxdeg)
    errset = [];
    deg_range = linspace(2,maxdeg,(maxdeg)/2);
    for i = 1:length(deg_range)
        polydeg = deg_range(i);
        [obf,Sx] = polyfit(peak_x,peak_y,polydeg);
        [~,terr] = polyval(obf,rr,Sx);
        errset(end+1) = sqrt(sum(terr.^2));
    end

    [~,ind] = min(errset);
    opt_deg = deg_range(ind);
    p = polyfit(peak_x,peak_y,opt_deg);

end