
vec4 DistortFishEye(vec4 p)
{
    vec2 v = p.xy / p.w;
    float radius = length(v);// Convert to polar coords
    if (radius > 0.0)
    {
      float theta = atan(v.y,v.x);
      
      radius = pow(radius, 0.93);// Distort:

      v.x = radius * cos(theta);// Convert back to Cartesian
      v.y = radius * sin(theta);
      p.xy = v.xy * p.w;
    }
    return p;
}