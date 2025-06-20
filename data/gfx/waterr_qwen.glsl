#version 330 core
in vec2 tc;
out vec4 color;
uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution;

void main(void) {
    // Distort texture coordinates with a sine wave for water-like ripples
    vec2 distortedTC = tc + vec2(
        sin(time_f * 2.0 + tc.x * 10.0) * 0.05,
        sin(time_f * 3.0 + tc.y * 15.0) * 0.03
    );

    // textTexturele the distorted texture
    vec4 texColor = texture(textTexture, distortedTC);

    // Apply a water-like color tint (blueish hue)
    color = texColor * vec4(0.5, 0.7, 1.0, 1.0);
}
