attribute vec4 position;
attribute vec3 a_color;
uniform mat4 mmat;
uniform mat4 u_mmat2;
uniform vec2 u_pos;
uniform vec2 size;
varying vec3 color;
void main(){
  vec4 tPos = vec4(position.x + u_pos.x,position.y + u_pos.y,position.z,position.w);
  vec4 pos=mmat*u_mmat2*tPos;
  gl_Position =vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,pos.z,1.0);
  color=a_color;
}