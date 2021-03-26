clear Parameters;
Parameters.coding='DECOC';
Parameters.decoding='ED';
Parameters.store_training_data=1;

Parameters.base_classifier=svdd;
Parameters.fracrej=0.0045;
Parameters.sigma=5;


[data_train, labels_train] = load_data('C:\Users\leona\Documents\Mestrado_code\MCSProject\ProcessedBases\Penbased\penbased_3_train.csv');
%classifiers = run_base_classifier(svdd, data_train, labels_train, 0.0045, 5);

[data_test, labels_test] = load_data('C:\Users\leona\Documents\Mestrado_code\MCSProject\ProcessedBases\Penbased\penbased_3_test.csv');

[Classifiers,Parameters]=ECOCTrain(data_train,labels_train,Parameters);


ECOC = Parameters.ECOC;

ECOC(ECOC==-1)=0;

Parameters.ECOC = ECOC;    


%%%% DES É APLICADO AQUI

[result,Labels,Values,confusion]=ECOCTest(data_test,Classifiers,Parameters,labels_test);
result;