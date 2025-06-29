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

vec4 color_blend(vec4 color) {
    vec4 color2 = color;
    ivec4 color_source = ivec4(color * 255);
    color = color*alpha;
    ivec4 colori = ivec4(color * 255);
    for(int i = 0; i < 3; ++i) {
        if(colori[i] >= 255)
            colori[i] = colori[i]%255;
        
        if(color_source[i] >= 255)
            color_source[i] = color_source[i]%255;
        
        colori[i] = colori[i] ^ color_source[i];
        color[i] = float(colori[i])/255;
    }
    
    for(int i = 0; i < 3; ++i)
        if(color[i] < 0.2) color[i] = color2[i];
    return color;
}


void main(void)
{
    if(restore_black_value == 1.0 && texture(textTexture, tc) == vec4(0, 0, 0, 1))
        discard;
    color = texture(textTexture, tc);
    ivec4 source = ivec4(255 * color);
    vec2 pos = gl_FragCoord.xy/iResolution_.xy;
    vec2 vpos;
    vpos[0] = 1.0-tc[0];
    vpos[1] = tc[1];
    vec4 color2 = texture(textTexture, vpos);
    vec4 color3 = texture(mat_textTexture, tc);
    vec4 color4 = texture(mat_textTexture, vpos);
    color = (0.3 * color) + (0.3 * color2) + (0.3 * color3) + (0.3 * color4);
    
    color = color_blend(color);
}


