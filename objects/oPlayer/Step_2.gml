#region Input

#region Basic
if (gamepad_button_check_pressed(0, gp_start) || keyboard_check(vk_escape)) game_end();
x_input_dir = sign(gamepad_axis_value(0, gp_axislh)) 
	+ gamepad_button_check(0, gp_padr) - gamepad_button_check(0, gp_padl) 
	+ keyboard_check(vk_right) - keyboard_check(vk_left);
y_input_dir = sign(gamepad_axis_value(0, gp_axislv)) 
	+ gamepad_button_check(0, gp_padd) - gamepad_button_check(0, gp_padu)
	+ keyboard_check(vk_down) - keyboard_check(vk_up);
input_angle = (x_input_dir == 0 && y_input_dir == 0 ? NaN : point_direction(0, 0, x_input_dir, y_input_dir));
grab_key = gamepad_button_check(0, gp_shoulderrb) || keyboard_check(vk_lshift);
grapple_key = gamepad_button_check(0, gp_shoulderlb) || gamepad_button_check(0, gp_shoulderl) || keyboard_check(ord("A"));
grapple_climb_key = gamepad_button_check(0, gp_face2);
grapple_extend_key = gamepad_button_check(0, gp_face4);
#endregion

#region Jump
if (gamepad_button_check_pressed(0, gp_face1) || keyboard_check_pressed(vk_space))
{
	jump_buffer = input_buffer;
}
if (gamepad_button_check_released(0, gp_face1) || keyboard_check_released(vk_space))
{
	jump_buffer = 0;
	jump_active = false;
	alarm[2] = -1;
}
#endregion

#region Dash
if (gamepad_button_check_pressed(0, gp_face3) || keyboard_check_pressed(ord("D")))
{
	dash_buffer = input_buffer;
}
if (gamepad_button_check_released(0, gp_face3) || keyboard_check_released(ord("D")))
{
	dash_buffer = 0;
}
#endregion

#endregion

#region Dynamic properties
if (horizontal_control) move_dir = x_input_dir;

switch (state)
{
	#region NORMAL and GRAPPLED
	case PLAYER_STATE.NORMAL:
	case PLAYER_STATE.GRAPPLED:
	if (move_dir != 0)
	{
		look_dir = move_dir;
		grab_dir = look_dir;
	}
	sprite_index = sPlayer;
	
	// Grabbing
	if (grab_key && climb_meter > 0 && y_vel >= 0)
	{
		var wall = instance_place(x+2*grab_dir, y, oAttachableWall);
		if (instance_exists(wall))
		{
			// Sticks player to wall if they're one pixel away
			if (!place_meeting(x+grab_dir, y, wall)) x += grab_dir;
			x_exact = x;
			slide_meter = 1;
			if (state == PLAYER_STATE.GRAPPLED) detach_grapple_from_wall();
			state = PLAYER_STATE.WALL_GRABBED;
			attach_to_wall(wall);
		}
		else
		{
			wall = instance_place(x, y-2, oAttachableWall);
			if (instance_exists(wall) && y_vel != 0)
			{
				// Sticks player to ceiling if they're one pixel away
				if (!place_meeting(x, y-1, wall)) y -= 1;
				y_exact = y;
				slide_meter = 1;
				y_vel = 0;
				if (state == PLAYER_STATE.GRAPPLED) detach_grapple_from_wall();
				state = PLAYER_STATE.CEILING_GRABBED;
				attach_to_wall(wall);
			}
		}
	}
	break;
	#endregion
	
	#region WALL_GRABBED
	case PLAYER_STATE.WALL_GRABBED:
	if (move_dir == grab_dir * -1) 
	{
		look_dir = move_dir;
		sprite_index = sPlayerWallGrabLook;
	}
	else sprite_index = sPlayerWallGrab;
	
	// Ceiling transition
	var wall = instance_place(x, y+y_input_dir, oAttachableWall);
	if (instance_exists(wall) && y_input_dir == -1)
	{
		state = PLAYER_STATE.CEILING_GRABBED;
		if (attached_to_wall) detach_from_wall();
		attach_to_wall(wall);
	}
	
	// Grab detachment
	if (!grab_key || climb_meter <= 0)
	{
		if (attached_to_wall) detach_from_wall();
		state = PLAYER_STATE.NORMAL;
	}
	if (!place_meeting(x+grab_dir, y, oAttachableWall))
	{
		if (place_meeting(x+2*grab_dir, y, oAttachableWall)) 
		{
			x += grab_dir;
			x_exact = x;
		}
		else
		{
			if (attached_to_wall) detach_from_wall();
			state = PLAYER_STATE.NORMAL;
		}
	}
	break;
	#endregion
	
	#region CEILING_GRABBED
	case PLAYER_STATE.CEILING_GRABBED:
	if (move_dir != 0)
	{
		look_dir = move_dir;
		grab_dir = look_dir;
	}
	sprite_index = sPlayerCeilingGrab;
	
	// Wall transition
	var wall = instance_place(x+x_input_dir, y, oAttachableWall)
	if (instance_exists(wall))
	{
		state = PLAYER_STATE.WALL_GRABBED;
		if (attached_to_wall) detach_from_wall();
		attach_to_wall(wall);
	}
	
	// Grab detachment
	if (!grab_key || climb_meter <= 0)
	{
		if (attached_to_wall) detach_from_wall();
		state = PLAYER_STATE.NORMAL;
	}
	if (!place_meeting(x, y-1, oAttachableWall))
	{
		if (place_meeting(x, y-2, oAttachableWall))
		{
			y -= 1;
			y_exact = y;
		}
		else
		{
			if (attached_to_wall) detach_from_wall();
			state = PLAYER_STATE.NORMAL;
		}
	}
	break;
	#endregion
}

