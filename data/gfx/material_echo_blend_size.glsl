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
in vec2 iResolution_;
uniform mat4 mv_matrix;
uniform mat4 proj_matrix;
uniform sampler2D textTexture;
uniform sampler2D mat_textTexture;
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
    vec4 color2, color3, color4, color5;
    vec2 st = gl_FragCoord.xy;
    color2 = texture(mat_textTexture, tc/3);
    color3 = texture(mat_textTexture, tc/4);
     vec2 coord = gl_FragCoord.xy / iResolution_.xy;
    float valueY = coord.y * 0.4;
    float valueX = coord.x * 0.4;
    color4 = texture(textTexture, tc/2);
    color = ((color+color4) * 0.5) + (color2 * valueY) + (color3 * (-valueY));
}















