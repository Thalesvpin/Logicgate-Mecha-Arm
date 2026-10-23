shader_type canvas_item;

group_uniforms Base_Geometry;
uniform vec2 rect_size = vec2(200.0, 100.0); 
uniform float bevel_width : hint_range(1.0, 100.0) = 16.0;      
uniform float bevel_smoothness : hint_range(0.0, 50.0) = 6.0;   

group_uniforms Global_Color_Settings;
uniform vec4 global_color : source_color = vec4(0.15, 0.16, 0.16, 1.0); 
uniform float edge_color_blend : hint_range(0.0, 1.0) = 0.2; 
uniform float cap_transparency : hint_range(0.0, 1.0) = 0.5;    
uniform float bevel_opacity : hint_range(0.0, 1.0) = 1.0;

group_uniforms Inactive_Color_Overrides;
uniform bool override_inactive_cap = false;
uniform int inactive_cap_blend : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen") = 0;
uniform int inactive_cap_grad_dir : hint_enum("Horizontal", "Vertical", "Diagonal", "Radial") = 0;
uniform sampler2D inactive_cap_gradient : hint_default_white;

uniform bool override_inactive_bevel = false;
uniform int inactive_bevel_blend : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen") = 0;
uniform int inactive_bevel_grad_dir : hint_enum("Horizontal", "Vertical", "Diagonal", "Radial") = 0;
uniform sampler2D inactive_bevel_gradient : hint_default_white;

uniform bool override_inactive_edge = false;
uniform int inactive_edge_blend : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen") = 0;
uniform int inactive_edge_grad_dir : hint_enum("Horizontal", "Vertical", "Diagonal", "Radial") = 0;
uniform sampler2D inactive_edge_gradient : hint_default_white;

group_uniforms Active_Color_Overrides;
uniform bool override_active_cap = false;
uniform int active_cap_blend : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen") = 0;
uniform int active_cap_grad_dir : hint_enum("Horizontal", "Vertical", "Diagonal", "Radial") = 0;
uniform sampler2D active_cap_gradient : hint_default_white;

uniform bool override_active_bevel = false;
uniform int active_bevel_blend : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen") = 0;
uniform int active_bevel_grad_dir : hint_enum("Horizontal", "Vertical", "Diagonal", "Radial") = 0;
uniform sampler2D active_bevel_gradient : hint_default_white;

uniform bool override_active_edge = false;
uniform int active_edge_blend : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen") = 0;
uniform int active_edge_grad_dir : hint_enum("Horizontal", "Vertical", "Diagonal", "Radial") = 0;
uniform sampler2D active_edge_gradient : hint_default_white;

group_uniforms Rocker_Shape;
uniform float tilt_amount : hint_range(-1.0, 1.0) = 0.0; 
uniform bool tilt_axis_is_x = false;
uniform bool tilt_use_custom_curve = false; 
uniform sampler2D tilt_custom_curve : hint_default_white; 
uniform float bevel_sink_amount : hint_range(0.0, 1.0) = 0.0;
uniform bool bevel_sink_axis_is_x = false;
uniform bool bevel_sink_use_custom_curve = false; 
uniform sampler2D bevel_sink_custom_curve : hint_default_white; 
uniform float face_curvature_amount : hint_range(-2.0, 2.0) = 0.0; 
uniform bool face_curvature_axis_is_x = false; 

group_uniforms Rocker_Split;
uniform bool enable_rocker_split = false;
uniform bool split_on_x_axis = false;
uniform float split_width : hint_range(0.01, 0.5) = 0.08;
uniform float split_smoothness : hint_range(0.001, 0.5) = 0.05;
uniform float split_depth : hint_range(0.0, 3.0) = 1.0;

group_uniforms Surface_Appearance;
uniform float smoothness : hint_range(0.0, 1.0) = 0.85;           
uniform float specular_intensity : hint_range(0.0, 3.0) = 1.2;     
uniform float fresnel_power : hint_range(1.0, 8.0) = 4.0;          
uniform float refraction_distortion : hint_range(0.0, 35.0) = 14.0;
uniform float environment_reflectivity : hint_range(0.0, 1.0) = 0.35;

