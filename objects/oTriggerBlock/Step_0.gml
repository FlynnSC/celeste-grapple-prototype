if (triggered)
{
	final_pos_x = lengthdir_x(move_dist, move_dir) + xstart;
	final_pos_y = lengthdir_y(move_dist, move_dir) + ystart;
	image_index = 1;
	x_vel = (final_pos_x - x) * interp_rate;
	y_vel = (final_pos_y - y) * interp_rate;
	detachment_x_vel = x_vel;
	detachment_y_vel = y_vel;
}
event_inherited();