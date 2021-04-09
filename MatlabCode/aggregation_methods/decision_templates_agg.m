function y_pred = decision_templates_agg(classifiers, X_train, y_train, X_test, removed_classes)
    decision_profile_train = build_decision_profile(classifiers, X_train);
   
    [decision_template_train, tamplates_labels] = build_decision_template(decision_profile_train, y_train, removed_classes);
    
    decision_profile_test = build_decision_profile(classifiers, X_test);
    
    y_pred = zeros(size(decision_profile_test, 1), 1);
    
    for i = 1:size(decision_profile_test, 1)
        min = 1/0;
        label = 0;
        for j = 1:size(decision_template_train, 1)
            X = decision_profile_test(i, :);
            Y = decision_template_train(j, :);
            distance = sum((X - Y) .^ 2);
            if(distance < min)
                min = distance;
                label = tamplates_labels(j);
            end
        end
        y_pred(i) = label;
    end    
end
