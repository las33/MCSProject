% Show the crossvalidation procedure
%
% Generate some simple data, split it in training and testing data using
% 10-fold cross-validation, and compare several one-class classifiers on
% it.

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

% Standard parameter:
% Standard parameter:
frac = 0.05;
reg = 1e-2;
% Define the classifiers
w = {parzen_dd([],frac,[])*dd_normc
     svdd([],frac,5)*dd_normc
	  mst_dd([],frac,20)*dd_normc
	  };
nrcl = length(w);
% Define the number of cross-validations:
nrbags = 10;
% Generating some OC dataset:
[data, labels] = load_data('C:\Users\barre\Documents\projeto\MCSProject\ProcessedBases\Penbased/penbased.csv');
pr = prdataset(data, labels);
a = oc_set(pr,1);
% a = oc_set(gendatb([100 60],1.6),'1');

% Set up:
auc = zeros(nrcl,nrbags);
I = nrbags;
% Run over the crossvalidation runs:
for i=1:nrbags
	[x,z,I] = dd_crossval(a,I);

	% Train three classifiers:
	for j=1:nrcl
		wtr = x*w{j};
		% evaluate the classifiers:
		%auc(j,i) = dd_auc(z*wtr*dd_roc);
        disp(z*wtr)
	end

end

% And the results:
for i=1:nrcl
   cname = getname(w{i});
	fprintf('%35s : %5.3f (%5.3f)\n',cname,mean(auc(i,:),2),std(auc(i,:),[],2));
end
