#version 330 core

in vec2 tc;
out vec4 color;
uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution;

//--------------------------------------------------------------------------------
// Hash + 2D noise + FBM (turbulent) functions
//--------------------------------------------------------------------------------
float hash(vec2 p) {
    // Project p into two dot‐products, then combine before fract
    p = vec2(
        dot(p, vec2(127.1, 311.7)),
        dot(p, vec2(269.5, 183.3))
    );
    float h = sin(p.x + p.y) * 43758.5453123;
    return -1.0 + 2.0 * fract(h);
}

float noise2d(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    float a = hash(i + vec2(0.0, 0.0));
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    return mix(a, b, u.x)
         + (c - a) * u.y * (1.0 - u.x)
         + (d - b) * u.x * u.y;
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
// Rotate a point around (0.5, 0.5) by angle θ
//--------------------------------------------------------------------------------
vec2 rotate_uv(vec2 uv, float angle) {
    vec2 cen = uv - vec2(0.5);
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s,
                    s,  c);
    return rot * cen + vec2(0.5);
}

//--------------------------------------------------------------------------------
// Main: boiling liquid metal with swirling FBM, rising bubbles, dynamic lighting
//--------------------------------------------------------------------------------
void main() {
    // 1) Remap tc into square‐pixel space so noise isn’t stretched
    vec2 uv = tc * iResolution.xy / min(iResolution.x, iResolution.y);

    // 2) Add a slow rotation over time to uv
    float angle = time_f * 0.1;
    vec2 uvR = rotate_uv(uv, angle);

    // 3) Compute multiple FBM layers flowing in different directions
    vec2 flow1 = uvR + vec2(time_f * 0.25, -time_f * 0.18);
    vec2 flow2 = uvR + vec2(-time_f * 0.30, time_f * 0.22);
    vec2 flow3 = uvR + vec2(time_f * 0.15, time_f * 0.15);

    float h1 = fbm(flow1 * 3.5);
    float h2 = fbm(flow2 * 5.0);
    float h3 = fbm(flow3 * 7.0);

    // Combine the layers for a more complex turbulent surface
    float height = h1 * 0.5 + h2 * 0.3 + h3 * 0.2;

    // 4) Add “bubble” disturbances rising upward over time
    float bubbleField = 0.0;
    for(int i = 0; i < 5; i++) {
        float fi = float(i);
        // Each bubble’s base center (pseudo‐randomized by hash)
        vec2 base = vec2(
            fract(hash(vec2(fi * 1.17, fi * 3.29)) * 0.5 + 0.25),
            fract(hash(vec2(fi * 2.53, fi * 7.61)) * 0.5 + 0.25)
        );
        // Move upward over time; wrap with fract so bubbles reappear
        vec2 center = fract(base + vec2(0.0, time_f * (0.1 + fi * 0.02)));

        // Radius pulsates slightly
        float radius = 0.08 + 0.02 * sin(time_f * (1.0 + fi * 0.3) + fi * 1.37);

        // Distance from uvR (use rotated coords so bubbles swirl too)
        float d = length(uvR - center);
        // Smooth edge: when d < radius => bubble contributes, else zero
        float bb = smoothstep(radius, radius - 0.02, d);
        bubbleField += bb * (0.3 + 0.2 * sin(time_f * 2.0 + fi * 2.0));
    }

    // Subtract bubbleField from height so bubbles appear as brighter “holes”/disturbances
    height -= bubbleField * 0.6;

    // 5) Estimate normals by textTextureling height at small offsets
    float e = 0.0008;
    float hx = fbm((flow1 + vec2(e, 0.0)) * 3.5) * 0.5
             + fbm((flow2 + vec2(e, 0.0)) * 5.0) * 0.3
             + fbm((flow3 + vec2(e, 0.0)) * 7.0) * 0.2
             - bubbleField * 0.6;
    float hy = fbm((flow1 + vec2(0.0, e)) * 3.5) * 0.5
             + fbm((flow2 + vec2(0.0, e)) * 5.0) * 0.3
             + fbm((flow3 + vec2(0.0, e)) * 7.0) * 0.2
             - bubbleField * 0.6;
    vec3 nrm = normalize(vec3((height - hx) / e,
                               (height - hy) / e,
                               1.0));

    // 6) Distort the original UVs for reflection based on the normal
    float distortionScale = 0.05 + 0.03 * fbm(uvR * 4.0 + vec2(time_f * 0.4));
    vec2 reflectionUV = tc + nrm.xy * distortionScale;

    // 7) textTexturele the input texture (environment) for the “metal” reflection
    vec3 env = texture(textTexture, reflectionUV).rgb;

    // 8) Dynamic lighting: rotate a light direction over time
    vec3 lightDir = normalize(vec3(
        sin(time_f * 0.3),
        0.7,
        cos(time_f * 0.4)
    ));

    // Diffuse term
    float diff = clamp(dot(nrm, lightDir), 0.0, 1.0);

    // Specular term (viewDir is (0,0,1) for a planar camera)
    vec3 viewDir = vec3(0.0, 0.0, 1.0);
    vec3 reflectDir = reflect(-lightDir, nrm);
    float spec = pow(max(dot(reflectDir, viewDir), 0.0), 64.0);

    // 9) Add a subtle rim glow when normals face sideways
    float rim = pow(1.0 - dot(nrm, viewDir), 3.0);

    // 10) Combine everything into a final “liquid metal” color
    vec3 metal = env * (0.3 + 0.7 * diff)
               + vec3(spec * 1.2)
               + vec3(rim * 0.2);

    color = vec4(sin(metal * time_f), 1.0);
}
