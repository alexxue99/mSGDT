% mSGDT for the uniform missing data model
% streaming setting - row slices of A are generated in each iteration
function [errors, last, sol] = mSGDT_uniform_streaming(X, N, swapAt, p)
[l, q, n] = size(X);
sol = ones(size(X)) * 128;
errors = zeros(N, 1);
swap = false;

count = 1;
f = 1 / 10^6;

fdiag = zeros(l, l, n);
while (count <= N)
    errors(count) = norm(X - sol, "fro");
    count = count + 1;
    
    A = randn(1, l, n);
    randmatrix = rand(size(A));
    B = tprod(A, X);
    A(randmatrix >= p) = 0;

    prod = tprod(tran(A), A);
    g = tprod(prod, sol) - p * tprod(tran(A), B);
    fdiag(:, :, 1) = diag(diag(prod(:, :, 1)));
    g = g - (1 - p) * tprod(fdiag, sol);
    
    if count == swapAt
        swap = true;
    end
    if swap
        f = sqrt(swapAt) / (10^6 * sqrt(count));
    end
    
    sol = sol - f * g;
end
last = errors(end);
fprintf("error at last iteration %.5f\n", last)
end