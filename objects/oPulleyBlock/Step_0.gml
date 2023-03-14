if (player_attached || player_grappled)
{
	reel_vel = max(reel_vel - reel_accel, -max_reel_in_speed);
}
else
{
	reel_vel = min(min(reel_vel + reel_accel, max_reel_out_speed), normal_left_length - left_grapple.length);
}

left_grapple.length += reel_vel;
right_grapple.length += reel_vel;

var energy = grav * (y - ystart);
var vel_dir = point_direction(0, 0, x_vel, y_vel);
var vel_mag = max(point_distance(0, 0, x_vel, y_vel), sqrt(max(2 * energy, 0)));
	
x_vel = lengthdir_x(vel_mag, vel_dir);
y_vel = lengthdir_y(vel_mag, vel_dir);
	
y_vel += grav;

grapple_wrap(left_grapple);
grapple_move(left_grapple);
grapple_wrap(right_grapple);
grapple_move(right_grapple);
	
detachment_x_vel = x_vel;
detachment_y_vel = y_vel;

event_inherited();
	
update_grapple_origin_point(left_grapple, x_exact - width / 2 - 2, y_exact - 1);
update_grapple_origin_point(right_grapple, x_exact + width / 2 - 1, y_exact - 1);