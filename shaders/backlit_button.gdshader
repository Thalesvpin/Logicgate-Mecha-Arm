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
uniform int inactive_cap_blend : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen", "Subtract") = 0;
uniform int inactive_cap_grad_dir : hint_enum("Horizontal", "Vertical", "Diagonal", "Radial") = 0;
uniform sampler2D inactive_cap_gradient : hint_default_white;
uniform bool override_inactive_bevel = false;
uniform int inactive_bevel_blend : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen", "Subtract") = 0;
uniform int inactive_bevel_grad_dir : hint_enum("Horizontal", "Vertical", "Diagonal", "Radial") = 0;
uniform sampler2D inactive_bevel_gradient : hint_default_white;
uniform bool override_inactive_edge = false;
uniform int inactive_edge_blend : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen", "Subtract") = 0;
uniform int inactive_edge_grad_dir : hint_enum("Horizontal", "Vertical", "Diagonal", "Radial") = 0;
uniform sampler2D inactive_edge_gradient : hint_default_white;

group_uniforms Active_Color_Overrides;
uniform bool override_active_cap = false;
uniform int active_cap_blend : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen", "Subtract") = 0;
uniform int active_cap_grad_dir : hint_enum("Horizontal", "Vertical", "Diagonal", "Radial") = 0;
uniform sampler2D active_cap_gradient : hint_default_white;
uniform bool override_active_bevel = false;
uniform int active_bevel_blend : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen", "Subtract") = 0;
uniform int active_bevel_grad_dir : hint_enum("Horizontal", "Vertical", "Diagonal", "Radial") = 0;
uniform sampler2D active_bevel_gradient : hint_default_white;
uniform bool override_active_edge = false;
uniform int active_edge_blend : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen", "Subtract") = 0;
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
uniform int carbon_fiber_stamp_mask : hint_enum("None", "Mask White Areas", "Mask Black Areas") = 0;

// --- SURFACE STAMPING MASTER GROUP ---
group_uniforms Surface_Stamping.Stamp1_Base;
uniform bool enable_stamping = false;
uniform float stamp1_base_opacity : hint_range(0.0, 1.0) = 1.0;
uniform int stamp1_base_mapping_mode : hint_enum("Stretch", "Keep Aspect") = 0;
uniform bool stamp1_base_cap_only = false;
uniform bool stamp1_base_bevel_wrapping = false;
uniform vec2 stamp1_base_scale = vec2(1.0, 1.0);
uniform vec2 stamp1_base_offset = vec2(0.0, 0.0);
uniform float stamp1_base_rotation : hint_range(-180.0, 180.0) = 0.0;
uniform vec2 stamp1_base_uv_panning = vec2(0.0, 0.0);
uniform bool stamp1_base_grid_tiling = false;
uniform vec2 stamp1_base_grid_scale = vec2(3.0, 3.0);
uniform vec2 stamp1_base_grid_offset = vec2(0.0, 0.0);
uniform bool stamp1_base_repeat = false;
uniform float stamp1_base_edge_sharpness : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D stamp1_base_texture : hint_default_black, filter_linear_mipmap;

group_uniforms Surface_Stamping.Stamp1_Outline;
uniform bool stamp1_outline_enabled = false;
uniform float stamp1_outline_size : hint_range(0.0, 50.0) = 5.0;
uniform float stamp1_outline_depth : hint_range(-5.0, 5.0) = 1.0;
uniform vec4 stamp1_outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float stamp1_outline_opacity : hint_range(0.0, 1.0) = 1.0;
uniform float stamp1_outline_roughness : hint_range(-1.0, 1.0) = -1.0;
uniform float stamp1_outline_metallic : hint_range(-1.0, 1.0) = -1.0;
uniform bool stamp1_outline_use_iridescence = false;
uniform bool stamp1_outline_mouse_fade = false;
uniform float stamp1_outline_fade_range : hint_range(10.0, 1000.0) = 250.0;
uniform bool stamp1_outline_mouse_hover = false;

group_uniforms Surface_Stamping.Stamp1_Depth;
uniform float stamp1_depth : hint_range(-5.0, 5.0) = 1.0;
uniform bool stamp1_depth_split_axis = false;
uniform vec2 stamp1_depth_split_xy = vec2(1.0, 1.0);
uniform float stamp1_bevel_width : hint_range(0.0, 0.5) = 0.05;
uniform float stamp1_bevel_curve : hint_range(0.1, 5.0) = 1.0;
uniform float stamp1_depth_inset_shadow : hint_range(0.0, 1.0) = 0.0;
uniform float stamp1_depth_crevice_dirt : hint_range(0.0, 1.0) = 0.0;
uniform vec4 stamp1_depth_dirt_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float stamp1_depth_dirt_opacity : hint_range(0.0, 1.0) = 1.0;
uniform float stamp1_depth_dirt_contrast : hint_range(0.1, 5.0) = 1.0;

group_uniforms Surface_Stamping.Stamp1_Appearance;
uniform int stamp1_appear_albedo_blend_mode : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen", "Subtract") = 1;
uniform float stamp1_appear_albedo_blend : hint_range(0.0, 1.0) = 0.0;
uniform vec4 stamp1_appear_albedo_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float stamp1_appear_albedo_margin : hint_range(0.0, 1.0) = 0.0;
uniform float stamp1_appear_emissive_intensity : hint_range(0.0, 5.0) = 0.0;
uniform float stamp1_appear_light_blocker : hint_range(0.0, 1.0) = 0.0;
uniform float stamp1_appear_roughness_override : hint_range(-1.0, 1.0) = -1.0;
uniform float stamp1_appear_metallic_override : hint_range(-1.0, 1.0) = -1.0;
uniform float stamp1_appear_cap_transparency : hint_range(0.0, 1.0) = 0.0;

