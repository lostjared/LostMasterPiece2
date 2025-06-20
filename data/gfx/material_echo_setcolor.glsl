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
uniform vec4 inc_valuex;

uniform float restore_black;
in float restore_black_value;

void main(void)
{
    if(restore_black_value == 1.0 && texture(textTexture, tc) == vec4(0, 0, 0, 1))
        discard;
    color = (0.5 * texture(textTexture, tc)) + (0.5 * texture(mat_textTexture, tc));
       
    vec4 orig_color = texture(textTexture, tc);
    
    vec2 tc1 = tc;
    vec2 tc2 = tc;
   
    tc1[0] = 1.0-tc1[0];
    tc2[1] = 1.0-tc2[1];

    vec4 color2 = (0.5 * texture(textTexture, tc2/2)) + (0.5 * texture(mat_textTexture, tc2/2));
    vec4 color3 = (0.5 * texture(textTexture, tc/4)) + (0.5 * texture(mat_textTexture, tc/4));
    vec4 color4 = (0.5 * texture(textTexture, tc1/8)) + (0.5 * texture(mat_textTexture, tc1/8));
    color = (color * 0.4) + (color2 * 0.4) + (color3 * 0.4) + (color4 * 0.4);
    
    color = (0.5 * orig_color) + 0.5 * color * sin(inc_valuex/255 * timeval);
}

