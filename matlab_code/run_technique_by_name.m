function y_pred = run_technique_by_name(techique_name, base_classifiers, X_train, y_train, X_test, y_test, alpha, agg_method_name, Parameters)
    if techique_name == "des"
        y_pred = des(base_classifiers, X_train, y_train, X_test, y_test, 0, agg_method_name, Parameters);
    elseif techique_name == "desthr"
        y_pred = des(base_classifiers, X_train, y_train, X_test, y_test, alpha, agg_method_name, Parameters);
    end
end