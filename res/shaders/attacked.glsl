extern number red;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 tex_color = Texel(texture, texture_coords) * color;
    
    if (tex_color.a != 0.0) {
        return (1 - red) * tex_color + red * vec4(1.0, 0.0, 0.0, 1.0);
    } else {
        return tex_color;
    }
}