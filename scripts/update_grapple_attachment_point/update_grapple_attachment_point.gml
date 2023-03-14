///@func update_grapple_attachment_point(grapple, new_x, new_y, initialise)
///@param grapple
///@param new_x
///@param new_y
///@param initialise
function update_grapple_attachment_point(argument0, argument1, argument2, argument3) {

	var grapple = argument0;
	var new_x = argument1;
	var new_y = argument2;
	var initialise = argument3;

	with (grapple)
	{
		if (initialise)
		{
			attachment_point.prev_x = new_x;
			attachment_point.prev_y = new_y;
		}
		else
		{
			attachment_point.prev_x = attachment_point.x;
			attachment_point.prev_y = attachment_point.y;
		}
		attachment_point.x = new_x;
		attachment_point.y = new_y;
	
		if (initialise)
		{
			update_point_data(attachment_point, origin_point, false);
			update_point_relations(attachment_point, origin_point, false);
		}
	}


}
