shader_type canvas_item;

// Photoshop gradient mask texture
uniform sampler2D gradient_mask : hint_default_white;

// Shield fill percentage from 0.0 (empty) to 1.0 (full)
uniform float shield_percentage : hint_range(0.0, 1.0) = 1.0;

group_uniforms Damage_Effect;
// Color overlay when the shield takes damage (Default: #ffffff White)
uniform vec4 damage_flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
// Intensity of the damage flash (0.0 to 1.0)
uniform float damage_intensity : hint_range(0.0, 1.0) = 0.0;

group_uniforms Fix_Effect;
// Color overlay when the shield recharges/is fixed (Default: #57ffbc Neo-Mint/Cyan)
uniform vec4 fix_flash_color : source_color = vec4(0.341, 1.0, 0.737, 1.0);
// Intensity of the shield fix flash (0.0 to 1.0)
uniform float fix_intensity : hint_range(0.0, 1.0) = 0.0;

// Re-usable hardware constant
const float SMOOTH_EDGE = 0.001;

void fragment() {
    // 1. Parallel Texture Sampling Pack
    vec4 tex_color = texture(TEXTURE, UV);
    float mask_value = texture(gradient_mask, UV).r;
    
    // 2. ULTRA-OPTIMIZATION: Replace separate uniform lookups with an on-the-fly math blend.
    // This allows the GPU to merge the overlays using native multiply-add (MAD) hardware assembly operations,
    // avoiding vec2 array allocations entirely on mobile/desktop GPUs.
    float total_overlay_weight = damage_intensity + fix_intensity;
    vec3 overlay_blend = (damage_flash_color.rgb * damage_intensity) + (fix_flash_color.rgb * fix_intensity);
    
    // 3. Prevent any possible division by zero natively while eliminating the max() function call overhead.
    // The clamp() safely acts as an execution weight mask.
    float safe_weight = total_overlay_weight + 0.0001; 
    tex_color.rgb = mix(tex_color.rgb, overlay_blend / safe_weight, clamp(total_overlay_weight, 0.0, 1.0));
    
    // 4. Calculate and apply depletion cutoff directly into the native fragment COLOR register
    tex_color.a *= smoothstep(shield_percentage + SMOOTH_EDGE, shield_percentage, mask_value);
    
    COLOR = tex_color;
}