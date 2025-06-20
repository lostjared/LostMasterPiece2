#version 330 core
in vec2 tc;
out vec4 color;
uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution;

void main(void) {
    // Create a wave-like distortion using sine functions
    float waveX = sin(time_f * 0.5 + tc.x * 3.0) * 0.05;
    float waveY = sin(time_f * 0.5 + tc.y * 3.0) * 0.05;
    vec2 displacedTC = tc + vec2(sin(waveX * time_f), sin(waveY * time_f));

    // textTexturele the texture with the distorted coordinates
    vec4 texColor = texture(textTexture, displacedTC);

    // Apply a blue water tint and subtle transparency
    vec3 waterTint = vec3(0.0, 0.2, 0.4);
    color = texColor * (1.0 - 0.3 * sin(time_f * 0.5)) + vec4(waterTint, 1.0) * 0.3;
}
