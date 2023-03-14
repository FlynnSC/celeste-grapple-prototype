if (!isStatic)
{
	var energy = grav * (y - ystart);
	var vel_dir = point_direction(0, 0, x_vel, y_vel);
	var vel_mag = max(point_distance(0, 0, x_vel, y_vel), sqrt(max(2 * energy, 0)));
	
	x_vel = lengthdir_x(vel_mag, vel_dir);
	y_vel = lengthdir_y(vel_mag, vel_dir);
	
	y_vel += grav;
	
	grapple_wrap(grapple);
	grapple_move(grapple);
	
	detachment_x_vel = x_vel;
	detachment_y_vel = y_vel;

	event_inherited();
	
	update_grapple_origin_point(grapple, x_exact, y_exact - height / 2 - 1);
}