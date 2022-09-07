
clc; clear; close all;
load ../Data/retail_set.mat; L = 10;
N_user = length(data);
N_loc = max([data{:}]);



N_lev = 4;
Prob = [0.05 0.05 0.05 0.85];
W = [1 1.2 2 4];
alpha = ceil(N_loc*Prob);
alpha(4) = alpha(4) + N_loc - sum(alpha);

W_list = [];
for j = 1:N_lev
    W_list = [W_list; j*ones(alpha(j),1)];
end
W_list = W_list(randperm(N_loc));
W_tab = tabulate(W_list);


myEpsilon = [0.5:0.5:4];
N_epsilon = length(myEpsilon);


d = sum(alpha);
fun0 = @(x) alpha*((x(N_lev+1:end)-x(N_lev+1:end).^2)./((x(1:N_lev)-x(N_lev+1:end)).^2))...
    + max((1-x(1:N_lev)-x(N_lev+1:end))./(x(1:N_lev)-x(N_lev+1:end)));
fun1 = @(x) alpha*(exp(x)./((exp(x)-1).^2)); % symmetric
fun2 = @(b) alpha*((b-b.^2)./((0.5-b).^2)) + 1; % a = 0.5

MSE = cell(3,N_epsilon);
RE = cell(3,N_epsilon);
Preci = cell(3,N_epsilon);


for i = 1:N_epsilon
    epsilon = myEpsilon(i);
    temp = W*epsilon;
    
    result(1,i) = N_loc*exp(epsilon/2)./((exp(epsilon/2)-1).^2);
    a = ones(N_lev,1)*exp(epsilon/2)/(exp(epsilon/2)+1); b = 1-a;
    [MSE{1,i}, RE{1,i}, Preci{1,i}] = actual_MSE(a,b,data,L,W_list);
    
    result(2,i) = N_loc*4*exp(epsilon)./((exp(epsilon)-1).^2)+1;
    a = ones(N_lev,1)*0.5; 
    b = ones(N_lev,1)/(exp(epsilon)+1);
    [MSE{2,i}, RE{2,i}, Preci{2,i}] = actual_MSE(a,b,data,L,W_list);
    
    [X, result(3,i)] = min_opt0(temp,fun0);
    a = X(1:N_lev); b = X((N_lev+1):end);
    [MSE{3,i}, RE{3,i}, Preci{3,i}] = actual_MSE(a,b,data,L,W_list);    
    
    fprintf('Finished %d over %d \n',i,N_epsilon);
end
