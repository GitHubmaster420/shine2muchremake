shader_type canvas_item;

uniform vec4 goal_1_color : source_color = vec4(0);
uniform vec4 goal_2_color : source_color = vec4(0);
uniform vec4 field_color : source_color = vec4(0, 1, 0, 1);

uniform vec4 mid_line_color : source_color;

uniform float goal_1_radius : hint_range(0.0, 0.5, 0.01) = 0.1;
uniform float goal_2_radius : hint_range(0.0, 0.5, 0.01) = 0.1;
uniform float line_thickness : hint_range(0.0, 0.25, 0.01);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (UV.y < goal_1_radius){
		COLOR = goal_1_color;
	}
	else if( 1.0 - UV.y < goal_2_radius){
		COLOR = goal_2_color;
	}

	else if (abs(UV.y - 0.5) < line_thickness){
		COLOR = mid_line_color;
	}
	else{
		COLOR = field_color;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
