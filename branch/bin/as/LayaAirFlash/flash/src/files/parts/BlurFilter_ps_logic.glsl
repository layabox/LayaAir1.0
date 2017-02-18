gl_FragColor=vec4(0.0);
gl_FragColor += texture2D(texture, vBlurTexCoords[ 0])*0.004431848411938341;
gl_FragColor += texture2D(texture, vBlurTexCoords[ 1])*0.05399096651318985;
gl_FragColor += texture2D(texture, vBlurTexCoords[ 2])*0.2419707245191454;
gl_FragColor += texture2D(texture, v_texcoord        )*0.3989422804014327;
gl_FragColor += texture2D(texture, vBlurTexCoords[ 3])*0.2419707245191454;
gl_FragColor += texture2D(texture, vBlurTexCoords[ 4])*0.05399096651318985;
gl_FragColor += texture2D(texture, vBlurTexCoords[ 5])*0.004431848411938341;