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
uniform vec4 inc_valuex;
uniform vec4 inc_value;


uniform float restore_black;
in float restore_black_value;

void main(void)
{
    if(restore_black_value == 1.0 && texture(textTexture, tc) == vec4(0, 0, 0, 1))
        discard;
    color = texture(textTexture, tc);
    vec4 color2 = texture(textTexture, tc / 2);
    vec2 pos1 = tc;
    vec2 pos2 = tc;
    vec4 iv1 = inc_valuex/255;
    vec4 iv2 = inc_value/255;
    pos1[0] - iv1[0]-pos1[0];
    pos1[1] = iv1[1]-pos1[1];
    pos2[0] = iv2[0]-pos2[0];
    pos2[1] = iv2[1]-pos2[1];
    vec4 color3 = texture(textTexture, (pos1/4)*0.9);
    vec4 color4 = texture(textTexture, (pos2/8)*0.9);
    color = (color * 0.4) + (color2 * 0.4) + (color3 * 0.4) + (color4 * 0.4) ;
}




