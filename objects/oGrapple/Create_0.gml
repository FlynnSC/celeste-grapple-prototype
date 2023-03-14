#region GRAPPLE_STATE enum
enum GRAPPLE_STATE
{
	READY,
	LAUNCHING,
	ATTACHED,
	REELING
}
#endregion

owner = noone;
player_grapple = false;
attached = false;

points = ds_list_create();
origin_point = instance_create_depth(0, 0, 0, oPoint);
attachment_point = instance_create_depth(0, 0, 0, oPoint);
ds_list_add(points, attachment_point);
ds_list_add(points, origin_point);

length = 0;
swing_point = noone; // Point one from the origin point in the chain
swing_length = 0; // Length from the swing point to the origin point
swing_angle = 0;

