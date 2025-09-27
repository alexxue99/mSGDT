% mSGDT for the frontal slice missing data model
function [errors, last, sol] = mSGDT_frontal(A, X, N, swapAt, p) 
B = tprod(A, X);
[m, l, n] = size(A);
sol = zeros(size(X));
errors = zeros(N, 1);

swap = false;
f = 1 / swapAt;
Atilde = A;
for i = 1:m
    for k = 1:1:n
        if rand > p
            % zero out kth frontal slice
            for j1 = 1:1:l
                Atilde(i, j1, k) = 0;
            end
        end
    end
end

count = 1;
while (count <= N)
    errors(count) = norm(X - sol, "fro");
    i = count;
    count = count + 1;

    ith = Atilde(i, :, :);

    prod = tprod(tran(ith), ith);
    g = tprod(prod, sol) - p * tprod(tran(ith), B(i, :, :));
    correction = zeros(l, l, n); 
    correction(:, :, 1) = prod(:, :, 1);

    g = g - (1 - p) * tprod(correction, sol);
    
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