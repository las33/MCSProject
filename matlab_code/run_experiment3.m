function run_experiment3()
    n_folds = 5;
    datasets = ["Auslan", "Autos", "Car", "Cleveland", "Dermatology", "Ecoli", "Flare", "Glass", "Isolet", "Led7digit", "Letter-2", "Lymphography", "Nursery", "Page-blocks", "Penbased", "Satimage", "Segment", "Shuttle", "Vehicle", "Vowel", "Yeast", "Zoo"];
    alpha = 0.1;
    root_dataset_name = "ProcessedBases";
    result_folder = "results";
    
    clear Parameters;
    Parameters.decoding='ED';
    Parameters.show_info=0;
    Parameters.store_training_data=0;
    Parameters.fracrej=0.1;
    Parameters.sigma=5;
    Parameters.base_classifier=[];
    
    base_classifiers = ["svc", "tree"];
    aggregators = ["max_agg", "decision_templates_agg", "ecoc_agg"];
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
                    last_aggregator_name = aggregator_name;
                    for j = 1:length(base_classifiers)
                        base_classifier_name = base_classifiers(j);
                        fprintf("\t\t\tBase classifier: " + base_classifier_name + "\n");
                        
                        if aggregator_name == "ecoc_agg"
                            if base_classifier_name == "svc"
                                Parameters.base_binary = "svm";
                            else
                                Parameters.base_binary = base_classifier_name;
                            end
                        end
                        
                        for k = 1:length(occ_strategies)
                            occ_strategie_name = occ_strategies(k);
                            fprintf("\t\t\t\tOCC: " + occ_strategie_name + "\n");
                            
                            if aggregator_name == "ecoc_agg"
                                if occ_strategie_name == "ovo"
                                    Parameters.coding = 'OneVsOne';
                                elseif occ_strategie_name == "ova"
                                    Parameters.coding = 'OneVsAll';
                                end

                                [base_classifier_trained, Parameters] = ECOCTrain(X_train, y_train, Parameters);
                            else
                                base_classifier_trained = run_occ_strategy(occ_strategie_name, base_classifier_name, X_train, y_train);
                            end
                            
                            if occ_strategie_name == "ovo"
                                if aggregator_name == "max_agg"
                                    aggregator_name = "majority_agg";
                                end
                            elseif occ_strategie_name == "ova"
                                aggregator_name = last_aggregator_name;
                            end
                            
                            for l = 1:length(techniques)
                                % run technique using base_classifier trained and aggregator
                                % save y_pred with a identifier
                                technique_name = techniques(l);
                                fprintf("\t\t\t\t\tTechnique: " + technique_name + "\n");

                                technique_result = run_technique_by_name(technique_name, base_classifier_trained, X_train, y_train, X_test, y_test, alpha, aggregator_name, Parameters);

                                save_fold_output([y_test technique_result], result_folder, sprintf("%s/%s", "Experiment3", dataset_name), n_fold, sprintf("%s_%s_%s_%s", base_classifier_name, aggregator_name, occ_strategie_name, technique_name));
                                
                                fprintf("\t\t\t\t\t\tAccuracy: " + accuracy_score(y_test, technique_result) + "\n");
                                fprintf("\t\t\t\t\t\tKappa: " + kappa_score(y_test, technique_result) + "\n");
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

