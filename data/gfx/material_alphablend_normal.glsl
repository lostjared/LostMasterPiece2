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


void main(void)
{
    color = texture(textTexture, tc);
    vec4 color2;
    color2 = texture(mat_textTexture, tc);
    color = ((0.5 * color) + (0.5 * color2))*alpha;
    ivec4 colori = ivec4(color * 255);
    for(int i = 0; i < 3; ++i) {
        if(colori[i] > 255)
            colori[i] = colori[i]%255;
        color[i] = float(colori[i]) / 255;
    }
}





