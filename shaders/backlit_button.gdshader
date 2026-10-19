shader_type canvas_item;

// --- GEOMETRY ---
uniform vec2 rect_size = vec2(200.0, 100.0); 

// --- FAKE 3D BEVELS (SIDES) ---
uniform float bevel_width : hint_range(1.0, 100.0) = 16.0;      
uniform float bevel_smoothness : hint_range(0.0, 50.0) = 6.0;   
uniform vec4 bevel_color : source_color = vec4(0.18, 0.18, 0.18, 1.0);
uniform float bevel_opacity : hint_range(0.0, 1.0) = 1.0;
uniform vec2 light_direction = vec2(-0.707, -0.707);            
uniform float bevel_highlight : hint_range(0.0, 2.0) = 0.8;
uniform float bevel_shadow : hint_range(0.0, 2.0) = 0.6;

// --- CLEAR PLASTIC & SURFACE OPTICS ---
uniform float smoothness : hint_range(0.0, 1.0) = 0.85;           
uniform float specular_intensity : hint_range(0.0, 3.0) = 1.2;     
uniform float fresnel_power : hint_range(1.0, 8.0) = 4.0;          
uniform float refraction_distortion : hint_range(0.0, 35.0) = 14.0;
uniform float environment_reflectivity : hint_range(0.0, 1.0) = 0.35;

// --- TEXTURE & IMPERFECTIONS ---
uniform sampler2D optional_surface_texture : hint_normal, filter_linear_mipmap; 
uniform vec2 texture_tiling = vec2(1.0, 1.0);
uniform float texture_influence : hint_range(0.0, 1.0) = 0.35;    
uniform float procedural_grain : hint_range(0.0, 1.0) = 0.15;     

// --- BEVEL LIGHT PHYSICS ---
uniform float side_glow_intensity : hint_range(0.0, 5.0) = 1.5;
uniform float side_light_falloff : hint_range(0.1, 5.0) = 1.5;         
uniform float side_angle_sensitivity : hint_range(0.0, 1.0) = 0.65;    
uniform float side_color_shift : hint_range(0.0, 1.0) = 0.85;          
uniform float inner_seam_glow : hint_range(0.0, 3.0) = 1.2;            
uniform float base_light_retention : hint_range(0.0, 1.0) = 0.15;      
uniform float outer_rim_glow : hint_range(0.0, 3.0) = 0.4;             

// --- FRONT CAP (PLASTIC PANEL) ---
uniform vec4 cap_color : source_color = vec4(0.12, 0.12, 0.12, 0.9);
uniform float cap_transparency : hint_range(0.0, 1.0) = 0.5;    

// --- INTERNAL BULBS & BACKLIGHT ---
uniform bool is_active = false; 
uniform int bulb_count : hint_range(1, 10) = 2;
uniform float bulb_size : hint_range(0.01, 0.5) = 0.12;         
uniform vec4 bulb_off_color : source_color = vec4(0.25, 0.2, 0.1, 0.8);
uniform vec4 bulb_on_color : source_color = vec4(1.0, 0.95, 0.8, 1.0);
uniform float backlight_intensity : hint_range(0.0, 5.0) = 2.5;
uniform vec4 backlight_color : source_color = vec4(1.0, 0.68, 0.1, 1.0); 
uniform float light_scatter : hint_range(0.1, 10.0) = 2.0;               
uniform float frosted_diffusion : hint_range(0.0, 1.0) = 0.6;            

