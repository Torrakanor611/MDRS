%% task 4
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

%% 4.a
clc
k= 10;
[sP, nSP, s2ndP, ns2ndP] = bestKpaths(logA, T, k);

% print 
%{
for i = 1:nFlows
    cell1 = sP{i};
    cell2 = s2ndP{i};
    i
    for j = 1:k
        path1 = cell1{j};
        if ~isempty(cell2{j})
            path2 = cell2{j}{1};
        else
            path2 = []
        end
        disp(path1)
        disp(path2)
    end
end
%}


