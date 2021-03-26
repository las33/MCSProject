function save_fold_output(content, database_name, n_fold, identifier)
    target_folder = sprintf("../results/%s", database_name);
    if ~exist(target_folder, "dir")
        mkdir(target_folder);
    end

    writematrix(content, sprintf("%s/fold_%d_%s.csv", target_folder, n_fold, identifier));
end