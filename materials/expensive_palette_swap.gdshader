shader_type canvas_item;

const float EPSILON = 1.0 / 128.0;

uniform sampler2D screen_texture: hint_screen_texture;
uniform sampler2D source_palette: filter_nearest;
uniform sampler2D output_palette: filter_nearest;

void fragment() {
	vec4 c = texture(screen_texture, SCREEN_UV);
	vec3 v = c.rgb;
	int palette_width = textureSize(source_palette, 0).x;
	int id = 0;
	for (int i = 0; i < palette_width; ++i) {
		vec3 pv = texture(source_palette, vec2((float(i) + 0.5) / float(palette_width), 0.5)).rgb;
		if (length(v - pv) < EPSILON) {
			id = i;
			break;
		}
	}
	COLOR = vec4(texture(output_palette, vec2((float(id) + 0.5) / float(palette_width), 0.5)).rgb, 1.0);
}
