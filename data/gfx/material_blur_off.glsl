#version 330
in vec2 tc;
out vec4 color;
uniform float alpha_r;
uniform float alpha_g;
uniform float alpha_b;
in float current_index;
in float timeval;
uniform float alpha;
in vec3 vpos;
in vec4 optx_val;
uniform vec4 optx;
in vec4 random_value;
uniform vec4 random_var;
uniform float alpha_value;
uniform mat4 mv_matrix;
uniform mat4 proj_matrix;
uniform sampler2D textTexture;
uniform sampler2D mat_textTexture;

uniform float value_alpha_r, value_alpha_g, value_alpha_b;
uniform float index_value;
uniform float time_f;
in vec2 iResolution_;
uniform vec2 iResolution;
uniform float restore_black;
in float restore_black_value;
uniform vec4 inc_value;

float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

void main(void)
{
    if(restore_black_value == 1.0 && texture(textTexture, tc) == vec4(0, 0, 0, 1))
        discard;
    color = texture(textTexture, tc);
    vec4 color2,color3,color4;
    color2 = texture(mat_textTexture, tc);
    vec2 pos1 = tc;
    vec2 pos2 = tc;
    
    pos1[0] -= 0.01;
    pos2[0] += 0.01;
    
    color3 = texture(textTexture, pos1);
    color4 = texture(mat_textTexture, pos2);
    
    color = (0.3 * color) + (0.3 * color2) + (0.3 * color3) + (0.3 * color4);
    
    
}
