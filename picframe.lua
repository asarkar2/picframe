conky.config = {
-- Conkyrc for picframe
	background = true,

	update_interval = 1,
	total_run_times = 0,
	net_avg_samples = 2,

	override_utf8_locale = true,

	double_buffer = true,
	no_buffers = true,

	text_buffer_size = 2048,
	imlib_cache_size = 0,

-- Window specifications

	own_window = true,
-- 	own_window_type = 'desktop',
-- 	own_window_type = 'normal',
	own_window_type = 'override',
	own_window_transparent = true,
	own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',

	border_inner_margin = 0,
	border_outer_margin = 0,

	minimum_width = 194, minimum_height = 170,

	alignment = bottom_right,
	gap_x = 5,
	gap_y = 25,

-- — Graphics settings — #
	draw_shades = false,
	draw_outline = false,
	draw_borders = false,
	draw_graph_borders = false,

-- — Text settings — #
	use_xft = true,
	font = 'Bitstream Vera Sans Mono:size=9',
	xftalpha = 0.8,

	default_color = '#FFFFFF',
	default_gauge_width = 47, default_gauge_height = 25,

	uppercase = false,
	use_spacer = 'right',

	color0 = 'white',
	color1 = 'orange',
	color2 = 'green',

};

conky.text = [[
${image ./pix/image.png -p 0,0 -s 194x170}

]];

