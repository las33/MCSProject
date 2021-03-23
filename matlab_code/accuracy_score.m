function score = accuracy_score(y_true, y_pred)
    score = mean(y_true == y_pred);
end
