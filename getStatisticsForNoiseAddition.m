function [finalresults]=getStatisticsForNoiseAddition(featuresnoise,featuresoriginal,plotresults,mseresults)
%FUNCTION GetStatisticsForNoiseAddition
%INPUTS: featuresnoise --> A vector of size M*3 where M corresponds to the
%number of classification instances that bradycardia or tachycardia have.
%Each column corresponds to the following: (1) low hr (if it's bradycardia)
%or  high hr (if it's tachycardia). (2) signal quality index (3) the number
%of the sensor which this variables where taken with
%       featuresoriginal --> same description as featuresnoise but these
%       results are obtained with the original version of the script
%       plotresults --> 1 if the plot for the analysis are required
%       mse results --> 1 if the results for mse, rmse and mad variables
%       for regression error are desired. if this value is 0 it will only
%       return the correlation coefficient between the noisy and original
%       values.

if(plotresults)
    t=(1:length(featuresnoise));
    figure(1)
    scatter(t,featuresnoise(:,1),'MarkerEdgeColor',[0 0 .5],'MarkerFaceColor',[0 0 .7],'LineWidth',1.5)
    hold on,grid on,
    scatter(t,featuresoriginal(:,1),'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5)
    if(length(featuresnoise)==89)
        title('Deviation of the decision parameters when summing noise: low HR for bradycardia')
        legend('Original results for brady low HR','Noisy results for brady low HR')
        xlabel('Instances of classification')
        ylabel('Low HR for determining Bradycardia')
    else
        title('Deviation of the decision parameters when summing noise: high HR for tachycardia')
        legend('Original results for tachy high HR','Noisy results for tachy high HR')
        xlabel('Instances of classification')
        ylabel('High HR for determining Bradycardia')
    end
    
    figure(2)
    plot(t,featuresnoise(:,1),'r-','Linewidth',1.5),hold on, plot(t,featuresoriginal(:,1),'-b','Linewidth',1.5),grid on
    
    if(length(featuresnoise)==89)
        grid on,hold on, plot(t,ones(length(featuresnoise),1).*45,'--k'),hold on, plot(t,ones(length(featuresnoise),1).*40,'--k')
        title('Deviation of the decision parameters when summing noise: low HR for bradycardia')
        legend('Original results for brady low HR','Noisy results for brady low HR')
        xlabel('Instances of classification')
        ylabel('Low HR for determining Bradycardia')
    else
        grid on,hold on, plot(t,ones(length(featuresnoise),1).*135,'--k'),hold on, plot(t,ones(length(featuresnoise),1).*140,'--k')
        title('Deviation of the decision parameters when summing noise: high HR for tachycardia')
        legend('Original results for tachy high HR','Noisy results for tachy high HR')
        xlabel('Instances of classification')
        ylabel('High HR for determining Bradycardia')
    end
end


%primero elimino aquellos valores que salieron con sensores distintos por
%alguna razon
finalresults=[];
vdiff=[];
if(mseresults)
    vdiff=featuresnoise(:,3)==featuresoriginal(:,3);
    vdiff=find(vdiff==0);
    for i=1:length(vdiff)
        index=vdiff(i);
        featuresnoise(index,1)=0; %lo hago tanto para el primer feature 
        featuresoriginal(index,1)=0;
        featuresnoise(index,2)=0; %como para el segundo
        featuresoriginal(index,2)=0;
    end
end
%para el primer feature hallo los valores NaN
vnan=isnan(featuresnoise(:,1)); %hallo los nan en noisy features
indexes=find(vnan==1); %hallo los indices en donde se encuentran
vnan=isnan(featuresoriginal(:,1)); %de nuevo hallo los nan en los originales
indexes=[indexes; find(vnan==1)]; %hallo los indices donde se encuentran
indexes=unique(indexes); %los hago unicos para que no se repitan
for i=1:length(indexes) %reemplazo los valores NaN por ceros.
    index=indexes(i);
    featuresnoise(index,1)=0;
    featuresoriginal(index,1)=0;
end
%ESTO es para quitar todos aquellos que hayan quedado por fuera de los 2
%criterios (en el analisis MSE, RMSE y MAD no es tan necesario, pues ya han
%sido igualados a cero y por tanto no aportan realmente al cálculo. En
%cambio en el análisis de ANOVA y en el que siguiente sí importan, pues
%contamos todos aquellos que cumplan las condiciones
ignored=[indexes; vdiff];
ignored1=unique(ignored);
ignored1=flip(ignored1);
%guardamos los features del ritmo cardiaco
featuresnoisehr=featuresnoise(:,1);
featuresoriginalhr=featuresoriginal(:,1);
%quitamos todos aquellos que no cumplen las condiciones
for i=1:length(ignored1)
    featuresnoisehr(ignored1(i))=[];
    featuresoriginalhr(ignored1(i))=[];
end

%para el segundo feature hago lo mismo para los valores NaN
vnan=isnan(featuresnoise(:,2));
indexes=find(vnan==1);
vnan=isnan(featuresoriginal(:,2));
indexes=[indexes; find(vnan==1)];
indexes=unique(indexes);
for i=1:length(indexes)
    index=indexes(i);
    featuresnoise(index,2)=0;
    featuresoriginal(index,2)=0;
end
% y luego hago lo mismo para quitarlos de los vectores
ignored=[indexes; vdiff];
ignored2=unique(ignored);
ignored2=flip(ignored2);
%guardamos los features del ritmo cardiaco
featuresnoisesqi=featuresnoise(:,2);
featuresoriginalsqi=featuresoriginal(:,2);
%quitamos todos aquellos que no cumplen las condiciones
for i=1:length(ignored2)
    featuresnoisesqi(ignored2(i))=[];
    featuresoriginalsqi(ignored2(i))=[];
end

corrbethr=corr(featuresnoisehr,featuresoriginalhr);
corrbetsqi=corr(featuresnoisesqi,featuresoriginalsqi);
finalresults=[finalresults corrbethr corrbetsqi];

if(mseresults)
    %Calculate MSE for the first features
    mse=[0 0];
    for i=1:length(featuresnoise)
        mse(1)=mse(1)+((featuresnoise(i,1)-featuresoriginal(i,1)).^2);
        mse(2)=mse(2)+((featuresnoise(i,2)-featuresoriginal(i,2)).^2);
    end
    mse(1)=mse(1)/(length(featuresnoise)-length(ignored1));
    mse(2)=mse(2)/(length(featuresnoise)-length(ignored2));
    rmse=sqrt(mse);
    %Calculate MAD
    mad=[0 0];
    for i=1:length(featuresnoise)
        mad(1)=mad(1)+abs((featuresnoise(i,1)-featuresoriginal(i,1)));
        mad(2)=mad(2)+abs((featuresnoise(i,2)-featuresoriginal(i,2)));
    end
    mad(1)=mad(1)/(length(featuresnoise)-length(ignored1));
    mad(2)=mad(2)/(length(featuresnoise)-length(ignored2));
    finalresults=[finalresults mse rmse mad];
end

if plotresults
    
%     xfrompaper=(featuresnoise+featuresoriginal)/2;
%     yfrompaper=(featuresoriginal-featuresnoise);
%     figure(3)
%     scatter(xfrompaper(:,1),yfrompaper(:,1),'b');
%     title('Bland Altman plot for the estimated HR in each arrhythmia')
%     xlabel('(Min HR Estimated + Min HR Ground Truth)/2 [beats]')
%     ylabel('Min HR Ground Truth - Min HR Estimated [beats]')
%     hold on, plot(xfrompaper(:,1),zeros(length(xfrompaper),1),'--k')
    
    figure(4)
    y=scatter(featuresoriginalhr,featuresnoisehr,'b');
    if(length(featuresnoise)==89)
        title('Correlation scatter for bradycardia Low HR variable'),
        xlabel('Original values for Low HR in bradycardia')
        ylabel('Noisy values for Low HR in bradycardia')
        grid on, axis tight, hold on, plot([0 140],[0 140],'k--')
        [~, objH] = legend(y,'junk');
        set(findobj(objH, 'Tag', 'junk'), 'Vis', 'off');    
        pos = get(objH(1), 'Pos');
        set(objH(1), 'Pos', [0.1 pos(2:3)], 'String', ['Correlation index: ' num2str(corrbethr)]);
    
    else
         title('Correlation scatter for tachycardia High HR variable'),
        xlabel('Original values for High HR in tachycardia')
        ylabel('Noisy values for High HR in tachycardia')
        grid on, axis tight, hold on, plot([0 140],[0 140],'k--')
        [~, objH] = legend(y,'junk');
        set(findobj(objH, 'Tag', 'junk'), 'Vis', 'off');    
        pos = get(objH(1), 'Pos');
        set(objH(1), 'Pos', [0.1 pos(2:3)], 'String', ['Correlation index: ' num2str(corrbethr)]);
    end
    
end