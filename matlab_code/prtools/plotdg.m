%PLOTDG Plot dendrogram
% 
%   PLOTDG(DENDROGRAM,K,FLIP)
% 
% INPUT
%   DENDROGRAM Dendrogram
%   K          Number of clusters
%   FLIP       FALSE (default) or TRUE
%
% OUTPUT
%
% DESCRIPTION
% Plots a dendrogram as generated by HCLUST. If the optional K is given the
% dendrogram is compressed first to K clusters. Along the horizontal axis
% the numbers stored in DENDROGRAM(1,:) are written as text. The dendrogram
% itself is defined by DENDROGRAM(2,:) in which each entry stands for the
% level on which the previous and next group of objects are clustered.
% 
% This routine also accepts dendrograms computed by Matlab's LINKAGE
%
% SEE ALSO (<a href="http://prtools.tudelft.nl/prtools">PRTools Guide</a>)
% HCLUST, LINKAGE

% Copyright: R.P.W. Duin, duin@ph.tn.tudelft.nl
% Faculty of Applied Sciences, Delft University of Technology
% P.O. Box 5046, 2600 GA Delft, The Netherlands

% $Id: plotdg.m,v 1.2 2006/03/08 22:06:58 duin Exp $

function plotdg(varargin)

	[dendro,k,flip] = setdefaults(varargin,[],[],false);
  if isempty(dendro)
    error('No proper dendrogram supplied')
  end
  if ~isinf(dendro(2,1))
    dendro = mat2pr_den(dendro);
  end
	[n,m] = size(dendro);
  if isempty(k), k = m; end 
  
	if k < m	% compress dendrogram to k clusters
		F = [dendro(2,:),inf];
		S = sort(-F); t = -S(k+1);   % find cluster level
		I = [find(F >= t),m+1];      % find all indices where cluster starts
		dendro = [I(2:k+1) - I(1:k); F(I(1:k))];
		m = k;
  elseif k > m
    error('Number of clusters should be less than sample size')
	end
	[S,I] = sort(dendro(2,:));

	C = [0:m-1;1:m;zeros(1,m);2:m+1];
	X = zeros(m,4); Y = X;
	T = zeros(m,4);
	for i=1:m-1
		X(i,:) = [C(2,I(i)), C(2,I(i)), C(2,C(1,I(i))), C(2,C(1,I(i)))];
		Y(i,:) = [C(3,I(i)), S(i), S(i), C(3,C(1,I(i)))];
		C(:,C(1,I(i))) = [C(1,C(1,I(i))), (C(2,I(i)) + C(2,C(1,I(i))))/2, ...
				  S(i), C(4,I(i))]';
		C(1,C(4,I(i))) = C(1,I(i));
		T(i,:) = sprintf('%4d',dendro(1,i));
	end
	T(m,:) = sprintf('%4d',dendro(1,m));
	T = char(T);
	h = gca;
  
  if flip
    X(m,:) = [0 0 m+1 m+1];
    Y(m,:) = [0 0 0 0];
    plot(Y',X','-b');
    set(h,'ytick',[1:m]);
    set(h,'yticklabel',T);
    axis([0,max(max(Y))*1.05,0,m+1])
  else
    X(m,:) = [0 0 m+1 m+1];
    Y(m,:) = [0 0 0 0];
    plot(X',Y','-b');
    set(h,'xtick',[1:m]);
    set(h,'xticklabel',T);
    axis([0,m+1,0,max(max(Y))*1.05])
  end
  
	set(h,'box','off');
	set(h,'fontsize',8)

	return
  
