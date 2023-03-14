var base_color = make_color_rgb(0, 0, 15);
var highlight_deactive_color = make_color_rgb(62, 53, 105);
var highlight_active_color = make_color_rgb(38, 175, 46);

draw_rectangle_color(bbox_left, bbox_top, bbox_right, bbox_bottom, base_color, base_color, base_color, base_color, false);
draw_sprite(symbol_sprite, (state != ACTIVE_STATE.DEACTIVATED ? 1 : 0), x, y);

if (!surface_exists(block_surf)) block_surf = surface_create(max_x_scale * 2 * half_width, max_y_scale * 2 * half_height);
surface_set_target(block_surf);
draw_clear_alpha(c_white,0);

// Disgusting code
var line_col = (state != ACTIVE_STATE.DEACTIVATED ? highlight_active_color : highlight_deactive_color);
var max_half_width = max_x_scale * half_width;
var max_half_height = max_y_scale * half_height;
draw_line_color(bbox_left-x+max_half_width, bbox_top+1-y+max_half_height, max_half_width-4, bbox_top+1-y+max_half_height, line_col, line_col);
draw_line_color(bbox_left+1-x+max_half_width, bbox_top+1-y+max_half_height, bbox_left+1-x+max_half_width, max_half_height-4, line_col, line_col);

draw_line_color(max_half_width+2, bbox_top+1-y+max_half_height, bbox_right-1-x+max_half_width, bbox_top+1-y+max_half_height, line_col, line_col);
draw_line_color(bbox_right-1-x+max_half_width, bbox_top+1-y+max_half_height, bbox_right-1-x+max_half_width, max_half_height-4, line_col, line_col);

draw_line_color(bbox_left+1-x+max_half_width, +max_half_height+2, bbox_left+1-x+max_half_width, bbox_bottom-1-y+max_half_height, line_col, line_col);
draw_line_color(bbox_left+1-x+max_half_width, bbox_bottom-1-y+max_half_height, max_half_width-4, bbox_bottom-1-y+max_half_height, line_col, line_col);

draw_line_color(max_half_width+2, bbox_bottom-1-y+max_half_height, bbox_right-1-x+max_half_width, bbox_bottom-1-y+max_half_height, line_col, line_col);
draw_line_color(bbox_right-1-x+max_half_width, max_half_height+2, bbox_right-1-x+max_half_width, bbox_bottom-1-y+max_half_height, line_col, line_col);

surface_reset_target();
draw_surface(block_surf, x - max_x_scale * half_width, y - max_y_scale * half_height);

//draw_line_color(bbox_left, bbox_top+1, x-4, bbox_top+1, line_col, line_col);
//draw_line_color(bbox_left+1, bbox_top, bbox_left+1, y-4, line_col, line_col);

//draw_line_color(x+2, bbox_top+1, bbox_right-1, bbox_top+1, line_col, line_col);
//draw_line_color(bbox_right-1, bbox_top+1, bbox_right-1, y-4, line_col, line_col);

//draw_line_color(bbox_left+1, y+2, bbox_left+1, bbox_bottom-1, line_col, line_col);
//draw_line_color(bbox_left+1, bbox_bottom-1, x-4, bbox_bottom-1, line_col, line_col);

//draw_line_color(x+2, bbox_bottom-1, bbox_right-1, bbox_bottom-1, line_col, line_col);
//draw_line_color(bbox_right-1, y+2, bbox_right-1, bbox_bottom-1, line_col, line_col);