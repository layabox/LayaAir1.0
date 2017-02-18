class ShaderPrecompileSample {
    private skinMesh: Laya.MeshSprite3D;
    private skinAni: Laya.SkinAnimations;

    constructor() {

        Laya3D.init(0, 0,true);

        //开启Shader编译调试模式，可在输出宏定义编译值。
        Laya.ShaderCompile3D.debugMode = true;

        var sc = Laya.ShaderCompile3D.get("SIMPLE");
        //部分低端移动设备不支持高精度shader,所以如果在PC端或高端移动设备输出的宏定义值需做判断移除高精度宏定义
        if (Laya.WebGL.frameShaderHighPrecision)
            sc.precompileShaderWithShaderDefine(2889);
        else
            sc.precompileShaderWithShaderDefine(2889 - Laya.ShaderCompile3D.SHADERDEFINE_FSHIGHPRECISION);

        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        var scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

        var camera = (scene.addChild(new Laya.Camera(0, 0.1, 100))) as Laya.Camera;
        camera.transform.translate(new Laya.Vector3(0, 0.8, 1.0));
        camera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
        camera.clearColor = null;

        var directionLight = scene.addChild(new Laya.DirectionLight()) as Laya.DirectionLight;
        directionLight.direction = new Laya.Vector3(0, -0.8, -1);
        directionLight.ambientColor = new Laya.Vector3(0.7, 0.6, 0.6);
        directionLight.specularColor = new Laya.Vector3(2.0, 2.0, 1.6);
        directionLight.diffuseColor = new Laya.Vector3(1, 1, 1);

        this.skinMesh = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/skinModel/dude/dude-him.lm"))) as Laya.MeshSprite3D;
        this.skinMesh.transform.localRotationEuler = new Laya.Vector3(0, 3.14, 0);
        this.skinAni = this.skinMesh.addComponent(Laya.SkinAnimations) as Laya.SkinAnimations;
        this.skinAni.templet = Laya.AnimationTemplet.load("../../res/threeDimen/skinModel/dude/dude.ani");
        this.skinAni.player.play();
    }
}
new ShaderPrecompileSample();