if (!grapple_key) has_grapple = true;

#region Grounding
var wall = instance_place(x, y+1 , oWall)
if (on_ground)
{
	if (instance_exists(wall))
	{
		on_ground_buffer = coyote_frames;
		if (attached_to_wall)
		{
			if (!place_meeting(x, y+1, attached_wall))
			{
				detach_from_wall();
				if (object_is_ancestor(wall.object_index, oAttachableWall)) attach_to_wall(wall);
			}
		}
		else if (object_is_ancestor(wall.object_index, oAttachableWall)) attach_to_wall(wall);
	}
	else 
	{
		on_ground = false;
		if (attached_to_wall)
		{
			detach_from_wall();
		}
	}
}
else
{
	if (instance_exists(wall))
	{
		on_ground = true;
		climb_meter = 1;
		slide_meter = 1;
		flashing = false;
		image_index = 0;
		alarm[1] = -1;
		if (grapple_state == GRAPPLE_STATE.LAUNCHING || grapple_state == GRAPPLE_STATE.ATTACHED) detach_grapple_from_wall();
	
		if (!attached_to_wall && object_is_ancestor(wall.object_index, oAttachableWall)) attach_to_wall(wall);
	}
}
#endregion

#region Animation
if (!flashing && climb_meter < 0.20)
{
	flashing = true;
	alarm[1] = flash_frames;
}
image_xscale = grab_dir;
#endregion

#endregion

