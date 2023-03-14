if (!surface_exists(building_surface))
{
	var col = background_sky_color;
	building_surface = surface_create(view_width, view_height);
	surface_set_target(building_surface)
	draw_rectangle_color(0, 0, room_width, room_height, col, col, col, col,false);
	
	//col = forefront_building_color;
	for (var i = 0; i < horizontal_building_count * vertical_building_count; ++i)
	{
		var x1 = buildings[# 0, i];
		var y1 = buildings[# 1, i];
		var x2 = buildings[# 2, i];
		var y2 = buildings[# 3, i];
		col = merge_color(forefront_building_color, background_building_color, clamp(y1 / view_height, 0, 1));
		draw_rectangle_color(x1, y1, x2, y2, col, col, col, col, false);
	}
	surface_reset_target();
}

draw_surface(building_surface, camera_get_view_x(camera), camera_get_view_y(camera));