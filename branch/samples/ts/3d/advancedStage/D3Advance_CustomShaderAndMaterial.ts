module laya {

    export class CustomShaderAndMaterial{

        constructor(){

            Laya3D.init(0, 0,true);
            Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
            Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
            Laya.Stat.show();
            this.initShader();
            var scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

            var camera = scene.addChild(new Laya.Camera(0, 0.1, 100)) as Laya.Camera;
            camera.transform.translate(new Laya.Vector3(0, 0.8, 1.5));
            camera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);

            var mesh = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm"))) as Laya.MeshSprite3D;
            mesh.transform.localPosition = new Laya.Vector3(-0.3, 0.0, 0.0);
            mesh.transform.localScale = new Laya.Vector3(0.5, 0.5, 0.5);

            var customMaterial = new CustomMaterial();
            customMaterial.setDiffuseTexture(Laya.Texture2D.load("../../res/threeDimen/staticModel/sphere/gridWhiteBlack.jpg"));
            mesh.meshRender.sharedMaterial = customMaterial;
        }

        private initShader():void{

            var attributeMap = {
                'a_Position': Laya.VertexElementUsage.POSITION0,
                'a_Normal':Laya.VertexElementUsage.NORMAL0,
                'a_Texcoord': Laya.VertexElementUsage.TEXTURECOORDINATE0,
            };
            var uniformMap = {
                'u_MvpMatrix': [Laya.Sprite3D.MVPMATRIX, Laya.Shader3D.PERIOD_SPRITE], 
                'u_WorldMat': [Laya.Sprite3D.WORLDMATRIX, Laya.Shader3D.PERIOD_SPRITE],
                'u_texture': [CustomMaterial.DIFFUSETEXTURE, Laya.Shader3D.PERIOD_MATERIAL]
            };
            var customShader = Laya.Shader3D.nameKey.add("CustomShader");
            var vs = "attribute vec4 a_Position;\nattribute vec2 a_Texcoord;\n\nuniform mat4 u_MvpMatrix;\nuniform mat4 u_WorldMat;\n\nvarying vec2 v_Texcoord;\n\nattribute vec3 a_Normal;\nvarying vec3 v_Normal;\n\nvoid main()\n{\n  gl_Position = u_MvpMatrix * a_Position;\n  v_Texcoord=a_Texcoord;\n  \n mat3 worldMat=mat3(u_WorldMat);\n v_Normal=worldMat*a_Normal;\n}";
            var ps = "#ifdef FSHIGHPRECISION\nprecision highp float;\n#else\nprecision mediump float;\n#endif\n\nvarying vec2 v_Texcoord;\nuniform sampler2D u_texture;\n\nvarying vec3 v_Normal;\n\nvoid main()\n{	\n  gl_FragColor=texture2D(u_texture, v_Texcoord);\n  \n  vec3 lightDir=normalize(vec3(0,-1,0));//该法线要从外面传入，如果传入值不能保证归一化，需要在此处归一化\n  vec3 normal = normalize(v_Normal);\n  float intensity=dot(-lightDir,normal);\n  \n  vec4 color;\n  if(intensity>0.95)\n  color=vec4(1.0,0.5,0.5,1.0);\n  else if(intensity>0.5)\n  color=vec4(0.6,0.3,0.3,1.0);\n  else if(intensity>0.25)\n  color=vec4(0.4,0.2,0.2,1.0);\n  else\n  color=vec4(0.2,0.1,0.1,1.0);\n  \n  gl_FragColor=gl_FragColor*color;\n}\n\n";

            Laya.ShaderCompile3D.add(customShader, vs, ps, attributeMap, uniformMap);
        }
    }
}
new laya.CustomShaderAndMaterial();

