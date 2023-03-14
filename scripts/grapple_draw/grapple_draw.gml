///@func grapple_draw(grapple)
///@param grapple
function grapple_draw(argument0) {

	var grapple = argument0;

	with (grapple)
	{
		var size = ds_list_size(points);
		var total_dist = 0;
		if (player_grapple)
		{
			for (var i = 1; i < size; ++i)
			{
				total_dist += points[|i].dist_set[? id];
			}
		}
	
		var color = make_color_rgb(153, 77, 26);//make_color_rgb(40, 20, 0);// make_color_rgb(51, 25, 0);
		for (var i = 0; i < size - 1; ++i)
		{
			var curr_point = points[|i];
			var next_point = points[|i + 1];
			var x1 = curr_point.x;
			var y1 = curr_point.y;
			var x2 = next_point.x;
			var y2 = next_point.y;
			var dir = point_direction(x1, y1, x2, y2);
		
			if (attached && instance_exists(curr_point.owning_wall))
			{
				if (dir == 270 && x1 > curr_point.owning_wall.x)
				{
					x1 += 1;
					x2 += 1;
				}
				if (dir == 180 && y1 > curr_point.owning_wall.y)
				{
					y1 += 1;
					y2 += 1;
				}
			}
		
			if (player_grapple && owner.grapple_state == GRAPPLE_STATE.ATTACHED && i == size - 2 ) draw_bezier_rope(x1, y1, x2, y2, swing_length, color);
			else draw_line_color(x1, y1, x2, y2, color, color);
			//draw_line_color(curr_point.x, curr_point.y, next_point.x, next_point.y, color, color);
			//draw_bezier_rope(curr_point.x, curr_point.y, next_point.x, next_point.y, next_point.dist * (grapple_length / total_dist), color);
		}
	}




}
