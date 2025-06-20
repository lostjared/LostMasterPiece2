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
uniform float value_alpha_r, value_alpha_g, value_alpha_b;
uniform float index_value;
uniform float time_f;
uniform vec4 inc_value;

uniform float restore_black;
in float restore_black_value;

void main(void)
{
    if(restore_black_value == 1.0 && texture(textTexture, tc) == vec4(0, 0, 0, 1))
        discard;
    
    color = texture(textTexture, tc);
    ivec4 source = ivec4(255 * color);
    vec2 vpos;
    vpos[0] = 1.0-tc[0];
    vpos[1] = tc[1];
    vec4 color2 = texture(textTexture, vpos);
    color = (0.5 * color) + (0.5 * color2);
    vec4 color2x = texture(textTexture, tc / 2);
    color2x[0] = 1.0;
    vec4 color3 = texture(textTexture, tc/ 4);
    color3[1] = 1.0;
    vec4 color4 = texture(textTexture, tc/ 8);
    color4[2] = 1.0;
    color = (color * 0.3) + (color2x * 0.3) + (color3 * 0.3) + (color4 * 0.3) ;
}




