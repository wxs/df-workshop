// Show a very basic ray-marching on the distance field
// Modified from https://www.shadertoy.com/view/4dSBz3

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;


float sphereDF(vec3 pt, vec3 center, float radius) {
    float d = distance(pt, center) - radius;
    return d;
}

float distanceField(vec3 pt) {
    float d = sphereDF(pt, vec3(vec2(0.450,0.300),-4.776), 1.);     // sphere at (-1,0,5) with radius 1
    return d;
}

void main() {
    vec2 normalizedCoordinates = gl_FragCoord.xy/u_resolution.xy; // ((0, 1) origin at bottom left)
    normalizedCoordinates -= vec2(0.5, 0.5); // centered, (-0.5, 0.5)
    normalizedCoordinates.x *= u_resolution.x/u_resolution.y;

    vec3 rayOrigin = vec3(0, 0, 1);

    vec3 rayDirection = normalize(vec3(normalizedCoordinates, 0.) - rayOrigin);

    // March the distance field until a surface is hit.
    float distance;
    float photonPosition = 1.; // Start out (approximately) at the image plane
    float stepSizeReduction = 0.8;
    for (int i = 0; i < 256; i++) {
        distance = distanceField(rayOrigin+ rayDirection * photonPosition);
        photonPosition += distance * stepSizeReduction;
        if (distance < 0.01) break;
    }
    
    if (distance < 0.01) {
        gl_FragColor = vec4(0.8, 0.2, 0.4, 1.0);
    } else {
    	gl_FragColor = vec4(0.0, 0.0, 0.0,1.0);
    }
}


