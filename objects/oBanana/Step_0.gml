if (!instance_exists(player)) player = instance_find(oPlayer, 0);

if (active)
{
	if (place_meeting(x, y - oscillation_offset, player) && player.climb_meter < 1)
	{
		with (player)
		{
			climb_meter = 1;
			slide_meter = 1;
			flashing = false;
			image_index = 0;
			alarm[1] = -1;
		}
		
		active = false;
		oscillation_offset = 0;
		y = ystart;
		frame_counter = 0;
		image_index = 1;
		alarm[0] = refresh_frames;
	}
	else
	{
		oscillation_offset = oscillation_magnitude * -sin(oscillation_speed * frame_counter);
		y = ystart + oscillation_offset;
		++frame_counter;
	}
}