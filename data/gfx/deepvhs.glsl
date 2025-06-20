#version 330 core

in vec2 tc;
out vec4 color;

uniform float time_f;
uniform sampler2D textTexture;
uniform vec2 iResolution;

vec4 scanlineEffect(vec4 baseColor, vec2 uv) {
    // More subtle scanlines
    float y = uv.y * iResolution.y;
    float scan = abs(sin(y * 3.14159 * 0.5 + time_f * 5.0));
    float factor = 0.95 + 0.05 * scan;
    return vec4(baseColor.rgb * factor, baseColor.a);
}

vec4 vhsEffect(sampler2D tex, vec2 uv) {
    // Start with original color
    vec4 original = texture(tex, uv);
    
    // Mild RGB separation
    float offset = 0.003;
    vec4 shifted = vec4(
        texture(tex, uv + vec2(offset, 0.0)).r,
        original.g,
        texture(tex, uv - vec2(offset, 0.0)).b,
        original.a
    );
    
    // Blend with original (keep 80% original)
    vec4 result = mix(original, shifted, 0.2);
    
    // Very subtle tracking effect
    float shiftAmount = sin(uv.y * 10.0 + time_f * 2.0) * 0.003;
    vec4 tracked = texture(tex, uv + vec2(shiftAmount, 0.0));
    
    // Minimal blending with tracking effect
    return mix(result, tracked, 0.1);
}

void main() {
    // Normalize coordinates properly
    vec2 uv = tc / iResolution.xy;
    
    // Get original texture
    vec4 base = texture(textTexture, uv);
    
    // Apply mild VHS effect
    vec4 vhs = vhsEffect(textTexture, uv);
    
    // Apply scanlines
    vec4 final = scanlineEffect(vhs, uv);
    
    // Preserve original details (80% effect, 20% original)
    color = mix(base, final, 0.8);
}