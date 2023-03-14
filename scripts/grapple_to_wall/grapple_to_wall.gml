///@func grapple_to_wall(wall)
///@param wall
function grapple_to_wall(argument0) {

	var wall = argument0;

	grapple.attached = true;
	grappled_wall = wall;
	wall.player_grappled = true;
	wall.grapple_point = grapple.attachment_point;
	wall.grapple_point_offset.x = grapple.attachment_point.x - wall.x;
	wall.grapple_point_offset.y = grapple.attachment_point.y - wall.y;

	switch (wall.object_index)
	{
	#region Winch block
		case oWinchBlock:
		with (wall)
		{
			if (abs(grapple_point_offset.x) / image_xscale > abs(grapple_point_offset.y) / image_yscale)
			{
				grapple_point_offset.y = clamp(grapple_point_offset.y, 3 - 8 * image_yscale, 3 + 8 * image_yscale);
				grapple_point.x = x + grapple_point_offset.x;
			
				if (sign(grapple_point_offset.x) == 1) winch_speed = abs(min(player.x_vel, 0));
				else winch_speed = abs(max(player.x_vel, 0));
			}
			else
			{
				grapple_point_offset.x = clamp(grapple_point_offset.x, 3 - 8 * image_xscale, 3 + 8 * image_xscale);
				grapple_point.y = y + grapple_point_offset.y;
			
				if (sign(grapple_point_offset.y) == 1) winch_speed = abs(min(player.y_vel, 0));
				else winch_speed = abs(max(player.y_vel, 0));
			}
		}
		break;
	#endregion
	
	#region Conveyor block
		case oConveyorBlock:
		with (wall)
		{
			if (abs(grapple_point_offset.x) / image_xscale > abs(grapple_point_offset.y) / image_yscale)
			{
				grapple_attachment_axis = 0;
				grapple_attachment_dir = sign(grapple_point_offset.x);
				grapple_point.x = floor(grapple_point.x);
				grapple_point_offset.x = floor(grapple_point_offset.x);
				grapple_point.y = floor(grapple_point.y);
				grapple_point_offset.y = floor(grapple_point_offset.y);
			}
			else
			{
				grapple_attachment_axis = 1;
				grapple_attachment_dir = sign(grapple_point_offset.y);
				grapple_point.x = floor(grapple_point.x);
				grapple_point_offset.x = floor(grapple_point_offset.x);
				grapple_point.y = floor(grapple_point.y);
				grapple_point_offset.y = floor(grapple_point_offset.y);
			}
		}
		break;
	#endregion
	}


}
