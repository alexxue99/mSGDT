% mSGDT for the uniform missing data model
function [errors, last, sol] = mSGDT_uniform(A, X, N, swapAt, p)
B = tprod(A, X);
[m, l, n] = size(A);
sol = zeros(size(X));
errors = zeros(N, 1);

swap = false; % flag indicating when to swap from constant step size to changing

random_matrix = rand(size(A));
Atilde = zeros(size(A));
Atilde(random_matrix <= p) = A(random_matrix <= p); % randomly chosen elements set to zero

count = 1;
f = 1 / swapAt; % initial factor for the constant step size

fdiag = zeros(l, l, n);

while (count <= N)
    errors(count) = norm(X - sol, "fro");

    i = count;
    count = count + 1;

    row = Atilde(i, :, :);

    prod = tprod(tran(row), row);
    g = tprod(prod, sol) - p * tprod(tran(row), B(i, :, :));
    fdiag(:, :, 1) = diag(diag(prod(:, :, 1)));
    g = g - (1 - p) * tprod(fdiag, sol);
    %g = g / p
    
    if count == swapAt
        swap = true;
    end
    if swap
        f = 1 / sqrt(swapAt * count);
    end
    
    sol = sol - f * g;
end
last = errors(end);
fprintf("error at last iteration %.5f\n", last)
end