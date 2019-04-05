#version 110

// Data to pass to fragment shader
varying vec4 var_Color;
varying vec3 var_Normal;
varying vec2 var_TexCoord;

void main() {
  gl_Position = ftransform();
  var_Color = gl_Color;
  var_Normal = gl_Normal;
  var_TexCoord = gl_MultiTexCoord0.xy;
}