#version 330 core
in vec2 tc;
out vec4 color;
uniform float time_f; // time elapsed since last frame
uniform sampler2D textTexture; // texture data
uniform vec2 iResolution; // screen resolution

// Additional variables for wave generation
const float PI = 3.1415926535897932384626433832795; // pi constant
const float freq = 0.1; // frequency of waves (in radians)
const float amp = 0.1; // amplitude of waves
const float phase = 0.0; // phase offset for waves

void main() {
    // Calculate wave position based on time and frequency
    vec2 pos = tc + freq * sin(tc.x * PI / 2.0 + time_f * PI) * amp;

    // Use noise function to add more realism to waves
    float noise = snoise(pos);
    color = texture(textTexture, pos + noise);
}