group_uniforms Lighting_And_Shadows;
uniform vec2 light_direction = vec2(-0.707, -0.707);            
uniform float bevel_highlight : hint_range(0.0, 2.0) = 0.8;
uniform float bevel_shadow : hint_range(0.0, 2.0) = 0.6;
uniform float edge_darkening : hint_range(0.0, 1.0) = 0.0; 
uniform float corner_edge_darkening : hint_range(0.0, 1.0) = 0.3; 

group_uniforms Advanced_Slope_Lighting;
uniform bool enable_advanced_slope_lighting = true;
uniform float slope_light_position : hint_range(0.0, 1.0) = 0.8;
uniform float slope_light_width : hint_range(0.01, 1.0) = 0.15;
uniform float slope_light_smoothness : hint_range(0.001, 1.0) = 0.2;
uniform float slope_light_intensity : hint_range(0.0, 10.0) = 3.0;
uniform float slope_light_corner_fade : hint_range(0.0, 1.0) = 0.5;
uniform vec4 slope_light_tint : source_color = vec4(1.0, 1.0, 1.0, 1.0);

group_uniforms Texture_And_Imperfections;
uniform bool use_optional_surface_texture = false;
uniform sampler2D optional_surface_texture : hint_normal, filter_linear_mipmap; 
uniform vec2 texture_tiling = vec2(1.0, 1.0);
uniform float normal_map_depth : hint_range(0.0, 5.0) = 1.0;      
uniform float texture_influence : hint_range(0.0, 1.0) = 0.35;    

uniform bool use_optional_bevel_texture = false;
uniform sampler2D optional_bevel_texture : hint_normal, filter_linear_mipmap; 
uniform vec2 bevel_texture_tiling = vec2(1.0, 1.0);
uniform float bevel_normal_depth : hint_range(0.0, 5.0) = 1.0;
uniform float bevel_texture_influence : hint_range(0.0, 1.0) = 0.35;

uniform float procedural_grain : hint_range(0.0, 1.0) = 0.15;     
uniform float backlight_texture_reveal : hint_range(0.0, 2.0) = 0.0; 

group_uniforms Backlight_State;
uniform bool is_active = false; 
uniform float backlight_intensity : hint_range(0.0, 5.0) = 2.5;
uniform vec4 backlight_color : source_color = vec4(1.0, 0.68, 0.1, 1.0); 

group_uniforms Internal_Bulbs;
uniform int bulb_count : hint_range(1, 10) = 2;
uniform float bulb_size : hint_range(0.01, 0.5) = 0.12;
uniform float bulb_spacing : hint_range(0.0, 1.0) = 0.3;
uniform float bulb_halo_power : hint_range(1.0, 10.0) = 5.0;         
uniform vec4 bulb_off_color : source_color = vec4(0.25, 0.2, 0.1, 0.8);
uniform vec4 bulb_on_color : source_color = vec4(1.0, 0.95, 0.8, 1.0);
uniform bool use_3d_spherical_bulbs = false;
uniform float bulb_3d_depth : hint_range(0.1, 3.0) = 1.0;
uniform float bulb_3d_shininess : hint_range(1.0, 128.0) = 32.0;
uniform float bulb_3d_specular_intensity : hint_range(0.0, 5.0) = 1.5;
uniform float bulb_3d_rim_glow : hint_range(0.0, 3.0) = 0.8;
uniform float bulb_3d_transparency : hint_range(0.0, 1.0) = 0.2;
uniform float bulb_3d_core_size : hint_range(0.01, 1.0) = 0.4;
uniform float bulb_3d_core_smoothness : hint_range(0.01, 1.0) = 0.3;
uniform int use_global_light_for_3d_bulb : hint_enum("Off", "Normal", "Inverted X", "Inverted Y", "Inverted X and Y") = 1;
uniform vec2 bulb_3d_light_direction = vec2(0.5, 0.5);

