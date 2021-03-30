function run_experiment3()
    n_folds = 5;
    datasets = ["Auslan", "Autos", "Car", "Cleveland", "Dermatology", "Ecoli", "Flare", "Glass", "Isolet", "Led7digit", "Letter-2", "Lymphography", "Nursery", "Page-blocks", "Penbased", "Satimage", "Segment", "Shuttle", "Vehicle", "Vowel", "Yeast", "Zoo"];
    
    alpha = 0.1;
    root_dataset_name = "ProcessedBases_MinMax";
    result_folder = "results_MinMax_prunned";
    
    base_classifiers = ["svc"]; %c4.5
    aggregators = ["max_agg", "decision_templates_agg"];%, "ecoc_agg"];
    occ_strategies = ["ovo", "ova"];
    techniques = ["desthr"];
    
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
                        base_classifier_name = base_classifiers(j);
                        fprintf("\t\t\tBase classifier: " + base_classifier_name + "\n");
                        
                        for k = 1:length(occ_strategies)
                            occ_strategie_name = occ_strategies(k);
                            fprintf("\t\t\t\tOCC: " + occ_strategie_name + "\n");
                            
                            base_classifier_trained = run_occ_strategy(occ_strategie_name, base_classifier_name, X_train, y_train);
                            
                            if occ_strategie_name == "ovo" && aggregator_name == "max_agg"
                                aggregator_name = "majority_agg";
                            end
                            
                            for l = 1:length(techniques)
                                % run technique using base_classifier trained and aggregator
                                % save y_pred with a identifier
                                technique_name = techniques(k);
                                fprintf("\t\t\t\t\tTechnique: " + technique_name + "\n");

                                technique_result = run_technique_by_name(technique_name, base_classifier_trained, X_train, y_train, X_test, y_test, alpha, aggregator_name, Parameters);

                                save_fold_output([y_test technique_result], result_folder, sprintf("%s/%s", "Experiment3", dataset_name), n_fold, sprintf("%s_%s_%s_%s", base_classifier_name, aggregator_name, occ_strategie_name, technique_name));
                            end
                        end
                    end
                end
            catch ME
                warning("There was a problem with fold #%d. %s", n_fold, ME.message);
            end
        end
    end
end

