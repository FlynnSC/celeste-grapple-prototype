event_inherited();

pull_dir = 0;
pull_dist = 0;
max_pull_dist = 48;
pull_speed = 5;

active_wait_frames = 90;
deactive_wait_frames = 15;

corner_offsets = array_create(4);
for (var i = 0; i < 4; ++i)
{
	var offset = instance_create_depth(corners[i].x - x, corners[i].y - y, 0, oPoint);
	instance_deactivate_object(offset);
	corner_offsets[i] = offset;
}

trail_surf = noone;