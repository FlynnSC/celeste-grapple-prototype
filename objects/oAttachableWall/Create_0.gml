event_inherited();
enum ACTIVE_STATE
{
	ACTIVATION_WAITING,
	ACTIVATING,
	ACTIVATED,
	DEACTIVATION_WAITING,
	DEACTIVATING,
	DEACTIVATED,
}
state = ACTIVE_STATE.DEACTIVATED;

player = noone;
player_attached = false;
player_grappled = false;
grapple_point = noone;
grapple_point_offset = instance_create_depth(0, 0, 0, oPoint);

has_grapple = false;

detachment_x_vel = 0;
detachment_y_vel = 0;
detachment_vel_conservation_frames = 6;

attached_spikes = ds_list_create();
instance_place_list(x + 1, y, oSpikesRight, attached_spikes, false);
instance_place_list(x - 1, y, oSpikesLeft, attached_spikes, false);
instance_place_list(x, y + 1, oSpikesDown, attached_spikes, false);
instance_place_list(x, y - 1, oSpikesUp, attached_spikes, false);

block_surf = noone;
width = 16 * image_xscale;
height = 16 * image_yscale;
