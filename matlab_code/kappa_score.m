% Kappa score function based on https://github.com/elayden/cohensKappa/blob/master/cohensKappa.m

function score = kappa_score(y_true, y_pred)
    C = confusionmat(y_true, y_pred);
    n = sum(C(:));
    C = C./n;
    expected = sum(C,2) * sum(C);
    po = sum(diag(C));
    pe = sum(diag(expected));
    score = (po-pe)/(1-pe);
end

