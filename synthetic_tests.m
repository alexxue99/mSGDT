rng(123);
A = randn(10^6, 20, 10); X = randn(20,10,10); N = 10^6;
x = logspace(0, 6, 200); % for plotting
for i = 1:length(x)
x(i) = ceil(x(i));
end

% run uniform missing data model
disp('Running uniform missing tests')
fun = @mSGDT_uniform;
[errors3, ~, ~] = fun(A, X, N, 5000, 0.3);
[errors5, ~, ~] = fun(A, X, N, 5000, 0.5);
[errors7, ~, ~] = fun(A, X, N, 5000, 0.7);
[errors99, ~, ~] = fun(A, X, N, 5000, 0.99);

fig=figure;
loglog(x, errors99(x), '+', x, errors7(x), '*', x, errors5(x), 'o', x, errors3(x),'x');
ylim([0 30]);
xlabel('Iteration', 'FontSize', 14);
ylabel('Error', 'FontSize', 14);
legend('p=.99','p=.7','p=.5','p=.3')
saveas(fig, "draws/uniform.png");

% run column block missing data model
disp('Running column block missing tests')
fun = @mSGDT_column;
[errors3C, ~, ~] = fun(A, X, N, 5000, 0.3, 4);
[errors5C, ~, ~] = fun(A, X, N, 5000, 0.5, 4);
[errors7C, ~, ~] = fun(A, X, N, 5000, 0.7, 4);
[errors99C, ~, ~] = fun(A, X, N, 5000, 0.99, 4);

fig=figure;
loglog(x, errors99C(x), '+', x, errors7C(x), '*', x, errors5C(x), 'o', x, errors3C(x),'x');
ylim([0 30]);
xlabel('Iteration', 'FontSize', 14);
ylabel('Error', 'FontSize', 14);
legend('p=.99','p=.7','p=.5','p=.3')
saveas(fig, "draws/column.png");

% run frontal slice missing data model
disp('Running frontal slice missing tests')
fun = @mSGDT_frontal;
[errors3F, ~, ~] = fun(A, X, N, 5000, 0.3);
[errors5F, ~, ~] = fun(A, X, N, 5000, 0.5);
[errors7F, ~, ~] = fun(A, X, N, 5000, 0.7);
[errors99F, ~, ~] = fun(A, X, N, 5000, 0.99);

fig=figure;
loglog(x, errors99F(x), '+', x, errors7F(x), '*', x, errors5F(x), 'o', x, errors3F(x),'x');
ylim([0 30]);
xlabel('Iteration', 'FontSize', 14);
ylabel('Error', 'FontSize', 14);
legend('p=.99','p=.7','p=.5','p=.3')
saveas(fig, "draws/frontal.png");