function [X] = featureScaling(X)

X_min = min(X(:));
X_max = max(X(:));

X = (X - X_min) ./ (X_max - X_min);

end