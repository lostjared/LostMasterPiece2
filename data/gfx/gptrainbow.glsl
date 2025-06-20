#version 330 core
in vec2 tc;
out vec4 color;
uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution;

#define PI 3.14159265359

vec3 shifting_rainbow(float t, float offset, float angle) {
    float phase = t + offset * cos(angle) + offset * sin(angle);
    return 0.5 + 0.5 * cos(PI * 2.0 * (vec3(0.0, 0.33, 0.67) + phase));
}

// Lift black toward gray and boost overall brightness
vec3 brighten(vec3 c, float lift, float gamma, float boost) {
    // lift moves black up (toward gray)
    c = mix(vec3(lift), c, 0.95);
    // boost overall brightness
    c *= boost;
    // apply a gentle gamma correction for even more brightness in shadows
    c = pow(c, vec3(gamma));
    return clamp(c, 0.0, 1.0);
}

void main() {
    float aspect = iResolution.x / iResolution.y;
    vec2 uv = tc * 2.0 - 1.0;
    uv.x *= aspect;

    float t = time_f * 0.23;
    float angle = t + 2.0 * sin(time_f * 0.17);
    float offset = dot(uv, vec2(cos(angle), sin(angle)));

    // Get original image, brighten and lift black
    vec3 orig = texture(textTexture, tc).rgb;
    orig = brighten(orig, 0.32, 0.8, 1.6);  // lift, gamma, boost

    // Make a shifting rainbow gradient
    vec3 grad = shifting_rainbow(time_f * 0.12, offset, angle);

    // Multiply original (now brightened) by gradient
    vec3 final = orig * grad * (1.1 + 0.22 * sin(time_f * 0.5 + offset * 4.0));

    color = vec4(final, 1.0);
}
