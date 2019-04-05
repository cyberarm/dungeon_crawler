#version 110

uniform sampler2D in_Texture;

varying vec4 var_Color;
varying vec3 var_Normal;
varying vec2 var_TexCoord;
varying float var_Time;

float TWOPI = 2.0 * 3.14;

// TODO: Implement normal based lighting with respect to player position or world lights
vec4 getNormalLight(vec3 normal) {
  return vec4(normal, 1.0);
}

// Pulsing "global illumination"
vec4 lightCurve() {
  float brightness = 1.0;
  float freq = 1.0;
  float amp  = 0.5;
  float shift= 0.7;

  brightness = (amp * (sin((TWOPI * var_Time) * freq))) + shift;

  return vec4(brightness, brightness, brightness, 1.0);
}

void main() {
    vec3 color = texture2D(in_Texture, var_TexCoord).rgb;

    // "var_Color" contains intensity values so multiplying by the
    // texture color gives us the desired intesity
    gl_FragColor = (var_Color * vec4(color, 0.0));// * lightCurve();
}