///@func update_point_data(src_point, dest_point, prev_state)
///@param src_point
///@param dest_point
///@param prev_state
function update_point_data(argument0, argument1, argument2) {

	var src_point = argument0;
	var dest_point = argument1;
	var prev_state = argument2;

	if (prev_state)
	{
		dest_point.prev_dir_set[? id] = point_direction(src_point.prev_x, src_point.prev_y, dest_point.prev_x, dest_point.prev_y);
		dest_point.prev_dist_set[? id] = point_distance(src_point.prev_x, src_point.prev_y, dest_point.prev_x, dest_point.prev_y);
	}
	else
	{
		dest_point.dir_set[? id] = point_direction(src_point.x, src_point.y, dest_point.x, dest_point.y);
		dest_point.dist_set[? id] = point_distance(src_point.x, src_point.y, dest_point.x, dest_point.y);
	}


}
