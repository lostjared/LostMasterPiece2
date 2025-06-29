#version 330 core
in vec2 tc;
out vec4 color;
uniform sampler2D textTexture;
uniform float time_f;

float pingPong(float x, float length) {
    float modVal = mod(x, length * 2.0);
    return modVal <= length ? modVal : length * 2.0 - modVal;
}

void main(void)
{
    color = texture(textTexture, tc);
    vec4 color2 = texture(textTexture, tc / 2);
    vec4 color3 = texture(textTexture, tc / 4);
    vec4 color4 = texture(textTexture, tc / 8);
    color = (color * 0.4) + (color2 * 0.4) + (color3 * 0.4) + (color4 * 0.4);
    
    float time_t = pingPong(time_f, 10.0) + 2.0;
    color = sin(color * time_t);
    color.a = 1.0;
}
