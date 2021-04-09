function run_experiment2()
    n_folds = 5;
    datasets = ["Auslan", "Autos", "Car", "Cleveland", "Dermatology", "Ecoli", "Flare", "Glass", "Isolet", "Led7digit", "Letter-2", "Lymphography", "Nursery", "Page-blocks", "Penbased", "Satimage", "Segment", "Shuttle", "Vehicle", "Vowel", "Yeast", "Zoo"];
    
    root_dataset_name = "ProcessedBases";
    result_folder = "results";
    
    K = [0, 1, 3];
    
    for d = 1:length(datasets)
        dataset_name = datasets(d);
        fprintf("Dataset: " + dataset_name + "\n");

        for n_fold = 1:n_folds
            fprintf("\tFold: #" + n_fold + "\n");

            [X_train, y_train] = load_data(sprintf("../%s/%s/%s_%d_train.csv", root_dataset_name, dataset_name, lower(dataset_name), n_fold));
            [X_test, y_test] = load_data(sprintf("../%s/%s/%s_%d_test.csv", root_dataset_name, dataset_name, lower(dataset_name), n_fold));

            for i = 1:length(K)
                k = K(i);
                fprintf("\t\tK: " + k + "\n");
                knn_result = run_knn(k, X_train, y_train, X_test);

                save_fold_output([y_test knn_result], result_folder, sprintf("%s/%s", "Experiment2", dataset_name), n_fold, sprintf("k%d", k));
            end
        end
    end
end

