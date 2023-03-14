///@func grapple_move(grapple)
///@param grapple
function grapple_move(argument0) {

	var grapple = argument0;

	with (grapple)
	{
		// Swing point and length calculation
		swing_point = points[|ds_list_size(points) - 2]; // Closest point in the chain to the player
		swing_length = length;
		for (var i = 1; i < ds_list_size(points) - 1; ++i)
		{
			swing_length -= points[|i].dist_set[? id];
		}

		// Velocity and position resolution
		var moved_x = origin_point.x + owner.x_vel;
		var moved_y = origin_point.y + owner.y_vel;
		var moved_dist = point_distance(swing_point.x, swing_point.y, moved_x, moved_y);
		swing_angle = point_direction(moved_x, moved_y, swing_point.x, swing_point.y);
		if (moved_dist > swing_length)
		{
			var dir = point_direction(swing_point.x, swing_point.y, moved_x, moved_y);
			var grappled_x = swing_length * dcos(dir) + swing_point.x;
			var grappled_y = swing_length * -dsin(dir) + swing_point.y;
			owner.x_vel += grappled_x - moved_x;
			owner.y_vel += grappled_y - moved_y;
		}
	}




}
