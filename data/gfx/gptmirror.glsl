#version 330 core

in vec2 tc;
out vec4 color;
uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution;

// 2D hash returning [0,1)
float hash(vec2 p) {
    p = vec2(dot(p, vec2(127.1, 311.7)),
             dot(p, vec2(269.5, 183.3)));
    return fract(sin(p.x + p.y) * 43758.5453123);
}

void main() {
    // Number of tiles along each axis
    const float TILES = 8.0;

    // Scale UV to tile grid
    vec2 coord = tc * TILES;
    vec2 cell_f = floor(coord);
    vec2 f = fract(coord);

    // Create a time‐varying seed per cell
    float t = floor(time_f * 0.5);
    float h = hash(cell_f + vec2(t, t * 1.37));

    // Determine mirror pattern from h in [0,1)
    //   [0, 0.25): mirror X
    //   [0.25, 0.5): mirror Y
    //   [0.5, 0.75): mirror both
    //   [0.75, 1.0): no mirror
    float mode = floor(h * 4.0);

    if (mode < 1.0) {
        f.x = 1.0 - f.x;
    } else if (mode < 2.0) {
        f.y = 1.0 - f.y;
    } else if (mode < 3.0) {
        f = vec2(1.0 - f.x, 1.0 - f.y);
    }

    // Optional jitter in tile index to avoid grid‐aligned look
    // Compute two separate hash values for x and y jitter:
    float hx = hash(cell_f * 1.93 + vec2(t, t + 1.0));
    float hy = hash(cell_f * 2.17 + vec2(t + 2.0, t + 3.0));
    vec2 jitter = (vec2(hx, hy) - 0.5) * 0.3;
    vec2 cell = cell_f + jitter;

    // Reconstruct mirrored UV
    vec2 mirroredUV = (cell + f) / TILES;

    // Add a slow global rotation to the entire UV space for extra psychedelia
    float angle = time_f * 0.1;
    vec2 center = vec2(0.5, 0.5);
    vec2 uv = mirroredUV - center;
    float s = sin(angle);
    float c = cos(angle);
    uv = mat2(c, -s, s, c) * uv;
    uv += center;

    // Wrap UV to [0,1]
    uv = fract(uv);

    // textTexturele the texture
    vec3 col = texture(textTexture, uv).rgb;

    // Apply a simple color shift per mode for extra effect
    if (mode < 1.0) {
        col.rgb = col.bgr; // swap channels
    } else if (mode < 2.0) {
        col.rgb = vec3(col.g, col.b, col.r);
    } else if (mode < 3.0) {
        col.rgb = vec3(1.0) - col; // invert
    }

    color = vec4(col, 1.0);
}
