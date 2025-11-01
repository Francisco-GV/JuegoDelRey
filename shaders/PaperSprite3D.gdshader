shader_type spatial;
render_mode unshaded, blend_mix, depth_prepass_alpha, cull_disabled,
    specular_disabled;

uniform sampler2D u_sprite_texture : source_color, filter_linear;
uniform vec4 u_line_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float u_outline_size : hint_range(0.0, 20.0) = 2.0;
uniform float u_outline_softness : hint_range(0.0, 1.0) = 0.3;
uniform bool u_enable_billboard_y = true;
uniform float u_flip_h : hint_range(-1.0, 1.0) = -1.0;

void vertex() {
  vec3 vertex_position = VERTEX;

  vertex_position.x *= u_flip_h;

  if (u_enable_billboard_y) {
    vec3 camera_forward_dir =
        normalize((INV_VIEW_MATRIX * vec4(0.0, 0.0, -1.0, 0.0)).xyz);

    camera_forward_dir.y = 0.0;
    camera_forward_dir = normalize(camera_forward_dir);

    float facing_angle = atan(camera_forward_dir.x, camera_forward_dir.z);

    mat3 rotation_y = mat3(vec3(cos(facing_angle), 0.0, -sin(facing_angle)),
                           vec3(0.0, 1.0, 0.0),
                           vec3(sin(facing_angle), 0.0, cos(facing_angle)));

    vertex_position = rotation_y * vertex_position;
    NORMAL = rotation_y * NORMAL;
  }

  VERTEX = vertex_position;
}

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

    float border_alpha =
        smoothstep(0.0, u_outline_softness, max_neighbor_alpha);
    if (border_alpha > 0.0) {
      ALBEDO = u_line_color.rgb;
      ALPHA = border_alpha;
    }
  }
}