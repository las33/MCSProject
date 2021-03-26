function classifier = get_classifier_by_name(classifier_name)
    if classifier_name == "svdd"
        classifier = svdd;
    elseif classifier_name == "parzen"
        classifier = parzen_dd;
    elseif classifier_name == "mst"
        classifier = mst_dd;
    end
end