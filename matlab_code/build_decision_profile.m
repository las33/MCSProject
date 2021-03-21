function [DECISION_PROFILE] = build_decision_profile(classifiers, DATA)
    
    saidas = struct();
    qtd_instancias = size(DATA,1);
    pr_test = prdataset(DATA);
    
    DECISION_PROFILE = zeros(size(DATA, 1),length(classifiers));
    
    for i = 1:length(classifiers)        
        pred = pr_test*classifiers(i).classifier;
        saidas(i).pred = pred.DATA(:,1);
        saidas(i).label = classifiers(i).label;
    end    
        
    for i = 1:qtd_instancias
        row = zeros(1, length(classifiers));
        for j = 1:length(saidas)
           row(j) = saidas(j).pred(i);             
        end
        DECISION_PROFILE(i,:) = row;
    end   
end