group_uniforms Light_Scattering;
uniform int bevel_light_mode : hint_enum("Standard Subsurface", "Milky Translucent", "Crystal Refractive", "Fiber Optic Edge") = 0;
uniform float light_scatter : hint_range(0.1, 10.0) = 2.0;               
uniform float frosted_diffusion : hint_range(0.0, 1.0) = 0.6;            
uniform float side_illumination_boost : hint_range(0.0, 10.0) = 2.5;  
uniform float side_rim_leak : hint_range(0.0, 5.0) = 1.0;             
uniform float side_inner_glow : hint_range(0.0, 5.0) = 1.5;           
uniform float side_glow_intensity : hint_range(0.0, 5.0) = 1.5;
uniform float side_light_falloff : hint_range(0.1, 5.0) = 1.5;         
uniform float side_angle_sensitivity : hint_range(0.0, 1.0) = 0.65;    
uniform float side_color_shift : hint_range(0.0, 1.0) = 0.85;          
uniform float base_light_retention : hint_range(0.0, 1.0) = 0.15;      

float hash(vec2 p) {
    p = fract(p * vec2(127.1, 311.7));
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

vec4 apply_blend(vec4 base, vec4 blend, int mode) {
    if (mode == 0) return blend;                                          
    if (mode == 1) return mix(base, blend, blend.a);                      
    if (mode == 2) return base * blend;                                   
    if (mode == 3) return min(base + blend, vec4(1.0));                   
    return vec4(1.0) - (vec4(1.0) - base) * (vec4(1.0) - blend);          
}

vec2 get_grad_coord(vec2 uv, int dir) {
    if (dir == 1) return vec2(uv.y, 0.5);
    if (dir == 2) return vec2((uv.x + uv.y) * 0.5, 0.5);
    if (dir == 3) return vec2(distance(uv, vec2(0.5)) * 1.414, 0.5);
    return vec2(uv.x, 0.5);
}

void fragment() {
    vec2 px = UV * rect_size;
    float min_dim = min(rect_size.x, rect_size.y); 
    float d_left = px.x;
    float d_right = rect_size.x - px.x;
    float d_top = px.y;
    float d_bottom = rect_size.y - px.y;
    
    float min_x = min(d_left, d_right);
    float min_y = min(d_top, d_bottom);
    float dist_to_edge = min(min_x, min_y);
    
    vec4 final_cap_color = global_color;
    vec4 final_bevel_color = global_color;
    vec4 final_edge_color = global_color;
    
    if (is_active) {
        if (override_active_cap) final_cap_color = apply_blend(global_color, texture(active_cap_gradient, get_grad_coord(UV, active_cap_grad_dir)), active_cap_blend);
        if (override_active_bevel) final_bevel_color = apply_blend(global_color, texture(active_bevel_gradient, get_grad_coord(UV, active_bevel_grad_dir)), active_bevel_blend);
        if (override_active_edge) final_edge_color = apply_blend(global_color, texture(active_edge_gradient, get_grad_coord(UV, active_edge_grad_dir)), active_edge_blend);
    } else {
        if (override_inactive_cap) final_cap_color = apply_blend(global_color, texture(inactive_cap_gradient, get_grad_coord(UV, inactive_cap_grad_dir)), inactive_cap_blend);
        if (override_inactive_bevel) final_bevel_color = apply_blend(global_color, texture(inactive_bevel_gradient, get_grad_coord(UV, inactive_bevel_grad_dir)), inactive_bevel_blend);
        if (override_inactive_edge) final_edge_color = apply_blend(global_color, texture(inactive_edge_gradient, get_grad_coord(UV, inactive_edge_grad_dir)), inactive_edge_blend);
    }
    
    vec2 centered_uv = UV * 2.0 - 1.0;
    float raw_tilt_axis = tilt_axis_is_x ? centered_uv.x : centered_uv.y;
    if (tilt_use_custom_curve) {
        raw_tilt_axis = texture(tilt_custom_curve, vec2(tilt_axis_is_x ? UV.x : UV.y, 0.5)).r * 2.0 - 1.0;
    }
    
    float raw_taper_axis = bevel_sink_axis_is_x ? centered_uv.x : centered_uv.y;
    if (bevel_sink_use_custom_curve) {
        raw_taper_axis = texture(bevel_sink_custom_curve, vec2(bevel_sink_axis_is_x ? UV.x : UV.y, 0.5)).r * 2.0 - 1.0;
    }
    
    float raw_curve_axis = face_curvature_axis_is_x ? centered_uv.x : centered_uv.y;

    float tilt_mod = enable_rocker_split ? abs(raw_tilt_axis) : raw_tilt_axis;
    float taper_mod = enable_rocker_split ? abs(raw_taper_axis) : raw_taper_axis;

    float dynamic_bevel_width = bevel_width * (1.0 - (taper_mod * tilt_amount * bevel_sink_amount));
    float safe_smoothness = min(bevel_smoothness, dynamic_bevel_width * 0.99);
    float bevel_factor = 1.0 - smoothstep(dynamic_bevel_width - safe_smoothness, dynamic_bevel_width + safe_smoothness, dist_to_edge);

    vec2 primary_dir;
    vec2 bev_uv;
    if (dist_to_edge == d_left) {
        primary_dir = vec2(1.0, 0.0);
        bev_uv = vec2(dist_to_edge / dynamic_bevel_width, px.y / min_dim);
    } else if (dist_to_edge == d_right) {
        primary_dir = vec2(-1.0, 0.0);
        bev_uv = vec2(dist_to_edge / dynamic_bevel_width, px.y / min_dim);
    } else if (dist_to_edge == d_top) {
        primary_dir = vec2(0.0, 1.0);
        bev_uv = vec2(px.x / min_dim, dist_to_edge / dynamic_bevel_width);
    } else {
        primary_dir = vec2(0.0, -1.0);
        bev_uv = vec2(px.x / min_dim, dist_to_edge / dynamic_bevel_width);
    }
    
    vec2 diag_dir = normalize(vec2(d_left < d_right ? 1.0 : -1.0, d_top < d_bottom ? 1.0 : -1.0));
    float corner_dist = abs(min_x - min_y);
    float miter_blend = 1.0 - smoothstep(0.0, max(1.0, safe_smoothness), corner_dist);
    vec2 bevel_dir = normalize(mix(primary_dir, diag_dir, miter_blend));

    float slope_strength = bevel_factor * 0.85; 
    vec3 base_normal = vec3(bevel_dir * slope_strength, 1.0 - slope_strength * 0.5);
    
    if (tilt_axis_is_x) base_normal.x += tilt_mod * tilt_amount;
    else base_normal.y += tilt_mod * tilt_amount;
    base_normal.z -= abs(tilt_mod * tilt_amount) * 0.5;
    
    float seam_darken = 1.0;
    if (enable_rocker_split) {
        float raw_split_axis = split_on_x_axis ? centered_uv.x : centered_uv.y;
        float s_dist = abs(raw_split_axis);
        float cap_mask = 1.0 - bevel_factor; 
        
        if (cap_mask > 0.0) {
            float s_prof = smoothstep(split_width, max(0.001, split_width - split_smoothness), s_dist) * cap_mask;
            if (s_prof > 0.0) {
                base_normal.z -= s_prof * split_depth;
                float s_slope = sign(raw_split_axis) * sin(s_prof * 3.14159) * split_depth * 0.5;
                if (split_on_x_axis) base_normal.x += s_slope;
                else base_normal.y += s_slope;
                seam_darken = 1.0 - (s_prof * clamp(split_depth, 0.0, 1.0) * 0.8);
            }
        }
    }

    float curve_val = sin(raw_curve_axis * 1.5707) * face_curvature_amount * (1.0 - bevel_factor);
    if (face_curvature_axis_is_x) base_normal.x += curve_val;
    else base_normal.y += curve_val;
    
    base_normal.z -= abs(sin(raw_curve_axis * 1.5707)) * abs(face_curvature_amount) * 0.3 * (1.0 - bevel_factor);
    vec3 normal = base_normal;

    // --- TEXTURES & IMPERFECTIONS ---
    vec3 cap_tex_normal = vec3(0.0, 0.0, 1.0);
    if (use_optional_surface_texture) {
        cap_tex_normal = texture(optional_surface_texture, UV * texture_tiling).rgb * 2.0 - 1.0;
        cap_tex_normal.xy *= normal_map_depth; 
        cap_tex_normal = normalize(cap_tex_normal);
    }
    
    vec3 bev_tex_normal = vec3(0.0, 0.0, 1.0);
    float bev_tex_lum = 1.0;
    if (use_optional_bevel_texture) {
        vec4 bev_tex_sample = texture(optional_bevel_texture, bev_uv * bevel_texture_tiling);
        bev_tex_normal = bev_tex_sample.rgb * 2.0 - 1.0;
        bev_tex_normal.xy *= bevel_normal_depth;
        bev_tex_normal = normalize(bev_tex_normal);
        bev_tex_lum = mix(1.0, dot(bev_tex_sample.rgb, vec3(0.299, 0.587, 0.114)) * 1.5, bevel_texture_influence);
    }

    vec3 active_tex_normal = mix(cap_tex_normal, bev_tex_normal, bevel_factor);
    float active_influence = mix(texture_influence, bevel_texture_influence, bevel_factor);
    
    float grn = hash(floor(px * 1.5)) * 2.0 - 1.0;
    vec3 grain_normal = normalize(vec3(grn, hash(floor(px * 1.5 + 24.0)) * 2.0 - 1.0, 50.0));
    
    vec3 detail_normal = mix(vec3(0.0, 0.0, 1.0), active_tex_normal, active_influence);
    detail_normal = mix(detail_normal, grain_normal, procedural_grain * (1.0 - smoothness));
    
    normal = normalize(normal + detail_normal * 0.15);

    vec3 light_3d = normalize(vec3(-light_direction, 0.65)); 
    vec3 view_dir = vec3(0.0, 0.0, 1.0);                     
    
    float diff_shade = dot(normal, light_3d);
    float ambient_shade = clamp(1.0 + diff_shade * (bevel_highlight - bevel_shadow), 0.15, 2.0);

    vec3 half_vector = normalize(light_3d + view_dir);
    float spec_factor = max(0.0, dot(normal, half_vector));
    float shininess = mix(3.0, 150.0, smoothness); 
    float spec = pow(spec_factor, shininess) * specular_intensity;
    float fresnel = pow(1.0 - max(0.0, dot(normal, view_dir)), fresnel_power);
    
    vec2 refract_offset = normal.xy * bevel_factor * refraction_distortion;
    vec2 refracted_px = px - refract_offset;

    // --- BULBS & SCATTER ---
    float total_cap_glow = 0.0;
    float total_side_glow = 0.0;
    float bulb_mask = 0.0;
    vec4 bulb_vis = vec4(0.0);

    float total_bulb_span = float(bulb_count - 1) * bulb_spacing * rect_size.x;
    float bulb_start_x = (rect_size.x - total_bulb_span) * 0.5;

    vec2 resolved_3d_light_dir = bulb_3d_light_direction;
    if (use_global_light_for_3d_bulb == 1) resolved_3d_light_dir = light_direction;
    else if (use_global_light_for_3d_bulb == 2) resolved_3d_light_dir = vec2(-light_direction.x, light_direction.y); 
    else if (use_global_light_for_3d_bulb == 3) resolved_3d_light_dir = vec2(light_direction.x, -light_direction.y); 
    else if (use_global_light_for_3d_bulb == 4) resolved_3d_light_dir = -light_direction; 
    
    vec3 sphere_light_dir = normalize(vec3(-resolved_3d_light_dir, 0.65));

    vec4 current_core_col = mix(bulb_off_color, bulb_on_color, is_active ? 1.0 : 0.0);
    current_core_col.rgb += vec3(is_active ? 3.0 : 0.4); 
    vec4 current_base_b_col = mix(bulb_off_color, bulb_on_color, is_active ? 1.0 : 0.0);
    float glass_opacity = clamp(1.0 - bulb_3d_transparency, 0.0, 1.0);
    float active_spec_mult = is_active ? 2.5 : 0.3;
    float active_rim_mult = is_active ? 2.0 : 0.3;
    float bulb_radius_px = bulb_size * min_dim;
    float core_radius = bulb_radius_px * bulb_3d_core_size;
    float core_edge_softness = max(0.001, bulb_3d_core_smoothness);

    for(int i = 0; i < bulb_count; i++) {
        float x_pos = (bulb_count > 1) ? bulb_start_x + float(i) * bulb_spacing * rect_size.x : rect_size.x * 0.5;
        vec2 bulb_px = vec2(x_pos, rect_size.y * 0.5);
        vec2 bulb_diff = refracted_px - bulb_px;
        float d_bulb_px = length(bulb_diff);
        float d_norm = d_bulb_px / min_dim; 

        total_cap_glow += exp(-d_norm * light_scatter * bulb_halo_power); 
        
        vec2 dir_to_bulb = d_bulb_px > 0.0 ? -bulb_diff / d_bulb_px : vec2(0.0);
        float internal_angle = max(0.0, dot(-bevel_dir, dir_to_bulb));
        total_side_glow += (1.0 / (1.0 + d_norm * light_scatter * 1.5)) * mix(0.4, 1.0, internal_angle * side_angle_sensitivity);

        if (use_3d_spherical_bulbs) {
            if (d_bulb_px <= bulb_radius_px) {
                float core_mask = 1.0 - smoothstep(1.0 - core_edge_softness, 1.0, d_bulb_px / core_radius);
                float sphere_dist = clamp((d_bulb_px / bulb_radius_px) / bulb_3d_depth, 0.0, 1.0);
                float z = sqrt(max(0.0, 1.0 - sphere_dist * sphere_dist));
                
                vec3 sphere_n = normalize(vec3(bulb_diff / bulb_radius_px, z));
                float spec_h = pow(max(0.0, dot(sphere_n, normalize(sphere_light_dir + vec3(0.0, 0.0, 1.0)))), bulb_3d_shininess);
                
                vec3 glass_color = current_base_b_col.rgb * max(0.3, dot(sphere_n, sphere_light_dir)) + vec3(spec_h * bulb_3d_specular_intensity * active_spec_mult);
                glass_color += backlight_color.rgb * pow(1.0 - z, 2.0) * bulb_3d_rim_glow * active_rim_mult;
                
                float alpha_mask = smoothstep(1.0, 0.88, sphere_dist);
                bulb_vis = mix(bulb_vis, vec4(mix(current_core_col.rgb * core_mask, glass_color, glass_opacity), alpha_mask), alpha_mask);
                bulb_mask = max(bulb_mask, alpha_mask);
            }
        } else {
            float b_edge = smoothstep(bulb_size, bulb_size - 0.015, d_norm);
            if (b_edge > 0.0) {
                vec4 flat_col = current_base_b_col + vec4(smoothstep(bulb_size * 0.4, 0.0, d_norm) * (is_active ? 1.5 : 0.1));
                bulb_vis = mix(bulb_vis, flat_col, b_edge);
                bulb_mask = max(bulb_mask, b_edge);
            }
        }
    }

    // --- COMPOSITING ---
    float active_mult = is_active ? backlight_intensity : 0.0;
    float edge_glow_boost = smoothstep(0.0, dynamic_bevel_width * 2.0, dist_to_edge);
    float cap_glow = (total_cap_glow * (1.0 - frosted_diffusion) + edge_glow_boost * frosted_diffusion) * active_mult * seam_darken;
    cap_glow *= mix(1.0, clamp(detail_normal.z, 0.0, 1.0), backlight_texture_reveal);

    vec4 cap_layer = final_cap_color;
    cap_layer.a *= (1.0 - cap_transparency);
    vec4 cap_final = mix(cap_layer, bulb_vis, bulb_mask * (1.0 - cap_layer.a)) + (backlight_color * cap_glow);

    float slope_progression = clamp(dist_to_edge / dynamic_bevel_width, 0.0, 1.0);
    vec3 base_bevel_rgb = mix(final_bevel_color.rgb, final_edge_color.rgb, smoothstep(dynamic_bevel_width * edge_color_blend, 0.0, dist_to_edge));
    base_bevel_rgb *= bev_tex_lum;

    float corner_factor = miter_blend * bevel_factor;
    vec3 lit_side_color = base_bevel_rgb * ambient_shade * mix(1.0, 1.0 - edge_darkening, 1.0 - bevel_factor) * mix(1.0, 1.0 - corner_edge_darkening, corner_factor);
    
    float side_bleed = 0.0;
    float falloff_curve = 0.0;
    
    if (bevel_light_mode == 0) {
        falloff_curve = pow(slope_progression, side_light_falloff);
        side_bleed = total_side_glow * active_mult * side_glow_intensity * mix(base_light_retention, 1.0, falloff_curve);
        side_bleed += (side_inner_glow * (1.0 - slope_progression) + side_rim_leak * slope_progression) * active_mult * total_side_glow;
    } else if (bevel_light_mode == 1) {
        falloff_curve = pow(slope_progression, side_light_falloff * 0.3);
        side_bleed = total_side_glow * active_mult * side_glow_intensity * 1.2 * mix(max(0.4, base_light_retention), 1.0, falloff_curve);
    } else if (bevel_light_mode == 2) {
        falloff_curve = pow(slope_progression, side_light_falloff * 0.8);
        side_bleed = pow(total_side_glow + 0.01, 2.0) * 1.5 * active_mult * side_glow_intensity * mix(base_light_retention * 0.5, 1.0, falloff_curve);
    } else if (bevel_light_mode == 3) {
        falloff_curve = pow(slope_progression, side_light_falloff * 2.0);
        side_bleed = total_side_glow * active_mult * side_glow_intensity * mix(base_light_retention * 0.2, 1.0, falloff_curve);
        side_bleed += (1.0 - slope_progression) * side_rim_leak * 2.0 * active_mult * total_side_glow;
    }
    side_bleed *= side_illumination_boost * bevel_factor;

    // --- ADVANCED SLOPE LIGHTING INJECTION ---
    if (enable_advanced_slope_lighting) {
        float half_band = slope_light_width * 0.5;
        float band_mask = 1.0 - smoothstep(max(0.0, half_band - slope_light_smoothness), half_band + slope_light_smoothness, abs(slope_progression - slope_light_position));
        side_bleed += band_mask * slope_light_intensity * total_side_glow * active_mult * mix(1.0, 1.0 - miter_blend, slope_light_corner_fade) * bevel_factor;
    }
    
    vec3 final_glow_color = backlight_color.rgb * slope_light_tint.rgb;
    lit_side_color = mix(lit_side_color, final_glow_color, clamp(side_bleed * side_color_shift, 0.0, 1.0)) + (final_glow_color * side_bleed);

    vec4 final_color = mix(cap_final, vec4(lit_side_color, bevel_opacity), bevel_factor);
    vec4 glaze_color = vec4(backlight_color.rgb * fresnel, fresnel * environment_reflectivity) + vec4(vec3(spec), spec * 0.5); 
    
    final_color.rgb += glaze_color.rgb;
    final_color.a = clamp(mix(cap_final.a, bevel_opacity, bevel_factor) + (glaze_color.a * smoothness), 0.0, 1.0);

    COLOR = final_color;
}