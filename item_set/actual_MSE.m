function [MSE, RE, Preci] = actual_MSE(a_list, b_list, data, L,W_list)

repeat = 1;
N_top = 100;
N_user = length(data);
N_loc = length(W_list);


tab_true = tabulate([data{:}]);
count_true = tab_true(:,2);
temp = sortrows(tab_true,2,'descend'); rank_true = temp(1:N_top,1);

MSE = zeros(N_loc,repeat);
RE = zeros(N_loc,repeat);
Preci = zeros(N_top,repeat);


for i = 1:repeat
    count_est = est(a_list, b_list, data, N_user, N_loc,L,W_list);
    MSE(:,i) = (count_est-count_true).^2/N_user;
    RE(:,i) = abs(count_est-count_true)./count_true;
    
    temp = sortrows([(1:N_loc)', count_est],2,'descend'); rank_est = temp(1:N_top,1);
    for t = 1:N_top        
        Preci(t,i) = length(intersect(rank_true(1:t),rank_est(1:t)))/t;
    end
end

MSE = mean(MSE,2);
RE = mean(RE,2);
Preci = mean(Preci,2);

end


function count_est = est(a_list, b_list, data, N_user, N_loc,L,W_list)

data_sample = zeros(N_user,1);
count_est = zeros(N_loc,1);

for i = 1:N_user
    items = data{i};
    len = length(items);
    eta = len/max(len,L);
    if randsrc(1,1,[[0 1]; [1-eta eta]]) == 1
        items = data{i};
        data_sample(i) = items(randperm(length(items),1));
    else
        data_sample(i) = N_loc + randperm(L,1);
    end
end


tab_true = tabulate(data_sample);
temp = tab_true(end,1);
if temp < N_loc
    tab_true = [tab_true; [((temp+1):N_loc)', zeros(N_loc-temp,2)]];
end
for k = 1:N_loc
    a = a_list(W_list(k)); 
    b = b_list(W_list(k)); 
    n1 = tab_true(k,2);
    n2 = N_user - n1;
    y1 = randsrc(n1,1,[[0 1]; [1-a a]]);
    y2 = randsrc(n2,1,[[0 1]; [1-b b]]);
    raw_count = sum([y1;y2]);

    count_est(k) = L*(raw_count-N_user*b)/(a-b);
end
end
