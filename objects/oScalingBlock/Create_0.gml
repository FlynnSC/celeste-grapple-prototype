event_inherited();

activation_waiting_frames = 2;
deactivation_waiting_frames = 65;

half_width = (bbox_right - bbox_left + 1) / 2;
half_height = (bbox_bottom - bbox_top + 1) / 2;
base_x_scale = image_xscale;
base_y_scale = image_yscale;
max_x_scale = x_scale_multiple * base_x_scale;
max_y_scale = y_scale_multiple * base_y_scale;
//scaling_frames = 7;
//x_scaling_speed = (max_x_scale - base_x_scale) / scaling_frames;
//y_scaling_speed = (max_y_scale - base_y_scale) / scaling_frames;

translation_x_dir = 0;
translation_y_dir = 0;

scaling_rate = 0.15;
scaling_val = 0;

if (x_scale_multiple > 1)
{
	if (y_scale_multiple > 1) symbol_sprite = sScalingBlockSymbol;
	else symbol_sprite = sScalingBlockSymbolHorizontal;
}
else symbol_sprite = sScalingBlockSymbolVertical;