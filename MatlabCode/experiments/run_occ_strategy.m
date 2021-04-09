function classifiers = run_occ_strategy(occ_strategy_name, base_classifier_name, X_train, y_train)
    if occ_strategy_name == "ovo"
        classifiers = ovo(base_classifier_name, X_train, y_train);
    elseif occ_strategy_name == "ova"
        classifiers = ova(base_classifier_name, X_train, y_train);
    end
end

