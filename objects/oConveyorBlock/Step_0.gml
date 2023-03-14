event_inherited();

if (active)
{
	#region Wall crawling
	if (attached_to_wall)
	{
		var x_diff = lengthdir_x(conveyor_speed, wall_attachment_dir + 90);
		var y_diff = lengthdir_y(conveyor_speed, wall_attachment_dir + 90);
	
		if (place_meeting(x+x_diff, y+y_diff, oWall))
		{
			while (place_meeting(x+x_diff, y+y_diff, oWall))
			{
				x_diff -= sign(x_diff);
				y_diff -= sign(y_diff);
			}
			wall_attachment_dir = (wall_attachment_dir + 90) % 360;
		}
		else
		{
			var x_nudge = lengthdir_x(1, wall_attachment_dir);
			var y_nudge = lengthdir_y(1, wall_attachment_dir);
			if (place_empty(x+x_diff+x_nudge, y+y_diff+y_nudge, oWall))
			{
				//while (place_empty(x+x_diff+x_nudge, y+y_diff+y_nudge, oWall))
				//{
				//	x_diff -= sign(x_diff);
				//	y_diff -= sign(y_diff);
				//}
				//x_diff += sign(x_diff);
				//y_diff += sign(y_diff);
				wall_attachment_dir = (wall_attachment_dir - 90) % 360;
			}
		}
	
		x += x_diff;
		y += y_diff;
	
		if (player_attached)
		{
			#region Player attached
			with (player) 
			{
				if (x_diff != 0)
				{
					x += x_diff;
					x_exact = x;
				}
				else
				{
					y += y_diff;
					y_exact = y;
				}
			
				if (place_meeting(x, y, oWall)) respawn_player();
			}
			#endregion
		}
		else
		{
			#region Player pushed
			if (place_meeting(x, y, player))
			{
				while (place_meeting(x, y, player))
				{
					player.x += sign(x_diff);
					player.y += sign(y_diff);
				}
				player.x_exact = player.x;
				player.y_exact = player.y;
			}
		
			with (player)
			{
				if (place_meeting(x, y, oWall)) respawn_player();
			}
			#endregion
		}
	
		#region Corners
		for (var i = 0; i < 4; ++i)
		{
			var corner = corners[i];
			corner.prev_x = corner.x;
			corner.prev_y = corner.y;
		}

		corners[0].x = bbox_left - 1;
		corners[0].y = bbox_top - 1;

		corners[1].x = bbox_right;
		corners[1].y = bbox_top - 1;	

		corners[2].x = bbox_left - 1;
		corners[2].y = bbox_bottom;

		corners[3].x = bbox_right;
		corners[3].y = bbox_bottom;
		#endregion
	}
	#endregion

	#region Player attached
	if (player_attached)
	{
		if (player.state == PLAYER_STATE.WALL_GRABBED)
		{
			var y_diff = conveyor_speed * ((conveyor_dir == 1) != (grapple_attachment_dir == 1) ? -1 : 1);
			player.y_exact += y_diff;
			player.y = floor(player.y_exact);
			detachment_x_vel = 0;
			detachment_y_vel = y_diff;
		
			with (player)
			{
				if (place_meeting(x, y, oWall)) 
				{
					while (place_meeting(x, y, oWall)) y -= sign(y_diff);
					y_exact = y;
				}
			}
		}
		else
		{
			var x_diff = conveyor_speed * ((conveyor_dir == 1) != (grapple_attachment_dir == 1) ? 1 : -1);
			player.x_exact += x_diff;
			player.x = floor(player.x_exact);
			detachment_x_vel = x_diff;
			detachment_y_vel = 0;
		
			with (player)
			{
				if (place_meeting(x, y, oWall)) 
				{
					while (place_meeting(x, y, oWall)) x -= sign(x_diff);
					x_exact = x;
				}
			}
		}
	}
	#endregion

	#region Player grappled
	if (player_grappled)
	{
		var offset_x = grapple_point_offset.x;
		var offset_y = grapple_point_offset.y;
	
		if (grapple_attachment_axis == 0)
		{
			var edge_transition_dir = -grapple_attachment_dir;
			var edge_y = ((conveyor_dir == 1) != (grapple_attachment_dir == 1) ? bbox_top-1 : bbox_bottom+1); //XOR
			var edge_diff = (edge_y - y) - offset_y;
		
			if (abs(edge_diff) < conveyor_speed)
			{
				offset_y += edge_diff;
				grapple_attachment_axis = 1;
				grapple_attachment_dir = ((conveyor_dir == 1) != (grapple_attachment_dir == 1) ? -1 : 1);
			
				grapple_point.prev_x = x + offset_x - edge_transition_dir;
				grapple_point.prev_y = y + offset_y;
			
				offset_x += edge_transition_dir * (conveyor_speed - abs(edge_diff));
			}
			else
			{
				offset_y += sign(edge_diff) * conveyor_speed;
				grapple_point.prev_x = x + offset_x - edge_transition_dir;
				grapple_point.prev_y = y + offset_y;
			}
			
			with (player)
			{
				var n = ds_list_size(grapple_points);
				update_point_data(grapple_points[|n - 2], grapple_points[|n - 1], true);
				update_point_relations(grapple_points[|n - 2], grapple_points[|n - 1], true);
			}
		}
		else
		{
			var edge_transition_dir = -grapple_attachment_dir;
			var edge_x = ((conveyor_dir == 1) != (grapple_attachment_dir == 1) ? bbox_right+1 : bbox_left-1); //XOR
			var edge_diff = (edge_x - x) - offset_x;
		
			if (abs(edge_diff) < conveyor_speed)
			{
				offset_x += edge_diff;
				grapple_attachment_axis = 0;
				grapple_attachment_dir = ((conveyor_dir == 1) != (grapple_attachment_dir == 1) ? 1 : -1);
			
				grapple_point.prev_x = x + offset_x;
				grapple_point.prev_y = y + offset_y - edge_transition_dir;
			
				offset_y += edge_transition_dir * (conveyor_speed - abs(edge_diff));
			}
			else 
			{
				offset_x += sign(edge_diff) * conveyor_speed;
				grapple_point.prev_x = x + offset_x;
				grapple_point.prev_y = y + offset_y - edge_transition_dir;
			}
			
			with (player)
			{
				var n = ds_list_size(grapple_points);
				update_point_data(grapple_points[|n - 2], grapple_points[|n - 1], true);
				update_point_relations(grapple_points[|n - 2], grapple_points[|n - 1], true);
			}
		}
	
		grapple_point_offset.x = offset_x;
		grapple_point_offset.y = offset_y;
		grapple_point.x = x + grapple_point_offset.x;
		grapple_point.y = y + grapple_point_offset.y;
	}
	#endregion
}
else
{
	if (player_attached || player_grappled) active = true;
}