#region Jump
if (jump_buffer > 0)
{
	switch (state)
	{
		#region NORMAL
		case PLAYER_STATE.NORMAL:
		if (on_ground_buffer > 0)
		{
			activate_jump(noone, 0, false, true);
			x_vel += move_dir * moving_jump_horizontal_boost;
		}
		else if (grab_key && climb_meter > 0 && place_meeting(x+3*grab_dir, y, oAttachableWall))
		{
			activate_jump(instance_place(x+3*grab_dir, y, oAttachableWall), 0, false, false);
			climb_meter -= climb_meter_jump_usage;
		}
		else
		{
			var wall_dir = 0;
			if (place_meeting(x+3, y, oWall)) wall_dir = 1;
			else if (place_meeting(x-3, y, oWall)) wall_dir = -1;
			if (wall_dir != 0)
			{
				var disable_horizontal_control = x_input_dir != 0 || (grab_key && wall_dir == grab_dir);
				activate_jump(instance_place(x+3*wall_dir, y, oWall), -wall_dir, disable_horizontal_control, true);
			}
		}
		break;
		#endregion
		
		#region WALL_GRABBED
		case PLAYER_STATE.WALL_GRABBED:
		if (look_dir == grab_dir)
		{
			activate_jump(attached_wall, 0, false, false);
			climb_meter -= climb_meter_jump_usage;
		}
		else activate_jump(attached_wall, look_dir, true, true);
		break;
		#endregion
		
		#region CEILING_GRABBED
		case PLAYER_STATE.CEILING_GRABBED:
		
		activate_jump(attached_wall, look_dir, true, true);
		climb_meter -= climb_meter_jump_usage;
		
		break;
		#endregion
		
		#region GRAPPLED
		case PLAYER_STATE.GRAPPLED:
		var wall_dir = 0;
		if (place_meeting(x+3, y, oWall)) wall_dir = 1;
		else if (place_meeting(x-3, y, oWall)) wall_dir = -1;
		if (wall_dir != 0)
		{
			activate_jump(instance_place(x+3*wall_dir, y, oWall), -wall_dir, true, true);
			state = PLAYER_STATE.GRAPPLED;
		}
		break;
		#endregion
	}
}
#endregion

#region Dash activation
if (dash_buffer)
{
	x_vel = 0;
	y_vel = 0;
	if (is_nan(input_angle)) x_vel = look_dir * dash_vel;
	else
	{
		x_vel = lengthdir_x(dash_vel, input_angle);
		y_vel = lengthdir_y(dash_vel, input_angle);
	}
	alarm[3] = dash_frames;
	slide_meter = 1;
	dash_buffer = 0;
	if (state == PLAYER_STATE.GRAPPLED) detach_grapple_from_wall();
	if (attached_to_wall) detach_from_wall();
	state = PLAYER_STATE.DASHING;
}
#endregion

