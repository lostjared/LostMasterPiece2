#version 330 core
out vec4 color;
in vec2 tc;

uniform sampler2D textTexture;
uniform vec2 iResolution;
uniform float time_f;
float noise(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void main(void) {
    vec2 uv = tc;
    float time = time_f * 0.5;
    float noiseValue = noise(uv * 10.0 + time);
    vec2 heatWaveOffset = vec2(noiseValue - 0.5, 0.0) * 0.02;
    
    float time_t = mod(time_f, 10);
    vec2 nuv = uv + sin(heatWaveOffset * time_t);

    
    vec4 texColor = texture(textTexture, nuv);
    color = texColor;
}

