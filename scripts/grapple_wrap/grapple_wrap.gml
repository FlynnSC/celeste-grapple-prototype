///@func grapple_wrap(grapple)
///@param grapple
function grapple_wrap(argument0) {

	var grapple = argument0;

	with (grapple)
	{
		// Wall interaction
		var iter_dir = 1;
		for (var i = 0; i < ds_list_size(points) - 1; i += iter_dir)
		{
			var alteration = false;
			var curr_point = points[|i];
			var next_point = points[|i + 1];
			update_point_data(curr_point, next_point, false);
		
		#region Corner attachment
			var relations = curr_point.relation_set[? id];
			for (var j = 0; j < array_length_1d(relations); ++j)
			{
				var relation = relations[j];
				var corner_point = relation.point;
				if ((abs(corner_point.x - curr_point.x) < next_point.dist_set[? id]) && (abs(corner_point.y - curr_point.y) < next_point.dist_set[? id])
					&& corner_point != curr_point && corner_point != next_point)
				{
					var corner_dir = point_direction(curr_point.x, curr_point.y, corner_point.x, corner_point.y);
					var angle_diff = angle_difference(next_point.dir_set[? id], corner_dir);
					var rot_dir = sign(angle_diff);
					var corner_dist = point_distance(curr_point.x, curr_point.y, corner_point.x, corner_point.y);
					var closer = corner_dist < next_point.dist_set[? id];
				
					if (abs(angle_diff) < 90 && relation.closer && closer && relation.rot_dir != rot_dir && rot_dir != 0)
					{
						// Sets the previous coords of the corner point to where it would have been had it already been 
						// part of the grapple points
						var temp_dir = point_direction(curr_point.prev_x, curr_point.prev_y, next_point.prev_x, next_point.prev_y);
						corner_point.prev_x = curr_point.prev_x + lengthdir_x(corner_dist, temp_dir);
						corner_point.prev_y = curr_point.prev_y + lengthdir_y(corner_dist, temp_dir);
						
						update_point_data(curr_point, corner_point, true);
						update_point_relations(curr_point, corner_point, true);
						update_point_data(corner_point, next_point, true);
						update_point_relations(corner_point, next_point, true);
						corner_point.rot_dir = sign(angle_difference(corner_dir, next_point.dir_set[? id]));
						ds_list_insert(points, i + 1, corner_point);
						alteration = true;
						break;
					}
				
					//if (rot_dir != 0) relation.rot_dir = rot_dir;
					relation.rot_dir = rot_dir;
					relation.closer = closer;
				}
			}
		#endregion
			
		#region Corner detachment
			if (i != 0 && !alteration)
			{
				var rot_dir = sign(angle_difference(curr_point.dir_set[? id], next_point.dir_set[? id]));
				if (curr_point.rot_dir != rot_dir && rot_dir != 0)
				{
					ds_list_delete(points, i);
					var prev_point = points[|i - 1];
					update_point_data(prev_point, next_point, true);
					update_point_relations(prev_point, next_point, true); 
					update_point_data(prev_point, next_point, false); 
					update_point_relations(prev_point, next_point, false);
					--i;
					alteration = true;
				}
			
			}
		#endregion
		
			//iter_dir = (alteration ? -1 : 1);
			iter_dir = (alteration ? 0 : 1);
		}
	}




}
