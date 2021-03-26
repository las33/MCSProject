
[data_train, labels_train] = load_data('C:\Users\leona\Documents\Mestrado_code\MCSProject\ProcessedBases\Penbased\penbased_3_train.csv');


[data_test, labels_test] = load_data('C:\Users\leona\Documents\Mestrado_code\MCSProject\ProcessedBases\Penbased\penbased_3_test.csv');

classifiers_ovo = ovo('svc', data_train, labels_train);

%classifiers_ova = ova('svc', data_train, labels_train);


%Se for ovo usar majority_agg no lugar do max
y_pred = majority_agg(classifiers_ovo, data_test);

hits = y_pred == labels_test;

num = sum(hits == 1)/length(labels_test);
