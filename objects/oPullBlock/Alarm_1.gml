/// @description wait timer

if (state == ACTIVE_STATE.DEACTIVATION_WAITING)
{
	state = ACTIVE_STATE.DEACTIVATING;
	alarm[0] = -1;
}
else
{
	state = ACTIVE_STATE.DEACTIVATED;
}