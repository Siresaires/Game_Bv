shader_type canvas_item;

// Textures for the grain effect.
uniform sampler2D grain;

// Controls for the grain effect.
uniform float grain_strength = 0.3; // Strength of the grain effect.
uniform float grain_size = 1.0; // Size of the grain particles. Larger values produce larger grains.
uniform float grain_amount = 1.0; // Amount of grain. Higher values increase the density/intensity of the grain.

// Controls for the animation of the grain effect.
uniform float fps = 12.0; // Frames per second for animating the grain effect.

// Controls for the flashing light effect.
uniform float flashing = 0.01; // Intensity of the flashing effect.

// Function to generate the grain effect.
float make_grain(float time, vec2 uv) {
    vec2 ofs = vec2(sin(41.0 * time * sin(time * 123.0)), sin(27.0 * time * sin(time * 312.0)));
    // Adjust the texture coordinates based on grain_size and apply grain_amount to modulate the grain's intensity.
    return texture(grain, (uv + mod(ofs, vec2(1.0, 1.0))) / grain_size).r * grain_amount;
}

void fragment() {
    // Start with the original texture color.
    vec3 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;

    // Calculate the grain effect.
    float frame_time = 1.0 / fps;
    float current_frame = TIME - mod(TIME, frame_time);
    float g = make_grain(current_frame, UV);
    g = max(g, make_grain(current_frame + frame_time, UV) * 0.5);
    g = max(g, make_grain(current_frame + frame_time * 2.0, UV) * 0.25);

    // Define a white-grey color for the grains.
    vec3 grain_color = vec3(0.8); // Represents a grey color.
    
    // Mix the original color with the grain color based on the grain value and strength.
    c = mix(c, grain_color, g * grain_strength);

    // Apply the flashing light effect.
    float flashing_time = TIME * 0.002;
    c += vec3(sin(75.0 * flashing_time * sin(flashing_time * 123.0))) * flashing;

    // Set the final color, including grain and flashing effects.
    COLOR.rgb = c;
}