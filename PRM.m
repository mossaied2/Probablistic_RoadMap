%
% Probablistic Road Map
%
clear all
close all

%seed = 5354870
%seed = 44344241
seed = 123123745
rng(seed)
%% Generate some points

nrows = 1300;
ncols = 1300;

obstacle = false(nrows, ncols);

[x, y] = meshgrid (1:ncols, 1:nrows); % remember that x is corresponding to cols while y is corresponding to rows

%% Generate some obstacle (Reviewe the file CircularObstacle.m to understand this section)

obstacle (y<50 | y>1250 | x<50 | x>1250) = true; % rectangular obstacle
obstacle (y<650 & y>600 & x<200) = true; % rectangular obstacle
obstacle (y<650 & y>600 & x>1000) = true; % rectangular obstacle
obstacle (y<350 & y>300 & x>1000) = true; % rectangular obstacle
obstacle (y>950 & x>650 & x<700) = true; % rectangular obstacle
obstacle (y>950 & y<1000 & x>400 & x<700) = true; % rectangular obstacle
obstacle (y<650 & x>500 & x<550) = true; % rectangular obstacle
obstacle (y>600 & y<650 & x>500 & x<700) = true; % rectangular obstacle
obstacle (y<200 & x>350 & x<550) = true; % rectangular obstacle

figure;
imshow(~obstacle);

axis ([0 ncols 0 nrows]);
axis xy; % xy — Default direction. For axes in a 2-D view, the y-axis is vertical with values increasing from bottom to top.
         % if this line is commented, y axis start will be at the top and increases downward 
         % Ref: https://www.mathworks.com/help/matlab/ref/axis.html
axis on;

xlabel ('x axis');
ylabel ('y axis');

title ('PRM Created Map (graph)');
grid on

%% PRM Parameters

Max_Nodes_Connect = 2;
Max_Connect_Length = 200;
Segments = 100; % All these nodes must be away from obstacles 
Max_Nodes_Grid = 350;

%% PRM Algorithm
Nodes = 0; % counter to count the genrated nodes 
map = zeros(size(obstacle));
map(obstacle) = 1; % 1 in map(row,col) means obstacle
Graph_Connections = Inf(Max_Nodes_Grid, Max_Nodes_Connect + 1);
while (Nodes < Max_Nodes_Grid)
    %% generate a node at a random location in the map & check if valid node
    Node_X = randi(ncols);
    Node_Y = randi(nrows);
    
    if (map(Node_Y,Node_X) == 1 || map(Node_Y,Node_X) == 2 )
        continue;
    end
    
    Nodes = Nodes + 1;
    
    map(Node_Y,Node_X) = 2; % 2 means node exist at that location
    
    hold on 
    plot(Node_X,Node_Y,'r*')
    hold off
    
    %% Connect the new node to the closest Max_Nodes_Connect nodes
    nodes_to_connect = [];
    distances = [];
    for i = 1: numel(Graph_Connections(:,1))
        if(Graph_Connections(i,1) == Inf)
            break
        end 
        [row, col] = ind2sub(size(map),Graph_Connections(i,1));
        
        % check if within range
        if(norm([Node_Y,Node_X]-[row,col]) > Max_Connect_Length) 
            continue
        end
        
        % check if obstacle between them
        if(via_obstacle(map,Segments,[Node_Y,Node_X],[row,col]))
            continue
        end
        
        % add this node as a node to connect
        nodes_to_connect = [nodes_to_connect, Graph_Connections(i,1)];
        
        distances = [distances; [Graph_Connections(i,1), norm([Node_Y,Node_X]-[row,col])]];
        %hold on
        %line([Node_X,col], [Node_Y,row])
        %hold off
    end
    
    %% Choose the closest Max_Nodes_Connect o connect to
    Graph_Connections(Nodes,1) = sub2ind(size(map),Node_Y,Node_X);
    
    if(size(distances > 0))
        distances_sorted = sortrows(distances,2);
        for i = 1 : min(Max_Nodes_Connect, size(distances_sorted,1))
            Graph_Connections(Nodes,i+1) = distances_sorted(i,1);

            [row, col] = ind2sub( size(map), distances_sorted(i,1) ); 

            hold on
            line([Node_X,col], [Node_Y,row])
            hold off

        end
    end

end