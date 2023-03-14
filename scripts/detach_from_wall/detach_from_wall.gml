///@func detach_from_wall()
function detach_from_wall() {

	x_vel += attached_wall.detachment_x_vel;
	y_vel += attached_wall.detachment_y_vel;

	attached_wall.player_attached = false;
	attached_to_wall = false;


}
