shader_type canvas_item;

uniform sampler2D palette : filter_nearest;

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	COLOR = vec4(texture(palette, vec2(c.r, 0.5)).rgb, c.a);
}
