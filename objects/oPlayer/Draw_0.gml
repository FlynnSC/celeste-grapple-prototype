if (grapple_state != GRAPPLE_STATE.READY)
{
	grapple_draw(grapple);
	//var size = ds_list_size(grapple_points);
	//var total_dist = 0;
	//for (var i = 1; i < size; ++i) total_dist += grapple_points[|i].dist;
	
	//var color = make_color_rgb(153, 77, 26);//make_color_rgb(40, 20, 0);// make_color_rgb(51, 25, 0);
	//for (var i = 0; i < size - 1; ++i)
	//{
	//	var curr_point = grapple_points[|i];
	//	var next_point = grapple_points[|i + 1];
	//	var x1 = curr_point.x;
	//	var y1 = curr_point.y;
	//	var x2 = next_point.x;
	//	var y2 = next_point.y;
	//	var dir = point_direction(x1, y1, x2, y2);
		
	//	if (grapple_state == GRAPPLE_STATE.ATTACHED)
	//	{
	//		if (dir == 270 && x1 > curr_point.owning_wall.x)
	//		{
	//			x1 += 1;
	//			x2 += 1;
	//		}
	//		if (dir == 180 && y1 > curr_point.owning_wall.y)
	//		{
	//			y1 += 1;
	//			y2 += 1;
	//		}
	//	}
		
	//	if (i == size - 2 && grapple_state == GRAPPLE_STATE.ATTACHED) draw_bezier_rope(x1, y1, x2, y2, grapple_swing_length, color);
	//	else draw_line_color(x1, y1, x2, y2, color, color);
	//	//draw_line_color(curr_point.x, curr_point.y, next_point.x, next_point.y, $452c06, $452c06);
	//	//draw_bezier_rope(curr_point.x, curr_point.y, next_point.x, next_point.y, next_point.dist * (grapple_length / total_dist), $452c06);
	//}
}
draw_self();