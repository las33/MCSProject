function [X, y] = load_data(filename)
  FILE = importdata(filename);
  
  if isstruct(FILE)
      X = FILE.data;
      y = cell2mat(FILE.textdata);
  else
      X = FILE(:, 1:(size(FILE, 2)-1));
      y = FILE(:, size(FILE, 2));
  end
end

