#version 330 core
out vec4 color;
in vec2 tc;

uniform sampler2D textTexture;
uniform float time_f;
uniform vec2 iResolution;

vec4 distort(float time_t) {
  vec4 ctx;
  float xDistort = cos(tc.y * 10.0 + time_f) * 0.1;
    float yDistort = sin(tc.x * 10.0 + time_f) * 0.1;
    float tanDistortX = tan(tc.x * 5.0 + time_f) * 0.05;
    float tanDistortY = tan(tc.y * 5.0 + time_f) * 0.05;
    vec2 distortedTC = tc + vec2(xDistort + tanDistortX, yDistort + tanDistortY);
    distortedTC = fract(distortedTC);
    ctx = texture(textTexture, distortedTC);
    return ctx;
}

void main(void) {
      color = distort(time_f);
}
