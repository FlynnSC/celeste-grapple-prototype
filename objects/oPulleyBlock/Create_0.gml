event_inherited();

has_grapple = true;

#region Grapple creation
left_grapple = instance_create_depth(0, 0, 0, oGrapple);
left_grapple.owner = id;
left_grapple.attached = true;
left_grapple.origin_point.x = x - width / 2 - 2;
left_grapple.origin_point.y = y - 1;
left_grapple.attachment_point.x = left_grapple.origin_point.x + left_grapple_attachment_offset_x;
left_grapple.attachment_point.y = left_grapple.origin_point.y + left_grapple_attachment_offset_y;
with (left_grapple) length = point_distance(origin_point.x, origin_point.y, attachment_point.x, attachment_point.y);

right_grapple = instance_create_depth(0, 0, 0, oGrapple);
right_grapple.owner = id;
right_grapple.attached = true;
right_grapple.origin_point.x = x + width / 2 - 1;
right_grapple.origin_point.y = y - 1;
right_grapple.attachment_point.x = right_grapple.origin_point.x + right_grapple_attachment_offset_x;
right_grapple.attachment_point.y = right_grapple.origin_point.y + right_grapple_attachment_offset_y;
with (right_grapple) length = point_distance(origin_point.x, origin_point.y, attachment_point.x, attachment_point.y);
#endregion

normal_left_length = left_grapple.length;
normal_right_length = right_grapple.length;

reel_vel = 0;
max_reel_in_speed = 4;
max_reel_out_speed = 1;
reel_accel = 0.15;
