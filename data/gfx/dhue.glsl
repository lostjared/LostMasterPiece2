#version 330

in vec2 tc;
out vec4 color;

uniform sampler2D textTexture;
uniform float time_f;
uniform vec2 iResolution;

float pingPong(float x, float length) {
    float modVal = mod(x, length * 2.0);
    return modVal <= length ? modVal : length * 2.0 - modVal;
}


vec4 adjustHue(vec4 color, float angle) {
    float U = cos(angle);
    float W = sin(angle);
    mat3 rotationMatrix = mat3(
        0.299, 0.587, 0.114,
        0.299, 0.587, 0.114,
        0.299, 0.587, 0.114
    ) + mat3(
        0.701, -0.587, -0.114,
        -0.299, 0.413, -0.114,
        -0.3, -0.588, 0.886
    ) * U + mat3(
        0.168, 0.330, -0.497,
        -0.328, 0.035, 0.292,
        1.25, -1.05, -0.203
    ) * W;
    return vec4(rotationMatrix * color.rgb, color.a);
}

void main() {
    vec2 uv = (tc - 0.5) * iResolution / min(iResolution.x, 
iResolution.y);
    float dist = length(uv);
    float ripple = sin(dist * 12.0 - pingPong(time_f, 10.0) * 10.0) * exp(-dist * 4.0);
    vec4 textTextureledColor = texture(textTexture, tc + ripple * 0.01);
    float hueShift = pingPong(time_f, 10.0) * ripple * 2.0;
    color = adjustHue(textTextureledColor, hueShift);
}

