function Y_PRED = decision_templates_agg(classifiers, DATA_TRAIN, LABELS_TRAIN, DATA_TEST)
    
    decision_profile_train = build_decision_profile(classifiers,DATA_TRAIN);
   
    [decision_template_train, tamplates_labels] = build_decision_template(decision_profile_train,LABELS_TRAIN);
    
    decision_profile_test = build_decision_profile(classifiers,DATA_TEST);
    
    Y_PRED = zeros(size(decision_profile_test,1),1);
    
    for i = 1:size(decision_profile_test,1) 
        min = 1/0;
        label = 0;
        for j = 1:size(decision_template_train,1)
            X = decision_profile_test(i,:);
            Y = decision_template_train(j,:);
            distance = sum((X - Y) .^ 2);
            if(distance < min)
                min = distance;
                label = tamplates_labels(j);
            end                
        end
        Y_PRED(i) = label;
    end    
end
