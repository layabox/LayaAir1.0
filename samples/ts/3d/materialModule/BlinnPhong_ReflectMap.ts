class BlinnPhong_ReflectMap {
    private rotation:Laya.Vector3 = new Laya.Vector3(0, 0.01, 0);
    constructor() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        var scene: Laya.Scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

        var camera: Laya.Camera = (scene.addChild(new Laya.Camera(0, 0.1, 100))) as Laya.Camera;
        camera.transform.translate(new Laya.Vector3(0, 1.3, 1.8));
        camera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
        camera.clearFlag = Laya.BaseCamera.CLEARFLAG_SKY;

        var directionLight: Laya.DirectionLight = scene.addChild(new Laya.DirectionLight()) as Laya.DirectionLight;
        directionLight.direction = new Laya.Vector3(0, -0.8, -1);
        directionLight.color = new Laya.Vector3(1, 1, 1);

        var textureCube: Laya.TextureCube = Laya.TextureCube.load("../../res/threeDimen/skyBox/skyBox1/skyCube.ltc");

        var skyBox: Laya.SkyBox = new Laya.SkyBox();
        skyBox.textureCube = textureCube;
        camera.sky = skyBox;

        var teapot1: Laya.MeshSprite3D = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/staticModel/teapot/teapot-Teapot001.lm"))) as Laya.MeshSprite3D;
        teapot1.transform.position = new Laya.Vector3(-0.8, 0, 0);
        teapot1.transform.rotation = new Laya.Quaternion(0.7071068, 0, 0, -0.7071067);

        var teapot2: Laya.MeshSprite3D = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/staticModel/teapot/teapot-Teapot001.lm"))) as Laya.MeshSprite3D;
        teapot2.transform.position = new Laya.Vector3(0.8, 0, 0);
        teapot2.transform.rotation = new Laya.Quaternion(0.7071068, 0, 0, -0.7071067);
        teapot2.meshFilter.sharedMesh.once(Laya.Event.LOADED, null, function (): void {
            var material: Laya.BlinnPhongMaterial = teapot2.meshRender.material as Laya.BlinnPhongMaterial;
            //反射贴图
            material.reflectTexture = textureCube;
        });

        Laya.timer.frameLoop(1, this, function (): void {
            teapot1.transform.rotate(this.rotation, false);
            teapot2.transform.rotate(this.rotation, false);
        });
    }
}
new BlinnPhong_ReflectMap();