class SkinAnimation_MultiSubMeshSample {
    private skinMesh: Laya.Mesh;
    private skinAni: Laya.SkinAnimations;

    constructor() {

        Laya.Laya3D.init(0, 0);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        var scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

        scene.currentCamera = (scene.addChild(new Laya.Camera(new Laya.Viewport(0, 0, Laya.stage.width, Laya.stage.height), Math.PI / 3, 0, 0.1, 100))) as Laya.Camera;
        scene.currentCamera.transform.translate(new Laya.Vector3(0, 0.8, 1.0));
        scene.currentCamera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
        scene.currentCamera.clearColor = null;
        Laya.stage.on(Laya.Event.RESIZE, null, () => {
            (scene.currentCamera as Laya.Camera).viewport = new Laya.Viewport(0, 0, Laya.stage.width, Laya.stage.height);
        });

        var directionLight = scene.addChild(new Laya.DirectionLight()) as Laya.DirectionLight;
        directionLight.direction = new Laya.Vector3(0, -0.8, -1);
        directionLight.ambientColor = new Laya.Vector3(0.7, 0.6, 0.6);
        directionLight.specularColor = new Laya.Vector3(2.0, 2.0, 1.6);
        directionLight.diffuseColor = new Laya.Vector3(1, 1, 1);
        scene.shadingMode = Laya.BaseScene.PIXEL_SHADING;

        this.skinMesh = scene.addChild(new Laya.Mesh()) as Laya.Mesh;
        this.skinMesh.load("threeDimen/skinModel/dude/dude-him.lm");
        this.skinMesh.transform.localRotationEuler = new Laya.Vector3(0, 3.14, 0);
        this.skinAni = this.skinMesh.addComponent(Laya.SkinAnimations) as Laya.SkinAnimations;
        this.skinAni.url = "threeDimen/skinModel/dude/dude.ani";
        this.skinAni.play();

    }
}
new SkinAnimation_MultiSubMeshSample();