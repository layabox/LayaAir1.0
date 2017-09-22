class Shader_Terrain {
    constructor() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        this.initShader();

        var scene: Laya.Scene = Laya.stage.addChild(Laya.Scene.load("../../res/threeDimen/scene/terrain/terrain.ls")) as Laya.Scene;

        var camera: Laya.Camera = scene.addChild(new Laya.Camera(0, 0.1, 1000)) as Laya.Camera;
        camera.transform.rotate(new Laya.Vector3(-38, 180, 0), false, false);
        camera.transform.translate(new Laya.Vector3(-5, 20, -30), false);
        camera.addComponent(CameraMoveScript);

        scene.once(Laya.Event.HIERARCHY_LOADED, this, function (): void {
            this.setCustomMaterial(scene.getChildAt(2));
        });
    }
    public setCustomMaterial(spirit3D: Laya.Sprite3D): void {

        if (spirit3D instanceof Laya.MeshSprite3D) {

            var meshSprite3D: Laya.MeshSprite3D = spirit3D as Laya.MeshSprite3D;
            var customMaterial: CustomTerrainMaterial = new CustomTerrainMaterial();
            customMaterial.splatAlphaTexture = Laya.Texture2D.load("../../res/threeDimen/scene/terrain/terrain/splatalpha 0.png");
            customMaterial.lightMapTexture = Laya.Texture2D.load("../../res/threeDimen/scene/terrain/Assets/Scenes/Level/XunLongShi/Lightmap-0_comp_light.png");
            customMaterial.diffuseTexture1 = Laya.Texture2D.load("../../res/threeDimen/scene/terrain/terrain/ground_01.jpg");
            customMaterial.diffuseTexture2 = Laya.Texture2D.load("../../res/threeDimen/scene/terrain/terrain/ground_02.jpg");
            customMaterial.diffuseTexture3 = Laya.Texture2D.load("../../res/threeDimen/scene/terrain/terrain/ground_03.jpg");
            customMaterial.diffuseTexture4 = Laya.Texture2D.load("../../res/threeDimen/scene/terrain/terrain/ground_04.jpg");
            customMaterial.setDiffuseScale1(new Laya.Vector2(27.92727, 27.92727));
            customMaterial.setDiffuseScale2(new Laya.Vector2(13.96364, 13.96364));
            customMaterial.setDiffuseScale3(new Laya.Vector2(18.61818, 18.61818));
            customMaterial.setDiffuseScale4(new Laya.Vector2(13.96364, 13.96364));
            customMaterial.ambientColor = new Laya.Vector3(1, 1, 1);
            customMaterial.diffuseColor = new Laya.Vector3(1, 1, 1);
            customMaterial.specularColor = new Laya.Vector4(1, 1, 1, 8);
            customMaterial.setLightmapScaleOffset(new Laya.Vector4(0.8056641, 0.8056641, 0.001573598, -6.878261E-11));
            meshSprite3D.meshRender.sharedMaterial = customMaterial;
        }

        for (var i: number = 0, n: number = spirit3D._childs.length; i < n; i++)
            this.setCustomMaterial(spirit3D._childs[i]);
    }

    private initShader(): void {

        var attributeMap = {
            'a_Position': Laya.VertexElementUsage.POSITION0,
            'a_Normal': Laya.VertexElementUsage.NORMAL0,
            'a_Texcoord0': Laya.VertexElementUsage.TEXTURECOORDINATE0,
            'a_Texcoord1': Laya.VertexElementUsage.TEXTURECOORDINATE1
        };
        var uniformMap = {
            'u_MvpMatrix': [Laya.Sprite3D.MVPMATRIX, Laya.Shader3D.PERIOD_SPRITE],
            'u_WorldMat': [Laya.Sprite3D.WORLDMATRIX, Laya.Shader3D.PERIOD_SPRITE],
            'u_CameraPos': [Laya.BaseCamera.CAMERAPOS, Laya.Shader3D.PERIOD_CAMERA],
            'u_SplatAlphaTexture': [CustomTerrainMaterial.SPLATALPHATEXTURE, Laya.Shader3D.PERIOD_MATERIAL],
            'u_NormalTexture': [CustomTerrainMaterial.NORMALTEXTURE, Laya.Shader3D.PERIOD_MATERIAL],
            'u_LightMapTexture': [CustomTerrainMaterial.LIGHTMAPTEXTURE, Laya.Shader3D.PERIOD_MATERIAL],
            'u_DiffuseTexture1': [CustomTerrainMaterial.DIFFUSETEXTURE1, Laya.Shader3D.PERIOD_MATERIAL],
            'u_DiffuseTexture2': [CustomTerrainMaterial.DIFFUSETEXTURE2, Laya.Shader3D.PERIOD_MATERIAL],
            'u_DiffuseTexture3': [CustomTerrainMaterial.DIFFUSETEXTURE3, Laya.Shader3D.PERIOD_MATERIAL],
            'u_DiffuseTexture4': [CustomTerrainMaterial.DIFFUSETEXTURE4, Laya.Shader3D.PERIOD_MATERIAL],
            'u_DiffuseTexture5': [CustomTerrainMaterial.DIFFUSETEXTURE5, Laya.Shader3D.PERIOD_MATERIAL],
            'u_DiffuseScale1': [CustomTerrainMaterial.DIFFUSESCALE1, Laya.Shader3D.PERIOD_MATERIAL],
            'u_DiffuseScale2': [CustomTerrainMaterial.DIFFUSESCALE2, Laya.Shader3D.PERIOD_MATERIAL],
            'u_DiffuseScale3': [CustomTerrainMaterial.DIFFUSESCALE3, Laya.Shader3D.PERIOD_MATERIAL],
            'u_DiffuseScale4': [CustomTerrainMaterial.DIFFUSESCALE4, Laya.Shader3D.PERIOD_MATERIAL],
            'u_DiffuseScale5': [CustomTerrainMaterial.DIFFUSESCALE5, Laya.Shader3D.PERIOD_MATERIAL],
            'u_lightmapScaleOffset': [CustomTerrainMaterial.LIGHTMAPSCALEOFFSET, Laya.Shader3D.PERIOD_MATERIAL],
            'u_MaterialDiffuse': [CustomTerrainMaterial.MATERIALDIFFUSE, Laya.Shader3D.PERIOD_MATERIAL],
            'u_MaterialAmbient': [CustomTerrainMaterial.MATERIALAMBIENT, Laya.Shader3D.PERIOD_MATERIAL],
            'u_MaterialSpecular': [CustomTerrainMaterial.MATERIALSPECULAR, Laya.Shader3D.PERIOD_MATERIAL],
            'u_DirectionLight.Direction': [Laya.Scene.LIGHTDIRECTION, Laya.Shader3D.PERIOD_SCENE],
            'u_DirectionLight.Diffuse': [Laya.Scene.LIGHTDIRDIFFUSE, Laya.Shader3D.PERIOD_SCENE]
        };
        var customTerrianShader: number = Laya.Shader3D.nameKey.add("CustomTerrainShader");
        var vs: string = "attribute vec4 a_Position;\nattribute vec2 a_Texcoord0;\nattribute vec2 a_Texcoord1;\n\nuniform mat4 u_MvpMatrix;\nuniform mat4 u_WorldMat;\nuniform vec4 u_lightmapScaleOffset;\n\nattribute vec3 a_Normal;\n\nvarying vec3 v_Normal;\n\nvarying vec3 v_PositionWorld;\n\nvarying vec2 v_Texcoord0;\nvarying vec2 v_Texcoord1;\n\nvoid main()\n{\n  gl_Position = u_MvpMatrix * a_Position;\n  \n  v_Normal = a_Normal;\n  v_Texcoord0 = a_Texcoord0;\n  v_PositionWorld = (u_WorldMat*a_Position).xyz;\n  \n  #ifdef CUSTOM_LIGHTMAP\n	//v_Texcoord1 = a_Texcoord0  * u_lightmapScaleOffset.xy + u_lightmapScaleOffset.zw;\n	v_Texcoord1 = vec2(a_Texcoord0.x*u_lightmapScaleOffset.x+u_lightmapScaleOffset.z,(a_Texcoord0.y-1.0)*u_lightmapScaleOffset.y+u_lightmapScaleOffset.w);\n  #endif\n}";
        var ps: string = "#ifdef FSHIGHPRECISION\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\n#include \"LightHelper.glsl\";\n\nuniform sampler2D u_SplatAlphaTexture;\nuniform sampler2D u_NormalTexture;\nuniform sampler2D u_LightMapTexture;\n\nuniform sampler2D u_DiffuseTexture1;\nuniform sampler2D u_DiffuseTexture2;\nuniform sampler2D u_DiffuseTexture3;\nuniform sampler2D u_DiffuseTexture4;\nuniform sampler2D u_DiffuseTexture5;\n\nuniform vec2 u_DiffuseScale1;\nuniform vec2 u_DiffuseScale2;\nuniform vec2 u_DiffuseScale3;\nuniform vec2 u_DiffuseScale4;\nuniform vec2 u_DiffuseScale5;\n\nuniform DirectionLight u_DirectionLight;\n\nuniform vec3 u_MaterialDiffuse;\nuniform vec3 u_MaterialAmbient;\nuniform vec4 u_MaterialSpecular;\nuniform vec3 u_CameraPos;\n           \nvarying vec3 v_PositionWorld;\nvarying vec3 v_Normal;\nvarying vec2 v_Texcoord0;\nvarying vec2 v_Texcoord1;\n\nvoid main()\n{\n	#ifdef CUSTOM_DETAIL_NUM1\n		vec4 splatAlpha = texture2D(u_SplatAlphaTexture, v_Texcoord);\n		vec4 color1 = texture2D(u_DiffuseTexture1, v_Texcoord0 * u_DiffuseScale1);\n		gl_FragColor.xyz = color1.xyz * splatAlpha.r;\n	#endif\n	#ifdef CUSTOM_DETAIL_NUM2\n		vec4 splatAlpha = texture2D(u_SplatAlphaTexture, v_Texcoord0);\n		vec4 color1 = texture2D(u_DiffuseTexture1, v_Texcoord0 * u_DiffuseScale1);\n		vec4 color2 = texture2D(u_DiffuseTexture2, v_Texcoord0 * u_DiffuseScale2);\n		gl_FragColor.xyz = color1.xyz * splatAlpha.r + color2.xyz * (1.0 - splatAlpha.r);\n	#endif\n	#ifdef CUSTOM_DETAIL_NUM3\n		vec4 splatAlpha = texture2D(u_SplatAlphaTexture, v_Texcoord0);\n		vec4 color1 = texture2D(u_DiffuseTexture1, v_Texcoord0 * u_DiffuseScale1);\n		vec4 color2 = texture2D(u_DiffuseTexture2, v_Texcoord0 * u_DiffuseScale2);\n		vec4 color3 = texture2D(u_DiffuseTexture3, v_Texcoord0 * u_DiffuseScale3);\n		gl_FragColor.xyz = color1.xyz * splatAlpha.r  + color2.xyz * splatAlpha.g + color3.xyz * (1.0 - splatAlpha.r - splatAlpha.g);\n	#endif\n	#ifdef CUSTOM_DETAIL_NUM4\n		vec4 splatAlpha = texture2D(u_SplatAlphaTexture, v_Texcoord0);\n		vec4 color1 = texture2D(u_DiffuseTexture1, v_Texcoord0 * u_DiffuseScale1);\n		vec4 color2 = texture2D(u_DiffuseTexture2, v_Texcoord0 * u_DiffuseScale2);\n		vec4 color3 = texture2D(u_DiffuseTexture3, v_Texcoord0 * u_DiffuseScale3);\n		vec4 color4 = texture2D(u_DiffuseTexture4, v_Texcoord0 * u_DiffuseScale4);\n		gl_FragColor.xyz = color1.xyz * splatAlpha.r  + color2.xyz * splatAlpha.g + color3.xyz * splatAlpha.b + color4.xyz * (1.0 - splatAlpha.r - splatAlpha.g - splatAlpha.b);\n	#endif\n	#ifdef CUSTOM_DETAIL_NUM5\n		vec4 splatAlpha = texture2D(u_SplatAlphaTexture, v_Texcoord0);\n		vec4 color1 = texture2D(u_DiffuseTexture1, v_Texcoord0 * u_DiffuseScale1);\n		vec4 color2 = texture2D(u_DiffuseTexture2, v_Texcoord0 * u_DiffuseScale2);\n		vec4 color3 = texture2D(u_DiffuseTexture3, v_Texcoord0 * u_DiffuseScale3);\n		vec4 color4 = texture2D(u_DiffuseTexture4, v_Texcoord0 * u_DiffuseScale4);\n		vec4 color5 = texture2D(u_DiffuseTexture5, v_Texcoord0 * u_DiffuseScale5);\n		gl_FragColor.xyz = color1.xyz * splatAlpha.r  + color2.xyz * splatAlpha.g + color3.xyz * splatAlpha.b + color4.xyz * splatAlpha.a + color5.xyz * (1.0 - splatAlpha.r - splatAlpha.g - splatAlpha.b - splatAlpha.a);\n	#endif\n	\n	#ifdef CUSTOM_LIGHTMAP\n		gl_FragColor.rgb = gl_FragColor.rgb * (texture2D(u_LightMapTexture, v_Texcoord1).rgb) * 2.0;\n	#endif\n}\n\n\n\n";
        var customTerrainCompile3D: Laya.ShaderCompile3D = Laya.ShaderCompile3D.add(customTerrianShader, vs, ps, attributeMap, uniformMap);

        CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM1 = customTerrainCompile3D.registerMaterialDefine("CUSTOM_DETAIL_NUM1");
        CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM2 = customTerrainCompile3D.registerMaterialDefine("CUSTOM_DETAIL_NUM2");
        CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM3 = customTerrainCompile3D.registerMaterialDefine("CUSTOM_DETAIL_NUM3");
        CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM4 = customTerrainCompile3D.registerMaterialDefine("CUSTOM_DETAIL_NUM4");
        CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM5 = customTerrainCompile3D.registerMaterialDefine("CUSTOM_DETAIL_NUM5");
        CustomTerrainMaterial.SHADERDEFINE_LIGHTMAP = customTerrainCompile3D.registerMaterialDefine("CUSTOM_LIGHTMAP");

    }
}
new Shader_Terrain;