class StaticModel_MeshSkySample {

    private skySprite3D: Laya.Sprite3D;
    private camera: Laya.Camera;

    constructor() {

        Laya3D.init(0, 0,true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        var scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

        this.camera = new Laya.Camera(0, 0.1, 100);
        scene.currentCamera = (scene.addChild(this.camera)) as Laya.Camera;
        scene.currentCamera.transform.translate(new Laya.Vector3(0.3, 0.3, 0.6));
        scene.currentCamera.transform.rotate(new Laya.Vector3(-12, 0, 0), true, false);


        scene.currentCamera.addComponent(CameraMoveScript);

        this.skySprite3D = scene.addChild(new Laya.Sprite3D()) as Laya.Sprite3D;
        var skySampleScript = this.skySprite3D.addComponent(SkySampleScript) as SkySampleScript;
        skySampleScript.skySprite = this.skySprite3D;
        skySampleScript.cameraSprite = this.camera;

        //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
        this.skySprite3D.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00IT006M.v3f.lh");
        this.skySprite3D.once(Laya.Event.HIERARCHY_LOADED, null, (sprite) => {
            var meshSprite = sprite.getChildAt(0) as Laya.MeshSprite3D;
            var mesh = meshSprite.meshFilter.sharedMesh;
            mesh.once(Laya.Event.LOADED, null, (templet) => {
                for (var i = 0; i < meshSprite.meshRender.shadredMaterials.length; i++) {
                    var material = meshSprite.meshRender.shadredMaterials[i];
                    material.once(Laya.Event.LOADED, null, (mat) => {
                        mat.albedo = new  Laya.Vector4(3.5,3.5,3.5,1.0);
                        mat.renderMode = Laya.Material.RENDERMODE_SKY;
                    });
                }
            });
        });
    }

}
new StaticModel_MeshSkySample();