shader_type canvas_item;

uniform bool effect_enabled = true;
uniform bool ignore_alpha = false;
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

group_uniforms Color_Matching;
uniform vec4 source_color_val : source_color = vec4(0.20392, 0.95294, 1.0, 1.0);
uniform bool use_color_range = false;
uniform vec4 source_color_max : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform bool invert_match = false;

group_uniforms RGB_Channel_Masking;
uniform bool match_red = true;
uniform bool match_green = true;
uniform bool match_blue = true;

group_uniforms HSV_Matching;
uniform bool use_hsv_matching = false;
uniform bool hue_only_matching = false;
uniform vec3 hsv_tolerance = vec3(1.0, 1.0, 1.0);

group_uniforms Gradient_Settings;
uniform bool use_local_space = false;
uniform sampler2D gradient_texture : filter_linear;
uniform int gradient_type : hint_enum("Linear", "Radial", "Reflected", "Conic") = 0;
uniform bool clamp_gradient = false;

group_uniforms Gradient_Transform;
uniform float linear_angle : hint_range(0.0, 360.0) = 0.0;
uniform vec2 radial_center = vec2(0.5, 0.5);
uniform bool correct_aspect_ratio = false;
uniform float gradient_scale : hint_range(0.1, 10.0) = 1.0;
uniform float gradient_offset : hint_range(0.0, 1.0) = 0.0;

group_uniforms Offset_Animation;
uniform bool animate_offset = false;
uniform sampler2D offset_curve : hint_default_white, filter_linear;
uniform float offset_animation_speed : hint_range(0.0, 10.0) = 1.0;

group_uniforms Opacity_Animation;
uniform bool animate_opacity = false;
uniform sampler2D opacity_curve : hint_default_white, filter_linear;
uniform float opacity_animation_speed : hint_range(0.0, 10.0) = 1.0;
uniform float opacity : hint_range(0.0, 1.0) = 1.0;

group_uniforms Settings;
uniform float tolerance : hint_range(0.0, 1.0) = 0.5;
uniform float gradient_smoothing : hint_range(0.0, 0.5) = 0.05;
group_uniforms; 

// --- OPTIMIZED SHARED VARYINGS ---
varying vec3 v_color_min;
varying vec3 v_color_max;
varying vec3 v_tolerance_mask;

// Packed math data to save interpolator bandwidth
// x = dynamic_offset, y = dynamic_opacity
varying vec2 v_dynamic_data;
// xy = radial_center, zw = linear_direction
varying vec4 v_transform_data;
varying vec2 v_smooth_bounds;

// Standard branchless RGB to HSV converter
vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

void vertex() {
    if (effect_enabled) {
        // 1. Safety epsilon added to prevent smoothstep divide-by-zero
        v_smooth_bounds = vec2(tolerance - gradient_smoothing, tolerance + gradient_smoothing + 0.0001);
        
        // 2. Varying Aliasing: Precompute RGB or HSV strictly into shared registers
        if (use_hsv_matching) {
            vec3 hsv_source = rgb2hsv(source_color_val.rgb);
            if (use_color_range) {
                vec3 hsv_max = rgb2hsv(source_color_max.rgb);
                v_color_min = min(hsv_source, hsv_max);
                v_color_max = max(hsv_source, hsv_max);
            } else {
                v_color_min = hsv_source;
                v_color_max = hsv_source;
            }
            vec3 mask = hue_only_matching ? vec3(1.0, 0.0, 0.0) : vec3(1.0, 1.0, 1.0);
            v_tolerance_mask = (tolerance / max(hsv_tolerance, vec3(0.0001))) * mask;
        } else {
            if (use_color_range) {
                v_color_min = min(source_color_val.rgb, source_color_max.rgb);
                v_color_max = max(source_color_val.rgb, source_color_max.rgb);
            } else {
                v_color_min = source_color_val.rgb;
                v_color_max = source_color_val.rgb;
            }
            v_tolerance_mask = vec3(float(match_red), float(match_green), float(match_blue));
        }
        
        // 3. Precompute Transformation Vectors
        v_transform_data.xy = radial_center;
        
        if (gradient_type == 0 && linear_angle != 0.0) {
            float a = radians(linear_angle);
            v_transform_data.zw = vec2(cos(a), -sin(a));
        } else {
            v_transform_data.zw = vec2(0.0, 0.0);
        }
        
        // 4. Texture Fetch Eradication: Read animation curves globally in vertex!
        v_dynamic_data.x = gradient_offset;
        if (animate_offset) {
            v_dynamic_data.x += textureLod(offset_curve, vec2(fract(TIME * offset_animation_speed), 0.5), 0.0).r;
        }
        
        v_dynamic_data.y = opacity;
        if (animate_opacity) {
            v_dynamic_data.y *= textureLod(opacity_curve, vec2(fract(TIME * opacity_animation_speed), 0.5), 0.0).r;
        }
    }
}

