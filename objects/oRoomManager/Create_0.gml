var start_room = room2_1;
player = noone;

#region room0
var room0_data = ds_map_create();
room0_data[? "dir"] = DIR.RIGHT;
room0_data[? "offset_x"] = -480;
room0_data[? "offset_y"] = 0;
transition_data[0] = room0_data;
#endregion

#region room1
var room1_data = ds_map_create();
room1_data[? "dir"] = DIR.UP;
room1_data[? "offset_x"] = -216;
room1_data[? "offset_y"] = 360;
transition_data[1] = room1_data;
#endregion

#region room2
var room2_data = ds_map_create();
room2_data[? "dir"] = DIR.RIGHT;
room2_data[? "offset_x"] = -320;
room2_data[? "offset_y"] = -296; 
transition_data[2] = room2_data;
#endregion

transition_occured = false;
transition_x = 0;
transition_y = 0;
transition_x_vel = 0;
transition_y_vel = 0;

var start_room_name = room_get_name(start_room);
if (string_copy(start_room_name, 1, 4) == "room")
{
	room_index = real(string_char_at(start_room_name, string_length(start_room_name)));
}
else room_index = -1;
room_count = array_length_1d(transition_data);
room_goto(start_room);