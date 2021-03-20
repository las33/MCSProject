

[data_train, labels_train] = load_data('C:\Users\leona\Documents\Mestrado_code\MCSProject\ProcessedBases\Penbased\penbased_2_train.csv');
classifiers = run_base_classifier(svdd, data_train, labels_train, 0.05, 5);

[data_test, labels_test] = load_data('C:\Users\leona\Documents\Mestrado_code\MCSProject\ProcessedBases\Penbased\penbased_2_test.csv');


y_pred = max_agg(classifiers,data_test);

