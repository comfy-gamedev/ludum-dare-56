shader_type canvas_item;

global uniform sampler2D dither_matrix : filter_nearest, repeat_enable;
uniform sampler2D palette : filter_nearest;

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	float d = texture(dither_matrix, SCREEN_UV / SCREEN_PIXEL_SIZE / vec2(textureSize(dither_matrix, 0))).r;
	if (c.a < d) discard;
	COLOR = vec4(texture(palette, vec2(c.r, 0.5)).rgb, 1.0);
}
