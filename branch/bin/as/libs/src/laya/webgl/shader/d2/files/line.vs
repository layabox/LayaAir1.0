attribute vec4 position;
uniform vec2 size;
uniform mat4 mmat;
void main() {
  vec4 pos=mmat*position;
  gl_Position =vec4((pos.x/size.x-0.5)*2.0,(0.5-pos.y/size.y)*2.0,pos.z,1.0);
}