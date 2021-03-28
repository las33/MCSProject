function y_pred = run_knn(K, X_train, y_train, X_test)
    y_pred = zeros(size(X_test, 1), 1);
    m = length(unique(y_train));
    k = K*m;
    
    if k == 0
        k = 1;
    end
    
    for i = 1:size(X_test, 1)
        idx = knnsearch(X_train, X_test(i, :), "K", k);
        neigh_labels = y_train(idx);
        
        if length(unique(neigh_labels)) > 1
            y_pred(i) = majority_vote(neigh_labels);
        else
            y_pred(i) = neigh_labels(1);
        end
    end
end

function label = majority_vote(labels)
    [group_count, group_label] = groupcounts(labels);
    
    max = 0;
    label = 0;
    
    for i = 1:length(group_count)
        if group_count(i) > max
            max = group_count(i);
            label = group_label(i);
        end
    end
end