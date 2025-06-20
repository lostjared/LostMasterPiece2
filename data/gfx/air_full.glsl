#version 330

in vec2 tc;
out vec4 color;
uniform sampler2D textTexture;
uniform float time_f;

void main(void) {
    float distortionStrength = 0.02;
    float distortionFrequency = 15.0;
    float distortion1 = sin(tc.y * distortionFrequency + time_f) * distortionStrength;
    float distortion2 = cos((tc.x + tc.y) * distortionFrequency + time_f) * distortionStrength;

    vec2 distortedTC1 = tc + vec2(distortion1, distortion2);
    vec2 distortedTC2 = tc + vec2(distortion2, -distortion1);

    vec4 texColor1 = texture(textTexture, distortedTC1);
    vec4 texColor2 = texture(textTexture, distortedTC2);

    color = texColor2;
}

