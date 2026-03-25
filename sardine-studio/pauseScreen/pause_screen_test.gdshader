shader_type canvas_item;

// Allows you to control the blur amount from the editor
uniform float blur_amount : hint_range(0.0, 5.0) = 2.0;

// Access to the texture behind the object
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    // textureLod samples the screen texture with a specific mipmap level (blur)
    COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount);
}