#version 330 core

in vec2 tc;
out vec4 color;
uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution;

//--------------------------------------------------------------------------------
// Hash → 2D noise → FBM (turbulent) functions
//--------------------------------------------------------------------------------
float hash(vec2 p) {
    p = vec2(
        dot(p, vec2(127.1, 311.7)),
        dot(p, vec2(269.5, 183.3))
    );
    return fract(sin(p.x + p.y) * 43758.5453123);
}

float noise2d(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    float a = hash(i + vec2(0.0, 0.0));
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    return mix(
        mix(a, b, u.x),
        mix(c, d, u.x),
        u.y
    );
}

float fbm(vec2 p) {
    float v = 0.0;
    float amplitude = 0.5;
    for(int i = 0; i < 6; i++) {
        v += amplitude * noise2d(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return v;
}

//--------------------------------------------------------------------------------
// Rotate a 2D coordinate around (0.5, 0.5) by angle a
//--------------------------------------------------------------------------------
vec2 rotate(vec2 uv, float a) {
    float s = sin(a);
    float c = cos(a);
    mat2 m = mat2(c, -s,
                  s,  c);
    return m * (uv - vec2(0.5)) + vec2(0.5);
}

//--------------------------------------------------------------------------------
// CORRECTED PALETTE: returns vec3
// Maps a single scalar t to an RGB triplet via cosine waves.
//--------------------------------------------------------------------------------
vec3 palette(float t) {
    return 0.5 + 0.5 * cos(6.2831 * (t + vec3(0.0, 0.33, 0.67)));
}

//--------------------------------------------------------------------------------
// Procedural background: swirling FBM‐based color field
//--------------------------------------------------------------------------------
vec3 getBackground(vec2 uv) {
    vec2 q = uv * 2.0 - 1.0;
    float a = atan(q.y, q.x);
    float r = length(q);
    float v = fbm(vec2(r * 3.0, a * 3.0 - time_f * 0.5));
    return palette(v);
}

//--------------------------------------------------------------------------------
// Cellular (Worley) noise for neon‐edge effect
//--------------------------------------------------------------------------------
float cellular(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float m = 1.0;
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 g = vec2(float(x), float(y));
            vec2 o = vec2(hash(i + g), hash(i + g * 2.0));
            vec2 r = g + o - f;
            m = min(m, dot(r, r));
        }
    }
    return sqrt(m);
}

//--------------------------------------------------------------------------------
// Neon‐style edge glow using cellular noise
//--------------------------------------------------------------------------------
vec3 neonEdges(vec2 uv) {
    float e = cellular(uv * 5.0 + time_f * 0.1);
    float glow = 1.0 - smoothstep(0.0, 0.5, e);
    return vec3(glow, 0.5 * glow, glow * 0.2);
}

//--------------------------------------------------------------------------------
// Chromatic aberration by offsetting R/G/B lookups over time
//--------------------------------------------------------------------------------
vec3 chromaticAberration(vec2 uv) {
    float ca = 0.005;
    float tR = time_f * 0.05;
    vec2 oR = uv + vec2(sin(tR) * ca, cos(tR) * ca);
    vec2 oG = uv;
    vec2 oB = uv - vec2(sin(tR) * ca, cos(tR) * ca);
    vec3 cR = texture(textTexture, oR).rgb;
    vec3 cG = texture(textTexture, oG).rgb;
    vec3 cB = texture(textTexture, oB).rgb;
    return vec3(cR.r, cG.g, cB.b);
}

//--------------------------------------------------------------------------------
// A simple “glitch” layer that shifts scanlines with chromatic aberration
//--------------------------------------------------------------------------------
vec3 glitchLayer(vec2 uv) {
    float t = time_f * 0.5;
    float yOffset = sin(uv.y * 10.0 + t * 5.0) * 0.02;
    vec2 uv1 = uv + vec2(0.0, yOffset);
    vec3 c = chromaticAberration(uv1);
    return c * 0.8;
}

//--------------------------------------------------------------------------------
// Main “image” function: swirling FBM + bubbles + neon edges + glitch + vignette
//--------------------------------------------------------------------------------
void mainImage(out vec4 fragColor, vec2 fragCoord) {
    // Normalize coordinates (0..1)
    vec2 uv = fragCoord / iResolution;

    // 1) Base procedural background
    vec3 base = getBackground(uv);

    // 2) Add a swirling FBM overlay
    vec3 swirl = palette(fbm(uv * 4.0 - time_f * 0.2));
    base = mix(base, swirl, 0.2);

    // 3) Rising “bubbles” that swirl and pulse
    vec3 bubbles = vec3(0.0);
    for (int i = 0; i < 3; i++) {
        float fi = float(i);
        vec2 c = vec2(
            fract(hash(vec2(fi * 3.0, fi * 2.0))),
            fract(hash(vec2(fi * 5.0, fi * 7.0)))
        );
        // Move bubble upward over time
        vec2 cp = c + vec2(0.0, -time_f * (0.1 + fi * 0.02));
        // Rotate bubble centers to make them swirl
        cp = rotate(cp, -time_f * (0.15 + fi * 0.05));
        float d = length(uv - cp);
        // Radius of each bubble pulsates
        float r = 0.1 + 0.04 * cos(time_f * (1.5 + fi * 0.5) + fi * 2.2);
        float f = smoothstep(r, r - 0.015, d);
        bubbles += vec3(0.8, 0.9, 1.0) * f;
    }
    base += bubbles * 0.5;

    // 4) Add neon edge glow
    vec3 neon = neonEdges(uv);

    // 5) Add glitch layer on top
    vec3 glitch = glitchLayer(uv);

    // 6) Final composite: mix everything
    vec3 post = base * 0.9 + neon * 0.5 + glitch * 0.3;

    // 7) Vignette to darken edges
    float vignette = 1.0 - smoothstep(0.5, 0.8, length(uv - vec2(0.5)));
    post *= vignette;

    // 8) Gamma correction / tone‐mapping (gamma ≈ 2.2)
    fragColor = vec4(pow(post, vec3(0.4545)), 1.0);
}

//--------------------------------------------------------------------------------
// Standard OpenGL entry point: call mainImage() with proper fragCoord
//--------------------------------------------------------------------------------
void main() {
    mainImage(color, tc * iResolution);
}
