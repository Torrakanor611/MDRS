%% b) Run Simulator 4 50 times with a stopping criterion of P = 10000
P = 10000;
l = 1500;
C = 10;
f = 1000000;
n = [10, 20, 30, 40];

datadelay = zeros(1, length(n));
errorsdata = zeros(1, length(n));
voipdelay = zeros(1, length(n));
errorsvoip = zeros(1, length(n));

N = 50;
for j = 1:length(datadelay)
    PLd = zeros(1, N);
    PLv = zeros(1, N);
    APDd = zeros(1, N);
    APDv = zeros(1, N);
    MPDd = zeros(1, N);
    MPDv = zeros(1, N);
    TT = zeros(1, N);
    
    for i = 1:N
        [PLd(i), PLv(i), APDd(i), APDv(i), MPDd(i), MPDv(i), TT(i)] = Simulator4(l,C,f,P,n(j));
    end    
    alfa = 0.1;    
    
    media = mean(APDd);
    term = norminv(1-alfa/2)*sqrt(var(APDd)/N);
    fprintf("Av. Packet Delay data (ms)    = %.2e +- %.2e\n", media, term);
    datadelay(j) = media;
    errorsdata(j) = term;

    media = mean(APDv);
    term = norminv(1-alfa/2)*sqrt(var(APDv)/N);
    fprintf("Av. Packet Delay VoIP (ms)    = %.2e +- %.2e\n", media, term);
    voipdelay(j) = media;
    errorsvoip(j) = term;
end


figure(1)
bar(n, datadelay)
title("Average Data Packet Delay")
xlabel("Number of aditional VoIP packet Flows")
ylabel("Average Data Packet Delay (ms)")
hold on
er = errorbar(n, datadelay, errorsdata, errorsdata);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off;


figure(2)
bar(n, voipdelay)
title("Average Voip Packet Delay")
xlabel("Number of aditional VoIP packet Flows")
ylabel("Average Voip Packet Delay (ms)")
hold on
er = errorbar(n, voipdelay, errorsvoip, errorsvoip);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off;