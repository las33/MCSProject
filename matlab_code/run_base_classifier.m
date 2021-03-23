function classifiers = run_base_classifier(base_classifier, X_train, y_train, fracrej, sigma)
    classifiers = struct();
    pr = prdataset(X_train, y_train);
    labels = unique(y_train);

    for i = 1:length(labels)
        one_class_dataset = oc_set(pr, labels(i));
        one_class_dataset = target_class(one_class_dataset);

        clf = base_classifier(one_class_dataset, fracrej, sigma)*dd_normc;

        classifiers(i).label = labels(i);
        classifiers(i).classifier = clf;
    end
end
