function Y_PRED = predict_one(classifier, X_test)
   
    pr_test = prdataset(X_test);  
    pred = pr_test*classifier;
    x = pred.FEATLAB(1,:);
    pred = pred.DATA(:,1);
    
    qtd_instancias = size(X_test,1);
    
    Y_PRED = zeros(qtd_instancias,1);
    
    for i = 1:qtd_instancias
        if(x  == 'outlier')
            if(pred(i) >= 0.5)
                Y_PRED(i) = -1;
            else
                Y_PRED(i) = 1;
            end
        else
          if(pred(i) >= 0.5)
                Y_PRED(i) = 1;
            else
                Y_PRED(i) = -1;
          end          
        end 
        
    end     
    
end