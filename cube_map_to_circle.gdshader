shader_type canvas_item;

uniform sampler2D front_view;
uniform sampler2D right_view;
uniform sampler2D back_view;
uniform sampler2D left_view;
uniform sampler2D top_view;
uniform sampler2D bottom_view;

const vec3 RIGHT = vec3(1, 0, 0);
const vec3 LEFT  = vec3(-1, 0, 0);
const vec3 UP    = vec3(0, 1, 0);
const vec3 DOWN  = vec3(0, -1, 0);
const vec3 FORWARD = vec3(0, 0, -1);
const vec3 BACK    = vec3(0, 0, 1);

vec3 rotate_around_axis(vec3 v, vec3 axis, float angle) {
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;

    return v * c +
           cross(axis, v) * s +
           axis * dot(axis, v) * oc;
}

vec3 circle_to_sphere(vec2 circle_uv){
	float alpha = atan(circle_uv.y, circle_uv.x);

	float circle_radius = 0.5;
	float d = length(circle_uv) / circle_radius * PI;

	vec3 rotate_around = vec3(cos(alpha), sin(alpha), 0);
	vec3 vector_to_rotate = vec3(0, 0, 1);

	vec3 rotated = rotate_around_axis(vector_to_rotate, rotate_around, d);

	return rotated;
}

vec2 sphere_to_local_uv(){
	return vec2(0);
}

void fragment() {
	vec2 uv_local = UV - vec2(0.5);
	uv_local = vec2(-uv_local.y, uv_local.x);
	if (length(uv_local) > 0.5){
		discard;
	}
	vec3 surface_location = circle_to_sphere(uv_local);
	vec3 a = surface_location;
vec3 abs_a = abs(a);

vec2 uv;
vec3 face;

if (abs_a.z >= abs_a.x && abs_a.z >= abs_a.y) {
    // FRONT / BACK
    if (a.z > 0.0) {
        // BACK
        uv = a.xy / abs_a.z;
        COLOR = texture(back_view, uv * 0.5 + 0.5);
    } else {
        // FRONT
        uv = vec2(-a.x, a.y) / abs_a.z;
        COLOR = texture(front_view, uv * 0.5 + 0.5);
    }

	} else if (abs_a.x >= abs_a.y) {
	    // LEFT / RIGHT
	    if (a.x > 0.0) {
	        // RIGHT
	        uv = vec2(a.z, a.y) / abs_a.x;
	        COLOR = texture(right_view, uv * 0.5 + 0.5);
	    } else {
	        // LEFT
	        uv = vec2(-a.z, a.y) / abs_a.x;
	        COLOR = texture(left_view, uv * 0.5 + 0.5);
	    }

	} else {
	    // TOP / BOTTOM
	    if (a.y > 0.0) {
	        // TOP
	        uv = vec2(a.x, -a.z) / abs_a.y;
	        COLOR = texture(top_view, uv * 0.5 + 0.5);
	    } else {
	        // BOTTOM
	        uv = vec2(a.x, a.z) / abs_a.y;
	        COLOR = texture(bottom_view, uv * 0.5 + 0.5);
	    }
	}

}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
