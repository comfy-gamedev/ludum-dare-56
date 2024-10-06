shader_type canvas_item;

const float EPSILON = 1.0 / 128.0;

uniform float lower_bound = 0.0;
uniform sampler2D screen_texture: hint_screen_texture;
uniform sampler2D output_palettes[4]: filter_nearest;
uniform sampler2D lightmap: filter_nearest;

void fragment() {
	float l = texture(lightmap, SCREEN_UV).a;
	int pal = int(clamp(mix(lower_bound, 1.0, l) * 4.0, 0.0, 3.0));
	vec4 c = texture(screen_texture, SCREEN_UV);
	vec3 v = c.rgb;
	int palette_width = textureSize(output_palettes[3], 0).x;
	int id = 0;
	for (int i = 0; i < palette_width; ++i) {
		vec3 pv = texture(output_palettes[3], vec2((float(i) + 0.5) / float(palette_width), 0.5)).rgb;
		if (length(v - pv) < EPSILON) {
			id = i;
			break;
		}
	}
	vec2 uv = vec2((float(id) + 0.5) / float(palette_width), 0.5);
	if (pal == 0) {
		COLOR = vec4(texture(output_palettes[0], uv).rgb, 1.0);
	} else if (pal == 1) {
		COLOR = vec4(texture(output_palettes[1], uv).rgb, 1.0);
	} else if (pal == 2) {
		COLOR = vec4(texture(output_palettes[2], uv).rgb, 1.0);
	} else {
		COLOR = vec4(texture(output_palettes[3], vec2((float(id) + 0.5) / float(palette_width), 0.5)).rgb, 1.0);
	}
}
