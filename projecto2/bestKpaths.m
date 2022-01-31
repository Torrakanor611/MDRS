function [k_shortest nSP P2nds nP2nds]= bestKpaths(L,T,k)
    nFlows= size(T,1);
    nSP= zeros(1,nFlows);
    % e k = 10 most available routing paths provided by the network to each traffic flow
    for f = 1:nFlows
        [shortestPath, totalCost] = kShortestPath(L,T(f,1),T(f,2),k);
        k_shortest{f}= shortestPath;
        nSP(f)= length(totalCost);
    end
    % print
    %{
    for n = 1 : nFlows
        for m = 1: k
            path = k_shortest{n}{m};
            disp(path)
        end
    end
    %}

    nP2nds = zeros(1,nFlows);
    for f = 1:nFlows
        flowK_shortest = k_shortest{f};
        auxL = L
        for x = 1:nSP(f) % k
            x
            path = flowK_shortest{x}
    
            for j = 1: (length(path) - 1)
                auxL(path(j), path(j+1)) = inf;
                auxL(path(j+1), path(j)) = inf;
            end
            auxL
    
            [shortestPath, totalCost] = kShortestPath(auxL,T(f,1),T(f,2),1);
            
            P2nds{f} = shortestPath;
            shortestPath
            nP2nds(f) = length(totalCost);
                
        end
    break
    end
end