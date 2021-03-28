function run_experiment()
    n_folds = 5;
    datasets = ["Auslan", "Autos", "Car", "Cleveland", "Dermatology", "Ecoli", "Flare", "Glass", "Isolet", "Led7digit", "Letter-2", "Lymphography", "Nursery", "Page-blocks", "Penbased", "Satimage", "Segment", "Shuttle", "Vehicle", "Vowel", "Yeast", "Zoo"];
    fracrej = 0.05;
    sigma = 5;
    width_param = [];
    N = 20;
    alpha = 0.1;
    root_dataset_name = "ProcessedBases_MinMax";
    result_folder = "results_MinMax_prunned";
    
    clear Parameters;
    Parameters.coding='DECOC';
    Parameters.decoding='ED';
    Parameters.show_info=0;
    Parameters.store_training_data=1;
    Parameters.fracrej=fracrej;
    
    base_classifiers = ["svdd", "parzen"];
    aggregators = ["max_agg", "decision_templates_agg", "ecoc_agg"];
    techniques = ["des", "desthr"];
    
    for d = 1:length(datasets)
        dataset_name = datasets(d);
        fprintf("Dataset: " + dataset_name + "\n");

        for n_fold = 1:n_folds
            try
                fprintf("\tFold: #" + n_fold + "\n");
                
                [X_train, y_train] = load_data(sprintf("../%s/%s/%s_%d_train.csv", root_dataset_name, dataset_name, lower(dataset_name), n_fold));
                [X_test, y_test] = load_data(sprintf("../%s/%s/%s_%d_test.csv", root_dataset_name, dataset_name, lower(dataset_name), n_fold));

                for i = 1:length(aggregators)
                    % use aggregator on base_classifier trained and save y_pred with a identifier
                    aggregator_name = aggregators(i);
                    fprintf("\t\tAggregator function: " + aggregator_name + "\n");

                    for j = 1:length(base_classifiers)
                        % run base_classifier (params customized)
                        base_classifier_name = base_classifiers(j);
                        fprintf("\t\t\tBase classifier: " + base_classifier_name + "\n");

                        base_classifier = get_classifier_by_name(base_classifier_name);
                        last_param = get_last_param_by_classifier_name(base_classifier_name);
                        
                        if aggregator_name == "ecoc_agg"
                            Parameters.base_classifier = base_classifier;
                            Parameters.sigma=last_param;
                            
                            [base_classifier_trained, Parameters] = ECOCTrain(X_train, y_train, Parameters);
                            [~, aggregator_result, ~, ~] = ECOCTest(X_test, base_classifier_trained, Parameters, y_test);
                            aggregator_result = aggregator_result'; % Transpose y_pred output (column -> line)
                        else
                            base_classifier_trained = run_base_classifier(base_classifier, X_train, y_train, fracrej, last_param);
                            aggregator_result = run_agg_method_by_name(aggregator_name, base_classifier_trained, X_train, y_train, X_test);
                        end

                        save_fold_output([y_test aggregator_result], result_folder, sprintf("%s/%s", "Experiment1", dataset_name), n_fold, sprintf("%s_%s", base_classifier_name, aggregator_name));
                        
                        for k = 1:length(techniques)
                            % run technique using base_classifier trained and aggregator
                            % save y_pred with a identifier
                            technique_name = techniques(k);
                            fprintf("\t\t\t\tTechnique: " + technique_name + "\n");

                            technique_result = run_techique_by_name(technique_name, base_classifier_trained, X_train, y_train, X_test, alpha, aggregator_name, Parameters);

                            save_fold_output([y_test technique_result], result_folder, sprintf("%s/%s", "Experiment1", dataset_name), n_fold, sprintf("%s_%s_%s", base_classifier_name, aggregator_name, technique_name));
                        end
                    end
                end
            catch ME
                warning("There was a problem with fold #%d. %s", n_fold, ME.message);
            end
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
end