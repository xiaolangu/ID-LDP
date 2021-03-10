function [MSE,RE] = actual_MSE(a_list,b_list,data,N_loc,W_list)

repeat = 10;
N_user = length(data);

tab_true = tabulate(data);
count_true = tab_true(:,2);
MSE = zeros(1,repeat);
RE = zeros(N_loc,repeat);

parfor i = 1:repeat
    count_est = est(W_list,N_loc,N_user,a_list,b_list,count_true);
    MSE(i) = norm(count_est-count_true,2)^2/N_user;
    RE(:,i) = abs(count_est-count_true)./count_true;
end

MSE = mean(MSE);
RE = mean(RE,2);

end


function est_count = est(W_list,N_loc,N_user,a_list,b_list,count_true)

est_count = zeros(N_loc,1);

parfor k = 1:N_loc

    n1 = count_true(k);
    n2 = N_user - n1;
    a = a_list(W_list(k)); 
    b = b_list(W_list(k)); 
    y1 = randsrc(n1,1,[[0 1]; [1-a a]]);
    y2 = randsrc(n2,1,[[0 1]; [1-b b]]);
    raw_count = sum([y1;y2]);

    est_count(k) = (raw_count-N_user*b)/(a-b);

end
    
end