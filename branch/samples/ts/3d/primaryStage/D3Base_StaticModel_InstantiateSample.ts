class StaticModel_InstantiateSample {

    private scene: Laya.Scene;
    constructor() {

        Laya3D.init(0, 0,true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        this.scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

        var camera = (this.scene.addChild(new Laya.Camera(0, 0.1, 100))) as Laya.Camera;
        camera.transform.translate(new Laya.Vector3(0, 0.8, 1.5));
        camera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);

        var completeHandler:Laya.Handler = Laya.Handler.create(this, this.onComplete);//创建完成事件处理Handler

        //一:资源释放。
        //1.批量加载复杂模式。
        Laya.loader.create("../../res/threeDimen/staticModel/simpleScene/B00IT001M000.v3f.lh", completeHandler);
    }

    private onComplete():void{

        var staticMesh:Laya.Sprite3D = this.scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/staticModel/simpleScene/B00IT001M000.v3f.lh")) as Laya.Sprite3D;
        staticMesh.transform.localScale = new Laya.Vector3(10, 10, 10);
        staticMesh.transform.localPosition = new Laya.Vector3(-0.8, 0.0, 0.0);

        var meshSprite:Laya.MeshSprite3D = staticMesh.getChildAt(0) as Laya.MeshSprite3D;
        for (var i = 0; i < meshSprite.meshRender.sharedMaterials.length; i++) {
            var material:Laya.StandardMaterial = meshSprite.meshRender.sharedMaterials[i] as Laya.StandardMaterial;
            material.albedo = new Laya.Vector4(3.5, 3.5, 3.5, 1.0);
        }

        //一:........................................................................................
        var cloneSprite3D:Laya.Sprite3D = Laya.Sprite3D.instantiate(staticMesh);
        this.scene.addChild(cloneSprite3D);
        cloneSprite3D.transform.localScale = new Laya.Vector3(10, 10, 10);
        cloneSprite3D.transform.localPosition = new Laya.Vector3(0.8, 0.0, 0.0);
        //........................................................................................

        //二:........................................................................................
        //var cloneSprite3D:Laya.Sprite3D = Laya.Sprite3D.instantiate(staticMesh,null,null,scene);
        //cloneSprite3D.transform.localScale = new Laya.Vector3(10, 10, 10);
        //cloneSprite3D.transform.localPosition = new Laya.Vector3(0.8, 0.0, 0.0);
        //........................................................................................

        //二:........................................................................................
        //var cloneSprite3D:Laya.Sprite3D = Laya.Sprite3D.instantiate(staticMesh, new Laya.Vector3(0.8, 0.0, 0.0), new Laya.Quaternion(), scene);//注意坐标为加入场景后的世界坐标
        //cloneSprite3D.transform.localScale = new Laya.Vector3(10, 10, 10);
        //........................................................................................
    }
}
new StaticModel_InstantiateSample();