event_inherited();

switch (state)
{
	#region DEACTIVATED
	case ACTIVE_STATE.DEACTIVATED:
	if (player_attached || player_grappled)
	{
		alarm[1] = activation_waiting_frames;
		state = ACTIVE_STATE.ACTIVATION_WAITING;
	}
	break;
	#endregion
	
	#region ACTIVATING
	case ACTIVE_STATE.ACTIVATING:
	translation_x_dir = place_meeting(x-1, y, oWall) - place_meeting(x+1, y, oWall);
	translation_y_dir = place_meeting(x, y-1, oWall) - place_meeting(x, y+1, oWall);
	
	scaling_val += scaling_rate * (scaling_val + 0.8);
	x_scaling_speed = (max_x_scale - base_x_scale) * scaling_val + base_x_scale - image_xscale;
	y_scaling_speed = (max_y_scale - base_y_scale) * scaling_val + base_y_scale - image_yscale;
	
	var x_scale_diff = min(x_scaling_speed, max_x_scale - image_xscale);
	var y_scale_diff = min(y_scaling_speed, max_y_scale - image_yscale);
	var x_dist_diff = x_scale_diff * half_width / base_x_scale;
	var y_dist_diff = y_scale_diff * half_height / base_y_scale;
	
	#region Grapple
	if (player_grappled)
	{
		grapple_point.x += (sign(grapple_point.x - x) + translation_x_dir) * x_dist_diff;
		grapple_point.y += (sign(grapple_point.y - y) + translation_y_dir) * y_dist_diff;
	}
	#endregion
	
	#region Corners
	for (var i = 0; i < 4; ++i)
	{
		var corner = corners[i];
		corner.x += (sign(corner.x - x) + translation_x_dir) * x_dist_diff;
		corner.y += (sign(corner.y - y) + translation_y_dir) * y_dist_diff;	
	}
	#endregion
	
	#region Spikes
	var n = ds_list_size(attached_spikes);
	for (var i = 0; i < n; ++i)
	{
		var spike = attached_spikes[|i];
		spike.x += (sign(spike.x - x + 4) + translation_x_dir) * x_dist_diff;
		spike.y += (sign(spike.y - y + 4) + translation_y_dir) * y_dist_diff;
	}
	#endregion
	
	#region Player movement handling
	if (player_attached)
	{
		player.x_exact += (sign(player.x - x) + translation_x_dir) * x_dist_diff;
		player.x = floor(player.x_exact);
		x += translation_x_dir * x_dist_diff;
		image_xscale += x_scale_diff;
		player.y_exact += (sign(player.y - y) + translation_y_dir) * y_dist_diff;
		player.y = floor(player.y_exact);
		y += translation_y_dir * y_dist_diff;
		image_yscale += y_scale_diff;
		
		if (!place_meeting(x+3*sign(player.x - x), y, player) && !place_meeting(x, y+3*sign(player.y - y), player))
		{
			with (player) detach_from_wall();
		}
		else
		{
			if (player.state == PLAYER_STATE.WALL_GRABBED)
			{
				var dir = sign(player.x - x);
				if (place_meeting(x, y, player))
				{
					while (place_meeting(x, y, player))
					{
						player.x += dir;
					}
				}
				if (!place_meeting(x+dir, y, player))
				{
					while (!place_meeting(x+dir, y, player))
					{
						player.x -= dir;
					}
				}
				player.x_exact = player.x;
			}
			else
			{
				var dir = sign(player.y - y);
				if (place_meeting(x, y, player))
				{
					while (place_meeting(x, y, player))
					{
						player.y += dir;
					}
				}
				if (!place_meeting(x, y+dir, player))
				{
					while (!place_meeting(x, y+dir, player))
					{
						player.y -= dir;
					}
				}
				player.y_exact = player.y;
			}
		}
	}
	else
	{
		image_xscale += x_scale_diff;
		x += translation_x_dir * x_dist_diff;
		var dir = sign(player.x - x);
		if (place_meeting(x, y, player))
		{
			while (place_meeting(x, y, player))
			{
				player.x += dir;
			}
			player.x_exact = player.x;
		}
		
		image_yscale += y_scale_diff;
		y += translation_y_dir * y_dist_diff;
		dir = sign(player.y - y);
		if (place_meeting(x, y, player))
		{
			while (place_meeting(x, y, player))
			{
				player.y += dir;
			}
			player.y_exact = player.y;
		}
	}
	#endregion
	
	#region Crush checking
	with (player)
	{
		if (place_meeting(x, y, oWall)) respawn_player();
	}
	#endregion
	
	#region Detachment vel
	if (sign(player.x - x) == 1) detachment_x_vel = max((sign(player.x - x) + translation_x_dir) * x_dist_diff, detachment_x_vel);
	else detachment_x_vel = min((sign(player.x - x) + translation_x_dir) * x_dist_diff, detachment_x_vel);
	
	if (sign(player.y - y) == 1) detachment_y_vel = max((sign(player.y - y) + translation_y_dir) * y_dist_diff, detachment_y_vel);
	else detachment_y_vel = min((sign(player.y - y) + translation_y_dir) * y_dist_diff, detachment_y_vel);
	#endregion
	
	if (scaling_val >= 1)
	//if (x_scale_diff == 0 && y_scale_diff == 0)
	{
		state = ACTIVE_STATE.ACTIVATED;
		alarm[0] = detachment_vel_conservation_frames;
		break;
	}
	break;
	#endregion
	
	#region ACTIVATED
	case ACTIVE_STATE.ACTIVATED:
	if (!player_attached && !player_grappled)
	{
		alarm[2] = deactivation_waiting_frames;
		state = ACTIVE_STATE.DEACTIVATION_WAITING;
	}
	break;
	#endregion
	
	#region DEACTIVATION_WAITING
	case ACTIVE_STATE.DEACTIVATION_WAITING:
	if (player_attached || player_grappled)
	{
		alarm[2] = -1;
		state = ACTIVE_STATE.ACTIVATED;
	}
	break;
	#endregion
	
	#region DEACTIVATING
	case ACTIVE_STATE.DEACTIVATING:
	if (player_attached || player_grappled)
	{
		state = ACTIVE_STATE.ACTIVATING;
		break;
	}
	scaling_val -= scaling_rate * (scaling_val + 0.8);
	x_scaling_speed = image_xscale - ((max_x_scale - base_x_scale) * scaling_val + base_x_scale);
	y_scaling_speed = image_yscale - ((max_y_scale - base_y_scale) * scaling_val + base_y_scale);
	
	var x_scale_diff = min(x_scaling_speed, image_xscale - base_x_scale);
	var y_scale_diff = min(y_scaling_speed, image_yscale - base_y_scale);
	var x_dist_diff = x_scale_diff * half_width / base_x_scale;
	var y_dist_diff = y_scale_diff * half_height / base_y_scale;
		
	#region Corners
	for (var i = 0; i < 4; ++i)
	{
		var corner = corners[i];
		corner.x -= (sign(corner.x - x) + translation_x_dir) * x_dist_diff;
		corner.y -= (sign(corner.y - y) + translation_y_dir) * y_dist_diff;	
	}
	#endregion
		
	#region Spikes
	var n = ds_list_size(attached_spikes);
	for (var i = 0; i < n; ++i)
	{
		var spike = attached_spikes[|i];
		spike.x -= (sign(spike.x - x + 4) + translation_x_dir) * x_dist_diff;
		spike.y -= (sign(spike.y - y + 4) + translation_y_dir) * y_dist_diff;
	}
	#endregion	
	
	image_xscale -= x_scale_diff;
	x -= translation_x_dir * x_dist_diff;
	image_yscale -= y_scale_diff;
	y -= translation_y_dir * y_dist_diff;
	
	if (scaling_val <= 0)
	//if (x_scale_diff == 0 && y_scale_diff == 0)
	{
		state = ACTIVE_STATE.DEACTIVATED;
		break;
	}
	break;
	#endregion
}