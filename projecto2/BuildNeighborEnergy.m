function [av, nSol, eN] = BuildNeighborEnergy(bestSol,i, sP, nSP, Links, nNodes, T, L, bestEnergy)
%Find best neighbor of a given solution
%   i - flow from whom we will choose neighbors
%   bestSol - current solution 
%   sP - Contains shortest paths among network nodes for each flow
%   nSP - Contains the number of shortest paths for each flow
%   Links - Links of the network
%   nNodes - Network Nodes
%   T - Network flows
%   allValues - to store load values for plot
%   bestEnergy - best energy found with  greedy randomized solution

nFlows= size(bestSol);
nSol= bestSol;
av= [];
eN= bestEnergy;
nLinks= size(Links,1);

for n=1:nFlows
    if n~=i
        newNeighbor= bestSol;
        for j=1:nSP(n)
            if j~=bestSol(n)
                newNeighbor(n)= j;
                Loads= calculateLinkLoads(nNodes,Links,T,sP,newNeighbor);
                load= max(max(Loads(:,3:4)));
                if load <= 10
                    energy= 0;
                    for a= 1:nLinks
                        if Loads(a,3)+Loads(a,4)>0
                            energy= energy + L(Loads(a,1),Loads(a,2));
                        end
                    end
                    av= [av energy];
                else
                    energy= inf;
                end
                if energy < eN
                    nSol= newNeighbor;
                    eN= energy; 
                end
            end
        end
    end
end



end