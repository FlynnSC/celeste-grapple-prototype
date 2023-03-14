if (!instance_exists(player)) player = instance_find(oPlayer, 0);

if (place_meeting(x, y, player))
{
	with (player) respawn_player();
}