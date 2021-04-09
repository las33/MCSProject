function run_experiment3()
    n_folds = 5;
    datasets = ["Autos", "Car", "Cleveland", "Dermatology", "Ecoli", "Flare", "Glass", "Isolet", "Led7digit", "Letter-2", "Lymphography", "Nursery", "Page-blocks", "Penbased", "Satimage", "Segment", "Shuttle", "Vehicle", "Vowel", "Yeast", "Zoo", "Auslan"];
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

                for j = 1:length(base_classifiers)
                    base_classifier_name = base_classifiers(j);
                    fprintf("\t\tBase classifier: " + base_classifier_name + "\n");
                    
                    fprintf("\t\t\tTraining: OVO\n");
                    base_classifier_trained_ovo = run_occ_strategy("ovo", base_classifier_name, X_train, y_train);
                    
                    fprintf("\t\t\tTraining: OVA\n");
                    base_classifier_trained_ova = run_occ_strategy("ova", base_classifier_name, X_train, y_train);
                    
                    if base_classifier_name == "svc"
                        Parameters.base_binary = "svm";
                    else
                        Parameters.base_binary = base_classifier_name;
                    end
                    
                    fprintf("\t\t\tTraining: ECOC(OVO)\n");
                    Parameters.coding = 'OneVsOne';
                    [base_classifier_trained_ecoc_ovo, Parameters_ovo] = ECOCTrain(X_train, y_train, Parameters);
                    
                    fprintf("\t\t\tTraining: ECOC(OVA)\n");
                    Parameters.coding = 'OneVsAll';
                    [base_classifier_trained_ecoc_ova, Parameters_ova] = ECOCTrain(X_train, y_train, Parameters);

                    for k = 1:length(occ_strategies)
                        occ_strategie_name = occ_strategies(k);
                        fprintf("\t\t\tOCC: " + occ_strategie_name + "\n");

                        for i = 1:length(aggregators)
                            % use aggregator on base_classifier trained and save y_pred with a identifier
                            aggregator_name = aggregators(i);
                            fprintf("\t\t\t\tAggregator function: " + aggregator_name + "\n");
                            last_aggregator_name = aggregator_name;
                            
                            if aggregator_name == "ecoc_agg"
                                if occ_strategie_name == "ovo"
                                    base_classifier_trained = base_classifier_trained_ecoc_ovo;
                                    Parameters = Parameters_ovo;
                                else
                                    base_classifier_trained = base_classifier_trained_ecoc_ova;
                                    Parameters = Parameters_ova;
                                end
                            elseif occ_strategie_name == "ovo"
                                if aggregator_name == "max_agg"
                                    aggregator_name = "majority_agg";
                                end
                                if aggregator_name == "ecoc_agg"
                                    base_classifier_trained = base_classifier_trained_ecoc_ovo;
                                else
                                    base_classifier_trained = base_classifier_trained_ovo;
                                end
                            elseif occ_strategie_name == "ova"
                                aggregator_name = last_aggregator_name;
                                if aggregator_name == "ecoc_agg"
                                    base_classifier_trained = base_classifier_trained_ecoc_ova;
                                else
                                    base_classifier_trained = base_classifier_trained_ova;
                                end
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

