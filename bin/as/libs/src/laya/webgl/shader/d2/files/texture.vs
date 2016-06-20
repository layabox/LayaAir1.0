attribute vec4 position;
attribute vec2 texcoord;
uniform vec2 size;

#ifdef WORLDMAT
uniform mat4 mmat;
#endif
varying vec2 v_texcoord;

#include?BLUR_FILTER  "parts/BlurFilter_vs_uniform.glsl";
void main() {
  #ifdef WORLDMAT
  vec4 pos=mmat*position;
  gl_Position =vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,pos.z,1.0);
  #else
  gl_Position =vec4((position.x/size.x-0.5)*2.0,(0.5-position.y/size.y)*2.0,position.z,1.0);
  #endif
  
  v_texcoord = texcoord;
  #include?BLUR_FILTER  "parts/BlurFilter_vs_logic.glsl";
}