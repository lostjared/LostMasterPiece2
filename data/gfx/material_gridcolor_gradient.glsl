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
    ivec4 source = ivec4(255 * color);
    vec2 pos = gl_FragCoord.xy/iResolution_.xy;
  
    pos[0] += 0.01;
    pos[1] += 0.01;
    vec4 color2 = texture(textTexture, pos);
    color *= vec4(tc, tc[0]+tc[1], 1);
    vec4 color3 = texture(mat_textTexture, tc);
    source += ivec4(color3 * 255);
    vec4 color4 = texture(mat_textTexture, pos);
    color = xor_RGB(color, source);
}