#region Player movement
//x_vel = x_input_dir * 1;
//y_vel = y_input_dir * 1;
switch (state)
{
	#region NORMAL
	case PLAYER_STATE.NORMAL:
	
	#region Horizontal movement
	// Deceleration
	var decel = (on_ground ? floor_move_decel : air_move_decel)
	if (move_dir == 0) x_vel -= sign(x_vel) * min(abs(x_vel), decel);
	else if (abs(x_vel) > max_x_vel) x_vel -= sign(x_vel) * decel;
	
	// Acceleration
	var accel = (on_ground ? floor_move_accel : air_move_accel);
	if (sign(x_vel) * move_dir == 1) x_vel += move_dir * clamp(max_x_vel - abs(x_vel), 0, accel);
	else x_vel += move_dir * accel;
	#endregion
	
	#region Vertical movement
	if (!on_ground)
	{
		// Sliding
		if ((place_meeting(x+x_input_dir, y, oWall) || (place_meeting(x+grab_dir, y, oWall) && grab_key)) 
			&& y_vel >= 0 && slide_meter > 0)
		{
			y_vel = max(y_vel - slide_decel, (1 - slide_meter) * max_fall_vel);
			slide_meter -= slide_meter_usage;
			y_vel += slide_meter_usage * max_fall_vel;
		}
		else
		{
			// Gravity and velocity damping
			if (y_vel > max_fall_vel) y_vel -= min(y_vel - max_fall_vel, air_move_decel);
			else if (!jump_active) y_vel += min(max_fall_vel - y_vel, grav); 
		}
	}
	#endregion
	
	break;
	#endregion
	
	#region WALL_GRABBED
	case PLAYER_STATE.WALL_GRABBED:
	if (y_input_dir == 1)
	{
		y_vel = grabbed_slide_vel;
	}
	else if (y_input_dir == -1)
	{
		if (place_empty(x+grab_dir, y-6, oWall))
		{
			//detach_from_wall();
			y_vel = -jump_vel;
			state = PLAYER_STATE.NORMAL;
			move_dir = grab_dir;
			horizontal_control = false;
			alarm[0] = corner_pop_control_disabled_frames;
		}
		else
		{
			y_vel = -climb_vel;
			climb_meter -= climb_meter_climb_usage;
		}
	}
	else
	{
		y_vel = 0;
		climb_meter -= climb_meter_normal_usage;
	}
	break;
	#endregion
	
	#region CEILING_GRABBED
	case PLAYER_STATE.CEILING_GRABBED:
	if (x_input_dir != 0)
	{
		x_vel = x_input_dir * climb_vel;
		climb_meter -= climb_meter_climb_usage;
	}
	else
	{
		x_vel = 0;
		climb_meter -= climb_meter_normal_usage;
	}
	break;
	#endregion
	
	#region GRAPPLED
	case PLAYER_STATE.GRAPPLED:
	y_vel += grav * 0.8;
	
	var relative_input_angle = angle_difference(grapple.swing_angle, input_angle);
	var angular_input_dir = 0; 
	if (!is_nan(relative_input_angle) && abs(relative_input_angle) > 22.5 && abs(relative_input_angle) < 157.5)
	{
		angular_input_dir = (relative_input_angle > 0 ? 1 : -1); // 1 = clockwise
	}
	
	// Swing acceleration
	if (angular_input_dir != 0)
	{
		var accel_angle = grapple.swing_angle - 90 * angular_input_dir;
		x_vel += lengthdir_x(grapple_swing_accel, accel_angle);
		y_vel += lengthdir_y(grapple_swing_accel, accel_angle);
	}
	
	// Jumping, climbing and extending
	if (jump_buffer > 0)
	{
		if (grappled_wall.object_index == oPullBlock && grappled_wall.state == ACTIVE_STATE.DEACTIVATED)
		{
			var dir = point_direction(grappled_wall.x, grappled_wall.y, x, y) //(grapple.swing_angle + 180) % 360;
			with (grappled_wall)
			{
				alarm[0] = -1;
				pull_dir = dir;
				if (place_meeting(x-1, y, oWall))
				{
					if (pull_dir > 90 && pull_dir <= 180) pull_dir = 90;
					else if (pull_dir > 180 && pull_dir < 270) pull_dir = 270;
				}
				if (place_meeting(x+1, y, oWall))
				{
					if (pull_dir >= 0 && pull_dir < 90) pull_dir = 90;
					else if (pull_dir > 270 && pull_dir < 360) pull_dir = 270;
				}
				if (place_meeting(x, y-1, oWall))
				{
					if (pull_dir > 0 && pull_dir <= 90) pull_dir = 0;
					else if (pull_dir > 90 && pull_dir < 180) pull_dir = 180;
				}
				if (place_meeting(x, y+1, oWall))
				{
					if (pull_dir > 180 && pull_dir <= 270) pull_dir = 180;
					else if (pull_dir > 270 && pull_dir < 360) pull_dir = 0;
				}
				
				state = ACTIVE_STATE.ACTIVATING;
			}
		}
		else
		{
			#region Launch calculation
			var launch_dir = grapple.swing_angle;
			var angular_vel = dot_product(lengthdir_x(1, grapple.swing_angle - 90), lengthdir_y(1, grapple.swing_angle - 90), 
				x_vel, y_vel);
			if (sign(angular_vel) == angular_input_dir)
			{
				launch_dir += 90 * (1 - (1 / (abs(angular_vel) / 5 + 1))) * -angular_input_dir;
			}
		
			var x_impulse = lengthdir_x(grapple_jump_vel, launch_dir);
			var y_impulse = lengthdir_y(grapple_jump_vel, launch_dir);
			if (x_impulse > 0) x_vel = max(x_vel + x_impulse, x_impulse);
			else x_vel = min(x_vel + x_impulse, x_impulse);
			if (y_impulse > 0) y_vel = max(y_vel + y_impulse, y_impulse);
			else y_vel = min(y_vel + y_impulse, y_impulse);
			#endregion
		}
		
		jump_buffer = 0;
		climb_meter -= climb_meter_jump_usage;
		grapple_spooling = true;
		alarm[4] = grapple_spooling_frames;
		
		//detach_grapple_from_wall();
		//jump_active = true;
		//alarm[2] = jump_rise_frames;
		//jump_buffer = 0;
		//slide_meter = 1;
	}
	
	if (grapple_spooling)
	{
		var dist = point_distance(x, y, grapple.swing_point.x, grapple.swing_point.y);
		grapple.length = grapple.length - grapple.swing_length + max((grapple.swing_length - dist) * 0.5 + dist, min_grapple_length);
	}
	else if (grapple_climb_key && grapple.length > min_grapple_length)
	{
		grapple.length -= climb_vel;
		climb_meter -= climb_meter_climb_usage;
	}
	else if (grapple_extend_key && grapple.length < max_grapple_length) grapple.length += grabbed_slide_vel;
	else climb_meter -= climb_meter_normal_usage;
	
	if (climb_meter <= 0) detach_grapple_from_wall();
	break;
	#endregion
}
#endregion