// Simple procedural high-frequency noise for plastic grain
float hash(vec2 p) {
    p = fract(p * vec2(127.1, 311.7));
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    // 1. Calculate Distances in Absolute Pixel Space
    vec2 px = UV * rect_size;
    float d_left = px.x;
    float d_right = rect_size.x - px.x;
    float d_top = px.y;
    float d_bottom = rect_size.y - px.y;
    float dist_to_edge = min(min(d_left, d_right), min(d_top, d_bottom));

    // 2. Generating Bevel Structures & Faux 3D Normal Coordinates
    float bevel_factor = 1.0 - smoothstep(bevel_width - bevel_smoothness, bevel_width + bevel_smoothness, dist_to_edge);

    float blend_w = max(0.001, bevel_smoothness * 2.0); 
    float w_l = clamp(1.0 - (d_left - dist_to_edge) / blend_w, 0.0, 1.0);
    float w_r = clamp(1.0 - (d_right - dist_to_edge) / blend_w, 0.0, 1.0);
    float w_t = clamp(1.0 - (d_top - dist_to_edge) / blend_w, 0.0, 1.0);
    float w_b = clamp(1.0 - (d_bottom - dist_to_edge) / blend_w, 0.0, 1.0);

    vec2 bevel_dir = vec2(w_l - w_r, w_t - w_b);
    if (length(bevel_dir) > 0.0) bevel_dir = normalize(bevel_dir);

    // Build the 3D Normal vector
    float slope_strength = bevel_factor * 0.85; 
    vec3 normal = normalize(vec3(bevel_dir * slope_strength, 1.0 - slope_strength * 0.5));

    // 3. Applying Optional Textures & Procedural Imperfections
    vec3 tex_normal = texture(optional_surface_texture, UV * texture_tiling).rgb * 2.0 - 1.0;
    
    // Procedural noise micro-normal fallback
    float grn = hash(floor(px * 1.5)) * 2.0 - 1.0;
    vec3 grain_normal = normalize(vec3(grn, hash(floor(px * 1.5 + 24.0)) * 2.0 - 1.0, 50.0));
    
    // Distort surface normals
    vec3 detail_normal = mix(vec3(0.0, 0.0, 1.0), tex_normal, texture_influence);
    detail_normal = mix(detail_normal, grain_normal, procedural_grain * (1.0 - smoothness));
    
    // Perturb 3D surface Normal Map
    normal = normalize(normal + detail_normal * 0.15);

    // 4. Specular Highlight & Glass Fresnel Reflection Math
    vec3 light_3d = normalize(vec3(-light_direction, 0.65)); 
    vec3 view_dir = vec3(0.0, 0.0, 1.0);                     
    
    // Ambient shading 
    float diff_shade = dot(normal, light_3d);
    float ambient_shade = clamp(1.0 + diff_shade * (bevel_highlight - bevel_shadow), 0.15, 2.0);

    // Real SPECULAR glare
    vec3 half_vector = normalize(light_3d + view_dir);
    float spec_factor = max(0.0, dot(normal, half_vector));
    
    // Sharper specular glint with higher Smoothness
    float shininess = mix(3.0, 150.0, smoothness); 
    float spec = pow(spec_factor, shininess) * specular_intensity;

    // FRESNEL: Rim reflection
    float fresnel = pow(1.0 - max(0.0, dot(normal, view_dir)), fresnel_power);
    
    // 5. Backlight Distortion / Refraction
    vec2 refract_offset = normal.xy * bevel_factor * refraction_distortion;
    vec2 refracted_px = px - refract_offset;

    // Calculate Internal Bulbs 
    float total_cap_glow = 0.0;
    float total_side_glow = 0.0;
    float bulb_mask = 0.0;
    vec4 bulb_vis = vec4(0.0);
    float min_dim = min(rect_size.x, rect_size.y); 

    for(int i = 0; i < bulb_count; i++) {
        float x_pos = (float(i) + 1.0) / (float(bulb_count) + 1.0);
        vec2 bulb_px = vec2(x_pos, 0.5) * rect_size;
        
        float d_bulb_px = length(refracted_px - bulb_px);
        float d_norm = d_bulb_px / min_dim; 

        float base_glow = exp(-d_norm * light_scatter * 5.0); 
        total_cap_glow += base_glow;

        vec2 dir_to_bulb = d_bulb_px > 0.0 ? (bulb_px - refracted_px) / d_bulb_px : vec2(0.0);
        float internal_angle = max(0.0, dot(-bevel_dir, dir_to_bulb));
        float angle_factor = mix(1.0, internal_angle, side_angle_sensitivity);
        total_side_glow += base_glow * angle_factor;

        float b_edge = smoothstep(bulb_size, bulb_size - 0.015, d_norm);
        if (b_edge > 0.0) {
            vec4 c_col = mix(bulb_off_color, bulb_on_color, is_active ? 1.0 : 0.0);
            float core = smoothstep(bulb_size * 0.4, 0.0, d_norm);
            c_col += vec4(core * (is_active ? 1.5 : 0.1));
            bulb_vis = mix(bulb_vis, c_col, b_edge);
            bulb_mask = max(bulb_mask, b_edge);
        }
    }

    // 6. Diffusion & Advanced Scattering
    float active_mult = is_active ? backlight_intensity : 0.0;
    float edge_glow_boost = smoothstep(0.0, bevel_width * 2.0, dist_to_edge);
    float cap_glow = (total_cap_glow * (1.0 - frosted_diffusion) + edge_glow_boost * frosted_diffusion) * active_mult;

    // --- COMPOSITING ---
    // A. Front Cap Phase 
    vec4 cap_layer = cap_color;
    cap_layer.a *= (1.0 - cap_transparency);
    vec4 glass_with_bulbs = mix(cap_layer, bulb_vis, bulb_mask * (1.0 - cap_layer.a));
    vec4 cap_final = glass_with_bulbs + (backlight_color * cap_glow);

    // B. Subsurface Scattered Bevel Phase 
    vec3 lit_side_color = bevel_color.rgb * ambient_shade;
    
    float depth_ratio = clamp(dist_to_edge / bevel_width, 0.0, 1.0);
    float falloff_curve = pow(depth_ratio, side_light_falloff);
    float depth_multiplier = mix(base_light_retention, 1.0, falloff_curve);
    
    float side_bleed = total_side_glow * active_mult * side_glow_intensity * depth_multiplier;
    
    float seam_boost = smoothstep(0.75, 1.0, depth_ratio) * inner_seam_glow * active_mult * total_side_glow;
    float rim_boost = smoothstep(0.25, 0.0, depth_ratio) * outer_rim_glow * active_mult * total_side_glow;
    side_bleed += seam_boost + rim_boost;
    
    lit_side_color = mix(lit_side_color, backlight_color.rgb, clamp(side_bleed * side_color_shift, 0.0, 1.0));
    lit_side_color += backlight_color.rgb * side_bleed;

    vec4 bevel_layer = vec4(lit_side_color, bevel_color.a * bevel_opacity);

    // --- C. COMBINE, REFLECT, & SHINE ---
    vec4 final_color = mix(cap_final, bevel_layer, bevel_factor);
    
    vec4 glaze_color = vec4(backlight_color.rgb * fresnel, fresnel * environment_reflectivity);
    glaze_color += vec4(vec3(spec), spec * 0.5); 
    
    final_color.rgb += glaze_color.rgb;
    final_color.a = clamp(mix(cap_final.a, bevel_layer.a, bevel_factor) + (glaze_color.a * smoothness), 0.0, 1.0);

    COLOR = final_color;
}