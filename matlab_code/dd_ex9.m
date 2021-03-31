% Show the crossvalidation procedure
%
% Generate some simple data, split it in training and testing data using
% 10-fold cross-validation, and compare several one-class classifiers on
% it.

% Copyright: D.M.J. Tax, D.M.J.Tax@prtools.org
% Faculty EWI, Delft University of Technology
% P.O. Box 5031, 2600 GA Delft, The Netherlands

% Standard parameter:
frac = 0.05;
% Define the classifiers
w = {svdd([],frac,[])*dd_normc
     svdd([],frac,5)*dd_normc
	  mst_dd([],frac,20)*dd_normc
	  };
nrcl = length(w);
% Define the number of cross-validations:
nrbags = 5;
% Generating some OC dataset:


[DATA, LABELS] = load_data(sprintf('car.csv'));

CLASS_LABELS = unique(LABELS);

a1 = oc_set(prdataset(DATA,LABELS),1);

alldata = prdataset(DATA);
svdd_ = svdd(a1,frac,[])*dd_normc;
saida = alldata*svdd_;
saida1 = saida.DATA;
saida2 = saida.DATA(:,1);%APENAS PRIMEIRA COLUNA

W0 = [w0 w1 w2]*meanc;


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
		auc(j,i) = dd_auc(z*wtr*dd_roc);
	end

end

% And the results:
for i=1:nrcl
   cname = getname(w{i});
	fprintf('%35s : %5.3f (%5.3f)\n',cname,mean(auc(i,:),2),std(auc(i,:),[],2));
end
