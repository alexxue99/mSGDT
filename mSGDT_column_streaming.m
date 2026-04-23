% mSGDT for the column missing data model
% streaming setting - row slices of A are generated in each iteration
function [errors, last, sol] = mSGDT_column_streaming(X, N, swapAt, p, b)
[l, q, n] = size(X);
sol = ones(size(X)) * 128;
errors = zeros(N, 1);
swap = false;

count = 1;
f = 1 / 10^6;
    
L = zeros(l, l, 1); % block diagonal of 1's of size b
for i = 1:b:l
    for i1 = i:i+b-1
        for j = i:i+b-1
            L(i1, j, 1) = 1;
        end
    end
end
while (count <= N)
    %errors(count) = norm(X - sol, "fro");
    if mod(count, 1e3) == 0
        disp(count);
    end
    count = count + 1;
    
    A = randn(1, l, n);
    B = tprod(A, X);
    mask = rand(1, l/b) <= p;   % keep blocks with prob p
    mask = repelem(mask, b);    % expand to length l
    A = A .* reshape(mask, 1, l, 1);

    prod = tprod(tran(A), A);
    g = tprod(prod, sol) - p * tprod(tran(A), B);
    g = g - (1 - p) * tprod(L .* prod, sol);
    
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