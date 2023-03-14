/// @function activate_jump(wall, wall_jump_dir, disable_horizontal_control, wall_detach)
/// @param wall
/// @param wall_jump_dir 
/// @param object_index 
/// @param wall_detach
function activate_jump(argument0, argument1, argument2, argument3) {
	var wall = argument0
	var wall_jump_dir = argument1;
	var disable_horizontal_control = argument2;
	var wall_detach = argument3;

	y_vel = -jump_vel;
	if (wall_jump_dir != 0) x_vel = wall_jump_dir * wall_jump_vel;

	if (disable_horizontal_control)
	{
		move_dir = wall_jump_dir;
		horizontal_control = false;
		alarm[0] = wall_jump_control_disabled_frames;
	}

	jump_active = true;
	alarm[2] = jump_rise_frames;
	jump_buffer = 0;
	state = PLAYER_STATE.NORMAL;
	slide_meter = 1;

	// Ensures that wall jumps that aren't attached to the wall gain the detachment vel
	if (instance_exists(wall) && object_is_ancestor(wall.object_index, oMovingBlock))
	{
		attached_to_wall = true;
		attached_wall = wall;
	}
	if (attached_to_wall && wall_detach) detach_from_wall();


}
