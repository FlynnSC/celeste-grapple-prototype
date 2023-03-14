if (!surface_exists(block_surf)) block_surf = surface_create(width, height);
surface_set_target(block_surf);
draw_clear_alpha(c_white,0);

if (image_xscale > 1 && image_yscale > 1)
{
	var base_color = make_color_rgb(11, 16, 19);
	draw_rectangle_color(8, 8, width - 8, height - 8, base_color, base_color, base_color, base_color, false);
}

draw_sprite_ext(sSwingingBlockCorner, 0, 0, 0, 1, 1, 0, c_white, 1);

draw_sprite_ext(sSwingingBlockCorner, 0, 0, height, 1, 1, 90, c_white, 1);

draw_sprite_ext(sSwingingBlockCorner, 0, width, height,  1, 1, 180, c_white, 1);

draw_sprite_ext(sSwingingBlockCorner, 0, width,  0, 1, 1, 270, c_white, 1);

var x_edge_tiles = 2 * (image_xscale - 1);
var y_edge_tiles = 2 * (image_yscale - 1);
for (var i = 0; i < x_edge_tiles; ++i)
{
	draw_sprite_ext(sSwingingBlockEdge, 0, 8 * (i + 1), 0, 1, 1, 0, c_white, 1);
}

for (var i = 0; i < y_edge_tiles; ++i)
{
	draw_sprite_ext(sSwingingBlockEdge, 0, 0, 8 * (i + 2), 1, 1, 90, c_white, 1);
}

for (var i = 0; i < x_edge_tiles; ++i)
{
	draw_sprite_ext(sSwingingBlockEdge, 0, 8 * (i + 2), height, 1, 1, 180, c_white, 1);
}

for (var i = 0; i < y_edge_tiles; ++i)
{
	draw_sprite_ext(sSwingingBlockEdge, 0, width, 8 * (i + 1), 1, 1, 270, c_white, 1);
}

surface_reset_target();
draw_surface(block_surf, x - width / 2, y - height / 2);

