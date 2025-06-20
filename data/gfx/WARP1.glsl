#version 330 core
in vec2 tc;
out vec4 color;
uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution;
void main(void) {
    // Distort the texture coordinates along the x-axis
    vec2 distortedCoords = vec2(sin(tc.x * 0.1 + time_f), tc.y);
    color = texture(textTexture, distortedCoords);
}
