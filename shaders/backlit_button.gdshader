shader_type canvas_item;

// --- GEOMETRY & SHAPE ---
group_uniforms Base_Geometry;
uniform vec2 rect_size = vec2(200.0, 100.0); 
uniform float bevel_width_x : hint_range(1.0, 100.0) = 16.0;
uniform float bevel_smoothness : hint_range(0.0, 50.0) = 6.0;   
uniform float outer_corner_radius : hint_range(0.0, 100.0) = 0.0; 
uniform vec4 independent_corner_radii = vec4(0.0, 0.0, 0.0, 0.0); // TL, TR, BR, BL

group_uniforms Advanced_Geometry_And_Housing;
uniform bool enable_asymmetrical_bevels = false;                  
uniform float bevel_width_y : hint_range(1.0, 100.0) = 16.0;      
uniform float convex_cap_dome : hint_range(0.0, 5.0) = 0.0;       
uniform float recessed_cap_depth : hint_range(0.0, 5.0) = 0.0;    
uniform float bevel_profile_curve : hint_range(0.1, 5.0) = 1.0;   
uniform float housing_occlusion : hint_range(0.0, 5.0) = 0.0;     
uniform float housing_occlusion_distance : hint_range(0.01, 1.0) = 0.3;
uniform float inner_seam_ao : hint_range(0.0, 1.0) = 0.0;         

// --- COLORS & OVERRIDES ---
group_uniforms Global_Color_Settings;
uniform vec4 global_color : source_color = vec4(0.15, 0.16, 0.16, 1.0); 
uniform float unlit_albedo_tint : hint_range(0.0, 1.0) = 0.0;     
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

// --- SHAPE MODIFIERS ---
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

// --- SURFACE & REFLECTIONS ---
group_uniforms Surface_Appearance;
uniform float smoothness : hint_range(0.0, 1.0) = 0.85;           
uniform float bevel_smoothness_override : hint_range(-1.0, 1.0) = -1.0; 
uniform float specular_intensity : hint_range(0.0, 3.0) = 1.2;     
uniform float fresnel_power : hint_range(1.0, 8.0) = 4.0;          
uniform vec4 fresnel_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); 
uniform float refraction_distortion : hint_range(0.0, 35.0) = 14.0;
uniform float environment_reflectivity : hint_range(0.0, 1.0) = 0.35;

group_uniforms Advanced_Specular_Clearcoat;
uniform vec2 manual_specular_offset = vec2(0.0, 0.0);              
uniform float anisotropic_stretch : hint_range(0.0, 1.0) = 0.0;      
uniform bool enable_dual_lobe_clearcoat = false;                     
uniform float clearcoat_intensity : hint_range(0.0, 5.0) = 1.0;
uniform float clearcoat_shininess : hint_range(10.0, 500.0) = 250.0;
uniform float edge_catching_glint : hint_range(0.0, 5.0) = 0.0;      

// --- MULTIPOINT LIGHTING ---
group_uniforms Lighting_And_Shadows;
uniform vec2 light_direction = vec2(-0.707, -0.707);            
uniform float bevel_highlight : hint_range(0.0, 2.0) = 0.8;
uniform float bevel_shadow : hint_range(0.0, 2.0) = 0.6;
uniform float edge_darkening : hint_range(0.0, 1.0) = 0.0; 
uniform float corner_edge_darkening : hint_range(0.0, 1.0) = 0.3; 

group_uniforms Multipoint_Lighting;
uniform bool enable_multipoint_lighting = false;
uniform vec3 fill_light_dir = vec3(0.8, -0.2, 0.5);
uniform vec4 fill_light_color : source_color = vec4(0.1, 0.2, 0.4, 1.0);
uniform float fill_intensity : hint_range(0.0, 2.0) = 0.5;
uniform vec3 rim_light_dir = vec3(0.0, 1.0, 0.2);
uniform vec4 rim_light_color : source_color = vec4(1.0, 1.0, 0.8, 1.0);
uniform float rim_intensity : hint_range(0.0, 5.0) = 1.0;

// --- TEXTURES & STAMPING ---
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

uniform float carbon_fiber_intensity : hint_range(0.0, 1.0) = 0.0;
uniform float carbon_fiber_scale : hint_range(1.0, 100.0) = 20.0;

