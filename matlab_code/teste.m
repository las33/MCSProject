clear Parameters;
Parameters.coding='DECOC';
Parameters.decoding='ED';
Parameters.store_training_data=0;

Parameters.base_classifier=svdd;
Parameters.base_binary = ''; %usa o que estiver em base_classifier
Parameters.fracrej=0.05;
Parameters.sigma=5;
%Parameters.removed_classes = [1]; %classes removidas pelo des
%Parameters.removed_clfs = [2,5]; %index dos classificadores removidos pelo
%des


[data_train, labels_train] = load_data('C:\Users\leona\Documents\Mestrado_code\MCSProject\ProcessedBases\Penbased\penbased_3_train.csv');
classifiers = run_base_classifier(svdd, data_train, labels_train, 0.05, 5);

[data_test, labels_test] = load_data('C:\Users\leona\Documents\Mestrado_code\MCSProject\ProcessedBases\Penbased\penbased_3_test.csv');


y_pred_max = max_agg(classifiers,data_test);
y_pred_dt = decision_templates_agg(classifiers,data_train, labels_train, data_test);


hits = y_pred_max == labels_test;
acc_max = sum(hits == 1)/length(labels_test);

hits = y_pred_dt == labels_test;
acc_dt = sum(hits == 1)/length(labels_test);

[Classifiers,Parameters]=ECOCTrain(data_train,labels_train,Parameters);
[acc_ecoc,~,~,~]=ECOCTest(data_test,Classifiers,Parameters,labels_test);

