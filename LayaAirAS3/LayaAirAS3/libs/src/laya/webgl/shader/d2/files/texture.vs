attribute vec4 position;
attribute vec2 texcoord;
uniform vec2 size;
uniform mat4 mmat;
varying vec2 v_texcoord;

#include?BLUR_FILTER  "parts/BlurFilter_vs_uniform.glsl";
void main() {
  vec4 pos=mmat*position;
  gl_Position =vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,pos.z,1.0);
  v_texcoord = texcoord;
  #include?BLUR_FILTER  "parts/BlurFilter_vs_logic.glsl";
}