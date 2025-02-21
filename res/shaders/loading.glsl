extern number min;
extern number max;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    if (texture_coords.x >= min && texture_coords.x <= max) {
        return vec4(0.0, 0.0, 0.0, 1.0);
    } else {
        return vec4(0.0, 0.0, 0.0, 0.0);
    }
}