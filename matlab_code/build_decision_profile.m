function [decision_profile] = build_decision_profile(classifiers, X)
    classifier_output = struct();
    qtd_instancias = size(X,1);
    pr_test = prdataset(X);
    
    decision_profile = zeros(size(X, 1),length(classifiers));
    
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
        
    for i = 1:qtd_instancias
        row = zeros(1, length(classifiers));
        for j = 1:length(classifier_output)
           row(j) = classifier_output(j).pred(i);
        end
        decision_profile(i,:) = row;
    end   
end

