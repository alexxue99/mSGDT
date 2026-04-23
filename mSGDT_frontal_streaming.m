% mSGDT for the column missing data model
% streaming setting - row slices of A are generated in each iteration
function [errors, last, sol] = mSGDT_frontal_streaming(X, N, swapAt, p, sol)
[l, q, n] = size(X);
sol = ones(size(X)) * 128;
errors = zeros(N, 1);
swap = false;

count = 1;
f = 1 / 10^6;
str = "frontal_p" + sprintf("%d", 10*p);

while (count <= N)
    %errors(count) = norm(X - sol, "fro");
    if mod(count, 1e4) == 0
        disp(count);
        save("data/" + str + "_1e5.mat", 'sol', 'count')
    end
    count = count + 1;
    
    A = randn(1, l, n);
    B = tprod(A, X);
    mask = rand(1, n) <= p;   % keep blocks with prob p
    mask = repelem(mask, l);    % expand to length l
    A = A .* reshape(mask, 1, l, n);

    prod = tprod(tran(A), A);
    g = tprod(prod, sol) - p * tprod(tran(A), B);

    correction = zeros(l, l, n); 
    correction(:, :, 1) = prod(:, :, 1);
    g = g - (1 - p) * tprod(correction, sol);
    
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