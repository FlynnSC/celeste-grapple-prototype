event_inherited();

grapple_attachment_axis = 0; // x = 0, y = 1
grapple_attachment_dir = 0;

subimage_index = 0;

attached_to_wall = false;
wall_attachment_dir = 0;

for (var dir = 0; dir < 360; dir += 90)
{
	var x_diff = lengthdir_x(1, dir);
	var y_diff = lengthdir_y(1, dir);
	if (place_meeting(x+x_diff, y+y_diff, oWall))
	{
		attached_to_wall = true;
		x_diff = lengthdir_x(1, dir + 90 * conveyor_dir);
		y_diff = lengthdir_y(1, dir + 90 * conveyor_dir); 
		if (place_meeting(x+x_diff, y+y_diff, oWall)) wall_attachment_dir = (dir + 90) % 360;
		else wall_attachment_dir = dir;
	}
}

