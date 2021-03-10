function randnum = generate_powlaw(num,ub)

alpha = 2;
temp = rand(1,num);

temp = (1-temp).^(1/-(alpha+1))-1;
randnum = temp*(ub-1)/max(temp)+1;
randnum = floor(randnum);

end