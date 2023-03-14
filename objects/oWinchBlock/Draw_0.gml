if (!surface_exists(block_surf)) block_surf = surface_create(width, height);
surface_set_target(block_surf);
draw_clear_alpha(c_white,0);

draw_sprite_tiled(sWinchBlockBase, 0, internal_surface_offset, 0);

draw_sprite_ext(sWinchBlockCorner, 0, 0, 0, 1, 1, 0, c_white, 1);
draw_sprite_ext(sWinchBlockEdge, 0, 8, 0, 2*(image_xscale-1), 1, 0, c_white, 1);

draw_sprite_ext(sWinchBlockCorner, 0, 0, height, 1, 1, 90, c_white, 1);
draw_sprite_ext(sWinchBlockEdge, 0, 0, height-8, 2*(image_yscale-1), 1, 90, c_white, 1);

draw_sprite_ext(sWinchBlockCorner, 0, width, height,  1, 1, 180, c_white, 1);
draw_sprite_ext(sWinchBlockEdge, 0, width-8, height, 2*(image_xscale-1), 1, 180, c_white, 1);

draw_sprite_ext(sWinchBlockCorner, 0, width,  0, 1, 1, 270, c_white, 1);
draw_sprite_ext(sWinchBlockEdge, 0, width, 8, 2*(image_yscale-1), 1, 270, c_white, 1);



surface_reset_target();
draw_surface(block_surf, x - width / 2, y - height / 2);

if (player_grappled)
{
	var grapple_color = make_color_rgb(153, 77, 26);
	var shaded_grapple_color = make_color_rgb(76, 38, 13);// merge_color(make_color_rgb(76, 38, 13), grapple_color, 0.5);
	var inside_x = grapple_point.x + lengthdir_x(2, player.grapple_angle);
	var inside_y = grapple_point.y + lengthdir_y(2, player.grapple_angle);
	draw_line_color(grapple_point.x, grapple_point.y, inside_x, inside_y, grapple_color, shaded_grapple_color);
}

