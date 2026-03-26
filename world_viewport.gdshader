shader_type canvas_item;

uniform sampler2D tex;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = vec2(UV.x, UV.y);
	COLOR = texture(tex, uv);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
