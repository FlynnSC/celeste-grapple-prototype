#region Particle stuff
part_system = part_system_create();
part_emitter = part_emitter_create(part_system);
part_type = part_type_create();
min_speed = 3;
max_speed = 5;
burst_cycle = 30;
alarm[0] = burst_cycle;

part_type_direction(part_type, 165, 195, 0, 1);
part_type_speed(part_type, min_speed, max_speed, 0, 0.01);
part_type_life(part_type, 1.5 * room_width / min_speed, 1.5 * room_width / min_speed);
part_type_color_hsv(part_type, 142, 142, 0, 150, 255, 255);

// Initial burst
part_emitter_region(part_system, part_emitter, 0, 1.5 * room_width, 0, room_height, ps_shape_rectangle, ps_distr_linear);
part_emitter_burst(part_system, part_emitter, part_type, 1.5 * room_width * room_height / 4000);

part_emitter_region(part_system, part_emitter, 1.5 * room_width, 1.5 * room_width, 0, room_height, ps_shape_line, ps_distr_linear);

part_system_layer(part_system, "Player");
#endregion

camera = view_camera[0];
view_width = camera_get_view_width(camera);
view_height = camera_get_view_height(camera);

forefront_building_color = make_color_rgb(16, 49, 102);//make_color_rgb(9, 26, 54);
background_building_color = make_color_rgb(2, 6, 51);//make_color_rgb(1, 3, 24);
background_sky_color = make_color_rgb(0, 0, 5);

min_width = 10;
max_width = 40;

horizontal_building_count = 8;
vertical_building_count = 6;
offset_max = 20;

var curr_room_name = room_get_name(room);
if (room == testRoom) random_set_seed(0);
else random_set_seed(real(string_char_at(curr_room_name, string_length(curr_room_name))));
buildings = ds_grid_create(4, horizontal_building_count * vertical_building_count);


for (var i = 0; i < horizontal_building_count; ++i)
{
	for (var j = 0; j < vertical_building_count; ++j)
	{
		var index = i * vertical_building_count + j;
		var width = irandom_range(min_width, max_width);
		var x_pos = (view_width * i / horizontal_building_count) + irandom_range(-offset_max, offset_max);
		var y_pos = (view_height * j / vertical_building_count) + irandom_range(-offset_max, offset_max);
	
		buildings[# 0, index] = x_pos;
		buildings[# 1, index] = y_pos;
		buildings[# 2, index] = x_pos + width;
		buildings[# 3, index] = room_height;
	}
}
ds_grid_sort(buildings, 1, true);

building_surface = noone;