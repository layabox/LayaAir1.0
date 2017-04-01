attribute vec2 position;
attribute vec2 texcoord;
attribute vec4 color;
uniform vec2 size;
uniform mat4 mul_mmat;
varying vec2 v_texcoord;
varying vec4 v_color;
void main() {
  vec4 pos=mul_mmat*vec4(position.x,position.y,0,1 );
  gl_Position = vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,pos.z,1.0);
  v_color = color;
  v_texcoord = texcoord;  
}