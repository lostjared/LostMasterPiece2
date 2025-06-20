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
uniform float restore_black;
in float restore_black_value;

void main(void)
{
    if(restore_black_value == 1.0 && texture(textTexture, tc) == vec4(0, 0, 0, 1))
        discard;
    color = texture(textTexture, tc);
    vec4 color2 = texture(textTexture, tc+0.01);
    vec4 color3 = texture(textTexture, tc-0.01);
    vec2 pos = tc;
    pos[0] -= 0.01;
    vec2 pos2 = tc;
    pos2[1] += 0.01;
    vec4 color4 = texture(textTexture, pos);
    vec4 color5 = texture(textTexture, pos2);
    
    color = (color + color2 + color3 + color4 + color5) / 5;
}





