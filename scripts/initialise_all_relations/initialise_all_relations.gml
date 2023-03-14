///@func initialise_all_relations()
function initialise_all_relations() {

	with (oGrapple)
	{
		var grapple = id;
		if (player_grapple)
		{
		#region Player grapple
			with (oWall)
			{
				for (var i = 0; i < 4; ++i)
				{
					var n = instance_number(oWall);
					var relations = array_create(n * 4);
					for (var j = 0; j < n; ++j)
					{
						var wall = instance_find(oWall, j);
						for (var k = 0; k < 4; ++k)
						{
							var relation = instance_create_depth(0, 0, 0, oRelation);
							relation.point = wall.corners[k];
							relations[@ 4 * j + k] = relation;
						}
					}
					corners[i].relation_set[? grapple] = relations;
				}
			}
		
			var n = instance_number(oWall);
			var relations = array_create(n * 4);
			for (var j = 0; j < n; ++j)
			{
				var wall = instance_find(oWall, j);
				for (var k = 0; k < 4; ++k)
				{
					var relation = instance_create_depth(0, 0, 0, oRelation);
					relation.point = wall.corners[k];
					relations[@ 4 * j + k] = relation;
				}
			}
			attachment_point.relation_set[? grapple] = relations;
		#endregion
		}
		else
		{
		#region Block grapples
			var wrappable_blocks = array_create(1);
			var wrappable_block_count = 0;
			with (oWall)
			{
				if (block_grapple_wrappable)
				{
					wrappable_blocks[wrappable_block_count] = id;
					++wrappable_block_count;
				}
			}

			for (var i = 0 ; i < wrappable_block_count; ++i)
			{
				with (wrappable_blocks[i])
				{
					for (var j = 0; j < 4; ++j)
					{
						var corner = corners[j];
						var relations = array_create(wrappable_block_count * 4);
						for (var k = 0; k < wrappable_block_count; ++k)
						{
							var block = wrappable_blocks[k];
							for (var l = 0; l < 4; ++l)
							{
								var relation = instance_create_depth(0, 0, 0, oRelation);
								relation.point = block.corners[l];
								relations[@ 4 * k + l] = relation;
							}
						}
						corner.relation_set[? grapple] = relations;
					}
				}
			}

			var relations = array_create(wrappable_block_count * 4);
			for (var k = 0; k < wrappable_block_count; ++k)
			{
				var block = wrappable_blocks[k];
				for (var l = 0; l < 4; ++l)
				{
					var relation = instance_create_depth(0, 0, 0, oRelation);
					relation.point = block.corners[l];
					relations[@ 4 * k + l] = relation;
				}
			}
			attachment_point.relation_set[? grapple] = relations;
		#endregion
		}
	}





}
