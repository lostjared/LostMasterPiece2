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

uniform float restore_black;
in float restore_black_value;
in vec2 iResolution_;

vec4 xor_RGB(vec4 icolor, ivec4 isource) {
    ivec3 int_color;
    for(int i = 0; i < 3; ++i) {
        int_color[i] = int(255 * icolor[i]);
        int_color[i] = int_color[i]^isource[i];
        if(int_color[i] > 255)
            int_color[i] = int_color[i]%255;
        icolor[i] = float(int_color[i])/255;
    }
    icolor.a = 1.0;
return icolor;
}



void main(void)
{
    if(restore_black_value == 1.0 && texture(textTexture, tc) == vec4(0, 0, 0, 1))
        discard;
    color = texture(textTexture, tc);
    vec2 pos = gl_FragCoord.xy/iResolution_.xy;
    vec2 vpos = 1.0-tc;
    vec4 color2 = texture(textTexture, vpos);
    vec4 color3 = texture(mat_textTexture, tc);
    vec4 color4 = texture(mat_textTexture, vpos);
    color = (0.3 * color) + ((0.13*alpha) * color2) + (0.3 * color3) + ((0.13*alpha) * color4);
    vec4 col = vec4(color[0] * pos[0], color[1] * pos[1], color[2] * vpos[0], 1);
    ivec4 source = ivec4(col * 255);
    color = xor_RGB(color, source);
}





