#version 330 core
in vec2 tc;
out vec4 color;
uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution;

#define PI 3.14159265359

mat2 rot(float a) {
    float s = sin(a);
    float c = cos(a);
    return mat2(c, -s, s, c);
}

float mandelbrot(vec2 c) {
    vec2 z = c;
    float iter = 0.0, max_iter = 24.0;
    for (int i = 0; i < 24; ++i) {
        z = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y) + c;
        if (length(z) > 2.0) break;
        iter++;
    }
    return iter / max_iter;
}

float julia(vec2 z, vec2 c) {
    float iter = 0.0, max_iter = 24.0;
    for (int i = 0; i < 24; ++i) {
        z = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y) + c;
        if (length(z) > 2.0) break;
        iter++;
    }
    return iter / max_iter;
}

// Directional shifting rainbow gradient: angle (direction) changes with t
vec3 shifting_rainbow(float t, float shift, float dir) {
    // dir is a direction angle in radians; shift is the offset
    return 0.5 + 0.5 * cos(PI * 2.0 * (vec3(0.0, 0.33, 0.67) + t + shift * cos(dir)));
}

void main() {
    float aspect = iResolution.x / iResolution.y;
    vec2 uv = tc * 2.0 - 1.0;
    uv.x *= aspect;

    float t = time_f * 0.35;

    // Spin and zoom oscillate
    float spin = t * 2.0 + sin(t * 0.4) * PI;
    float zoom = 1.2 + sin(time_f * 0.6) * 0.8;

    // Fractal morphing
    float morph = fract(t / 16.0);

    // Center morph
    vec2 center = vec2(sin(t * 0.45), cos(t * 0.39)) * 0.35;

    // Spin/rotate the space
    vec2 spun_uv = rot(spin) * uv;

    // Mandelbrot, zoomed, rotated, and shifted
    vec2 mandel_uv = (spun_uv * rot(t * 0.13)) / zoom + center;
    float mandel = mandelbrot(mandel_uv * 1.3);

    // Julia, zoomed, rotated, and shifted
    vec2 julia_c = vec2(cos(t * 0.28), sin(t * 0.21)) * 0.72;
    vec2 julia_uv = (spun_uv * rot(t * 0.19)) / zoom + center * 1.08;
    float jul = julia(julia_uv * 1.15, julia_c);

    // Tunnel/kaleido pattern, zoomed and spun
    float angle = atan(spun_uv.y, spun_uv.x) + spin * 0.6;
    float radius = length(spun_uv) * (1.0 + 0.31 * sin(time_f + angle * 2.4));
    float kaleido = abs(sin(7.0 * angle + t * 1.18));
    float tunnel = sin(PI * 10.0 * (radius / zoom) + t * 1.7 + kaleido);
    float pattern3 = mix(kaleido, tunnel, 0.55 + 0.45 * sin(t * 0.37));

    // Blending between patterns
    float morphA = smoothstep(0.0, 0.33, morph);
    float morphB = smoothstep(0.33, 0.66, morph);
    float morphC = smoothstep(0.66, 1.0, morph);

    float pattern =
        mandel * (1.0 - morphA) +
        jul   * (morphA * (1.0 - morphB)) +
        pattern3 * (morphB * (1.0 - morphC)) +
        mandel * (morphC);

    // Animated kaleidoscope UVs, also zoomed and spun
    float kalei_sides = 7.0 + 3.0 * sin(t * 0.4);
    float segment = PI * 2.0 / kalei_sides;
    float mod_angle = mod(angle, segment) - segment * 0.5;
    vec2 k_uv = vec2(cos(mod_angle), sin(mod_angle)) * (radius / zoom);
    k_uv = rot(t * 0.16) * k_uv;

    // Strongly manipulated texture textTexturele (fractal warping)
    vec2 textTextureleUV = mix(spun_uv, k_uv, 0.69 + 0.31 * sin(t * 0.9)) * (1.13 + 0.17 * pattern);

    // Unwarped (original) texture textTexturele
    vec3 orig_tex = texture(textTexture, tc).rgb;

    // Warped psychedelic texture
    vec3 warped_tex = texture(textTexture, fract(textTextureleUV * 0.45 + t * 0.08)).rgb;

    // Shift the gradient direction and position as it spins/rotates
    float gradient_dir = t + sin(time_f * 0.15) * PI + angle;
    float gradient_shift = dot(spun_uv, vec2(cos(gradient_dir), sin(gradient_dir))) * 0.5 + time_f * 0.07;

    // Shifting rainbow gradient for the texture
    vec3 grad = shifting_rainbow(pattern + angle * 0.1, gradient_shift, gradient_dir);

    // Apply gradient *to* the original texture, and add a little to the warped version
    vec3 grad_orig = orig_tex * grad;
    vec3 grad_warped = warped_tex * mix(grad, vec3(1.0), 0.5 + 0.5 * sin(t * 1.5));

    // Mix: In areas where the fractal pattern is low, see more original; where high, more warped/psychedelic
    float warp_strength = pattern * 0.7 + 0.2;
    vec3 mixed = mix(grad_orig, grad_warped, warp_strength);

    // Add pulsing for that trippy feel
    float pulse = 0.7 + 0.3 * sin(time_f * 1.3 + sin(time_f * 0.27));
    mixed *= pulse;

    color = vec4(mixed, 1.0);
}
