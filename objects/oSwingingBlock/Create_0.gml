event_inherited();

has_grapple = true;
grapple = instance_create_depth(0, 0, 0, oGrapple);
grapple.owner = id;
grapple.attached = true;
grapple.origin_point.x = x;
grapple.origin_point.y = y - height / 2 - 1;
grapple.attachment_point.x = grapple.origin_point.x + attachment_offset_x;
grapple.attachment_point.y = grapple.origin_point.y + attachment_offset_y;
with (grapple) length = point_distance(origin_point.x, origin_point.y, attachment_point.x, attachment_point.y);

for (var i = 0; i < frame_advance; ++i)
{
	event_perform(ev_step, ev_step_normal);
}