void fragment() {
    vec4 screen_color = texture(screen_texture, SCREEN_UV);
    vec3 final_rgb = screen_color.rgb;
    float final_alpha = ignore_alpha ? 1.0 : screen_color.a;
    
    if (effect_enabled) {
        float dist = 0.0;
        
        // Shared color matching logic via Aliased Varyings
        if (use_hsv_matching) {
            vec3 hsv_screen = rgb2hsv(screen_color.rgb);
            vec3 diff = hsv_screen - clamp(hsv_screen, v_color_min, v_color_max);
            diff.x = min(abs(diff.x), 1.0 - abs(diff.x)); // Circular Hue wrap
            dist = length(diff * v_tolerance_mask);
        } else {
            vec3 diff = screen_color.rgb - clamp(screen_color.rgb, v_color_min, v_color_max);
            dist = length(diff * v_tolerance_mask);
        }
        
        // Mask calculation
        float match_val = smoothstep(v_smooth_bounds.x, v_smooth_bounds.y, dist);
        float match = invert_match ? match_val : (1.0 - match_val);
        
        // Factor in the dynamic opacity fetched in vertex (v_dynamic_data.y)
        float blend_factor = match * v_dynamic_data.y;
        
        // Skip all heavy UV and gradient logic if pixel is unmatched OR completely transparent
        if (blend_factor > 0.0) {
            vec2 base_uv = use_local_space ? UV : SCREEN_UV;
            vec2 aspect_uv = base_uv;
            vec2 center = v_transform_data.xy;
            
            // Aspect ratio math MUST be inside fragment, but we only calculate it on matched pixels
            if (correct_aspect_ratio) {
                float aspect = use_local_space ? (TEXTURE_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.x) : (SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x);
                aspect_uv.x *= aspect;
                center.x *= aspect;
            }
            
            float raw_grad_uv = 0.0;
            
            // 5. Lean gradient switch block using precomputed transforms
            switch (gradient_type) {
                case 0: // Linear
                    raw_grad_uv = (linear_angle != 0.0) ? (dot(base_uv - 0.5, v_transform_data.zw) + 0.5) : base_uv.x;
                    break;
                case 1: // Radial
                    raw_grad_uv = distance(aspect_uv, center) * 1.41421356;
                    break;
                case 2: // Reflected
                    raw_grad_uv = abs(fract(base_uv.x) - 0.5) * 2.0;
                    break;
                case 3: // Conic
                    raw_grad_uv = (atan(aspect_uv.y - center.y, aspect_uv.x - center.x) + PI) / TAU;
                    break;
            }
            
            // Offset and Scale using pre-read vertex animation data
            float grad_uv = raw_grad_uv * gradient_scale + v_dynamic_data.x;
            grad_uv = clamp_gradient ? clamp(grad_uv, 0.0, 1.0) : fract(grad_uv);
            
            vec3 gradient_color = texture(gradient_texture, vec2(grad_uv, 0.5)).rgb;
            final_rgb = mix(screen_color.rgb, gradient_color, blend_factor);
        }
    }
    
    COLOR = vec4(final_rgb, final_alpha);
}