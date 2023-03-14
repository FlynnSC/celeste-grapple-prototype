if (!instance_exists(player))
{
	var spawn = instance_find(oPlayerSpawn, 0);
	if (instance_exists(spawn))
	{
		if (transition_occured)
		{
			player = instance_create_layer(transition_x, transition_y, "Player", oPlayer);
			player.x_vel = transition_x_vel;
			player.y_vel = transition_y_vel;
			transition_occured = false;
		}
		else player = instance_create_layer(spawn.x, spawn.y, "Player", oPlayer);
	}
}

initialise_all_relations();