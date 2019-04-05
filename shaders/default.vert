#version 110

uniform int in_Time;

// Data to pass to fragment shader
varying vec4 var_Color;
varying vec3 var_Normal;
varying vec2 var_TexCoord;
varying float var_Time;

void main() {
  gl_Position = ftransform();
  var_Color = gl_Color;
  var_Normal = gl_Normal;
  var_TexCoord = gl_MultiTexCoord0.xy;
  var_Time = float(in_Time) / 1000.0;
}