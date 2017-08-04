// Title: Showing some use of sinusoids

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

void main() {
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st.x *= u_resolution.x/u_resolution.y;

    vec3 color = vec3(0.);
    color = vec3(st.x,abs(sin(st.y * 22.424 * 3.776 + st.x * 30. * 0.976 + st.x*st.y*20.152*5.*sin(u_time))),abs(sin(u_time + u_mouse.x/u_resolution.x)));

    gl_FragColor = vec4(color,1.0);
}


