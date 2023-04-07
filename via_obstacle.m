 function via_obstacle = via_obstacle(map, Segments, Node_coord, Neigbor_coord)
    
    via_obstacle = false;
 
    delta_y = (Neigbor_coord(1) - Node_coord(1))/Segments;
    delta_x = (Neigbor_coord(2) - Node_coord(2))/Segments;  
    
    point_y = Node_coord(1) + delta_y;
    point_x = Node_coord(2) + delta_x;
    
    for i = 1 : Segments
        if(map(floor(point_y), floor(point_x)) == 1)
            via_obstacle = true;
            break
        end
        
        point_x = point_x + delta_x;
        point_y = point_y + delta_y;
    end
 end 