function [DECISION_TEMPLATE, CLASS_LABELS] = build_decision_template(DECISION_PROFILE, LABELS)
        
    CLASS_LABELS = unique(LABELS);
    
    DECISION_TEMPLATE = zeros(length(CLASS_LABELS),size(DECISION_PROFILE,2));
    
    for i = 1:length(CLASS_LABELS)
        current_label = CLASS_LABELS(i);
        C_TAMPLATE = zeros(1,size(DECISION_PROFILE,2));
        count = 0;
        for j = 1:length(LABELS)             
            if(LABELS(j) == current_label)
               C_TAMPLATE =  sum([C_TAMPLATE;DECISION_PROFILE(i,:)]);
               count = count+1;
            end
        end
        C_TAMPLATE = C_TAMPLATE/count;
        DECISION_TEMPLATE(i,:) = C_TAMPLATE;
    end  
end

