///@func attach_to_wall(wall)
///@param wall
function attach_to_wall(argument0) {

	var wall = argument0;

	attached_wall = wall;
	attached_to_wall = true;
	wall.player_attached = true;
	if (on_ground && object_is_ancestor(wall.object_index, oMovingBlock))
	{
		if (x_vel > 0) x_vel = max(x_vel - wall.x_vel, 0);
		else if (x_vel < 0) x_vel = min(x_vel - wall.x_vel, 0);
	}

	var wall_type = wall.object_index;
	if (object_is_ancestor(wall_type, oMovingBlock))
	{
		x_exact = floor(x_exact) + frac(wall.x_exact); // Synchronises the player's inter-pixel offset
		y_exact = floor(y_exact) + frac(wall.y_exact);
	}
	else if (wall_type == oConveyorBlock)
	{
		with (wall)
		{
			if (abs(player.x - x) / image_xscale > abs(player.y - y) / image_yscale)
			{
				grapple_attachment_axis = 0;
				grapple_attachment_dir = sign(player.x - x);
			}
			else
			{
				grapple_attachment_axis = 1;
				grapple_attachment_dir = sign(player.y - y);
			}
		}
	}


}
