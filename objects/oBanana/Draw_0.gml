draw_self();

if (active)
{
	gpu_set_blendmode(bm_add);
	draw_circle_color(x-1, y-1, 9, make_color_rgb(80, 80, 0), make_color_rgb(0, 0, 0), false);
	gpu_set_blendmode(bm_normal);
}

