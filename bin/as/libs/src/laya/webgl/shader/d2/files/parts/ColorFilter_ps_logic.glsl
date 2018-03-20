mat4 alphaMat =colorMat;

alphaMat[0][3] *= gl_FragColor.a;
alphaMat[1][3] *= gl_FragColor.a;
alphaMat[2][3] *= gl_FragColor.a;

gl_FragColor = gl_FragColor * alphaMat;
gl_FragColor += colorAlpha/255.0*gl_FragColor.a;