#region Grapple behaviour

// Grapple launching, attachment, reeling and storing
switch (grapple_state)
{
	#region READY
	case GRAPPLE_STATE.READY:
	if (grapple_key && has_grapple && climb_meter > 0 && !on_ground)
	{
		grapple.length = 0;
		if (is_nan(input_angle)) grapple_launch_angle = (look_dir == 1 ? 0 : 180);
		else grapple_launch_angle = input_angle;
		
		update_grapple_attachment_point(grapple, x, y, true);
		grapple_state = GRAPPLE_STATE.LAUNCHING;
		has_grapple = false;
	}
	break;
	#endregion
	
	#region LAUNCHING
	case GRAPPLE_STATE.LAUNCHING:
	with (grapple)
	{
		length = 0;
		for (var i = 0; i < ds_list_size(points) - 1; ++i)
		{
			var p1 = points[|i];
			var p2 = points[|i + 1];
			length += point_distance(p1.x, p1.y, p2.x, p2.y);
		}
		var dist = other.grapple_travel_speed;
		if (dist > other.grapple_range - length)
		{
			dist = other.grapple_range - length;
			other.grapple_state = GRAPPLE_STATE.REELING;
		}
	
		var x_diff = lengthdir_x(dist, other.grapple_launch_angle);
		var y_diff = lengthdir_y(dist, other.grapple_launch_angle);
		var data = collision_line_point(attachment_point.x, attachment_point.y, 
			attachment_point.x + x_diff, attachment_point.y + y_diff, oWall, false, true);
		attachment_point.x += x_diff;
		attachment_point.y += y_diff;
		var obj = data[0];
		var attachment_point_x = data[1];
		var attachment_point_y = data[2];
		if (obj != noone)
		{
			attachment_point.x = attachment_point_x;
			attachment_point.y = attachment_point_y;
			attachment_point.owning_wall = obj;
			if (obj.object_index == oLooseWall) other.grapple_state = GRAPPLE_STATE.REELING;
			else
			{
				with (other)
				{
					grapple_to_wall(obj);
					if (attached_to_wall) detach_from_wall();
					state = PLAYER_STATE.GRAPPLED;
					grapple_state = GRAPPLE_STATE.ATTACHED;
				}
		
				length = 0;
				for (var i = 0; i < ds_list_size(points) - 1; ++i)
				{
					var p1 = points[|i];
					var p2 = points[|i + 1];
					length += point_distance(p1.x, p1.y, p2.x, p2.y);
				}
				length = max(length, other.min_grapple_length);
			}
		}
	}
	break;
	#endregion
	
	#region ATTACHED
	case GRAPPLE_STATE.ATTACHED:
	if (!grapple_key) detach_grapple_from_wall();
	break;
	#endregion
	
	#region REELING
	case GRAPPLE_STATE.REELING:
	with (grapple)
	{
		length -= other.grapple_travel_speed;
	
		if (length > 0)
		{
			var curr_length = length;
			for (var i = ds_list_size(points) - 1; i > 0; --i)
			{
				var p1 = points[|i];
				var p2 = points[|i - 1];
				var dist = point_distance(p1.x, p1.y, p2.x, p2.y);
				if (dist > curr_length)
				{
					attachment_point.x = p1.x + (p2.x - p1.x) * curr_length / dist;
					attachment_point.y = p1.y + (p2.y - p1.y) * curr_length / dist;
					for (var j = i - 1; j >= 0; --j) ds_list_delete(points, 0);
					break;
				}
				else curr_length -= dist;
			}
			ds_list_insert(points, 0, attachment_point);
		}
		else other.grapple_state = GRAPPLE_STATE.READY;
	}
	break;
	#endregion
}

