function run_experiment()
    n_folds = 5;
    datasets = ["Satimage", "Segment", "Vehicle", "Vowel", "Yeast", "Zoo"];
    fracrej = 0.05;
    sigma = 5;
    width_param = [];
    N = 20;
    alpha = 0.1;
    base_classifiers = ["svdd", "parzen"];
    aggregators = ["max_agg", "decision_templates_agg"]; %, "ecoc_agg"];
    techniques = ["des", "desthr"];
    
    for d = 1:length(datasets)
        try
            dataset_name = datasets(d);
            fprintf("Dataset: " + dataset_name + "\n");

            for n_fold = 1:n_folds
                fprintf("\tFold: #" + n_fold + "\n");
                [X_train, y_train] = load_data(sprintf("../ProcessedBases/%s/%s_%d_train.csv", dataset_name, lower(dataset_name), n_fold));
                [X_test, y_test] = load_data(sprintf("../ProcessedBases/%s/%s_%d_test.csv", dataset_name, lower(dataset_name), n_fold));

                for i = 1:length(aggregators)
                    % use aggregator on base_classifier trained and save y_pred with a identifier
                    aggregator_name = aggregators(i);
                    fprintf("\t\tAggregator function: " + aggregator_name + "\n");
                    %aggregator_accuracy = zeros(size(base_classifiers, 1) * (size(techniques)+1));
                    %aggregator_kappa = zeros(size(base_classifiers, 1) * (size(techniques)+1));

                    for j = 1:length(base_classifiers)
                        % run base_classifier (params customized)
                        base_classifier_name = base_classifiers(j);
                        fprintf("\t\t\tBase classifier: " + base_classifier_name + "\n");

                        base_classifier = get_classifier_by_name(base_classifier_name);
                        last_param = get_last_param_by_classifier_name(base_classifier_name);
                        base_classifier_trained = run_base_classifier(base_classifier, X_train, y_train, fracrej, last_param);

                        aggregator_result = run_agg_method_by_name(aggregator_name, base_classifier_trained, X_train, y_train, X_test);

                        save_fold_output([y_test aggregator_result], dataset_name, n_fold, sprintf("%s_%s", base_classifier_name, aggregator_name));

                        %accuracy_score(y_test, aggregator_result);
                        %kappa_score(y_test, aggregator_result);
                        for k = 1:length(techniques)
                            % run technique using base_classifier trained and aggregator
                            % save y_pred with a identifier
                            technique_name = techniques(k);
                            fprintf("\t\t\t\tTechnique: " + technique_name + "\n");

                            technique_result = run_techique_by_name(technique_name, base_classifier_trained, X_train, y_train, X_test, aggregator_name, alpha);

                            save_fold_output([y_test technique_result], dataset_name, n_fold, sprintf("%s_%s_%s", base_classifier_name, aggregator_name, technique_name));

                            %accuracy_score(y_test, technique_result);
                            %kappa_score(y_test, technique_result);
                        end
                    end
                end
            end
        catch ME
            warning("There was a problem with fold #%d. %s", n_fold, ME.message);
        end
    end
    
    function param = get_last_param_by_classifier_name(classifier_name)
        if classifier_name == "svdd"
            param = sigma;
        elseif classifier_name == "parzen"
            param = width_param;
        elseif classifier_name == "mst"
            param = N;
        end
    end
%{
    function epoch_structure = create_epoch_structure(n_fold)
        epoch_structure = containers.Map;
        epoch_key = sprintf("fold_%d", n_fold);
        
        epoch_structure(epoch_key) = containers.Map;
        root = epoch_structure(epoch_key);
        
        for x = 1:length(base_classifiers)
            for y = 1:length(aggregators)
                for z = 1:length(techniques)
                end
            end
        end
    end
%}
    function y_pred = run_techique_by_name(techique_name, base_classifiers, X_train, y_train, X_test, agg_method_name, alpha)
        if techique_name == "des"
            y_pred = des(base_classifiers, X_train, y_train, X_test, agg_method_name, 0);
        elseif techique_name == "desthr"
            y_pred = des(base_classifiers, X_train, y_train, X_test, agg_method_name, alpha);
        end
    end

    function save_fold_output(content, database_name, n_fold, identifier)
        target_folder = sprintf("../results/%s", database_name);
        if ~exist(target_folder, "dir")
            mkdir(target_folder);
        end
        
        writematrix(content, sprintf("%s/fold_%d_%s.csv", target_folder, n_fold, identifier));
    end
end

function classifier = get_classifier_by_name(classifier_name)
    if classifier_name == "svdd"
        classifier = svdd;
    elseif classifier_name == "parzen"
        classifier = parzen_dd;
    elseif classifier_name == "mst"
        classifier = mst_dd;
    end
end