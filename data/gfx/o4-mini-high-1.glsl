#version 330 core
in vec2 tc;
out vec4 color;
uniform sampler2D textTexture;

void main(void) {
    vec3 c = texture(textTexture, tc).rgb;
    // Quantize to 3 bits red, 3 bits green, 2 bits blue (256 colors)
    c.r = floor(c.r * 7.0 + 0.5) / 7.0;
    c.g = floor(c.g * 7.0 + 0.5) / 7.0;
    c.b = floor(c.b * 3.0 + 0.5) / 3.0;
    color = vec4(c, 1.0);
}
