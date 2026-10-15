shader_type canvas_item;

// Photoshop gradient mask texture
uniform sampler2D gradient_mask : hint_default_white;

// Shield fill percentage from 0.0 (empty) to 1.0 (full)
uniform float shield_percentage : hint_range(0.0, 1.0) = 1.0;

group_uniforms Mask_Correction;
// CORREÇÃO DO TOPO (Reta Vertical): Onde a curva começa lá em cima (Default: 0.5)
uniform float curve_start_threshold : hint_range(0.5, 0.95) = 0.5;
// CORREÇÃO DA BASE (Reta Horizontal Esquerda): Onde o achatamento começa perto do fim (Default: 0.25)
uniform float curve_end_threshold : hint_range(0.05, 0.5) = 0.25;
// Alinha a altura da amostragem com o centro da sua barra horizontal (Default: 0.745)
uniform float base_y_alignment : hint_range(0.0, 1.0) = 0.745;

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
    
    // 2. CORREÇÃO DO TOPO (Reta Vertical Superior)
    if (mask_value > curve_start_threshold) {
        float linear_top = 1.0 - UV.y;
        float transition_factor = (mask_value - curve_start_threshold) / (1.0 - curve_start_threshold);
        mask_value = mix(mask_value, linear_top, transition_factor);
    }
    
    // 3. CORREÇÃO DA BASE (Achatamento de Eixo para a Reta Esquerda)
    if (mask_value < curve_end_threshold) {
        vec2 flattened_uv = vec2(UV.x, base_y_alignment);
        float straight_left_mask = texture(gradient_mask, flattened_uv).r;
        
        float transition_factor = mask_value / curve_end_threshold;
        mask_value = mix(straight_left_mask, mask_value, transition_factor);
    }
    
    // 4. ULTRA-OPTIMIZATION: Replace separate uniform lookups with an on-the-fly math blend.
    float total_overlay_weight = damage_intensity + fix_intensity;
    vec3 overlay_blend = (damage_flash_color.rgb * damage_intensity) + (fix_flash_color.rgb * fix_intensity);
    
    // 5. Prevent any possible division by zero natively
    float safe_weight = total_overlay_weight + 0.0001; 
    tex_color.rgb = mix(tex_color.rgb, overlay_blend / safe_weight, clamp(total_overlay_weight, 0.0, 1.0));
    
    // 6. Calculate and apply depletion cutoff directly into the native fragment COLOR register
    tex_color.a *= smoothstep(shield_percentage + SMOOTH_EDGE, shield_percentage, mask_value);
    
    COLOR = tex_color;
}