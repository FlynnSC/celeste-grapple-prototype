if (!triggered)
{
	if (place_meeting(x, y, oPlayer))
	{
		triggered = true;
		var all_triggered = true;
		var n = instance_number(oTrigger);
		for (var i = 0; i < n; ++i)
		{
			var trigger = instance_find(oTrigger, i);
			if (trigger.trigger_block_index == trigger_block_index && !trigger.triggered)
			{
				all_triggered = false;
				break;
			}
		}
		if (all_triggered)
		{
			var block = instance_find(oTriggerBlock, trigger_block_index);
			block.triggered = true;
			var index = trigger_block_index;
			with (oTrigger)
			{
				if (trigger_block_index == index) image_index = 2;
			}
		}
		else image_index = 1;
	}
}