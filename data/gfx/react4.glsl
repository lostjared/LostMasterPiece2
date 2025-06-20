#version 330

in vec2 tc;
out vec4 color;
uniform sampler2D textTexture;
uniform float time_f;

void main(void) {
    vec2 uv = tc - 0.5;
    float drumEffect = sin(time_f * 10.0) * 0.1;
    vec2 drumUV = uv * (1.0 + drumEffect);
    color = texture(textTexture, drumUV + 0.5);
}
