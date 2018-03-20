gl_FragColor = vec4(colorAdd.rgb,colorAdd.a*gl_FragColor.a);
gl_FragColor.xyz *= colorAdd.a;