group_uniforms Surface_Stamping;
uniform bool enable_stamping = false;
uniform float stamp_depth : hint_range(-5.0, 5.0) = 1.0;
uniform sampler2D stamp_texture : hint_default_black;

// --- INTERNAL LIGHTING ---
group_uniforms Backlight_State;
uniform bool is_active = false; 
uniform float backlight_intensity : hint_range(0.0, 5.0) = 2.5;
uniform vec4 backlight_color : source_color = vec4(1.0, 0.68, 0.1, 1.0); 
uniform float ignition_stutter_intensity : hint_range(0.0, 1.0) = 0.0;

group_uniforms Voltage_Flicker;
uniform bool enable_voltage_flicker = false;
uniform bool voltage_flicker_smooth = false;
uniform float voltage_flicker_intensity : hint_range(0.0, 1.0) = 0.0;
uniform float voltage_flicker_speed : hint_range(0.1, 60.0) = 20.0;

group_uniforms Internal_Bulbs;
uniform int bulb_layout : hint_enum("Row", "Grid", "Ring") = 0;
uniform int bulb_count : hint_range(1, 10) = 2;
uniform int filament_shape : hint_enum("Sphere", "Square SMD", "Tube", "Ring", "Cross", "Diamond") = 0;
uniform float bulb_size : hint_range(0.01, 0.5) = 0.12;
uniform vec2 filament_stretch = vec2(1.0, 1.0);                      
uniform bool is_led_profile = false;                                 
uniform float bulb_spacing : hint_range(0.0, 1.0) = 0.3;
uniform float bulb_halo_power : hint_range(1.0, 10.0) = 5.0;         
uniform vec4 bulb_off_color : source_color = vec4(0.25, 0.2, 0.1, 0.8);
uniform vec4 bulb_on_color : source_color = vec4(1.0, 0.95, 0.8, 1.0);
uniform bool use_blackbody_colors = false;

uniform vec2 internal_baffle_grid = vec2(0.0, 0.0);
uniform bool baffle_cap_only = true;

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

group_uniforms Advanced_Subsurface_Scattering;
uniform float backplate_bounce_light : hint_range(0.0, 5.0) = 0.0;   
uniform float cloudy_refraction_noise : hint_range(0.0, 1.0) = 0.0;  
uniform float corner_pooling_shadow : hint_range(0.0, 1.0) = 0.0;    
uniform bool enable_dual_layer_hue = false;                          
uniform vec4 secondary_subsurface_hue : source_color = vec4(1.0, 0.0, 0.0, 1.0);

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

group_uniforms Advanced_Slope_Lighting;
uniform bool enable_advanced_slope_lighting = false;
uniform float slope_light_position : hint_range(0.0, 1.0) = 0.8;
uniform float slope_light_width : hint_range(0.01, 1.0) = 0.15;
uniform float slope_light_smoothness : hint_range(0.001, 1.0) = 0.2;
uniform float slope_light_intensity : hint_range(0.0, 10.0) = 3.0;
uniform float slope_light_corner_fade : hint_range(0.0, 1.0) = 0.5;
uniform vec4 slope_light_tint : source_color = vec4(1.0, 1.0, 1.0, 1.0);

group_uniforms Interactive_Mouse_Lighting;
uniform bool enable_mouse_light = false; 
uniform vec2 mouse_position = vec2(0.0, 0.0); 
uniform vec4 inactive_mouse_light_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float inactive_mouse_light_intensity : hint_range(0.0, 5.0) = 1.0;
uniform float inactive_mouse_light_range : hint_range(10.0, 1000.0) = 250.0;
uniform float inactive_mouse_light_height : hint_range(10.0, 500.0) = 50.0;
uniform vec4 active_mouse_light_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float active_mouse_light_intensity : hint_range(0.0, 5.0) = 1.0;
uniform float active_mouse_light_range : hint_range(10.0, 1000.0) = 250.0;
uniform float active_mouse_light_height : hint_range(10.0, 500.0) = 50.0;

group_uniforms Experimental_Features;
uniform float heat_distortion_intensity : hint_range(0.0, 1.0) = 0.0;

