function y_pred = max_agg(classifiers, X_test)
    classifier_output = struct();
    qtd_instancias = size(X_test, 1);
    pr_test = prdataset(X_test);
    
    for i = 1:length(classifiers)
        pred = pr_test*classifiers(i).classifier;
        feature_cod = pred.FEATLAB(1,:);
        if(feature_cod ~= 'outlier')
            classifier_output(i).pred = pred.DATA(:, 1);            
        else            
            classifier_output(i).pred = pred.DATA(:, 2);
        end
        classifier_output(i).label = classifiers(i).label;
    end
    
    y_pred = zeros(qtd_instancias,1);
    
    for i = 1:qtd_instancias
        max = 0;
        label = 0;
        for j = 1:length(classifier_output)
           if classifier_output(j).pred(i) > max
            label = classifier_output(j).label;
            max = classifier_output(j).pred(i);
           end
        end
        y_pred(i) = label;
    end   
end

