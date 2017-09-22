uniform vec4 strength_sig2_2sig2_gauss1;
uniform vec2 blurInfo;

#define PI 3.141593

//float sigma=strength/3.0;//3σ以外影响很小。即当σ=1的时候，半径为3
//float sig2 = sigma*sigma;
//float _2sig2 = 2.0*sig2;
//return 1.0/(2*PI*sig2)*exp(-(x*x+y*y)/_2sig2)
//float gauss1 = 1.0/(2.0*PI*sig2);

float getGaussian(float x, float y){
    return strength_sig2_2sig2_gauss1.w*exp(-(x*x+y*y)/strength_sig2_2sig2_gauss1.z);
}

vec4 blur(){
    const float blurw = 9.0;
    vec4 vec4Color = vec4(0.0,0.0,0.0,0.0);
    vec2 halfsz=vec2(blurw,blurw)/2.0/blurInfo;    
    vec2 startpos=v_texcoord-halfsz;
    vec2 ctexcoord = startpos;
    vec2 step = 1.0/blurInfo;  //每个像素      
    
    for(float y = 0.0;y<=blurw; ++y){
        ctexcoord.x=startpos.x;
        for(float x = 0.0;x<=blurw; ++x){
            //TODO 纹理坐标的固定偏移应该在vs中处理
            vec4Color += texture2D(texture, ctexcoord)*getGaussian(x-blurw/2.0,y-blurw/2.0);
            ctexcoord.x+=step.x;
        }
        ctexcoord.y+=step.y;
    }
    return vec4Color;
}