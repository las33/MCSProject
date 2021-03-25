function classifiers = run_base_classifier_ecoc(base_classifier, X_train, y_train, fracrej, sigma, ECOC)
    classifiers = struct();
    pr = prdataset(X_train, y_train);
    for i = 1:size(ECOC,2)
        labels = get_labels(ECOC(:,i));
        one_class_dataset = oc_set(pr,labels);
        one_class_dataset = target_class(one_class_dataset);
        clf = base_classifier(one_class_dataset, fracrej, sigma)*dd_normc;
        classifiers(i).label = labels;
        classifiers(i).classifier = clf;
    end
end


function labels = get_labels(code)
    labels = [];
    for i = 1:size(code)
        if(code(i) == 1)
            labels = [labels;i];
        end
    end
end
