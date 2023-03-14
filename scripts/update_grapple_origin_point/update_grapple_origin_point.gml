///@func update_grapple_origin_point(grapple, new_x, new_y)
///@param grapple
///@param new_x
///@param new_y
function update_grapple_origin_point(argument0, argument1, argument2) {

	var grapple = argument0;
	var new_x = argument1;
	var new_y = argument2;

	with (grapple)
	{
		origin_point.prev_x = origin_point.x;
		origin_point.prev_y = origin_point.y;
		origin_point.x = new_x;
		origin_point.y = new_y;
	}


}