group_uniforms Surface_Stamping.Stamp1_Iridescence;
uniform float stamp1_appear_iridescent_foil : hint_range(0.0, 1.0) = 0.0;
uniform float stamp1_appear_irid_saturation : hint_range(0.0, 2.0) = 1.0;
uniform float stamp1_appear_irid_scale : hint_range(0.1, 10.0) = 5.0;
uniform bool stamp1_appear_irid_mouse_fade = false;
uniform float stamp1_appear_irid_fade_range : hint_range(10.0, 1000.0) = 250.0;
uniform bool stamp1_appear_irid_use_gradient = false;
uniform sampler2D stamp1_appear_irid_gradient : hint_default_white;

group_uniforms Surface_Stamping.Stamp1_Interactivity;
uniform bool stamp1_interact_active_swap = false;
uniform int stamp1_interact_albedo_blend_mode : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen", "Subtract") = 1;
uniform float stamp1_interact_albedo_blend : hint_range(0.0, 1.0) = 0.0;
uniform vec4 stamp1_interact_albedo_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float stamp1_interact_emissive_intensity : hint_range(0.0, 5.0) = 0.0;
uniform float stamp1_interact_light_blocker : hint_range(0.0, 1.0) = 0.0;
uniform float stamp1_interact_roughness_override : hint_range(-1.0, 1.0) = -1.0;
uniform float stamp1_interact_metallic_override : hint_range(-1.0, 1.0) = -1.0;
uniform float stamp1_interact_iridescent_foil : hint_range(0.0, 1.0) = 0.0;
uniform float stamp1_interact_cap_transparency : hint_range(0.0, 1.0) = 0.0;
uniform float stamp1_interact_press_depth_link : hint_range(0.0, 1.0) = 0.0;
uniform bool stamp1_interact_heat_isolate = false;

group_uniforms Surface_Stamping.Stamp2_Base;
uniform bool enable_stamp_2 = false;
uniform float stamp2_base_opacity : hint_range(0.0, 1.0) = 1.0;
uniform int stamp2_base_mapping_mode : hint_enum("Stretch", "Keep Aspect") = 0;
uniform bool stamp2_base_cap_only = false;
uniform bool stamp2_base_bevel_wrapping = false;
uniform vec2 stamp2_base_scale = vec2(1.0, 1.0);
uniform vec2 stamp2_base_offset = vec2(0.0, 0.0);
uniform float stamp2_base_rotation : hint_range(-180.0, 180.0) = 0.0;
uniform vec2 stamp2_base_uv_panning = vec2(0.0, 0.0);
uniform bool stamp2_base_grid_tiling = false;
uniform vec2 stamp2_base_grid_scale = vec2(3.0, 3.0);
uniform vec2 stamp2_base_grid_offset = vec2(0.0, 0.0);
uniform bool stamp2_base_repeat = false;
uniform float stamp2_base_edge_sharpness : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D stamp2_base_texture : hint_default_black, filter_linear_mipmap;

group_uniforms Surface_Stamping.Stamp2_Outline;
uniform bool stamp2_outline_enabled = false;
uniform float stamp2_outline_size : hint_range(0.0, 50.0) = 5.0;
uniform float stamp2_outline_depth : hint_range(-5.0, 5.0) = 1.0;
uniform vec4 stamp2_outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float stamp2_outline_opacity : hint_range(0.0, 1.0) = 1.0;
uniform float stamp2_outline_roughness : hint_range(-1.0, 1.0) = -1.0;
uniform float stamp2_outline_metallic : hint_range(-1.0, 1.0) = -1.0;
uniform bool stamp2_outline_use_iridescence = false;
uniform bool stamp2_outline_mouse_fade = false;
uniform float stamp2_outline_fade_range : hint_range(10.0, 1000.0) = 250.0;
uniform bool stamp2_outline_mouse_hover = false;

group_uniforms Surface_Stamping.Stamp2_Depth;
uniform float stamp2_depth : hint_range(-5.0, 5.0) = 1.0;
uniform bool stamp2_depth_split_axis = false;
uniform vec2 stamp2_depth_split_xy = vec2(1.0, 1.0);
uniform float stamp2_bevel_width : hint_range(0.0, 0.5) = 0.05;
uniform float stamp2_bevel_curve : hint_range(0.1, 5.0) = 1.0;
uniform float stamp2_depth_inset_shadow : hint_range(0.0, 1.0) = 0.0;
uniform float stamp2_depth_crevice_dirt : hint_range(0.0, 1.0) = 0.0;
uniform vec4 stamp2_depth_dirt_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float stamp2_depth_dirt_opacity : hint_range(0.0, 1.0) = 1.0;
uniform float stamp2_depth_dirt_contrast : hint_range(0.1, 5.0) = 1.0;

