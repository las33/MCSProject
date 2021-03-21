function y_pred = des(base_classifiers, X_train, y_train, X_test, agg_method, alpha)
    y_pred = zeros(length(X_test));
    m = length(unique(y_train));
    k = 3*m;
    threshold = 0;
    
    if alpha > 0
        threshold = ceil(alpha*k);
    end
    
    for i = 1:length(X_test)
        idx = knnsearch(X_train, X_test(i, :), "K", k);
        neigh_labels = y_train(idx);
        
        % DESthr
        if threshold > 0
            neigh_labels = filter_neighborhood_by_threshold(neigh_labels, threshold);
        end
        
        if length(unique(neigh_labels)) > 1
            classifiers = base_classifiers(neigh_labels);
            y_pred_i = agg_method(classifiers, X_test(i, :));
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