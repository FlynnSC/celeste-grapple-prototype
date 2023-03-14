///@func detach_grapple_from_wall
function detach_grapple_from_wall() {

	state = PLAYER_STATE.NORMAL;
	if (grapple_state == GRAPPLE_STATE.ATTACHED) grappled_wall.player_grappled = false;
	grapple_state = GRAPPLE_STATE.REELING;



}
