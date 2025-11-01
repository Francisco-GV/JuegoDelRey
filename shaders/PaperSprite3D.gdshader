shader_type spatial;
render_mode unshaded, blend_mix, depth_prepass_alpha, cull_disabled,
    specular_disabled;

uniform sampler2D u_sprite_texture : source_color, filter_linear;
uniform vec4 u_line_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float u_outline_size : hint_range(0.0, 20.0) = 2.0;

void fragment() {
  vec4 sprite_color = texture(u_sprite_texture, UV);
  ALBEDO = sprite_color.rgb;
  ALPHA = sprite_color.a;

  vec2 pixel_size = 1.0 / vec2(textureSize(u_sprite_texture, 0));

  if (ALPHA < 0.1) {
    float max_neighbor_alpha = 0.0;

    for (float x = -u_outline_size; x <= u_outline_size; x += 1.0) {
      for (float y = -u_outline_size; y <= u_outline_size; y += 1.0) {
        if (x == 0.0 && y == 0.0)
          continue;

        vec2 offset = vec2(x, y) * pixel_size;
        float neighbor_alpha = texture(u_sprite_texture, UV + offset).a;
        max_neighbor_alpha = max(max_neighbor_alpha, neighbor_alpha);
      }
    }

    if (max_neighbor_alpha > 0.1) {
      ALBEDO = u_line_color.rgb;
      ALPHA = 1.0;
    }
  }
}