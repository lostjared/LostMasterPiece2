#version 330 core
out vec4 color;
in vec2 tc;

uniform sampler2D textTexture;
uniform vec2 iResolution;

void main() {
    vec2 uv = tc;
    if (uv.x < 0.5) {
        uv.x = 1.0 - uv.x;
    }
    color = texture(textTexture, uv);
}
