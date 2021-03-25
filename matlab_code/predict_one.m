function Y_PRED = predict_one(classifier, X_test)
   
    pr_test = prdataset(X_test);  
    pred = pr_test*classifier;
    pred = pred.DATA(:,1);
    qtd_instancias = size(X_test,1);
    
    Y_PRED = zeros(qtd_instancias,1);
    
    for i = 1:qtd_instancias
        if(pred(i) >= 0.5)
            Y_PRED(i) = 1;
        else
            Y_PRED(i) = 0;
        end
    end     
    
end