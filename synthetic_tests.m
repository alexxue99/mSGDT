rng(123);
A = randn(10^6, 20, 10); X = randn(20,10,10); N = 10^6;
x = logspace(0, 6, 200); % for plotting
for i = 1:length(x)
    x(i) = ceil(x(i));
end

nRuns = 30;

%% ── Uniform missing data model ──────────────────────────────────────────────
tic
disp('Running uniform missing tests')
fun = @mSGDT_uniform;

all_errors3   = zeros(nRuns, length(x));
all_errors5   = zeros(nRuns, length(x));
all_errors7   = zeros(nRuns, length(x));
all_errors99  = zeros(nRuns, length(x));

for r = 1:nRuns
    [e3,  ~, ~] = fun(A, X, N, 5000, 0.3);  all_errors3(r,:)  = e3(x);
    [e5,  ~, ~] = fun(A, X, N, 5000, 0.5);  all_errors5(r,:)  = e5(x);
    [e7,  ~, ~] = fun(A, X, N, 5000, 0.7);  all_errors7(r,:)  = e7(x);
    [e99, ~, ~] = fun(A, X, N, 5000, 0.99); all_errors99(r,:) = e99(x);
end
toc

mu3   = mean(all_errors3);   sd3   = std(all_errors3);
mu5   = mean(all_errors5);   sd5   = std(all_errors5);
mu7   = mean(all_errors7);   sd7   = std(all_errors7);
mu99  = mean(all_errors99);  sd99  = std(all_errors99);

fig = figure;
set(gca, 'XScale', 'log', 'YScale', 'log'); hold on;
shadedErrorBar(x, mu99, sd99, 'lineProps', {'-', 'Color', [0.00 0.45 0.74]}, 'transparent', 1);
shadedErrorBar(x, mu7,  sd7,  'lineProps', {'-', 'Color', [0.85 0.33 0.10]}, 'transparent', 1);
shadedErrorBar(x, mu5,  sd5,  'lineProps', {'-', 'Color', [0.93 0.69 0.13]}, 'transparent', 1);
shadedErrorBar(x, mu3,  sd3,  'lineProps', {'-', 'Color', [0.49 0.18 0.56]}, 'transparent', 1);
ylim([0 30]);
xlabel('Iteration', 'FontSize', 14); ylabel('Error', 'FontSize', 14);
legend('p=.99','p=.7','p=.5','p=.3');
saveas(fig, "draws/uniform.png");
save("data/uniform_synthetic.mat", "mu3", "mu5", "mu7", "mu99", "sd3", "sd5", "sd7", "sd99");

%% ── Column block missing data model ─────────────────────────────────────────
disp('Running column block missing tests')
fun = @mSGDT_column;

all_errors3C  = zeros(nRuns, length(x));
all_errors5C  = zeros(nRuns, length(x));
all_errors7C  = zeros(nRuns, length(x));
all_errors99C = zeros(nRuns, length(x));

for r = 1:nRuns
    [e3,  ~, ~] = fun(A, X, N, 5000, 0.3,  4); all_errors3C(r,:)  = e3(x);
    [e5,  ~, ~] = fun(A, X, N, 5000, 0.5,  4); all_errors5C(r,:)  = e5(x);
    [e7,  ~, ~] = fun(A, X, N, 5000, 0.7,  4); all_errors7C(r,:)  = e7(x);
    [e99, ~, ~] = fun(A, X, N, 5000, 0.99, 4); all_errors99C(r,:) = e99(x);
end
toc

mu3C  = mean(all_errors3C);  sd3C  = std(all_errors3C);
mu5C  = mean(all_errors5C);  sd5C  = std(all_errors5C);
mu7C  = mean(all_errors7C);  sd7C  = std(all_errors7C);
mu99C = mean(all_errors99C); sd99C = std(all_errors99C);

fig = figure;
set(gca, 'XScale', 'log', 'YScale', 'log'); hold on;
shadedErrorBar(x, mu99C, sd99C, 'lineProps', {'-', 'Color', [0.00 0.45 0.74]}, 'transparent', 1);
shadedErrorBar(x, mu7C,  sd7C,  'lineProps', {'-', 'Color', [0.85 0.33 0.10]}, 'transparent', 1);
shadedErrorBar(x, mu5C,  sd5C,  'lineProps', {'-', 'Color', [0.93 0.69 0.13]}, 'transparent', 1);
shadedErrorBar(x, mu3C,  sd3C,  'lineProps', {'-', 'Color', [0.49 0.18 0.56]}, 'transparent', 1);
ylim([0 30]);
xlabel('Iteration', 'FontSize', 14); ylabel('Error', 'FontSize', 14);
legend('p=.99','p=.7','p=.5','p=.3');
saveas(fig, "draws/column.png");
save("data/column_synthetic.mat", "mu3C", "mu5C", "mu7C", "mu99C", "sd3C", "sd5C", "sd7C", "sd99C");

%% ── Frontal slice missing data model ────────────────────────────────────────
disp('Running frontal slice missing tests')
fun = @mSGDT_frontal;

all_errors3F  = zeros(nRuns, length(x));
all_errors5F  = zeros(nRuns, length(x));
all_errors7F  = zeros(nRuns, length(x));
all_errors99F = zeros(nRuns, length(x));

for r = 1:nRuns
    [e3,  ~, ~] = fun(A, X, N, 5000, 0.3);  all_errors3F(r,:)  = e3(x);
    [e5,  ~, ~] = fun(A, X, N, 5000, 0.5);  all_errors5F(r,:)  = e5(x);
    [e7,  ~, ~] = fun(A, X, N, 5000, 0.7);  all_errors7F(r,:)  = e7(x);
    [e99, ~, ~] = fun(A, X, N, 5000, 0.99); all_errors99F(r,:) = e99(x);
end
toc

mu3F  = mean(all_errors3F);  sd3F  = std(all_errors3F);
mu5F  = mean(all_errors5F);  sd5F  = std(all_errors5F);
mu7F  = mean(all_errors7F);  sd7F  = std(all_errors7F);
mu99F = mean(all_errors99F); sd99F = std(all_errors99F);

fig = figure;
set(gca, 'XScale', 'log', 'YScale', 'log'); hold on;
shadedErrorBar(x, mu99F, sd99F, 'lineProps', {'-', 'Color', [0.00 0.45 0.74]}, 'transparent', 1);
shadedErrorBar(x, mu7F,  sd7F,  'lineProps', {'-', 'Color', [0.85 0.33 0.10]}, 'transparent', 1);
shadedErrorBar(x, mu5F,  sd5F,  'lineProps', {'-', 'Color', [0.93 0.69 0.13]}, 'transparent', 1);
shadedErrorBar(x, mu3F,  sd3F,  'lineProps', {'-', 'Color', [0.49 0.18 0.56]}, 'transparent', 1);
ylim([0 30]);
xlabel('Iteration', 'FontSize', 14); ylabel('Error', 'FontSize', 14);
legend('p=.99','p=.7','p=.5','p=.3');
saveas(fig, "draws/frontal.png");
save("data/frontal_synthetic.mat", "mu3F", "mu5F", "mu7F", "mu99F", "sd3F", "sd5F", "sd7F", "sd99F");