vec4 tcol = gl_FragColor;
tcol.xyz = (colorMat * gl_FragColor).xyz;
gl_FragColor = tcol + colorAlpha/255.0;