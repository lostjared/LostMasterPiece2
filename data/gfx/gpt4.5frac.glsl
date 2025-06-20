#version 330 core

in vec2 tc;
out vec4 color;

uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution;

const int MANDALA_SIDES = 14;

void main() {
    // Centered & aspect-corrected coordinates
    vec2 uv = tc * 2.0 - 1.0;
    uv.x *= iResolution.x / iResolution.y;

    // Animation controls
    float spin = time_f * 0.65;
    float spiral = 1.0 + 0.45 * sin(time_f * 0.65);
    float stretch = 0.5 + 0.5 * cos(time_f * 0.32 + uv.y * 6.0);
    float wave = 0.08 * sin(12.0 * atan(uv.y, uv.x) + time_f * 2.0 + length(uv) * 7.0);
    float expand = 1.0 + 0.18 * sin(time_f * 1.3 + length(uv) * 6.5);
    float contract = 0.9 + 0.19 * cos(time_f * 1.9 - length(uv) * 6.5);

    // Mandala/kaleidoscope mapping with spiral/stretch/wave/expand/contract
    float r = length(uv) * expand * contract * spiral;
    float a = atan(uv.y, uv.x);

    // Apply spinning, stretching, spiraling, bending, and waving to angle and radius
    a += spin + stretch * sin(a * float(MANDALA_SIDES) + time_f * 1.4);
    r += wave;

    // Mandala mirror effect
    float seg = 2.0 * 3.14159265359 / float(MANDALA_SIDES);
    a = mod(a, seg);
    a = abs(a - seg / 2.0);

    // Final coordinates, further distort for movement
    vec2 m_uv;
    m_uv.x = r * cos(a);
    m_uv.y = r * sin(a);

    // Extra undulation for even more motion
    m_uv.x += 0.13 * sin(time_f * 1.6 + m_uv.y * 5.5);
    m_uv.y += 0.13 * cos(time_f * 1.2 + m_uv.x * 5.1);

    // Texture coordinates: tile and rotate, keeping all motion continuous
    float tex_zoom = 0.7 + 0.45 * sin(time_f * 0.8 + r * 2.1);
    vec2 tcoord = fract(m_uv * tex_zoom + 0.5 + 0.1 * spin);

    // textTexturele the original texture
    vec4 texCol = texture(textTexture, tcoord);

    // Psychedelic gradient overlay (for richness)
    float angle_norm = atan(m_uv.y, m_uv.x) / 6.2831 + 0.5;
    float rad_norm = clamp(length(m_uv), 0.0, 1.0);
    vec3 grad = 0.45 + 0.55 * cos(6.2831 * (angle_norm + vec3(0.0, 0.27, 0.59)) + time_f + rad_norm * 5.5);

    // Modulate texture color with gradient for more vivid effect
    vec3 col = grad * (0.7 + 0.7 * texCol.rgb);

    // No vignette: full-screen coverage!
    color = vec4(col, 1.0);
}
