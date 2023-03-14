#region Charge and color
var charge;
switch (state)
{
	case ACTIVE_STATE.DEACTIVATED:
	case ACTIVE_STATE.ACTIVATION_WAITING:
	case ACTIVE_STATE.DEACTIVATING:
	charge = 1;
	break;
	
	case ACTIVE_STATE.ACTIVATING:
	charge = 1 - pull_dist / max_pull_dist;
	break;
	
	case ACTIVE_STATE.DEACTIVATION_WAITING:
	charge = 1 - alarm[1] / active_wait_frames;
	break;
}
var charge_color = merge_color(make_color_rgb(76, 0, 45), make_color_rgb(237, 0, 140), charge);
#endregion

#region Block
if (!surface_exists(block_surf)) block_surf = surface_create(width, height);
surface_set_target(block_surf);
draw_clear_alpha(make_color_rgb(0, 0, 15), 1);

draw_sprite(sPullBlockSymbol, charge * 24, width / 2, height / 2);

draw_line_color(-1, 0, width-1, 0, charge_color, charge_color);
draw_line_color(0, 0, 0, height-1, charge_color, charge_color);
draw_line_color(0, height-1, width-1, height-1, charge_color, charge_color);
draw_line_color(width-1, 0, width-1, height-1, charge_color, charge_color);

surface_reset_target();
draw_surface(block_surf, x - width / 2, y - height / 2);
#endregion

