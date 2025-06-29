
#version 330

in vec2 tc;
out vec4 color;
uniform sampler2D textTexture;
uniform sampler2D mat_textTexture;

uniform float time_f;

void main(void) {
    float speed = 5.0;
    float amplitude = 0.03;
    float wavelength = 10.0;
    float ripple = sin(tc.x * wavelength + time_f * speed) * amplitude;
    ripple += sin(tc.y * wavelength + time_f * speed) * amplitude;
    vec2 rippleTC = tc + vec2(ripple, ripple);
    vec4 originalColor = texture(textTexture, tc);
    vec4 rippleColor = texture(mat_textTexture, rippleTC);
    color = mix(originalColor, rippleColor, 0.5);
}
