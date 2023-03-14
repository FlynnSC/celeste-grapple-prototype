///@func opposite_direction(dir)
///@param dir
function opposite_direction(argument0) {

	var dir = argument0;
	switch (dir)
	{
		case DIR.RIGHT:
		return DIR.LEFT;
	
		case DIR.LEFT:
		return DIR.RIGHT;
	
		case DIR.UP:
		return DIR.DOWN;
	
		case DIR.DOWN:
		return DIR.UP;
	}


}
