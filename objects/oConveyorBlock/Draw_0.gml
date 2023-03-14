draw_self();

if (!surface_exists(block_surf)) block_surf = surface_create(width, height);
surface_set_target(block_surf);
draw_clear_alpha(make_color_rgb(0, 0, 15), 1);

draw_sprite_ext(sConveyorBlockSymbol, active, width / 2, height / 2, conveyor_dir, 1, 0, c_white, 1);

var x_edge_tiles = 2 * image_xscale; //2 * (image_xscale - 1);
var y_edge_tiles = 2 * image_yscale;// 2 * (image_yscale - 1);
for (var i = 0; i < x_edge_tiles; ++i)
{
	draw_sprite_ext(sConveyorBlockEdge, subimage_index + (i % 2 == 0 ? 8 : 0), 8 * i, 0, 1, 1, 0, c_white, 1);
}

for (var i = 0; i < y_edge_tiles; ++i)
{
	draw_sprite_ext(sConveyorBlockEdge, subimage_index + (i % 2 == 1 ? 8 : 0), 0, 8 * (i + 1), 1, 1, 90, c_white, 1);
}

for (var i = 0; i < x_edge_tiles; ++i)
{
	draw_sprite_ext(sConveyorBlockEdge, subimage_index + (i % 2 == 0 ? 0 : 8), 8 * (i + 1), height, 1, 1, 180, c_white, 1);
}

for (var i = 0; i < y_edge_tiles; ++i)
{
	draw_sprite_ext(sConveyorBlockEdge, subimage_index + (i % 2 == 1 ? 0 : 8), width, 8 * i, 1, 1, 270, c_white, 1);
}

draw_sprite_ext(sConveyorBlockCorner, subimage_index, 0, 0, 1, 1, 0, c_white, 1);
draw_sprite_ext(sConveyorBlockCorner, subimage_index, 0, height, 1, 1, 90, c_white, 1);
draw_sprite_ext(sConveyorBlockCorner, subimage_index, width, height,  1, 1, 180, c_white, 1);
draw_sprite_ext(sConveyorBlockCorner, subimage_index, width,  0, 1, 1, 270, c_white, 1);

if (active)
{
	subimage_index = subimage_index + conveyor_dir * conveyor_speed;
	if (subimage_index == -1) subimage_index = 15;
	else if (subimage_index == 16) subimage_index = 0;
}

surface_reset_target();
draw_surface(block_surf, x - width / 2, y - height / 2);

//draw_text(60, 30, subimage_index);

