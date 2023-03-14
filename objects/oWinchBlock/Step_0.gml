event_inherited();

if (player_grappled)
{
	if (player.grapple_length < player.min_grapple_length)
	{
		with (player) detach_grapple_from_wall();
	}
	else
	{
		player.grapple_length -= winch_speed;
		internal_surface_offset += winch_speed / 4;
		internal_surface_offset %= height;
		winch_speed += (max_winch_speed - winch_speed) * winch_speed_interp_rate;
		
		if (abs(grapple_point_offset.x) / image_xscale > abs(grapple_point_offset.y) / image_yscale)
		{
			var desired_y = clamp(player.y - y, -image_yscale * 8, image_yscale * 8);
			grapple_point_offset.y += (desired_y - grapple_point_offset.y) * grapple_point_interp_rate;
		}
		else
		{
			var desired_x = clamp(player.x - x, -image_xscale * 8, image_xscale * 8);
			grapple_point_offset.x += (desired_x - grapple_point_offset.x) * grapple_point_interp_rate;
		}
		grapple_point.x = x + grapple_point_offset.x;
		grapple_point.y = y + grapple_point_offset.y;
	}
}