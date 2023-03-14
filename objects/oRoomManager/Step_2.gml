var goto_next = false;
for (var i = -1; i < 1; ++i)
{
	var transition;
	if (room_index + i >= 0 && room_index + i < room_count)
	{
		transition = transition_data[room_index + i];
		var dir = (i == 0 ? transition[? "dir"] : opposite_direction(transition[? "dir"]))
		switch (dir)
		{
			case DIR.RIGHT:
			transition_occured = player.x > room_width;
			break;
		
			case DIR.UP:
			transition_occured = player.y < 0;
			break;
		
			case DIR.LEFT:
			transition_occured = player.x < 0;
			break;
		
			case DIR.DOWN:
			transition_occured = player.y > room_height;
			break;
		}
	}
	
	if (transition_occured)
	{
		transition_x_vel = player.x_vel;
		transition_y_vel = player.y_vel;
		if (goto_next)
		{
			transition_x = player.x + transition[? "offset_x"];
			transition_y = player.y + transition[? "offset_y"];
			++room_index;
			room_goto_next();
		}
		else 
		{
			transition_x = player.x - transition[? "offset_x"];
			transition_y = player.y - transition[? "offset_y"];
			--room_index;
			room_goto_previous();
		}
		break;
	}
	
	goto_next = true;
}

