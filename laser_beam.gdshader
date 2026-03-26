shader_type canvas_item;

uniform vec3 A;
uniform vec3 B;

uniform float cosRadius = 0.2;

uniform vec3 color : source_color = vec3(1, 0, 0);

uniform bool wrap_around = false;

uniform float alpha_m = 1.0;

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

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {

	vec3 N = normalize(cross(A, B));

	vec2 uv_local = UV - vec2(0.5);
	uv_local = vec2(-uv_local.y, uv_local.x);
	if (length(uv_local) > 0.5){
		discard;
	}
	vec3 C = circle_to_sphere(uv_local);
	vec3 Cproj = normalize(C - N * dot(C, N));
	float side1 = dot(cross(A, Cproj), N);
	float side2 = dot(cross(Cproj, B), N);

	// inside arc if both >= 0
	float inside = step(0.0, side1) * step(0.0, side2);

	if(wrap_around){
		inside = 1.0 - inside;
	}

	float dA = dot(C, A);
	float dB = dot(C, B);
	vec3 Pend = mix(B, A, step(dB, dA)); // pick closer endpoint

	vec3 P = normalize(mix(Pend, Cproj, inside));

	float d = dot(C, P);

	float hit = step(cosRadius, d);

	COLOR.a *= hit * alpha_m;
	COLOR.rgb = color;

}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
