#version 330 core

in vec2 tc;
out vec4 color;
uniform sampler2D textTexture;

void main(void) {
    color = texture(textTexture, tc);
}

