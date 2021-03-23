function run_experiment()
    n_folds = 5;
    dataset_name = 'Penbased';
    fracrej = 0.05;
    sigma = 5;
    width_param = [];
    N = 20;
    alpha = 0.1;
    base_classifiers = ['svdd', 'parzen', 'mst'];
    aggregators = ['max_agg', 'decision_templates_agg', 'ecoc_agg'];
    techniques = ['des', 'desthr'];
    
    results = zeros(n_folds);
    for n_fold = 1:length(n_folds)
        epoch = struct();
        epoch.fold = n_fold;
        
        [X_train, y_train] = load_data(sprintf('../ProcessedBases/%s/%s_%d_train.csv', dataset_name, lower(dataset_name), n_fold));
        [X_test, y_test] = load_data(sprintf('../ProcessedBases/%s/%s_%d_test.csv', dataset_name, lower(dataset_name), n_fold));
        
        for i = 1:length(base_classifiers)
            base_classifier = base_classifiers(i);
            % run base_classifier (params customized)
            for j = 1:length(aggregators)
                aggregator = aggregators(i);
                % use aggregator on base_classifier trained and save y_pred with a identifier
                for k = 1:length(techniques)
                    technique = techniques(i);
                    % run technique using base_classifier trained and aggregator
                    % save y_pred with a identifier
                end
            end
        end
        
        results(n_fold) = epoch;
        
        % SVDD
        svdd_trained = run_base_classifier(svdd, X_train, y_train, fracrej, sigma);
        
        svdd_max_pred = max_agg(svdd_trained, X_test);
        svdd_dt_pred = decision_templates_agg(svdd_trained, X_train, y_train, X_test);
        %svdd_ecoc_pred = ecoc_agg();
        des_svdd_max_pred = des(svdd_trained, X_train, y_train, X_test, max_agg, 0);
        des_svdd_dt_pred = des(svdd_trained, X_train, y_train, X_test, decision_templates_agg, 0);
        %des_svdd_ecoc_pred = des(svdd_trained, X_train, y_train, X_test, ecoc_agg, 0);
        desthr_svdd_max_pred = des(svdd_trained, X_train, y_train, X_test, max_agg, alpha);
        desthr_svdd_dt_pred = des(svdd_trained, X_train, y_train, X_test, decision_templates_agg, alpha);
        %desthr_svdd_ecoc_pred = des(svdd_trained, X_train, y_train, X_test, ecoc_agg, alpha);
        
        accuracy_score(y_test, svdd_max_pred);
        accuracy_score(y_test, svdd_dt_pred);
        accuracy_score(y_test, svdd_ecoc_pred);
        accuracy_score(y_test, des_svdd_max_pred);
        accuracy_score(y_test, des_svdd_dt_pred);
        accuracy_score(y_test, des_svdd_ecoc_pred);
        accuracy_score(y_test, desthr_svdd_max_pred);
        accuracy_score(y_test, desthr_svdd_dt_pred);
        accuracy_score(y_test, desthr_svdd_ecoc_pred);
        
        kappa_score(y_test, svdd_max_pred);
        kappa_score(y_test, svdd_dt_pred);
        kappa_score(y_test, svdd_ecoc_pred);
        kappa_score(y_test, des_svdd_max_pred);
        kappa_score(y_test, des_svdd_dt_pred);
        kappa_score(y_test, des_svdd_ecoc_pred);
        kappa_score(y_test, desthr_svdd_max_pred);
        kappa_score(y_test, desthr_svdd_dt_pred);
        kappa_score(y_test, desthr_svdd_ecoc_pred);
        
        % PARZEN
        parzen_trained = run_base_classifier(parzen_dd, X_train, y_train, fracrej, width_param);

        parzen_max_pred = max_agg(parzen_trained, X_test);
        parzen_dt_pred = decision_templates_agg(parzen_trained, X_train, y_train, X_test);
        %parzen_ecoc_pred = ecoc_agg();
        des_parzen_max_pred = des(parzen_trained, X_train, y_train, X_test, max_agg, 0);
        des_parzen_dt_pred = des(parzen_trained, X_train, y_train, X_test, decision_templates_agg, 0);
        %des_parzen_ecoc_pred = des(parzen_trained, X_train, y_train, X_test, ecoc_agg, 0);
        desthr_parzen_max_pred = des(parzen_trained, X_train, y_train, X_test, max_agg, alpha);
        desthr_parzen_dt_pred = des(parzen_trained, X_train, y_train, X_test, decision_templates_agg, alpha);
        %desthr_parzen_ecoc_pred = des(parzen_trained, X_train, y_train, X_test, ecoc_agg, alpha);
        
        % MST
        mst_trained = run_base_classifier(mst_dd, X_train, y_train, fracrej, N);
        
        mst_max_pred = max_agg(mst_trained, X_test);
        mst_dt_pred = decision_templates_agg(mst_trained, X_train, y_train, X_test);
        %mst_ecoc_pred = ecoc_agg();
        des_mst_max_pred = des(mst_trained, X_train, y_train, X_test, max_agg, 0);
        des_mst_dt_pred = des(mst_trained, X_train, y_train, X_test, decision_templates_agg, 0);
        %des_mst_ecoc_pred = des(mst_trained, X_train, y_train, X_test, ecoc_agg, 0);
        desthr_mst_max_pred = des(mst_trained, X_train, y_train, X_test, max_agg, alpha);
        desthr_mst_dt_pred = des(mst_trained, X_train, y_train, X_test, decision_templates_agg, alpha);
        %desthr_mst_ecoc_pred = des(mst_trained, X_train, y_train, X_test, ecoc_agg, alpha);
    end
end

