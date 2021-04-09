function classifiers = ova(base_classifier, X_train, y_train)
    classifiers = struct();
    pr = prdataset(X_train, y_train);
    labels = unique(y_train);

    for i = 1:length(labels)
        one_class_dataset = oc_set(pr, labels(i));

        if(base_classifier == "svc")
            clf = one_class_dataset*svc(proxm('p',3));
        end
        if(base_classifier == "tree")
           clf = one_class_dataset*treec('maxcrit',0,[]);            
        end
        
        
        classifiers(i).label = labels(i);
        classifiers(i).classifier = clf;
    end
end
