#version 330 core
in vec2 tc;
out vec4 color;
uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution;

void main(void) {
    // normalize to [-1,1] with aspect correction
    vec2 uv = tc * 2.0 - 1.0;
    uv.x *= iResolution.x / iResolution.y;
    
    // compute radius for radial effects
    float r = length(uv);
    
    // barrel distortion strength oscillates over time
    float k = 0.3 + 0.2 * sin(time_f * 0.5);
    uv *= 1.0 + k * r * r;
    
    // apply a rotating twist that grows with radius
    float a = time_f + r * 5.0;
    mat2 m = mat2(cos(a), -sin(a), sin(a), cos(a));
    uv = m * uv;
    
    // map back to [0,1]
    vec2 finalUV = uv;
    finalUV.x *= iResolution.y / iResolution.x;
    finalUV = finalUV * 0.5 + 0.5;
    
    color = texture(textTexture, finalUV);
}
