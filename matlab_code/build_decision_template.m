function [decision_template, output_labels] = build_decision_template(decision_profile, input_labels)
    output_labels = unique(input_labels);
    
    decision_template = zeros(length(output_labels), size(decision_profile, 2));
    
    for i = 1:length(output_labels)
        current_label = output_labels(i);
        c_template = zeros(1, size(decision_profile, 2));
        count = 0;
        for j = 1:length(input_labels)
            if(input_labels(j) == current_label)
               c_template =  sum([c_template; decision_profile(i, :)]);
               count = count + 1;
            end
        end
        c_template = c_template/count;
        decision_template(i, :) = c_template;
    end
end