// --- POST PROCESSING ---
group_uniforms Post_Processing;
uniform float global_contrast : hint_range(0.1, 3.0) = 1.0;          
uniform float light_bleed_overflow : hint_range(0.0, 1.0) = 0.0;     

// --- FAST GPU HASH FUNCTIONS ---
float hash(vec2 p) {
    vec3 p3  = fract(vec3(p.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

vec2 hash2(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * vec3(0.1031, 0.1030, 0.0973));
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.xx + p3.yz) * p3.zy);
}

// --- UTILITY FUNCTIONS ---
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
    if (dir == 3) return vec2(distance(uv, vec2(0.5)) * 1.41421, 0.5);
    return vec2(uv.x, 0.5);
}

float get_corner_radius_mask(vec2 px, vec2 size, float base_r, vec4 custom_r) {
    vec2 half_size = size * 0.5;
    bool is_left = px.x < half_size.x;
    bool is_top = px.y < half_size.y;
    float rx = is_left ? (is_top ? custom_r.x : custom_r.w) : (is_top ? custom_r.y : custom_r.z);
    float final_r = max(base_r, rx);
    if (final_r <= 0.0) return 1.0;
    vec2 d = abs(px - half_size) - (half_size - vec2(final_r));
    return 1.0 - smoothstep(final_r - 1.0, final_r + 1.0, length(max(d, vec2(0.0))) + min(max(d.x, d.y), 0.0));
}

