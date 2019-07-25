function [AUCpc,AUC_emp,AUC_abin,AUC_convex]=IndividualROCcurves(real,forecast,flagbrady)
    figure(1);
    AUCpc=GenerateROCCurve(real,forecast,flagbrady);
    hold on,
    a=find(real==0);
    b=find(forecast==0);
    for i=1:length(a)
        real(a(i))=-1;
    end
    for i=1:length(b)
        forecast(b(i))=-1;
    end
    [TPR_emp, FPR_emp, ~, AUC_emp] = prc_stats_empirical(real, forecast);
    [TPR_abin, FPR_abin, ~,AUC_abin] = prc_stats_binormal(real, forecast, true);
    [k,v]=convhull(TPR_emp,FPR_emp);
    k=k(1:end-1);
    AUC_convex=v+0.5;
    cols = [200 45 43; 37 64 180; 0 176 80; 0 0 0]/255;
    plot(FPR_emp, TPR_emp, '-o', 'color', cols(1,:), 'linewidth', 2);
    plot(FPR_abin, TPR_abin, '-', 'color', cols(3,:), 'linewidth', 2);
    plot(FPR_emp(k), TPR_emp(k), '-^', 'color', cols(2,:), 'linewidth', 2);
    plot([0 1], [0 1], '-', 'color', [0.7 0.7 0.7], 'linewidth', 2);
    axis([0 1 0 1]);
    legend('ROC curve with perfcurve','ROC curve with empirical form','ROC curve with binormal form','ROC curve with convex hull form');
    set(gca, 'box', 'on');
end