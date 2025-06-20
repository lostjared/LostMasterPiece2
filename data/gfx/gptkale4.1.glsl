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

vec3 shifting_rainbow(float t, float shift, float dir) {
    return 0.5 + 0.5 * cos(PI * 2.0 * (vec3(0.0, 0.33, 0.67) + t + shift * cos(dir)));
}

void main() {
    float aspect = iResolution.x / iResolution.y;
    vec2 uv = tc * 2.0 - 1.0;
    uv.x *= aspect;

    float t = time_f * 0.35;

    // Animation controls
    float spin = t * 2.0 + sin(t * 0.4) * PI;
    float zoom = 1.2 + sin(time_f * 0.6) * 0.8;

    // Number of kaleidoscopic segments morphs between 5 and 12
    float kalei_sides = 5.0 + 7.0 * (0.5 + 0.5 * sin(time_f * 0.23));
    float angle = atan(uv.y, uv.x) + spin;
    float radius = length(uv) / zoom;

    // Kaleidoscope mapping: fold the angle into one segment, mirror if needed
    float seg = PI * 2.0 / kalei_sides;
    float folded_angle = mod(angle, seg);
    float mirrored = mod(floor(angle / seg), 2.0);
    folded_angle = mirrored > 0.5 ? seg - folded_angle : folded_angle;

    // Reconstruct scattered coordinates
    vec2 kalei_uv = vec2(cos(folded_angle), sin(folded_angle)) * radius;
    kalei_uv = rot(spin * 0.2) * kalei_uv; // slow extra spin

    // Convert back to normalized texture coordinates
    vec2 scattered_tc = (kalei_uv / aspect) * 0.5 + 0.5;

    // Optional: clamp to avoid textTextureling outside (or wrap for infinite mirror)
    scattered_tc = fract(scattered_tc);

    // textTexturele the scattered original texture
    vec3 scattered_tex = texture(textTexture, scattered_tc).rgb;

    // Shifting, spinning rainbow gradient
    float gradient_dir = t + sin(time_f * 0.15) * PI + angle;
    float gradient_shift = dot(kalei_uv, vec2(cos(gradient_dir), sin(gradient_dir))) * 0.6 + time_f * 0.1;
    vec3 grad = shifting_rainbow(angle * 0.12 + radius * 0.3 + time_f * 0.22, gradient_shift, gradient_dir);

    // Overlay gradient onto the kaleidoscopic image
    vec3 final = scattered_tex * grad * (0.85 + 0.25 * sin(time_f * 0.37 + radius * 4.0));

    // Add pulsing
    float pulse = 0.7 + 0.3 * sin(time_f * 1.5 + radius * 8.0);
    final *= pulse;

    color = vec4(final, 1.0);
}