if (grapple_state != GRAPPLE_STATE.READY)
{
	grapple_wrap(grapple);
	
	if (grapple_state == GRAPPLE_STATE.ATTACHED) grapple_move(grapple);
}
#endregion

#region Movement and collision handling

#region x handling
x_exact += x_vel;
x = floor(x_exact);
if (place_meeting(x, y, oWall))
{
	var shifted = false;
	if (!grab_key && abs(x_vel) > min_corner_slide_vel)
	{
		for (var offset = 1; offset <= 4; ++offset)
		{
			if (place_empty(x, y + offset, oWall))
			{
				y += offset;
				y_exact = y;
				shifted = true;
				y_vel = max(y_vel, 0);
				break;
			}
			else if (place_empty(x, y - offset, oWall))
			{
				y -= offset;
				y_exact = y;
				shifted = true;
				y_vel = min(y_vel, 0);
				break;
			}
		}
	}
	if (!shifted)
	{
		while (place_meeting(x, y, oWall)) x -= sign(x_vel);
		x_exact = x;
		x_vel = 0;
	}
}
#endregion

#region y handling
y_exact += y_vel;
y = floor(y_exact);
if (place_meeting(x, y, oWall))
{
	var shifted = false;
	if (y_vel < 0 && abs(y_vel) > min_corner_slide_vel)
	{
		for (var offset = 1; offset <= 4; ++offset)
		{
			if (place_empty(x + offset, y, oWall))
			{
				x += offset;
				x_exact = x;
				shifted = true;
				x_vel = max(x_vel, 0);
				break;
			}
			else if (place_empty(x - offset, y, oWall))
			{
				x -= offset;
				x_exact = x;
				shifted = true;
				x_vel = min(x_vel, 0);
				break;
			}
		}
	}
	if (!shifted)
	{
		while (place_meeting(x, y, oWall)) y -= sign(y_vel);
		y_exact = y;
		y_vel = 0;
	}
}
#endregion

update_grapple_origin_point(grapple, x_exact, y_exact);

if (y > room_height + 8) respawn_player();

// Check here if the distance to the grapple point is still further than the grapple length, and detach if true

#region Old collision code
////x collision
//if (place_meeting(round(x_exact + x_vel), y, oWall))
//{
//	//if (!place_meeting(round(x_exact + x_vel), y + 4, oWall)) y += 4;
//	//else if (!place_meeting(round(x_exact + x_vel), y - 4, oWall)) y -= 4;
//	//else 
//	//{
//		while (!place_meeting(x + sign(x_vel), y, oWall))
//		{
//			x += sign(x_vel);
//		}
//		x_vel = 0;
//		x_exact = x;
//	//}
//}

////y collision
//if (place_meeting(x, round(y_exact + y_vel), oWall))
//{
//	while (!place_meeting(x, y + sign(y_vel), oWall))
//	{
//		y += sign(y_vel);
//	}
//	y_vel = 0;
//	y_exact = y;
//}

////Corner collision
//if (place_meeting(round(x_exact + x_vel), round(y_exact + y_vel), oWall))
//{
//	if (x_vel > y_vel)
//	{
//		while (!place_meeting(round(x + x_vel), y + sign(y_vel), oWall))
//		{
//			y += sign(y_vel);
//		}
//		y_vel = 0;
//		y_exact = y;
//	}
//	else
//	{
//		while (!place_meeting(x + sign(x_vel), round(y + y_vel), oWall))
//		{
//			x += sign(x_vel);
//		}
//		x_vel = 0;
//		x_exact = x;
//	}
//}

////Movement handling
//x_exact += x_vel;
//x = round(x_exact);
//y_exact += y_vel;
//y = round(y_exact);
#endregion

#endregion

#region Buffer decrementing
if (jump_buffer > 0) jump_buffer -= 1;
if (dash_buffer > 0) dash_buffer -= 1;
if (on_ground_buffer > 0) on_ground_buffer -= 1;
#endregion