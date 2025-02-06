extern number time;
extern vec3 glow_color;

vec4 effect(vec4 color, Image texture, vec2 textureCoords, vec2 screenCoords) {

    number distance = sqrt(pow(textureCoords.x - 0.5, 2) + pow(textureCoords.y - 0.5, 2));
    number alpha = (0.25 * abs(sin(time)) + 0.20) * (1.0 - (distance / 0.5));

    if(distance <= 0.5) {
        return vec4(glow_color, alpha);
    } else {
        return vec4(0.0, 0.0, 0.0, 0.0);
    }
}