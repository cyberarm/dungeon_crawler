#version 110

uniform sampler2D in_Texture;

varying vec4 var_Color;
varying vec3 var_Normal;
varying vec2 var_TexCoord;

// TODO: Implement normal based lighting with respect to player position or world lights
vec4 getNormalLight(vec3 normal) {
  return vec4(normal, 1.0);
}

void main()
{
    vec3 color = texture2D(in_Texture, var_TexCoord).rgb;

    // "var_Color" contains intensity values so multiplying by the
    // texture color gives us the desired intesity
    gl_FragColor = var_Color * vec4(color, 0.0);
}