function classifiers = run_base_classifier_ecoc(base_classifier, X_train, y_train, fracrej, sigma, ECOC, coding, clf_bin)
    classifiers = struct();
    pr = prdataset(X_train, y_train);
    for i = 1:size(ECOC,2)
        if(strcmp(clf_bin, 'svm'))
            labels = [];
            if(coding == 'OneVsOne')
                [pos, neg] = get_labels_OneVsOne(ECOC(:,i));
                labels = [pos, neg];
                dataset = selclass(pr,labels);  
                
            end
            if(coding == 'OneVsAll')
               labels = get_labels(ECOC(:,i));
               dataset = oc_set(pr, labels); 
            end
            clf = dataset*svc(proxm('p',3));
            classifiers(i).classifier = clf;
            classifiers(i).label = labels; 
        else
            labels = get_labels(ECOC(:,i));
            one_class_dataset = oc_set(pr,labels);
            one_class_dataset = target_class(one_class_dataset);
            clf = base_classifier(one_class_dataset, fracrej, sigma)*dd_normc;
            classifiers(i).label = labels;
            classifiers(i).classifier = clf;
        end
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

function [pos, neg] = get_labels_OneVsOne(code)
    for i = 1:size(code)
        if(code(i) == 1)
            pos = i;
        end
        if(code(i) == -1)
            neg = i;
        end
    end
end
