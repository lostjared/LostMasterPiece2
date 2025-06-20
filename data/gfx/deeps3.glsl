#version 330 core

out vec4 color;
in vec2 tc;

uniform sampler2D textTexture;
uniform float time_f;
uniform vec2 iResolution;

float pingPong(float x, float length) {
    float modVal = mod(x, length * 2.0);
    return modVal <= length ? modVal : length * 2.0 - modVal;
}

void main(void) {
    float angle = atan(tc.y - 0.5, tc.x - 0.5);
    float modulatedTime = pingPong(time_f, 5.0);
    angle += modulatedTime;

    vec2 rotatedTC;
    rotatedTC.x = cos(angle) * (tc.x - 0.5) - sin(angle) * (tc.y - 0.5) + 0.5;
    rotatedTC.y = sin(angle) * (tc.x - 0.5) + cos(angle) * (tc.y - 0.5) + 0.5;

    float warpFactor = sin(time_f) * 0.5 + 0.5;
    vec2 warpedCoords;
    warpedCoords.x = pingPong(rotatedTC.x + time_f * 0.1, 1.0);
    warpedCoords.y = pingPong(rotatedTC.y + time_f * 0.1, 1.0);

    vec2 warpedCoords2;
    warpedCoords2.x = pingPong(rotatedTC.x + time_f * 0.3, 1.0);
    warpedCoords2.y = pingPong(rotatedTC.y + time_f * 0.3, 1.0);

    vec2 warpedCoords3;
    warpedCoords3.x = pingPong(rotatedTC.x + time_f * 0.6, 1.0);
    warpedCoords3.y = pingPong(rotatedTC.y + time_f * 0.6, 1.0);


    color.r = texture(textTexture, warpedCoords).r;
    color.g = texture(textTexture, warpedCoords2).g;
    color.b  = texture(textTexture, warpedCoords3).b;
    color.a = 1.0;
}

