shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

group_uniforms Color;
uniform float brightness = 0.1;
uniform float chromatic_shift_amount : hint_range(0.0, 1.0, 0.01) = 0.2;

group_uniforms Refraction;
uniform float bend_amount : hint_range(0.0, 1.0, 0.05) = 0.4;

group_uniforms Blur;
uniform float blur_amount : hint_range(0.0, 10.0, 0.1) = 2.0;

group_uniforms Grain;
uniform float grain_amount : hint_range(0.0, 1.0, 0.05) = 0.05;

group_uniforms Light;
uniform float curve_light_blend : hint_range(0.0, 1.0, 0.05) = 0.5;
uniform float rim_light_blend : hint_range(0.0, 1.0, 0.05) = 0.8;

/**
Does not actually set the shadow color, but rather is used to exclude shadow color from stylebox from blurring
**/
uniform vec4 shadow_color : source_color;

float noise(vec2 uv){
	return fract(sin(dot(uv, vec2(9.82131, 58.234))) * 45312.1324);
}

void fragment() {
	vec2 warp_dir = UV;
	warp_dir.x = 1.0 - mix(mix(0.5, 1.0,pow(warp_dir.x, 8.0)), 0.0, pow(1.0 - warp_dir.x, 8.0));
	warp_dir.y = mix(mix(0.5, 1.0,pow(warp_dir.y, 8.0)), 0.0, pow(1.0 - warp_dir.y, 8.0));
	warp_dir = warp_dir * 2.0 - 1.0;

	vec2 warp = warp_dir * pow(COLOR.a - 0.1, 2.0)*bend_amount;
	vec2 warped_uv = SCREEN_UV / (1.0 - warp);

	vec2 chromatic_shift = warp * chromatic_shift_amount;

	vec4 screen = vec4(
		textureLod(SCREEN_TEXTURE, warped_uv + chromatic_shift, blur_amount).rg,
		textureLod(SCREEN_TEXTURE, warped_uv, blur_amount).ba
	);

	float edge_mask = COLOR.a;
	float curve_mask = clamp((edge_mask - 0.5) / (1.0 - 0.5), 0.0, 1.0);
	float curve_light = sin(curve_mask * PI) * edge_mask;
	curve_light *= 1.0 - pow(length(UV),2.0);
	curve_light = clamp(curve_light, 0.0, 1.0);
	curve_light *= curve_light_blend;

	float rim_mask = abs((UV.y + UV.x) - 1.0);
	float rim = clamp((edge_mask - 0.9) / (1.0 - 0.9), 0.0, 1.0);
	rim *= rim_light_blend;
	rim *= rim_mask;

	float grain = clamp(noise(SCREEN_UV), 0.0, 1.0);
	grain = grain * 2.0 - 1.0;
	grain = (grain * grain_amount) + 1.0;

	screen *= grain;

	if(COLOR.rgb != shadow_color.rgb){
		COLOR = screen * vec4(COLOR.rgb, 1.0) + rim + curve_light + brightness;
	}
}