group_uniforms Surface_Stamping.Stamp2_Appearance;
uniform int stamp2_appear_albedo_blend_mode : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen", "Subtract") = 1;
uniform float stamp2_appear_albedo_blend : hint_range(0.0, 1.0) = 0.0;
uniform vec4 stamp2_appear_albedo_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float stamp2_appear_albedo_margin : hint_range(0.0, 1.0) = 0.0;
uniform float stamp2_appear_emissive_intensity : hint_range(0.0, 5.0) = 0.0;
uniform float stamp2_appear_light_blocker : hint_range(0.0, 1.0) = 0.0;
uniform float stamp2_appear_roughness_override : hint_range(-1.0, 1.0) = -1.0;
uniform float stamp2_appear_metallic_override : hint_range(-1.0, 1.0) = -1.0;
uniform float stamp2_appear_cap_transparency : hint_range(0.0, 1.0) = 0.0;

group_uniforms Surface_Stamping.Stamp2_Iridescence;
uniform float stamp2_appear_iridescent_foil : hint_range(0.0, 1.0) = 0.0;
uniform float stamp2_appear_irid_saturation : hint_range(0.0, 2.0) = 1.0;
uniform float stamp2_appear_irid_scale : hint_range(0.1, 10.0) = 5.0;
uniform bool stamp2_appear_irid_mouse_fade = false;
uniform float stamp2_appear_irid_fade_range : hint_range(10.0, 1000.0) = 250.0;
uniform bool stamp2_appear_irid_use_gradient = false;
uniform sampler2D stamp2_appear_irid_gradient : hint_default_white;

group_uniforms Surface_Stamping.Stamp2_Interactivity;
uniform bool stamp2_interact_active_swap = false;
uniform int stamp2_interact_albedo_blend_mode : hint_enum("Replace", "Mix", "Multiply", "Add", "Screen", "Subtract") = 1;
uniform float stamp2_interact_albedo_blend : hint_range(0.0, 1.0) = 0.0;
uniform vec4 stamp2_interact_albedo_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float stamp2_interact_emissive_intensity : hint_range(0.0, 5.0) = 0.0;
uniform float stamp2_interact_light_blocker : hint_range(0.0, 1.0) = 0.0;
uniform float stamp2_interact_roughness_override : hint_range(-1.0, 1.0) = -1.0;
uniform float stamp2_interact_metallic_override : hint_range(-1.0, 1.0) = -1.0;
uniform float stamp2_interact_iridescent_foil : hint_range(0.0, 1.0) = 0.0;
uniform float stamp2_interact_cap_transparency : hint_range(0.0, 1.0) = 0.0;
uniform float stamp2_interact_press_depth_link : hint_range(0.0, 1.0) = 0.0;
uniform bool stamp2_interact_heat_isolate = false;


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
    if (mode == 1) return vec4(mix(base.rgb, blend.rgb, blend.a), max(base.a, blend.a));                      
    if (mode == 2) return vec4(base.rgb * blend.rgb, max(base.a, blend.a));                                   
    if (mode == 3) return min(base + blend, vec4(1.0));                   
    if (mode == 4) return vec4(vec3(1.0) - (vec3(1.0) - base.rgb) * (vec3(1.0) - blend.rgb), max(base.a, blend.a));          
    return max(base - blend * blend.a, vec4(0.0));
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

float get_msdf(sampler2D tex, vec2 uv) {
    vec3 c = texture(tex, uv).rgb;
    return max(min(c.r, c.g), min(max(c.r, c.g), c.b));
}

