// Now, colour by normals

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
    float d = sphereDF(pt, vec3(vec2(-0.010,0.020),-5.792), 1.);     // sphere at (-1,0,5) with radius 1
    return d;
}

vec3 calculateNormal(in vec3 pt) {
    vec2 eps = vec2(1.0, -1.0) * 0.0005;
    return normalize(eps.xyy * distanceField(pt + eps.xyy) +
                     eps.yyx * distanceField(pt + eps.yyx) +
                     eps.yxy * distanceField(pt + eps.yxy) +
                     eps.xxx * distanceField(pt + eps.xxx));
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
        distance = distanceField(rayOrigin + rayDirection * photonPosition);
        photonPosition += distance * stepSizeReduction;
        if (distance < 0.01) break;
    }
    
    if (distance < 0.01) {
        vec3 intersectionNormal = calculateNormal(rayOrigin + rayDirection * photonPosition);
        float x = intersectionNormal.x * 0.5 + 0.5;
        float y = intersectionNormal.y * -.5 + 0.5;
        gl_FragColor = vec4(x, y, 1.0,1.000);
    } else {
    	gl_FragColor = vec4(0.112,0.695,0.395,1.000);
    }
}


