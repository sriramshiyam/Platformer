vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 tex_color = Texel(texture, texture_coords) * color;

    number distance = sqrt(pow(texture_coords.x - 0.5, 2) + pow(texture_coords.y - 0.5, 2));
    if (distance >= 0.4) {
        return vec4(0.0, 0.0, 0.0, (distance - 0.4) * 2.5);
    }

    return tex_color;
}