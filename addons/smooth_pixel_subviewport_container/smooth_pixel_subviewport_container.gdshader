// Implements smooth camera motion and anti-aliasing for pixel art games.

shader_type canvas_item;

/** Used for camera smoothing. Set automatically by SmoothPixelSubViewportContainer. */
uniform vec2 vertex_offset;

void vertex() {
	// Camera smoothing.
	VERTEX += vertex_offset;
}

void fragment() {
	// Pixel edge anti-aliasing.
	
	// Thanks to mortarroad for the inspiration and original shader code.
	// <https://godotshaders.com/shader/sub-pixel-accurate-pixel-sprite-filtering/>
	
	// NOTE: This relies on TEXTURE's sampling being set to LINEAR.
	
	// This math is mostly unit conversions.
	// The gist of the anti-aliasing calculation is that we calculate the
	// distance from our current pixel's (fragment's) center to the nearest texel corner.
	// Since this distance is measured in screen pixels, we can directly use it
	// as the input to a simple bilinear filter between the texels around the corner.
	
	// This could probably be optimized and refactored a bit,
	// but I like this flow for educational purposes.
	
	// The size of a pixel in UV space.
	vec2 uv_per_pixel = fwidth(UV);
	
	// The texel corner nearest to the center of the screen pixel.
	vec2 nearest_texel_corner = round(UV / TEXTURE_PIXEL_SIZE);
	
	// The above in UV space.
	vec2 nearest_texel_corner_uv = nearest_texel_corner * TEXTURE_PIXEL_SIZE;
	
	// The distance from the center of the screen pixel to the texel corner, in screen pixels.
	vec2 pixel_dist_to_nearest_texel_corner = (UV - nearest_texel_corner_uv) / uv_per_pixel;
	
	vec2 bilinear_filter_value = clamp(pixel_dist_to_nearest_texel_corner, -0.5, 0.5);
	
	// For non-edge pixels (that is, pixels which don't need to be anti-aliased),
	// bilinear_filter_value will be clamped to either -0.5 or 0.5,
	// and for edge pixels it will be within that range (-0.5 to 0.5).
	
	// If we sample at exactly nearest_texel_corner_uv, the result is an equal blend
	// of all four neighboring texels. An offset of exactly (+/-0.5, +/-0.5) will
	// result in only one texel being sampled.
	
	// Again: this relies on TEXTURE's sampling being set to LINEAR.
	
	vec2 sharp_uv = nearest_texel_corner_uv + bilinear_filter_value * TEXTURE_PIXEL_SIZE;
	
	COLOR = texture(TEXTURE, sharp_uv);
}
