function y_pred = majority_agg(classifiers, X_test)
    classifier_output = struct();
    qtd_instancias = size(X_test, 1);
    pr_test = prdataset(X_test);
    
    for i = 1:length(classifiers)
        pred = pr_test*classifiers(i).classifier;
        classifier_output(i).pred_a = pred.DATA(:, 1);
        classifier_output(i).pred_b = pred.DATA(:, 2);
        classifier_output(i).label = classifiers(i).label;
    end
    
    clf_preds = zeros(qtd_instancias,length(classifiers));       
       
    for i = 1:length(classifier_output)      
        clf_pred = zeros(qtd_instancias,1);
        for j = 1:qtd_instancias
           if classifier_output(i).pred_a(j) > classifier_output(i).pred_b(j)
              clf_pred(j) = classifier_output(i).label(1);
           else
              clf_pred(j) = classifier_output(i).label(2); 
           end
        end 
        clf_preds(:,i) = clf_pred;
    end    
    y_pred = zeros(qtd_instancias,1); 
    
    for i = 1:qtd_instancias
       [M,F] = mode(clf_preds(i,:));
       y_pred(i) = M;
    end    
end