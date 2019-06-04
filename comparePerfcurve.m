function comparePerfcurve(realData,forecastOriginal,forecastNoisy,forecastDenoised,bradyflag)

    [XROCorig,YROCorig,~,AUCorig]=perfcurve(realData,forecastOriginal,1);
    [XROCnoi,YROCnoi,~,AUCnoi]=perfcurve(realData,forecastNoisy,1);
    [XROCden,YROCden,~,AUCden]=perfcurve(realData,forecastDenoised,1);
    
    figure; hold on;
    plot(XROCorig,YROCorig),hold on,
    plot(XROCnoi,YROCnoi),hold on,
    plot(XROCden,YROCden),hold on,
    plot([0 1], [0 1],'-k');
    axis([0 1 0 1]);
    xlabel('FPR'); ylabel('TPR')
    if(bradyflag==1)
        title('Comparison of ROC curves in different scenarios for Bradycardia')
    else
        title('Comparison of ROC curves in different scenarios for Tachycardia')
    end
    set(gca, 'box', 'on');
    legend(['Original results. AUC=' num2str(AUCorig)],['Noisy results. AUC=' num2str(AUCnoi)],['Denoised results. AUC=' num2str(AUCden)])
    
end