void fragment() {
    vec2 px = UV * rect_size;
    vec2 heat_dist_offset = vec2(0.0);
    
    if (heat_distortion_intensity > 0.0 && is_active) {
        heat_dist_offset = (hash2(UV + TIME * 0.1) * 2.0 - 1.0) * heat_distortion_intensity * 15.0;
        px += heat_dist_offset;
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

    // --- ACCUMULATOR VARIABLES FOR DUAL STAMPING ---
    vec4 stamp_albedo_acc = vec4(0.0);
    vec4 stamp_dirt_acc = vec4(0.0);
    float stamp_emissive_acc = 0.0;
    float stamp_blocker_acc = 0.0;
    float stamp_transparency_acc = 0.0;
    float stamp_shadow_acc = 0.0;
    float stamp_roughness_val = 0.0; float stamp_roughness_blend = 0.0;
    float stamp_metallic_val = 0.0;  float stamp_metallic_blend = 0.0;
    float global_stamp_mask = 0.0;

    // --- PRIMARY STAMP LOGIC ---
    if (enable_stamping) {
        vec2 panned_uv1 = UV;
        if (stamp1_base_uv_panning != vec2(0.0)) panned_uv1 = fract(UV - TIME * stamp1_base_uv_panning);

        vec2 st_uv = (stamp1_base_mapping_mode == 1) ? (((panned_uv1 - 0.5) * rect_size * inv_min_dim) + 0.5) : panned_uv1;
        if (stamp1_base_bevel_wrapping && !stamp1_base_cap_only) st_uv -= base_normal.xy * 0.05;
        
        st_uv -= 0.5;
        if (stamp1_base_rotation != 0.0) {
            float r_rad = stamp1_base_rotation * 0.017453292;
            float cr = cos(r_rad); float sr = sin(r_rad);
            st_uv = vec2(st_uv.x * cr - st_uv.y * sr, st_uv.x * sr + st_uv.y * cr);
        }
        st_uv = (st_uv / max(vec2(0.001), stamp1_base_scale)) + 0.5 - stamp1_base_offset;
        
        bool in_bounds = true;
        if (!stamp1_base_repeat && !stamp1_base_grid_tiling) {
            in_bounds = (st_uv.x >= 0.0 && st_uv.x <= 1.0 && st_uv.y >= 0.0 && st_uv.y <= 1.0);
        } else if (stamp1_base_grid_tiling) {
            st_uv = fract(st_uv * stamp1_base_grid_scale + stamp1_base_grid_offset);
        } else if (stamp1_base_repeat) {
            st_uv = fract(st_uv);
        }

        if (stamp1_interact_heat_isolate && heat_distortion_intensity > 0.0 && is_active) {
            st_uv += (hash2(st_uv + TIME * 0.1) * 2.0 - 1.0) * heat_distortion_intensity * 0.1;
        }
        
        float cap_mask = stamp1_base_cap_only ? (1.0 - bevel_factor) : 1.0;
        
        if (in_bounds && cap_mask > 0.0) {
            float d_center = get_msdf(stamp1_base_texture, st_uv);
            
            float aa_width = mix(0.1, 0.001, stamp1_base_edge_sharpness);
            float s0 = smoothstep(0.5 - aa_width, 0.5 + aa_width, d_center);
            
            float d_off = 0.002; 
            float d_l = get_msdf(stamp1_base_texture, st_uv - vec2(d_off, 0.0));
            float d_r = get_msdf(stamp1_base_texture, st_uv + vec2(d_off, 0.0));
            float d_u = get_msdf(stamp1_base_texture, st_uv - vec2(0.0, d_off));
            float d_d = get_msdf(stamp1_base_texture, st_uv + vec2(0.0, d_off));
            
            global_stamp_mask = max(global_stamp_mask, s0 * cap_mask);
            
            // --- STAMP 1 OUTLINE EVALUATION ---
            if (stamp1_outline_enabled && stamp1_outline_size > 0.0) {
                float out_dist = stamp1_outline_size * 0.005;
                float o_max = smoothstep(0.5 - out_dist - aa_width, 0.5 - out_dist + aa_width, d_center);
                float o_mask = clamp(o_max - s0, 0.0, 1.0) * cap_mask;
                
                vec2 out_grad = vec2(d_l - d_r, d_u - d_d) * 20.0 * stamp1_outline_depth;
                
                if (o_mask > 0.0) {
                    float m_fade = 1.0;
                    if (enable_mouse_light) {
                        if (stamp1_outline_mouse_hover) {
                            bool inside = (mouse_position.x >= 0.0 && mouse_position.x <= rect_size.x && mouse_position.y >= 0.0 && mouse_position.y <= rect_size.y);
                            if (!inside) m_fade = 0.0;
                        }
                        if (stamp1_outline_mouse_fade && m_fade > 0.0) {
                            float m_dist = length(mouse_position - (px - heat_dist_offset));
                            m_fade *= smoothstep(stamp1_outline_fade_range, 0.0, m_dist);
                        }
                    }
                    
                    float final_o_alpha = o_mask * stamp1_outline_opacity * m_fade;
                    if (final_o_alpha > 0.0) {
                        stamp_albedo_acc = apply_blend(stamp_albedo_acc, vec4(stamp1_outline_color.rgb, final_o_alpha), 1);
                        
                        if (stamp1_outline_roughness >= 0.0) { stamp_roughness_val = mix(stamp_roughness_val, stamp1_outline_roughness, final_o_alpha); stamp_roughness_blend = max(stamp_roughness_blend, final_o_alpha); }
                        if (stamp1_outline_metallic >= 0.0) { stamp_metallic_val = mix(stamp_metallic_val, stamp1_outline_metallic, final_o_alpha); stamp_metallic_blend = max(stamp_metallic_blend, final_o_alpha); }
                        if (stamp1_outline_depth != 0.0) base_normal = normalize(vec3(base_normal.xy + out_grad * final_o_alpha, base_normal.z));
                        
                        if (stamp1_outline_use_iridescence) {
                            vec3 irid_view = vec3(0.0, 0.0, 1.0);
                            if (enable_mouse_light) {
                                float m_h = is_active ? active_mouse_light_height : inactive_mouse_light_height;
                                irid_view = normalize(vec3((px - heat_dist_offset) - mouse_position, m_h));
                            }
                            float stamp_dot = max(0.0, dot(base_normal, irid_view));
                            float t = stamp_dot * stamp1_appear_irid_scale;
                            vec3 irid_color;
                            if (stamp1_appear_irid_use_gradient) irid_color = texture(stamp1_appear_irid_gradient, vec2(fract(t), 0.5)).rgb;
                            else {
                                irid_color = clamp(vec3(sin(t), sin(t + 2.094), sin(t + 4.188)) * 0.5 + 0.5, 0.0, 1.0);
                                irid_color = mix(vec3(dot(irid_color, vec3(0.333))), irid_color, stamp1_appear_irid_saturation);
                            }
                            stamp_albedo_acc = apply_blend(stamp_albedo_acc, vec4(irid_color, final_o_alpha), 1);
                        }
                    }
                }
            }

            float s_mask = clamp(s0 * stamp1_base_opacity * cap_mask, 0.0, 1.0);
            
            if (s_mask > 0.0) {
                bool is_swap = (stamp1_interact_active_swap && is_active);
                float cur_blend = is_swap ? stamp1_interact_albedo_blend : stamp1_appear_albedo_blend;
                vec4 cur_color = is_swap ? stamp1_interact_albedo_color : stamp1_appear_albedo_color;
                float cur_emiss = is_swap ? stamp1_interact_emissive_intensity : stamp1_appear_emissive_intensity;
                float cur_block = is_swap ? stamp1_interact_light_blocker : stamp1_appear_light_blocker;
                float cur_rough = is_swap ? stamp1_interact_roughness_override : stamp1_appear_roughness_override;
                float cur_metal = is_swap ? stamp1_interact_metallic_override : stamp1_appear_metallic_override;
                float cur_foil = is_swap ? stamp1_interact_iridescent_foil : stamp1_appear_iridescent_foil;
                float cur_transp = is_swap ? stamp1_interact_cap_transparency : stamp1_appear_cap_transparency;
                int cur_blend_mode = is_swap ? stamp1_interact_albedo_blend_mode : stamp1_appear_albedo_blend_mode;

                float w1 = max(0.001, stamp1_bevel_width);
                float c1 = stamp1_bevel_curve;
                float h_c = pow(clamp((d_center - 0.5) / w1, 0.0, 1.0), c1);
                float h_l = pow(clamp((d_l - 0.5) / w1, 0.0, 1.0), c1);
                float h_r = pow(clamp((d_r - 0.5) / w1, 0.0, 1.0), c1);
                float h_u = pow(clamp((d_u - 0.5) / w1, 0.0, 1.0), c1);
                float h_d = pow(clamp((d_d - 0.5) / w1, 0.0, 1.0), c1);

                float dx = (h_l - h_r) * 15.0;
                float dy = (h_u - h_d) * 15.0;

                vec2 current_depth_xy = (stamp1_depth_split_axis ? stamp1_depth_split_xy : vec2(stamp1_depth)) * stamp1_base_opacity;
                if (stamp1_interact_press_depth_link > 0.0) current_depth_xy *= mix(1.0, abs(tilt_amount) * 2.0, stamp1_interact_press_depth_link);
                
                vec3 st_norm = vec3(dx, dy, 1.0 / max(0.01, abs(current_depth_xy.x)));
                st_norm.xy *= current_depth_xy;
                if (current_depth_xy.x < 0.0) st_norm.xy *= -1.0;
                base_normal = normalize(base_normal + st_norm * cap_mask);
                
                float color_mask = smoothstep(stamp1_appear_albedo_margin, stamp1_appear_albedo_margin + 0.01, s0);
                stamp_albedo_acc = apply_blend(stamp_albedo_acc, vec4(cur_color.rgb, cur_color.a * color_mask * cur_blend * s_mask), cur_blend_mode);
                
                if (cur_foil > 0.0) {
                    vec3 irid_view = vec3(0.0, 0.0, 1.0);
                    float mouse_fade = 1.0;
                    if (enable_mouse_light) {
                        float m_h = is_active ? active_mouse_light_height : inactive_mouse_light_height;
                        vec3 mouse_vec = vec3((px - heat_dist_offset) - mouse_position, m_h);
                        irid_view = normalize(mouse_vec);
                        if (stamp1_appear_irid_mouse_fade) mouse_fade = smoothstep(stamp1_appear_irid_fade_range, 0.0, length(mouse_vec));
                    }
                    float stamp_dot = max(0.0, dot(base_normal, irid_view));
                    float t = stamp_dot * stamp1_appear_irid_scale; 
                    vec3 irid_color;
                    if (stamp1_appear_irid_use_gradient) {
                        irid_color = texture(stamp1_appear_irid_gradient, vec2(fract(t), 0.5)).rgb;
                    } else {
                        irid_color = clamp(vec3(sin(t), sin(t + 2.094), sin(t + 4.188)) * 0.5 + 0.5, 0.0, 1.0);
                        irid_color = mix(vec3(dot(irid_color, vec3(0.333))), irid_color, stamp1_appear_irid_saturation);
                    }
                    stamp_albedo_acc = apply_blend(stamp_albedo_acc, vec4(irid_color, cur_foil * s_mask * mouse_fade), cur_blend_mode);
                }

                stamp_emissive_acc += cur_emiss * s_mask;
                stamp_blocker_acc += cur_block * s_mask;
                stamp_transparency_acc += cur_transp * s_mask;
                
                if (cur_rough >= 0.0) { stamp_roughness_val = mix(stamp_roughness_val, cur_rough, s_mask); stamp_roughness_blend = max(stamp_roughness_blend, s_mask); }
                if (cur_metal >= 0.0) { stamp_metallic_val = mix(stamp_metallic_val, cur_metal, s_mask); stamp_metallic_blend = max(stamp_metallic_blend, s_mask); }
                
                float shadow_val = max(0.0, dot(st_norm.xy, light_direction));
                stamp_shadow_acc += stamp1_depth_inset_shadow * shadow_val * 5.0 * s_mask;
                
                if (stamp1_depth_crevice_dirt > 0.0) {
                    float dirt_mask = pow(clamp(1.0 - h_c, 0.0, 1.0), stamp1_depth_dirt_contrast) * s_mask * stamp1_depth_crevice_dirt;
                    stamp_dirt_acc = apply_blend(stamp_dirt_acc, vec4(stamp1_depth_dirt_color.rgb, stamp1_depth_dirt_color.a * dirt_mask * stamp1_depth_dirt_opacity), 1);
                }
            }
        }
    }

    // --- SECONDARY STAMP LOGIC ---
    if (enable_stamp_2) {
        vec2 panned_uv2 = UV;
        if (stamp2_base_uv_panning != vec2(0.0)) panned_uv2 = fract(UV - TIME * stamp2_base_uv_panning);

        vec2 st_uv = (stamp2_base_mapping_mode == 1) ? (((panned_uv2 - 0.5) * rect_size * inv_min_dim) + 0.5) : panned_uv2;
        if (stamp2_base_bevel_wrapping && !stamp2_base_cap_only) st_uv -= base_normal.xy * 0.05;
        
        st_uv -= 0.5;
        if (stamp2_base_rotation != 0.0) {
            float r_rad = stamp2_base_rotation * 0.017453292;
            float cr = cos(r_rad); float sr = sin(r_rad);
            st_uv = vec2(st_uv.x * cr - st_uv.y * sr, st_uv.x * sr + st_uv.y * cr);
        }
        st_uv = (st_uv / max(vec2(0.001), stamp2_base_scale)) + 0.5 - stamp2_base_offset;
        
        bool in_bounds = true;
        if (!stamp2_base_repeat && !stamp2_base_grid_tiling) {
            in_bounds = (st_uv.x >= 0.0 && st_uv.x <= 1.0 && st_uv.y >= 0.0 && st_uv.y <= 1.0);
        } else if (stamp2_base_grid_tiling) {
            st_uv = fract(st_uv * stamp2_base_grid_scale + stamp2_base_grid_offset);
        } else if (stamp2_base_repeat) {
            st_uv = fract(st_uv);
        }

        if (stamp2_interact_heat_isolate && heat_distortion_intensity > 0.0 && is_active) {
            st_uv += (hash2(st_uv + TIME * 0.1) * 2.0 - 1.0) * heat_distortion_intensity * 0.1;
        }
        
        float cap_mask = stamp2_base_cap_only ? (1.0 - bevel_factor) : 1.0;
        
        if (in_bounds && cap_mask > 0.0) {
            float d_center = get_msdf(stamp2_base_texture, st_uv);
            
            float aa_width = mix(0.1, 0.001, stamp2_base_edge_sharpness);
            float s0 = smoothstep(0.5 - aa_width, 0.5 + aa_width, d_center);
            
            float d_off = 0.002; 
            float d_l = get_msdf(stamp2_base_texture, st_uv - vec2(d_off, 0.0));
            float d_r = get_msdf(stamp2_base_texture, st_uv + vec2(d_off, 0.0));
            float d_u = get_msdf(stamp2_base_texture, st_uv - vec2(0.0, d_off));
            float d_d = get_msdf(stamp2_base_texture, st_uv + vec2(0.0, d_off));
            
            global_stamp_mask = max(global_stamp_mask, s0 * cap_mask);
            
            // --- STAMP 2 OUTLINE EVALUATION ---
            if (stamp2_outline_enabled && stamp2_outline_size > 0.0) {
                float out_dist = stamp2_outline_size * 0.005;
                float o_max = smoothstep(0.5 - out_dist - aa_width, 0.5 - out_dist + aa_width, d_center);
                float o_mask = clamp(o_max - s0, 0.0, 1.0) * cap_mask;
                
                vec2 out_grad = vec2(d_l - d_r, d_u - d_d) * 20.0 * stamp2_outline_depth;
                
                if (o_mask > 0.0) {
                    float m_fade = 1.0;
                    if (enable_mouse_light) {
                        if (stamp2_outline_mouse_hover) {
                            bool inside = (mouse_position.x >= 0.0 && mouse_position.x <= rect_size.x && mouse_position.y >= 0.0 && mouse_position.y <= rect_size.y);
                            if (!inside) m_fade = 0.0;
                        }
                        if (stamp2_outline_mouse_fade && m_fade > 0.0) {
                            float m_dist = length(mouse_position - (px - heat_dist_offset));
                            m_fade *= smoothstep(stamp2_outline_fade_range, 0.0, m_dist);
                        }
                    }
                    
                    float final_o_alpha = o_mask * stamp2_outline_opacity * m_fade;
                    if (final_o_alpha > 0.0) {
                        stamp_albedo_acc = apply_blend(stamp_albedo_acc, vec4(stamp2_outline_color.rgb, final_o_alpha), 1);
                        
                        if (stamp2_outline_roughness >= 0.0) { stamp_roughness_val = mix(stamp_roughness_val, stamp2_outline_roughness, final_o_alpha); stamp_roughness_blend = max(stamp_roughness_blend, final_o_alpha); }
                        if (stamp2_outline_metallic >= 0.0) { stamp_metallic_val = mix(stamp_metallic_val, stamp2_outline_metallic, final_o_alpha); stamp_metallic_blend = max(stamp_metallic_blend, final_o_alpha); }
                        if (stamp2_outline_depth != 0.0) base_normal = normalize(vec3(base_normal.xy + out_grad * final_o_alpha, base_normal.z));
                        
                        if (stamp2_outline_use_iridescence) {
                            vec3 irid_view = vec3(0.0, 0.0, 1.0);
                            if (enable_mouse_light) {
                                float m_h = is_active ? active_mouse_light_height : inactive_mouse_light_height;
                                irid_view = normalize(vec3((px - heat_dist_offset) - mouse_position, m_h));
                            }
                            float stamp_dot = max(0.0, dot(base_normal, irid_view));
                            float t = stamp_dot * stamp2_appear_irid_scale;
                            vec3 irid_color;
                            if (stamp2_appear_irid_use_gradient) irid_color = texture(stamp2_appear_irid_gradient, vec2(fract(t), 0.5)).rgb;
                            else {
                                irid_color = clamp(vec3(sin(t), sin(t + 2.094), sin(t + 4.188)) * 0.5 + 0.5, 0.0, 1.0);
                                irid_color = mix(vec3(dot(irid_color, vec3(0.333))), irid_color, stamp2_appear_irid_saturation);
                            }
                            stamp_albedo_acc = apply_blend(stamp_albedo_acc, vec4(irid_color, final_o_alpha), 1);
                        }
                    }
                }
            }

            float s_mask = clamp(s0 * stamp2_base_opacity * cap_mask, 0.0, 1.0);
            
            if (s_mask > 0.0) {
                bool is_swap = (stamp2_interact_active_swap && is_active);
                float cur_blend = is_swap ? stamp2_interact_albedo_blend : stamp2_appear_albedo_blend;
                vec4 cur_color = is_swap ? stamp2_interact_albedo_color : stamp2_appear_albedo_color;
                float cur_emiss = is_swap ? stamp2_interact_emissive_intensity : stamp2_appear_emissive_intensity;
                float cur_block = is_swap ? stamp2_interact_light_blocker : stamp2_appear_light_blocker;
                float cur_rough = is_swap ? stamp2_interact_roughness_override : stamp2_appear_roughness_override;
                float cur_metal = is_swap ? stamp2_interact_metallic_override : stamp2_appear_metallic_override;
                float cur_foil = is_swap ? stamp2_interact_iridescent_foil : stamp2_appear_iridescent_foil;
                float cur_transp = is_swap ? stamp2_interact_cap_transparency : stamp2_appear_cap_transparency;
                int cur_blend_mode = is_swap ? stamp2_interact_albedo_blend_mode : stamp2_appear_albedo_blend_mode;

                float w2 = max(0.001, stamp2_bevel_width);
                float c2 = stamp2_bevel_curve;
                float h_c = pow(clamp((d_center - 0.5) / w2, 0.0, 1.0), c2);
                float h_l = pow(clamp((d_l - 0.5) / w2, 0.0, 1.0), c2);
                float h_r = pow(clamp((d_r - 0.5) / w2, 0.0, 1.0), c2);
                float h_u = pow(clamp((d_u - 0.5) / w2, 0.0, 1.0), c2);
                float h_d = pow(clamp((d_d - 0.5) / w2, 0.0, 1.0), c2);

                float dx = (h_l - h_r) * 15.0;
                float dy = (h_u - h_d) * 15.0;

                vec2 current_depth_xy = (stamp2_depth_split_axis ? stamp2_depth_split_xy : vec2(stamp2_depth)) * stamp2_base_opacity;
                if (stamp2_interact_press_depth_link > 0.0) current_depth_xy *= mix(1.0, abs(tilt_amount) * 2.0, stamp2_interact_press_depth_link);
                
                vec3 st_norm = vec3(dx, dy, 1.0 / max(0.01, abs(current_depth_xy.x)));
                st_norm.xy *= current_depth_xy;
                if (current_depth_xy.x < 0.0) st_norm.xy *= -1.0;
                base_normal = normalize(base_normal + st_norm * cap_mask);
                
                float color_mask = smoothstep(stamp2_appear_albedo_margin, stamp2_appear_albedo_margin + 0.01, s0);
                stamp_albedo_acc = apply_blend(stamp_albedo_acc, vec4(cur_color.rgb, cur_color.a * color_mask * cur_blend * s_mask), cur_blend_mode);
                
                if (cur_foil > 0.0) {
                    vec3 irid_view = vec3(0.0, 0.0, 1.0);
                    float mouse_fade = 1.0;
                    if (enable_mouse_light) {
                        float m_h = is_active ? active_mouse_light_height : inactive_mouse_light_height;
                        vec3 mouse_vec = vec3((px - heat_dist_offset) - mouse_position, m_h);
                        irid_view = normalize(mouse_vec);
                        if (stamp2_appear_irid_mouse_fade) mouse_fade = smoothstep(stamp2_appear_irid_fade_range, 0.0, length(mouse_vec));
                    }
                    float stamp_dot = max(0.0, dot(base_normal, irid_view));
                    float t = stamp_dot * stamp2_appear_irid_scale; 
                    vec3 irid_color;
                    if (stamp2_appear_irid_use_gradient) {
                        irid_color = texture(stamp2_appear_irid_gradient, vec2(fract(t), 0.5)).rgb;
                    } else {
                        irid_color = clamp(vec3(sin(t), sin(t + 2.094), sin(t + 4.188)) * 0.5 + 0.5, 0.0, 1.0);
                        irid_color = mix(vec3(dot(irid_color, vec3(0.333))), irid_color, stamp2_appear_irid_saturation);
                    }
                    stamp_albedo_acc = apply_blend(stamp_albedo_acc, vec4(irid_color, cur_foil * s_mask * mouse_fade), cur_blend_mode);
                }

                stamp_emissive_acc += cur_emiss * s_mask;
                stamp_blocker_acc += cur_block * s_mask;
                stamp_transparency_acc += cur_transp * s_mask;
                
                if (cur_rough >= 0.0) { stamp_roughness_val = mix(stamp_roughness_val, cur_rough, s_mask); stamp_roughness_blend = max(stamp_roughness_blend, s_mask); }
                if (cur_metal >= 0.0) { stamp_metallic_val = mix(stamp_metallic_val, cur_metal, s_mask); stamp_metallic_blend = max(stamp_metallic_blend, s_mask); }
                
                float shadow_val = max(0.0, dot(st_norm.xy, light_direction));
                stamp_shadow_acc += stamp2_depth_inset_shadow * shadow_val * 5.0 * s_mask;
                
                if (stamp2_depth_crevice_dirt > 0.0) {
                    float dirt_mask = pow(clamp(1.0 - h_c, 0.0, 1.0), stamp2_depth_dirt_contrast) * s_mask * stamp2_depth_crevice_dirt;
                    stamp_dirt_acc = apply_blend(stamp_dirt_acc, vec4(stamp2_depth_dirt_color.rgb, stamp2_depth_dirt_color.a * dirt_mask * stamp2_depth_dirt_opacity), 1);
                }
            }
        }
    }

    vec3 normal = base_normal;

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
        float cf_multiplier = 1.0;
        if (carbon_fiber_stamp_mask == 1) cf_multiplier = clamp(1.0 - global_stamp_mask, 0.0, 1.0);
        else if (carbon_fiber_stamp_mask == 2) cf_multiplier = clamp(global_stamp_mask, 0.0, 1.0);
        
        vec2 cf_uv = px * carbon_fiber_scale * 0.01;
        float pattern = step(0.5, fract(cf_uv.x)) == step(0.5, fract(cf_uv.y)) ? 1.0 : -1.0;
        detail_normal.xy += pattern * carbon_fiber_intensity * (1.0 - bevel_factor) * cf_multiplier;
    }

    normal = normalize(normal + detail_normal * 0.15);

    final_cap_color.rgb = mix(final_cap_color.rgb, stamp_dirt_acc.rgb, stamp_dirt_acc.a);
    final_bevel_color.rgb = mix(final_bevel_color.rgb, stamp_dirt_acc.rgb, stamp_dirt_acc.a);
    final_cap_color.rgb = mix(final_cap_color.rgb, stamp_albedo_acc.rgb, stamp_albedo_acc.a);
    final_bevel_color.rgb = mix(final_bevel_color.rgb, stamp_albedo_acc.rgb, stamp_albedo_acc.a);

    float active_smoothness = mix(smoothness, bevel_smoothness_override, bevel_factor * step(0.0, bevel_smoothness_override));
    active_smoothness = mix(active_smoothness, stamp_roughness_val, stamp_roughness_blend);

    vec3 light_3d = normalize(vec3(-light_direction, 0.65)); 
    
    float diff_shade = max(0.0, dot(normal, light_3d));
    vec3 ambient_diffuse = vec3(clamp(1.0 + diff_shade * (bevel_highlight - bevel_shadow), 0.15, 2.0));
    
    ambient_diffuse *= 1.0 - clamp(stamp_shadow_acc, 0.0, 1.0);
    
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
    
    float current_metallic = stamp_metallic_blend * stamp_metallic_val;
    float glint_mult = 1.0 + (miter_blend * edge_catching_glint * bevel_factor);
    float spec = pow(spec_factor, shininess) * (specular_intensity + current_metallic * 2.0) * glint_mult;
    
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

    float stamp_light_pass = clamp(1.0 - stamp_blocker_acc, 0.0, 1.0);
    total_cap_glow *= stamp_light_pass;
    total_side_glow *= stamp_light_pass;
    bulb_vis *= stamp_light_pass;
    bulb_mask *= stamp_light_pass;

    vec3 effective_backlight_color = enable_dual_layer_hue ? mix(secondary_subsurface_hue.rgb, backlight_color.rgb, clamp(total_side_glow, 0.0, 1.0)) : backlight_color.rgb;

    float edge_glow_boost = smoothstep(0.0, 2.0, raw_slope_progression);
    float cap_glow = (total_cap_glow * (1.0 - frosted_diffusion) + edge_glow_boost * frosted_diffusion) * active_mult * seam_darken;
    cap_glow *= mix(1.0, clamp(detail_normal.z, 0.0, 1.0), backlight_texture_reveal);

    vec4 cap_layer = final_cap_color;
    cap_layer.a *= clamp(1.0 - (cap_transparency + stamp_transparency_acc), 0.0, 1.0);
    
    vec4 cap_final = mix(cap_layer, bulb_vis, bulb_mask * (1.0 - cap_layer.a)) + vec4(effective_backlight_color * cap_glow, cap_glow);
    cap_final.rgb += stamp_albedo_acc.rgb * stamp_emissive_acc * max(active_mult, 0.1);

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
    
    vec4 glaze_color = vec4(fresnel_color.rgb * fresnel, fresnel * (environment_reflectivity + current_metallic * 0.5)) + vec4(vec3(spec), spec * 0.5); 
    
    if (enable_mouse_light) {
        vec4 current_m_color = is_active ? active_mouse_light_color : inactive_mouse_light_color;
        float current_m_intensity = is_active ? active_mouse_light_intensity : inactive_mouse_light_intensity;
        float current_m_range = is_active ? active_mouse_light_range : inactive_mouse_light_range;
        float current_m_height = is_active ? active_mouse_light_height : inactive_mouse_light_height;

        vec3 mouse_light_vec = vec3((px - heat_dist_offset) - mouse_position, current_m_height);
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