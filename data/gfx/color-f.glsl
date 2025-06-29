#version 330 core
in vec2 tc;
out vec4 color;
uniform sampler2D textTexture;
uniform vec2 iResolution;
uniform float time_f;

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main(void) {
    vec4 ctx = texture(textTexture, tc);
    float adjusted_time = time_f * 0.1;

    float hue = mod(tc.x + adjusted_time, 1.0);
    vec3 hsvColor = vec3(hue, 1.0, 1.0);
    vec3 smoothColor = hsv2rgb(hsvColor);
    ctx.rgb = mix(ctx.rgb, smoothColor, 0.5);
    color = ctx;
}
