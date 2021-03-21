

[data_train, labels_train] = load_data('C:\Users\leona\Documents\Mestrado_code\MCSProject\ProcessedBases\Penbased\penbased_3_train.csv');
classifiers = run_base_classifier(svdd, data_train, labels_train, 0.0045, 5);

[data_test, labels_test] = load_data('C:\Users\leona\Documents\Mestrado_code\MCSProject\ProcessedBases\Penbased\penbased_3_test.csv');


y_pred_1 = max_agg(classifiers,data_test);

y_pred = decision_templates_agg(classifiers,data_train, labels_train, data_test);

