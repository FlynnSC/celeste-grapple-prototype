///@func draw_bezier_rope(x1, y1, x2, y2, length, color)
///@param x1
///@param y1
///@param x2
///@param y2
///@param length
///@param color
function draw_bezier_rope(argument0, argument1, argument2, argument3, argument4, argument5) {

	var x1 = argument0;
	var y1 = argument1;
	var x2 = argument2;
	var y2 = argument3;
	var length = argument4;
	var color = argument5;

	var segment_count = 10;

	// Control point
	var x3 = (x1 + x2) / 2;
	var y3 = (y1 + y2) / 2 + (length - point_distance(x1, y1, x2, y2));


	var past_x = x1;
	var past_y = y1;
	var curr_x;
	var curr_y;
	for (var segment = 1; segment <= segment_count; ++segment)
	{
		var t = segment / segment_count;
		curr_x = x3 + power((1-t), 2) * (x1-x3) + power(t, 2) * (x2 - x3);
		curr_y = y3 + power((1-t), 2) * (y1-y3) + power(t, 2) * (y2 - y3);
		draw_line_color(past_x, past_y, curr_x, curr_y, color, color);
		past_x = curr_x;
		past_y = curr_y;
	}


}
