corners = array_create(4);
for (var i = 0; i < 4; ++i)
{
	var corner = instance_create_depth(0, 0, 0, oPoint);
	corner.owning_wall = id;
	corners[i] = corner;
}
corners[0].x = bbox_left - 1;
corners[0].y = bbox_top - 1;

corners[1].x = bbox_right;
corners[1].y = bbox_top - 1;	

corners[2].x = bbox_left - 1;
corners[2].y = bbox_bottom;

corners[3].x = bbox_right;
corners[3].y = bbox_bottom;

for (var i = 0; i < 4; ++i)
{
	var corner = corners[i];
	corner.prev_x = corner.x;
	corner.prev_y = corner.y;
}