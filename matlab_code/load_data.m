function [ DATA, LABELS ] = load_data( filename )
  FILE = importdata(filename);
  
  if isstruct(FILE)
      DATA = FILE.data;
      LABELS = cell2mat(FILE.textdata);
  else
      DATA = FILE(:, 1:(size(FILE, 2)-1));
      LABELS = FILE(:, size(FILE, 2));
  end
end

