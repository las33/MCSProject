function y_pred = run_agg_method_by_name(agg_method_name, classifiers, X_train, y_train, X_test, y_test, Parameters)
    if size(classifiers, 2) > 0
        if agg_method_name == "max_agg"
            y_pred = max_agg(classifiers, X_test);
        elseif agg_method_name == "decision_templates_agg"
            y_pred = decision_templates_agg(classifiers, X_train, y_train, X_test,Parameters.removed_classes);
        elseif agg_method_name == "ecoc_agg"
            [~, y_pred, ~, ~] = ECOCTest(X_test, classifiers, Parameters, y_test);
        elseif agg_method_name == "majority_agg"
            y_pred = majority_agg(classifiers, X_test);
        end
    else
        y_pred = zeros(size(X_test, 1));
    end
end