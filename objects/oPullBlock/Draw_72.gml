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

#region Trail
if (!surface_exists(trail_surf)) trail_surf = surface_create(width, height);
surface_set_target(trail_surf);
draw_clear_alpha(c_white, 0);

draw_set_alpha(0.8);
draw_rectangle_color(0, 0, width - 1, height - 1, 
	charge_color, charge_color, charge_color, charge_color, false);
draw_set_alpha(1);

surface_reset_target();
gpu_set_blendmode(bm_add);
draw_surface(trail_surf, xstart - width / 2, ystart - height / 2);
gpu_set_blendmode(bm_normal);
#endregion