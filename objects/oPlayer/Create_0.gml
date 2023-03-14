#region Direction enum
enum DIR
{
	RIGHT,
	UP_RIGHT,
	UP,
	UP_LEFT,
	LEFT,
	DOWN_LEFT,
	DOWN,
	DOWN_RIGHT
}
#endregion

#region State enum
enum PLAYER_STATE
{
	NORMAL,
	WALL_GRABBED,
	CEILING_GRABBED,
	DASHING,
	GRAPPLED
}
#endregion

#region Constants
max_x_vel = 1.5;
floor_move_accel = 0.30;
air_move_accel = 0.16;
floor_move_decel = 0.38;
air_move_decel = 0.11; // Fall velocity decel, move_dir == 0 and floor horizontal decel

jump_vel = 1.6;
jump_rise_frames = 13;//12;
moving_jump_horizontal_boost = 0.6;
grav = 0.19;
max_fall_vel = 2.65;
coyote_frames = 6;

input_buffer = 4;
min_corner_slide_vel = 0.5; // For sliding around corners upon collision

dash_vel = 4;
dash_frames = 7;

wall_jump_vel = 1.8; // Sideways velocity
wall_jump_control_disabled_frames = 10; // Used when jumping away from a wall 
climb_vel = 0.75;
grabbed_slide_vel = 1.3;
slide_meter = 1; // Used for when moving toward a wall or grabbing with no grab meter
slide_meter_usage = 0.02;
slide_decel = 0.3;

climb_meter_normal_usage = 0.0015;
climb_meter_climb_usage = 0.007;
climb_meter_jump_usage = 0.25;
flashing = false;
flash_frames = 3;
corner_pop_control_disabled_frames = 9;

// Grapple
grapple_range = 200;//150;
min_grapple_length = 6;
max_grapple_length = 500;
grapple_jump_vel = 3;
grapple_swing_accel = 0.04;
grapple_spooling_frames = 16;
grapple_travel_speed = 20;

#endregion

#region Properties
image_speed = 0;
x_vel = 0;
x_exact = xstart;
y_vel = 0;
y_exact = ystart;
x_input_dir = 0;
y_input_dir = 0;
input_angle = NaN;
horizontal_control = true;

move_dir = 0;
look_dir = 1;
grab_dir = 1;
on_ground = false;
state = PLAYER_STATE.NORMAL;

jump_buffer = 0;
jump_active = false;
dash_buffer = 0;
on_ground_buffer = coyote_frames;

attached_to_wall = false;
attached_wall = noone;

climb_meter = 1;

// Grapple
grapple = instance_create_depth(0, 0, 0, oGrapple);
grapple.owner = id;
grapple.player_grapple = true;

has_grapple = false;
grapple_state = GRAPPLE_STATE.READY;
grappled_wall = noone;

grapple_launch_angle = 0;
grapple_spooling = false; // Reducing length while still grappled

// Debug

// Config
instance_create_layer(x, y, "Player", oCameraManager);
gamepad_set_axis_deadzone(0, 0.4);
window_set_fullscreen(true);
//window_set_size(1200, 720);
window_set_position(150, 120);
window_set_cursor(cr_none);
show_debug_overlay(true);
#endregion
