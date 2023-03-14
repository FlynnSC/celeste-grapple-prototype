var player = instance_place(x, y, oPlayer);
if (player != noone)
{
	player.x_vel = 0;
	player.y_vel = -spring_vel;
	player.climb_meter = 1;
}