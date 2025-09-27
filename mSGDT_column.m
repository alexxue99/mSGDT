% mSGDT for the column block missing data model
function [errors, last, sol] = mSGDT_column(A, X, N, swapAt, p, b) 
B = tprod(A, X);
[m, l, n] = size(A);
sol = zeros(size(X));
errors = zeros(N, 1);

swap = false;

f = 1 / swapAt;

Atilde = A;
for i = 1:m
    for j = 1:b:l
        % zero out column block with y-coordinates in {j,...,j+b-1}
        if rand > p
            for j1 = j:j+b-1
                for k1 = 1:n
                    Atilde(i, j1, k1) = 0;
                end
            end
        end
    end
end

L = zeros(l, l, 1); % block diagonal of 1's of size b
for i = 1:b:l
    for i1 = i:i+b-1
        for j = i:i+b-1
            L(i1, j, 1) = 1;
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

    for k = 1:1:n
        correction(:, :, k) = L .* prod(:, :, k);
    end

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