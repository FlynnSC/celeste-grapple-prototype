if (isStatic)
{
	if (player_attached || player_grappled)
	{
		with (oSwingingBlock) isStatic = false;
	}
}