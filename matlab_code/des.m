function y_pred = des(base_classifiers, X_train, y_train, X_test, alpha, agg_method_name, Parameters)
    y_pred = zeros(size(X_test, 1), 1);
    m = length(unique(y_train));
    k = 3*m;
    threshold = 0;
    
    if alpha > 0
        threshold = ceil(alpha*k);
    end
    
    for i = 1:size(X_test, 1)
        idx = knnsearch(X_train, X_test(i, :), "K", k);
        neigh_labels = y_train(idx);
        
        if length(unique(neigh_labels)) > 1
            % DESthr
            if threshold > 0
                neigh_labels = filter_neighborhood_by_threshold(neigh_labels, threshold);
            end
            
            unique_neigh_labels = unique(neigh_labels);
            classifiers = get_classifiers_by_label(base_classifiers, unique_neigh_labels, agg_method_name);
            y_pred_i = run_agg_method_by_name(agg_method_name, classifiers, X_train, y_train, X_test(i, :), Parameters);
            y_pred(i) = y_pred_i(1);
        else
            y_pred(i) = neigh_labels(1);
        end
    end
end

function filtered_labels = filter_neighborhood_by_threshold(labels, threshold)
    filtered_labels = [];
    [group_count, group_label] = groupcounts(labels);
    
    for i = 1:length(group_count)
        if group_count(i) > threshold
            filtered_labels = [filtered_labels group_label(i)];
        end
    end
end

function classifiers = get_classifiers_by_label(base_classifiers, labels, agg_method_name)
    if agg_method_name == "ecoc_agg"
        to_select = zeros(1, size(base_classifiers, 2));
        for i = 1:size(base_classifiers, 2)
            base_classifier = base_classifiers{i};
            to_select(i) = any(ismember(base_classifier.label, labels));
        end

        classifiers = base_classifiers(to_select == 1);
    else
        to_select = zeros(1, size(base_classifiers, 2));
        for i = 1:size(base_classifiers, 2)
            base_classifier = base_classifiers(i);
            to_select(i) = any(ismember(base_classifier.label, labels));
        end

        classifiers = base_classifiers(to_select == 1);
    end
end
