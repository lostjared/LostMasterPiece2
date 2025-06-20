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

vec3 rainbow(float t) {
    return 0.5 + 0.5 * cos(PI * 2.0 * (vec3(0.0, 0.33, 0.67) + t));
}

void main() {
    float aspect = iResolution.x / iResolution.y;
    vec2 uv = tc * 2.0 - 1.0;
    uv.x *= aspect;

    float t = time_f * 0.45;

    // Morph between patterns
    float morph = fract(t / 16.0);

    // Zoom factor oscillates between 0.6 and 2.2
    float zoom = 1.4 + sin(time_f * 0.7 + sin(time_f * 0.13) * 2.0) * 0.8;
    float invZoom = 1.0 / zoom;

    // Center morph
    vec2 center = vec2(sin(t * 0.6), cos(t * 0.4)) * 0.4;

    // Mandelbrot, zoomed and centered
    vec2 mandel_uv = (uv * rot(t * 0.23)) * invZoom + center;
    float mandel = mandelbrot(mandel_uv * 1.2);

    // Julia, zoomed and centered
    vec2 julia_c = vec2(cos(t * 0.33), sin(t * 0.27)) * 0.7;
    vec2 julia_uv = (uv * rot(t * 0.11)) * invZoom + center * 1.2;
    float jul = julia(julia_uv * 1.4, julia_c);

    // Tunnel/kaleido pattern, zoomed
    float angle = atan(uv.y, uv.x) + sin(time_f * 0.25) * 0.6;
    float radius = length(uv) * (1.0 + 0.3 * sin(time_f + angle * 3.0));
    float kaleido = abs(sin(6.0 * angle + t * 1.4));
    float tunnel = sin(PI * 8.0 * (radius * invZoom) + t * 1.8 + kaleido);
    float pattern3 = mix(kaleido, tunnel, 0.5 + 0.5 * sin(t * 0.27));

    // Blending patterns
    float morphA = smoothstep(0.0, 0.33, morph);
    float morphB = smoothstep(0.33, 0.66, morph);
    float morphC = smoothstep(0.66, 1.0, morph);

    float pattern =
        mandel * (1.0 - morphA) +
        jul   * (morphA * (1.0 - morphB)) +
        pattern3 * (morphB * (1.0 - morphC)) +
        mandel * (morphC);

    // Animated kaleidoscope UVs, also zoomed
    float kalei_sides = 6.0 + 4.0 * sin(t * 0.3);
    float segment = PI * 2.0 / kalei_sides;
    float mod_angle = mod(angle, segment) - segment * 0.5;
    vec2 k_uv = vec2(cos(mod_angle), sin(mod_angle)) * (radius * invZoom);
    k_uv = rot(t * 0.16) * k_uv;

    vec2 textTextureleUV = mix(uv, k_uv, 0.7 + 0.3 * sin(t * 0.8)) * (1.1 + 0.2 * pattern);

    // Psychedelic spiral, also affected by zoom
    float spiral = sin(PI * 12.0 * (radius * invZoom) + angle * 6.0 - t * 1.2);

    vec3 tex = texture(textTexture, fract(textTextureleUV * 0.48 + t * 0.1)).rgb;
    vec3 col = rainbow(pattern + spiral * 0.4 + t * 0.25);

    // Mix for trippy look
    vec3 final = mix(tex, col, 0.6 + 0.4 * pattern);

    // Brightness pulse
    float pulse = 0.7 + 0.3 * sin(t * 2.5);
    final *= pulse;

    color = vec4(final, 1.0);
}
