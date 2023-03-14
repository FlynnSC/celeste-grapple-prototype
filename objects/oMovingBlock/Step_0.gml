event_inherited();

#region Block and player movement handling

#region x handling
x_exact += x_vel;
x = floor(x_exact);
if (player_attached)
{
	player.x_exact += x_vel;
	player.x = floor(player.x_exact);
}

// Push handling
if (place_meeting(x, y, player))
{
	var dir = sign(player.x - x);
	while (place_meeting(x, y, player))
	{
		player.x += dir;
	}
	player.x_exact = player.x;
}

// Pushed by other wall handling and crush checking
with (player)
{
	var wall = instance_place(x, y, oWall);
	if (instance_exists(wall))
	{
		var vel_dir = sign(other.x_vel);
		while (place_meeting(x, y, wall))
		{
			x -= sign(vel_dir);
		}
		x_exact = x;
		if (place_meeting(x, y, oWall)) respawn_player();
	}
}

//// Snap to wall handling
//if (player_attached && player.state == PLAYER_STATE.WALL_GRABBED)
//{
//	var dir = sign(player.x - x);
//	if (!place_meeting(x+dir, y, player))
//	{
//		while (!place_meeting(x+dir, y, player))
//		{
//			player.x -= dir;
//		}
//	}
//	player.x_exact = player.x;
//}
#endregion

#region y handling
y_exact += y_vel;
y = floor(y_exact);
if (player_attached)
{
	player.y_exact += y_vel;
	player.y = floor(player.y_exact);
}

// Push handling
if (place_meeting(x, y, player))
{
	var dir = sign(player.y - y);
	while (place_meeting(x, y, player))
	{
		player.y += dir;
	}
	player.y_exact = player.y;
}

// Pushed by other wall handling and crush checking
with (player)
{
	var wall = instance_place(x, y, oWall);
	if (instance_exists(wall))
	{
		var vel_dir = sign(other.y_vel);
		while (place_meeting(x, y, wall))
		{
			y -= vel_dir;
		}
		y_exact = y;
		if (place_meeting(x, y, oWall)) respawn_player();
	}
}

//// Snap to wall handling
//if (player_attached && player.state != PLAYER_STATE.WALL_GRABBED)
//{
//	var dir = sign(player.y - y);
//	if (!place_meeting(x, y+dir, player))
//	{
//		while (!place_meeting(x, y+dir, player))
//		{
//			player.y -= dir;
//		}
//	}
//	player.y_exact = player.y;
//}
#endregion

#region Detachment and alignment handling
if (player_attached)
{
	if (!place_meeting(x+3*sign(player.x - x), y, player) && !place_meeting(x, y+3*sign(player.y - y), player))
	{
		with (player) detach_from_wall();
	}
	else
	{
		if (player.x_vel == 0) player.x_exact = player.x + frac(x_exact);
		if (player.y_vel == 0) player.y_exact = player.y + frac(y_exact);
	}
}
#endregion

#endregion
	
#region Spikes
var n = ds_list_size(attached_spikes);
for (var i = 0; i < n; ++i)
{
	var spike = attached_spikes[|i];
	spike.x_exact += x_vel;
	spike.x = floor(spike.x_exact);
	spike.y_exact += y_vel;
	spike.y = floor(spike.y_exact);
}
#endregion

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

if (player_grappled)
{
	grapple_point.x = x + grapple_point_offset.x;
	grapple_point.y = y + grapple_point_offset.y;
}

