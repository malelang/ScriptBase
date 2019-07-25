function AUC=GenerateROCCurve(reallabels,forecastlabels,flagbrady)
    
    [XROC,YROC,~,AUC]=perfcurve(reallabels,forecastlabels,1);
    plot(XROC,YROC,'-m','LineWidth',2),xlabel('False Positive Rate'),ylabel('True Positive Rate')
    if(flagbrady==1)
        title('ROC Curve for Bradycardia Classification with Base Script')
    else
        title('ROC Curve for Tachycardia Classification with Base Script')
    end
    
end