void fragment() {
    vec2 px = UV * rect_size;
    
    if (heat_distortion_intensity > 0.0 && is_active) {
        px += (hash2(UV + TIME * 0.1) * 2.0 - 1.0) * heat_distortion_intensity * 15.0;
    }

    float alpha_mask = get_corner_radius_mask(px, rect_size, outer_corner_radius, independent_corner_radii);
    if (alpha_mask <= 0.0 && light_bleed_overflow == 0.0) discard;

    float min_dim = min(rect_size.x, rect_size.y); 
    float inv_min_dim = 1.0 / min_dim;
    float min_x = min(px.x, rect_size.x - px.x);
    float min_y = min(px.y, rect_size.y - px.y);
    float dist_to_edge = min(min_x, min_y);
    
    float miter_progress_x = min_x * (1.0 / max(0.001, bevel_width_x));
    float miter_progress_y = min_y * (1.0 / max(0.001, enable_asymmetrical_bevels ? bevel_width_y : bevel_width_x));
    bool is_x_bevel = miter_progress_x < miter_progress_y;

    vec2 centered_uv = UV * 2.0 - 1.0;
    
    float raw_tilt_axis = tilt_axis_is_x ? centered_uv.x : centered_uv.y;
    if (tilt_use_custom_curve) raw_tilt_axis = texture(tilt_custom_curve, vec2(tilt_axis_is_x ? UV.x : UV.y, 0.5)).r * 2.0 - 1.0;
    
    float raw_taper_axis = bevel_sink_axis_is_x ? centered_uv.x : centered_uv.y;
    if (bevel_sink_use_custom_curve) raw_taper_axis = texture(bevel_sink_custom_curve, vec2(bevel_sink_axis_is_x ? UV.x : UV.y, 0.5)).r * 2.0 - 1.0;
    
    float tilt_mod = enable_rocker_split ? abs(raw_tilt_axis) : raw_tilt_axis;
    float taper_mod = enable_rocker_split ? abs(raw_taper_axis) : raw_taper_axis;

    float dynamic_bevel_width = bevel_width_x * (1.0 - (taper_mod * tilt_amount * bevel_sink_amount));
    float current_dist = dist_to_edge;

    if (enable_asymmetrical_bevels) {
        float dyn_bx = bevel_width_x * (1.0 - (taper_mod * tilt_amount * bevel_sink_amount));
        float dyn_by = bevel_width_y * (1.0 - (taper_mod * tilt_amount * bevel_sink_amount));
        dynamic_bevel_width = is_x_bevel ? dyn_bx : dyn_by;
        current_dist = is_x_bevel ? (min_x * (dynamic_bevel_width / max(0.001, dyn_bx))) : (min_y * (dynamic_bevel_width / max(0.001, dyn_by)));
    }

    float safe_smoothness = min(bevel_smoothness, dynamic_bevel_width * 0.99);
    float bevel_factor = 1.0 - smoothstep(dynamic_bevel_width - safe_smoothness, dynamic_bevel_width + safe_smoothness, current_dist);

    float raw_slope_progression = current_dist * (1.0 / max(0.001, dynamic_bevel_width));
    float slope_progression = pow(clamp(raw_slope_progression, 0.0, 1.0), bevel_profile_curve);

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
        
        final_cap_color.rgb = mix(final_cap_color.rgb, final_cap_color.rgb * unlit_albedo_tint, 0.5);
        final_bevel_color.rgb = mix(final_bevel_color.rgb, final_bevel_color.rgb * unlit_albedo_tint, 0.5);
    }

    vec2 primary_dir;
    vec2 bev_uv;
    if (is_x_bevel) {
        primary_dir = px.x < (rect_size.x * 0.5) ? vec2(1.0, 0.0) : vec2(-1.0, 0.0);
        bev_uv = vec2(slope_progression, px.y * inv_min_dim);
    } else {
        primary_dir = px.y < (rect_size.y * 0.5) ? vec2(0.0, 1.0) : vec2(0.0, -1.0);
        bev_uv = vec2(px.x * inv_min_dim, slope_progression);
    }
    
    vec2 diag_dir = vec2(px.x < (rect_size.x * 0.5) ? 0.707106 : -0.707106, px.y < (rect_size.y * 0.5) ? 0.707106 : -0.707106);
    float actual_corner_dist = enable_asymmetrical_bevels ? abs(miter_progress_x - miter_progress_y) * dynamic_bevel_width : abs(min_x - min_y);
    float miter_blend = 1.0 - smoothstep(0.0, max(1.0, safe_smoothness), actual_corner_dist);
    vec2 bevel_dir = normalize(mix(primary_dir, diag_dir, miter_blend));

    float slope_strength = bevel_factor * 0.85; 
    vec3 base_normal = vec3(bevel_dir * slope_strength, 1.0 - slope_strength * 0.5);
    
    if (convex_cap_dome > 0.0 && bevel_factor >= 1.0) {
        float dome_dist = length(centered_uv);
        base_normal.xy += centered_uv * dome_dist * convex_cap_dome * 0.5;
        base_normal.z -= dome_dist * convex_cap_dome * 0.5;
    }

    if (recessed_cap_depth > 0.0 && slope_progression > 0.8) {
        float wall_steepness = smoothstep(0.8, 1.0, slope_progression);
        base_normal.xy -= bevel_dir * wall_steepness * recessed_cap_depth;
        base_normal.z += wall_steepness * recessed_cap_depth * 0.5;
    }

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

    float raw_curve_axis = face_curvature_axis_is_x ? centered_uv.x : centered_uv.y;
    float curve_val = sin(raw_curve_axis * 1.57079) * face_curvature_amount * (1.0 - bevel_factor);
    if (face_curvature_axis_is_x) base_normal.x += curve_val;
    else base_normal.y += curve_val;
    
    base_normal.z -= abs(sin(raw_curve_axis * 1.57079)) * abs(face_curvature_amount) * 0.3 * (1.0 - bevel_factor);
    vec3 normal = base_normal;

    if (enable_stamping) {
        float s0 = texture(stamp_texture, UV).r;
        float sx = texture(stamp_texture, UV + vec2(0.01, 0.0)).r;
        float sy = texture(stamp_texture, UV + vec2(0.0, 0.01)).r;
        vec3 st_norm = vec3((s0-sx)*10.0, (s0-sy)*10.0, 1.0 / max(0.01, abs(stamp_depth)));
        if (stamp_depth < 0.0) st_norm.xy *= -1.0;
        normal = normalize(normal + st_norm * (1.0 - bevel_factor));
    }

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
    
    vec2 grn2 = hash2(floor(px * 1.5)) * 2.0 - 1.0;
    vec3 grain_normal = normalize(vec3(grn2, 50.0));
    
    vec3 detail_normal = mix(vec3(0.0, 0.0, 1.0), active_tex_normal, active_influence);
    detail_normal = mix(detail_normal, grain_normal, procedural_grain * (1.0 - smoothness));
    
    if (carbon_fiber_intensity > 0.0) {
        vec2 cf_uv = px * carbon_fiber_scale * 0.01;
        float pattern = step(0.5, fract(cf_uv.x)) == step(0.5, fract(cf_uv.y)) ? 1.0 : -1.0;
        detail_normal.xy += pattern * carbon_fiber_intensity * (1.0 - bevel_factor);
    }

    normal = normalize(normal + detail_normal * 0.15);

    float active_smoothness = mix(smoothness, bevel_smoothness_override, bevel_factor * step(0.0, bevel_smoothness_override));

    vec3 light_3d = normalize(vec3(-light_direction, 0.65)); 
    
    float diff_shade = max(0.0, dot(normal, light_3d));
    vec3 ambient_diffuse = vec3(clamp(1.0 + diff_shade * (bevel_highlight - bevel_shadow), 0.15, 2.0));
    
    if (enable_multipoint_lighting) {
        vec3 norm_fill = normalize(fill_light_dir);
        vec3 norm_rim = normalize(rim_light_dir);
        ambient_diffuse += max(0.0, dot(normal, norm_fill)) * fill_light_color.rgb * fill_intensity;
        ambient_diffuse += pow(max(0.0, 1.0 - normal.z), 4.0) * max(0.0, dot(normal, norm_rim)) * rim_light_color.rgb * rim_intensity;
    }

    vec3 spec_half_vector = normalize(light_3d + vec3(manual_specular_offset, 1.0));
    if (anisotropic_stretch > 0.0) {
        spec_half_vector.x *= 1.0 + (anisotropic_stretch * (1.0 - abs(normal.x)));
        spec_half_vector.y *= 1.0 + (anisotropic_stretch * (1.0 - abs(normal.y)));
        spec_half_vector = normalize(spec_half_vector);
    }
    
    float spec_factor = max(0.0, dot(normal, spec_half_vector));
    float shininess = mix(3.0, 150.0, active_smoothness); 
    
    float glint_mult = 1.0 + (miter_blend * edge_catching_glint * bevel_factor);
    float spec = pow(spec_factor, shininess) * specular_intensity * glint_mult;
    
    if (enable_dual_lobe_clearcoat) {
        spec += pow(spec_factor, clearcoat_shininess) * clearcoat_intensity * glint_mult;
    }

    float fresnel = pow(max(0.0, 1.0 - normal.z), fresnel_power);
    
    vec2 refract_offset = normal.xy * bevel_factor * refraction_distortion;
    if (cloudy_refraction_noise > 0.0) {
        refract_offset += (hash2(px) * 2.0 - 1.0) * cloudy_refraction_noise * 10.0;
    }
    vec2 refracted_px = px - refract_offset;

    float total_cap_glow = backplate_bounce_light * 0.1; 
    float total_side_glow = backplate_bounce_light * 0.1;
    float bulb_mask = 0.0;
    vec4 bulb_vis = vec4(0.0);

    vec2 resolved_3d_light_dir = bulb_3d_light_direction;
    if (use_global_light_for_3d_bulb == 1) resolved_3d_light_dir = light_direction;
    else if (use_global_light_for_3d_bulb == 2) resolved_3d_light_dir = vec2(-light_direction.x, light_direction.y); 
    else if (use_global_light_for_3d_bulb == 3) resolved_3d_light_dir = vec2(light_direction.x, -light_direction.y); 
    else if (use_global_light_for_3d_bulb == 4) resolved_3d_light_dir = -light_direction; 
    vec3 sphere_light_dir = normalize(vec3(-resolved_3d_light_dir, 0.65));

    float flicker_mod = 1.0;
    if (enable_voltage_flicker && is_active) {
        float noise_flicker = voltage_flicker_smooth ? 
            ((sin(TIME * voltage_flicker_speed) + sin(TIME * voltage_flicker_speed * 0.73) + sin(TIME * voltage_flicker_speed * 1.37)) * 0.166 + 0.5) : 
            hash(vec2(floor(TIME * voltage_flicker_speed), 0.0));
        flicker_mod -= voltage_flicker_intensity * noise_flicker;
    }
    
    if (ignition_stutter_intensity > 0.0 && is_active) {
        float startup_noise = smoothstep(0.2, 0.8, hash(vec2(TIME * 15.0, 1.0)));
        flicker_mod *= mix(1.0, startup_noise, ignition_stutter_intensity);
    }
    
    float active_mult = (is_active ? backlight_intensity : 0.0) * flicker_mod;

    vec4 base_b_col = is_active ? bulb_on_color : bulb_off_color;
    if (use_blackbody_colors && is_active) {
        base_b_col.rgb = mix(vec3(1.0, 0.1, 0.0), bulb_on_color.rgb, clamp(active_mult, 0.0, 1.0));
    }
    
    vec4 core_b_col = base_b_col;
    core_b_col.rgb += vec3(is_active ? 3.0 : 0.4);
    
    core_b_col.rgb *= flicker_mod;
    base_b_col.rgb *= flicker_mod;

    // --- Loop-Invariant Bulb Math ---
    int internal_bulb_max = min(bulb_count, 10);
    float glass_opacity = clamp(1.0 - bulb_3d_transparency, 0.0, 1.0);
    float active_spec_mult = is_active ? 2.5 : 0.3;
    float active_rim_mult = is_active ? 2.0 : 0.3;
    float bulb_radius_px = bulb_size * min_dim;
    float core_radius = bulb_radius_px * bulb_3d_core_size;
    float core_edge_softness = max(0.001, bulb_3d_core_smoothness);
    
    float scatter_power = light_scatter * bulb_halo_power;
    float led_halo_scatter = scatter_power * 5.0;
    float led_side_scatter = light_scatter * 5.0;
    float norm_side_scatter = light_scatter * 1.5;
    
    vec3 sphere_half_vec = normalize(sphere_light_dir + vec3(0.0, 0.0, 1.0));
    vec2 inv_filament_stretch = 1.0 / max(vec2(0.001), filament_stretch);

    float bulb_start_x = 0.0;
    vec2 grid_start = vec2(0.0);
    int grid_cols = 1;
    float angle_step = 0.0;
    float bulb_spacing_px = bulb_spacing * min_dim;

    if (bulb_layout == 0) {
        bulb_start_x = (rect_size.x - float(internal_bulb_max - 1) * bulb_spacing * rect_size.x) * 0.5;
    } else if (bulb_layout == 1) {
        grid_cols = int(ceil(sqrt(float(internal_bulb_max))));
        int rows = int(ceil(float(internal_bulb_max) / float(grid_cols)));
        grid_start = (rect_size - vec2(float(grid_cols - 1), float(rows - 1)) * bulb_spacing_px) * 0.5;
    } else if (bulb_layout == 2) {
        angle_step = 6.283185 / float(internal_bulb_max);
    }
    
    for(int i = 0; i < 10; i++) {
        if (i >= internal_bulb_max) break;
        
        vec2 bulb_px = rect_size * 0.5;
        if (bulb_layout == 0) {
            bulb_px.x = (internal_bulb_max > 1) ? bulb_start_x + float(i) * bulb_spacing * rect_size.x : rect_size.x * 0.5;
        } else if (bulb_layout == 1) {
            bulb_px = grid_start + vec2(float(i % grid_cols), float(i / grid_cols)) * bulb_spacing_px;
        } else if (bulb_layout == 2) {
            float angle = float(i) * angle_step;
            bulb_px += vec2(cos(angle), sin(angle)) * bulb_spacing_px;
        }
        
        vec2 bulb_diff = (refracted_px - bulb_px) * inv_filament_stretch;
        float d_bulb_px = length(bulb_diff);
        
        if (filament_shape == 1) { 
            d_bulb_px = max(abs(bulb_diff.x), abs(bulb_diff.y));
        } else if (filament_shape == 2) { 
            d_bulb_px = length(bulb_diff - vec2(clamp(bulb_diff.x, -bulb_radius_px, bulb_radius_px), 0.0));
        } else if (filament_shape == 3) {
            d_bulb_px = abs(d_bulb_px - bulb_radius_px * 0.5);
        } else if (filament_shape == 4) {
            float hx = clamp(bulb_diff.x, -bulb_radius_px, bulb_radius_px);
            float hy = clamp(bulb_diff.y, -bulb_radius_px, bulb_radius_px);
            d_bulb_px = min(length(bulb_diff - vec2(hx, 0.0)), length(bulb_diff - vec2(0.0, hy)));
        } else if (filament_shape == 5) {
            d_bulb_px = (abs(bulb_diff.x) + abs(bulb_diff.y)) * 0.707106;
        }
        
        float d_norm = d_bulb_px * inv_min_dim; 

        float glow_falloff = is_led_profile ? (1.0 / (1.0 + d_norm * led_halo_scatter)) : exp(-d_norm * scatter_power);
        total_cap_glow += glow_falloff;
        
        vec2 dir_to_bulb = d_bulb_px > 0.0 ? -bulb_diff / d_bulb_px : vec2(0.0);
        float internal_angle = max(0.0, dot(-bevel_dir, dir_to_bulb));
        
        float side_base_falloff = is_led_profile ? (1.0 / (1.0 + d_norm * led_side_scatter)) : (1.0 / (1.0 + d_norm * norm_side_scatter));
        total_side_glow += side_base_falloff * mix(0.4, 1.0, internal_angle * side_angle_sensitivity);

        if (use_3d_spherical_bulbs && filament_shape == 0) {
            if (d_bulb_px <= bulb_radius_px) {
                float core_mask = 1.0 - smoothstep(1.0 - core_edge_softness, 1.0, d_bulb_px / core_radius);
                float sphere_dist = clamp((d_bulb_px / bulb_radius_px) / bulb_3d_depth, 0.0, 1.0);
                float z = sqrt(max(0.0, 1.0 - sphere_dist * sphere_dist));
                
                vec3 sphere_n = normalize(vec3(bulb_diff / bulb_radius_px, z));
                float spec_h = pow(max(0.0, dot(sphere_n, sphere_half_vec)), bulb_3d_shininess);
                
                vec3 glass_color = base_b_col.rgb * max(0.3, dot(sphere_n, sphere_light_dir)) + vec3(spec_h * bulb_3d_specular_intensity * active_spec_mult);
                glass_color += backlight_color.rgb * pow(1.0 - z, 2.0) * bulb_3d_rim_glow * active_rim_mult;
                
                float a_mask = smoothstep(1.0, 0.88, sphere_dist);
                bulb_vis = mix(bulb_vis, vec4(mix(core_b_col.rgb * core_mask, glass_color, glass_opacity), a_mask), a_mask);
                bulb_mask = max(bulb_mask, a_mask);
            }
        } else {
            float b_edge = smoothstep(bulb_size, bulb_size - 0.015, d_norm);
            if (b_edge > 0.0) {
                vec4 flat_col = base_b_col + vec4(smoothstep(bulb_size * 0.4, 0.0, d_norm) * (is_active ? 1.5 : 0.1));
                bulb_vis = mix(bulb_vis, flat_col, b_edge);
                bulb_mask = max(bulb_mask, b_edge);
            }
        }
    }
    
    if (internal_baffle_grid.x > 0.0 || internal_baffle_grid.y > 0.0) {
        vec2 grid = fract(refracted_px * (0.1 * internal_baffle_grid));
        if (grid.x < 0.1 || grid.y < 0.1) {
            float b_mask = baffle_cap_only ? (1.0 - bevel_factor) : 1.0;
            bulb_mask *= (1.0 - b_mask);
            bulb_vis *= (1.0 - b_mask);
            total_cap_glow *= mix(1.0, 0.2, b_mask);
            total_side_glow *= mix(1.0, 0.5, b_mask);
        }
    }

    vec3 effective_backlight_color = enable_dual_layer_hue ? mix(secondary_subsurface_hue.rgb, backlight_color.rgb, clamp(total_side_glow, 0.0, 1.0)) : backlight_color.rgb;

    float edge_glow_boost = smoothstep(0.0, 2.0, raw_slope_progression);
    float cap_glow = (total_cap_glow * (1.0 - frosted_diffusion) + edge_glow_boost * frosted_diffusion) * active_mult * seam_darken;
    cap_glow *= mix(1.0, clamp(detail_normal.z, 0.0, 1.0), backlight_texture_reveal);

    vec4 cap_layer = final_cap_color;
    cap_layer.a *= (1.0 - cap_transparency);
    vec4 cap_final = mix(cap_layer, bulb_vis, bulb_mask * (1.0 - cap_layer.a)) + vec4(effective_backlight_color * cap_glow, cap_glow);

    vec3 base_bevel_rgb = mix(final_bevel_color.rgb, final_edge_color.rgb, smoothstep(edge_color_blend, 0.0, slope_progression));
    base_bevel_rgb *= bev_tex_lum;

    float corner_factor = miter_blend * bevel_factor;
    float housing_darkening = pow(smoothstep(0.0, housing_occlusion_distance, slope_progression), housing_occlusion);
    float pooling_shadow = mix(1.0, 1.0 - corner_factor, corner_pooling_shadow);
    
    vec3 lit_side_color = base_bevel_rgb * ambient_diffuse * mix(1.0, 1.0 - edge_darkening, 1.0 - bevel_factor) * mix(1.0, 1.0 - corner_edge_darkening, corner_factor);
    lit_side_color *= housing_darkening * pooling_shadow;
    
    if (inner_seam_ao > 0.0) {
        lit_side_color *= mix(1.0, smoothstep(1.0, 0.85, slope_progression), inner_seam_ao);
    }

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

    if (enable_advanced_slope_lighting) {
        float half_band = slope_light_width * 0.5;
        float band_mask = 1.0 - smoothstep(max(0.0, half_band - slope_light_smoothness), half_band + slope_light_smoothness, abs(slope_progression - slope_light_position));
        side_bleed += band_mask * slope_light_intensity * total_side_glow * active_mult * mix(1.0, 1.0 - miter_blend, slope_light_corner_fade) * bevel_factor;
    }
    
    vec3 final_glow_color = effective_backlight_color * slope_light_tint.rgb;
    lit_side_color = mix(lit_side_color, final_glow_color, clamp(side_bleed * side_color_shift, 0.0, 1.0)) + (final_glow_color * side_bleed);

    vec4 final_color = mix(cap_final, vec4(lit_side_color, bevel_opacity), bevel_factor);
    
    vec4 glaze_color = vec4(fresnel_color.rgb * fresnel, fresnel * environment_reflectivity) + vec4(vec3(spec), spec * 0.5); 
    
    if (enable_mouse_light) {
        vec4 current_m_color = is_active ? active_mouse_light_color : inactive_mouse_light_color;
        float current_m_intensity = is_active ? active_mouse_light_intensity : inactive_mouse_light_intensity;
        float current_m_range = is_active ? active_mouse_light_range : inactive_mouse_light_range;
        float current_m_height = is_active ? active_mouse_light_height : inactive_mouse_light_height;

        vec3 mouse_light_vec = vec3(px - mouse_position, current_m_height);
        float mouse_dist = length(mouse_light_vec);
        float mouse_attenuation = smoothstep(current_m_range, 0.0, mouse_dist);
        vec3 mouse_dir_norm = mouse_light_vec * (1.0 / max(0.001, mouse_dist));
        
        vec3 m_half = normalize(mouse_dir_norm + vec3(0.0, 0.0, 1.0));
        float m_spec = pow(max(0.0, dot(normal, m_half)), shininess) * specular_intensity;
        
        vec3 added_mouse_light = (current_m_color.rgb * max(0.0, dot(normal, mouse_dir_norm)) + vec3(m_spec)) * mouse_attenuation * current_m_intensity;
        final_color.rgb += added_mouse_light;
    }
    
    final_color.rgb += glaze_color.rgb;
    final_color.a = clamp(mix(cap_final.a, bevel_opacity, bevel_factor) + (glaze_color.a * active_smoothness), 0.0, 1.0);
    
    if (light_bleed_overflow > 0.0 && alpha_mask <= 0.0) {
        float overflow_falloff = exp(-distance(px, clamp(px, vec2(0.0), rect_size)) * 0.1);
        final_color = vec4(effective_backlight_color * total_side_glow * active_mult * light_bleed_overflow * overflow_falloff, overflow_falloff * 0.5 * light_bleed_overflow);
    } else {
        final_color.a *= alpha_mask;
    }

    final_color.rgb = clamp((final_color.rgb - 0.5) * global_contrast + 0.5, 0.0, 1.0);

    COLOR = final_color;
}