if (!surface_exists(block_surf)) block_surf = surface_create(width, height);
surface_set_target(block_surf);
draw_clear_alpha(c_white,0);

draw_sprite_tiled(sTriggerBlockBase, 0, 0, 1);

var edge_color = make_color_rgb(20, 36, 51);

draw_line_color(0, 0, width - 1, 0, edge_color, edge_color);
draw_line_color(0, 0, 0, height - 1, edge_color, edge_color);
draw_line_color(width - 1, 0, width - 1, height - 1, edge_color, edge_color);
draw_line_color(0, height - 1, width - 1, height - 1, edge_color, edge_color);

draw_sprite(sTriggerBlockSymbol, triggered, width / 2, height / 2);

surface_reset_target();
draw_surface(block_surf, x - width / 2, y - height / 2);

