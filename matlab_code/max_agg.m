function Y_PRED = max_agg(classifiers, X_test)
    
    saidas = struct();
    qtd_instancias = size(X_test,1);
    pr_test = prdataset(X_test);
    
    for i = 1:length(classifiers)        
        pred = pr_test*classifiers(i).classifier;
        saidas(i).pred = pred.DATA(:,1);
        saidas(i).label = classifiers(i).label;
    end
    
    Y_PRED = zeros(qtd_instancias,1);
    
    for i = 1:qtd_instancias
        max = 0;
        label = 0;
        for j = 1:length(saidas)
           if saidas(j).pred(i) > max
            label = saidas(j).label;
            max = saidas(j).pred(i);
           end               
        end
        Y_PRED(i) = label;
    end   
end