function classifiers = ovo(base_classifier, X_train, y_train)
    classifiers = struct();
    pr = prdataset(X_train, y_train);
    labels = unique(y_train);

    count = 1;
    for i = 1:length(labels)
        for j = i+1:length(labels)
            two_class_set = selclass(pr,[labels(i) labels(j)]);            

            if(base_classifier == "svc")
                clf = two_class_set*svc(proxm('p',3));
            end
            if(base_classifier == "tree")
                clf = two_class_set*treec('maxcrit',0,[]);            
            end
            classifiers(count).label = [labels(i) labels(j)];
            classifiers(count).classifier = clf;
            count = count +1;
        end
    end
end
