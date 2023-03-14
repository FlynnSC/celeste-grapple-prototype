if (!instance_exists(player)) player = instance_find(oPlayer, 0);

var new_focal_point_x = player.x;
var new_focal_point_y = player.y;
var volume = collision_point(player.x, player.y, oCameraControlVolume, false, true);
if (instance_exists(volume))
{
	new_focal_point_x += volume.focal_offset_x;
	new_focal_point_y += volume.focal_offset_y;
	if (volume.left_clamp) new_focal_point_x = max(new_focal_point_x, volume.bbox_left + view_width / 2);
	if (volume.right_clamp) new_focal_point_x = min(new_focal_point_x, volume.bbox_right + 1 - view_width / 2);
	if (volume.top_clamp) new_focal_point_y = max(new_focal_point_y, volume.bbox_top + view_height / 2);
	if (volume.bottom_clamp) new_focal_point_y = min(new_focal_point_y, volume.bbox_bottom + 1 - view_height / 2);
}

focal_point_x += (new_focal_point_x - focal_point_x) * interp_rate;
focal_point_y += (new_focal_point_y - focal_point_y) * interp_rate;

x = clamp(focal_point_x - view_width / 2, 0, room_width - view_width);
y = clamp(focal_point_y - view_height / 2, 0, room_height - view_height);
camera_set_view_pos(camera, x, y);