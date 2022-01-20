Nodes= [30 70
       350 40
       550 180
       310 130
       100 170
       540 290
       120 240
       400 310
       220 370
       550 380];
   
Links= [1 2
        1 5
        2 3
        2 4
        3 4
        3 6
        3 8
        4 5
        4 8
        5 7
        6 8
        6 10
        7 8
        7 9
        8 9
        9 10];

T= [1  3  1.0 1.0
    1  4  0.7 0.5
    2  7  2.4 1.5
    3  4  2.4 2.1
    4  9  1.0 2.2
    5  6  1.2 1.5
    5  8  2.1 2.5
    5  9  1.6 1.9
    6 10  1.4 1.6];

nNodes= 10;
nLinks= size(Links,1);
nFlows= size(T,1);

B= 625;  %Average packet size in Bytes

co= Nodes(:,1)+1i*Nodes(:,2);

L= inf(nNodes);    %Square matrix with arc lengths (in Km)
for i=1:nNodes
    L(i,i)= 0;
end
C= zeros(nNodes);  %Square matrix with arc capacities (in Gbps)
for i=1:nLinks
    C(Links(i,1),Links(i,2))= 10;  %Gbps
    C(Links(i,2),Links(i,1))= 10;  %Gbps
    d= abs(co(Links(i,1))-co(Links(i,2)));
    L(Links(i,1),Links(i,2))= d+5; %Km
    L(Links(i,2),Links(i,1))= d+5; %Km
end
L= round(L);  %Km

MTBF= (450*365*24)./L;
A= MTBF./(MTBF + 24);
% matrix A, matrix com a disonibilidade de cada ligação
A(isnan(A))= 0;

% links com valor mais perto de 0 são os mais curtos
logA = -log(A);

%% 3.a)
% Compute up to 1 paths for each flow:
n= 1;
% dar a matrix -log da matrix de A.
[sP, nSP]= calculatePaths(logA,T,n);
%sP sao os caminhos e o nSp sao o número de caminhos sP
for n = 1 : nFlows
    path = sP{n}{1};
    fprintf('flow %d, %2d <-> %2d:', n, T(n,1), T(n,2))
    disp(path)
end

%% 3.b)
clc
[sP, nSP] = best2Paths(logA, T);
avail = zeros(1, nFlows);      
avail2nd = zeros(1, nFlows);
for n = 1 : (nFlows)
    path = sP{n}{1};
    path2nd = sP{n + nFlows}{1};
    fprintf('flow %d | %-2d <-> %2d:\n', n, T(n,1), T(n,2))
    fprintf('%15s','best: ');
    printPath(path, '  ')
    avail(n) = calculateAvailability(A, path);
    fprintf('%13s | availability: %f', '', avail(n));
    fprintf('\n')
    fprintf('%5s', 'best disjoint: ')
    printPath(path2nd, '  ')
    avail2nd(n) = calculateAvailability(A, path2nd);
    fprintf('%5s | availability: %f', '', avail2nd(n));
    fprintf('\n')
end
fprintf('average availability for best paths: %f\n', mean(avail));
fprintf('average availability for 2nd best paths disjoint with best path: %f\n', mean(avail2nd));



