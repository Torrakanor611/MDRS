%P = 10000;   %Critério de paragem
l = 1800;    %Packet rate
C = 10;      %Capacidade do link
f = 1000000; %Tamanho da queue

numelems = (109 - 65 + 1) + (1517 - 111 + 1);
probrestante = 100 - (19 + 23 + 17);
probcadaelem = (probrestante / numelems);

a = 65:109;
a = a*(probcadaelem/100);
b = 111:1517;
b = b*(probcadaelem/100);

numMedioBytes = 0.19*64 + 0.23*110 + 0.17*1518 + sum(a) + sum(b);
tmpMedio = (numMedioBytes * 8) / (C*10^6);

bytes = 64:1518;
S = (bytes .* 8)./(C*10^6);
S2 = (bytes .* 8)./(C*10^6);

for i = 1:length(bytes)
    if i == 1
        S(i) = S(i)*0.19;
        S2(i) = S2(i)^2*0.19;
    elseif i == 110-64+1
        S(i) = S(i)*0.23;
        S2(i) = S2(i)^2*0.23;
    elseif i == 1518-64+1
        S(i) = S(i)*0.17;
        S2(i) = S2(i)^2*0.17;
    else
        S(i) = S(i)*(probcadaelem/100);
        S2(i) = S2(i)^2*(probcadaelem/100);
    end
end

ES = sum(S);
ES2 = sum(S2);

W = ((l*ES2/(2*(1-l*(ES)))) + ES)*10^3
