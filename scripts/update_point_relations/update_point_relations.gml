///@func update_point_relations(src_point, dest_point, prev_state)
///@param src_point
///@param dest_point
///@param prev_state
function update_point_relations(argument0, argument1, argument2) {

	var src_point = argument0;
	var dest_point = argument1;
	var prev_state = argument2;

	var relations = src_point.relation_set[? id];
	var n = array_length_1d(relations);
	if (prev_state)
	{
		for (var i = 0; i < n; ++i)
		{
			var relation = relations[i];
			var corner_point = relation.point;
			var corner_dir = point_direction(src_point.prev_x, src_point.prev_y, corner_point.prev_x, corner_point.prev_y);
			var rot_dir = sign(angle_difference(dest_point.prev_dir_set[? id], corner_dir)); 
			//if (rot_dir != 0) relation.rot_dir = rot_dir;
			relation.rot_dir = rot_dir;
			var corner_dist = point_distance(src_point.prev_x, src_point.prev_y, corner_point.prev_x, corner_point.prev_y);
			relation.closer = corner_dist < dest_point.prev_dist_set[? id];
		}
	}
	else
	{
		for (var i = 0; i < n; ++i)
		{
			var relation = relations[i];
			var corner_point = relation.point;
			var corner_dir = point_direction(src_point.x, src_point.y, corner_point.x, corner_point.y);
			var rot_dir = sign(angle_difference(dest_point.dir_set[? id], corner_dir)); 
			//if (rot_dir != 0) relation.rot_dir = rot_dir;
			relation.rot_dir = rot_dir;
			var corner_dist = point_distance(src_point.x, src_point.y, corner_point.x, corner_point.y);
			relation.closer = corner_dist < dest_point.dist_set[? id];
		}
	}


}
