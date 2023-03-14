player = instance_find(oPlayer, 0);
camera = view_camera[0];
view_width = camera_get_view_width(camera);
view_height = camera_get_view_height(camera);
interp_rate = 0.08;

focal_point_x = player.x;
focal_point_y = player.y;
var volume = collision_point(player.x, player.y, oCameraControlVolume, false, true);
if (instance_exists(volume))
{
	focal_point_x += volume.focal_offset_x;
	focal_point_y += volume.focal_offset_y;
	if (volume.left_clamp) focal_point_x = max(focal_point_x, volume.bbox_left + view_width / 2);
	if (volume.right_clamp) focal_point_x = min(focal_point_x, volume.bbox_right + 1 - view_width / 2);
	if (volume.top_clamp) focal_point_y = max(focal_point_y, volume.bbox_top + view_height / 2);
	if (volume.bottom_clamp) focal_point_y = min(focal_point_y, volume.bbox_bottom + 1 - view_height / 2);
}

x = clamp(round(focal_point_x - view_width / 2), 0, room_width - view_width);
y = clamp(round(focal_point_y - view_height / 2), 0, room_height - view_height);
camera_set_view_pos(camera, x, y);