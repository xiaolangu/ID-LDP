%% Plot setting
clc; clear; close all;
set(0,'defaulttextinterpreter','latex'); 
set(0,'defaultlinelinewidth',1.3); 
set(0,'DefaultLineMarkerSize',6); 
set(0,'DefaultTextFontSize', 14); 
set(0,'DefaultAxesFontSize',14); 

figure;
h = plot([1 2],rand(6,2));
c = get(h,'Color');
Color = cell2mat(c);
Color = Color([1 2 5 3 4],:);
Color(3,:) = [0.13,0.55,0.13];
close all;


%%

N_lev = 3; W = [1 1.2 2];
N_loc = 100;
N_user = 100000;
Prob = [0.05 0.05 0.9];
alpha = N_loc*Prob;

W_list = [];
for j = 1:N_lev
    W_list = [W_list; j*ones(alpha(j),1)];
end
W_list = W_list(randperm(N_loc));
W_tab = tabulate(W_list);

W_index = cell(N_lev,1);
for j = 1:N_lev
    W_index{j} = find(W_list==j);
end


data = generate_powlaw(N_user,N_loc);



fun0 = @(x) alpha*((x(N_lev+1:end)-x(N_lev+1:end).^2)./((x(1:N_lev)-x(N_lev+1:end)).^2))...
    + max((1-x(1:N_lev)-x(N_lev+1:end))./(x(1:N_lev)-x(N_lev+1:end)));
fun1 = @(x) alpha*(exp(x)./((exp(x)-1).^2)); % symmetric
fun2 = @(b) alpha*((b-b.^2)./((0.5-b).^2)) + 1; % a = 0.5

myEpsilon = [0.5:0.5:4];
N_epsilon = length(myEpsilon);



for i = 1:N_epsilon
    epsilon = myEpsilon(i);
    temp = W*epsilon;
    
    result(1,i) = N_loc*exp(epsilon/2)./((exp(epsilon/2)-1).^2);
    a = ones(N_lev,1)*exp(epsilon/2)/(exp(epsilon/2)+1); b = 1-a;
    [MSE(1,i), ~] = actual_MSE(a,b,data,N_loc,W_list);
    
    result(2,i) = N_loc*4*exp(epsilon)./((exp(epsilon)-1).^2)+1;
    a = ones(N_lev,1)*0.5; 
    b = ones(N_lev,1)/(exp(epsilon)+1);
    [MSE(2,i), ~] = actual_MSE(a,b,data,N_loc,W_list);
    
    [X, result_min(1,i)] = min_opt0(temp,fun0); Xmin0(:,i) = X;
    a = X(1:N_lev); b = X((N_lev+1):end);
    [MSE_min(1,i), ~] = actual_MSE(a,b,data,N_loc,W_list);    
    
    [X, result_min(2,i)] = min_opt1(temp,fun1); Xmin1(:,i) = X;
    a = exp(X)./(1+exp(X)); b = 1./(1+exp(X));
    [MSE_min(2,i), ~] = actual_MSE(a,b,data,N_loc,W_list);
    
    [X, result_min(3,i)] = min_opt2(temp,fun2); Xmin2(:,i) = X;
    a = 0.5*ones(N_lev,1); b = X;
    [MSE_min(3,i), ~] = actual_MSE(a,b,data,N_loc,W_list);
    
end

figure;
ah1 = TightPlots(1, 1, 500,[10 7],[80,80],[50,20],[70,10],'pixels');
axes(ah1(1));


plot(myEpsilon,MSE(1,:),'-o','Color',Color(1,:)); hold on; 
plot(myEpsilon,MSE(2,:),'-s','Color',Color(2,:)); hold on;
plot(myEpsilon,MSE_min(1,:),'-^','Color',Color(3,:)); hold on; 
plot(myEpsilon,MSE_min(2,:),'-*','Color',Color(4,:)); hold on; 
plot(myEpsilon,MSE_min(3,:),'-d','Color',Color(5,:)); hold on; 


plot(myEpsilon,result(1,:),'-.o','Color',Color(1,:)); hold on;
plot(myEpsilon,result(2,:),'-.s','Color',Color(2,:)); hold on;
plot(myEpsilon,result_min(1,:),'-.^','Color',Color(3,:)); hold on; 
plot(myEpsilon,result_min(2,:),'-.*','Color',Color(4,:)); hold on; 
plot(myEpsilon,result_min(3,:),'-.d','Color',Color(5,:)); hold on; 

legend('RAPPOR','OUE','IDUE-opt0','IDUE-opt1','IDUE-opt2');
yticks([25 50 100 200 400]); 
xlim([1,3]);
ylim([15,450]);
xlabel('$\epsilon$'); ylabel('MSE');
set(gca, 'YScale', 'log');

text(1.05, 22,{'Power-law Distribution', '(m=100)'});
