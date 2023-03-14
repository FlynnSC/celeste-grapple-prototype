switch (state)
{
	#region ACTIVATING
	case ACTIVE_STATE.ACTIVATING:
	var dist_diff = min(pull_speed, max_pull_dist - pull_dist);
	if (dist_diff == 0)
	{
		x_vel = 0;
		y_vel = 0;
		alarm[0] = detachment_vel_conservation_frames;
		state = ACTIVE_STATE.DEACTIVATION_WAITING;
		alarm[1] = active_wait_frames;
	}
	else
	{
		pull_dist += dist_diff;
		x_vel = lengthdir_x(dist_diff, pull_dir);
		y_vel = lengthdir_y(dist_diff, pull_dir);
		
		detachment_x_vel = sign(x_vel) * max(abs(detachment_x_vel), abs(x_vel));
		detachment_y_vel = sign(y_vel) * max(abs(detachment_y_vel), abs(y_vel));
	}
	break;
	#endregion
	
	#region DEACTIVATING
	case ACTIVE_STATE.DEACTIVATING:
	var dist_diff = min(pull_speed, pull_dist);
	if (dist_diff == 0)
	{
		x_vel = 0;
		y_vel = 0;
		alarm[0] = detachment_vel_conservation_frames;
		state = ACTIVE_STATE.ACTIVATION_WAITING; // makes it so that it can't be pulled for a short amount of time after rebounding
		alarm[1] = deactive_wait_frames;
	}
	else
	{
		pull_dist -= dist_diff;
		x_vel = -lengthdir_x(dist_diff, pull_dir);
		y_vel = -lengthdir_y(dist_diff, pull_dir);
		
		detachment_x_vel = sign(x_vel) * max(abs(detachment_x_vel), abs(x_vel));
		detachment_y_vel = sign(y_vel) * max(abs(detachment_y_vel), abs(y_vel));
	}
	break;
	#endregion
}

event_inherited();

