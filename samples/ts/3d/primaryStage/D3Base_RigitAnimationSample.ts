class D3Base_RigitAnimationSample {

    private scene: Laya.Scene;
    private effectSprite: Laya.Sprite3D;
    constructor() {

        Laya3D.init(0, 0,true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        this.scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

        this.scene.currentCamera = (this.scene.addChild(new  Laya.Camera(0, 0.1, 1000)));
        this.scene.currentCamera.transform.translate(new Laya.Vector3(0, 16.8, 26.0));
        this.scene.currentCamera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
        this.scene.currentCamera.clearColor = null;

        this.effectSprite = this.scene.addChild(new Laya.Sprite3D()) as Laya.Sprite3D;
        this.effectSprite.once(Laya.Event.HIERARCHY_LOADED, this, (sender, sprite3D)=> {
            this.setMeshParams(this.effectSprite, Laya.Material.RENDERMODE_NONDEPTH_ADDTIVEDOUBLEFACE);
            var rootAnimations = sprite3D.addComponent(Laya.RigidAnimations);
            rootAnimations.url = "../../res/threeDimen/staticModel/effect/WuShen/WuShen.lani";
            rootAnimations.player.play(0);
        });
        this.effectSprite.loadHierarchy("../../res/threeDimen/staticModel/effect/WuShen/WuShen.lh");
    }

    private  setMeshParams(spirit3D:Laya.Sprite3D, renderMode:number):void {
        if (spirit3D instanceof Laya.MeshSprite3D) {
            var meshSprite = spirit3D as Laya.MeshSprite3D;
            var mesh = meshSprite.meshFilter.sharedMesh;
            if (mesh != null) {
                //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
                mesh.once(Laya.Event.LOADED, this, function (mesh:Laya.BaseMesh):void {
                    for (var i = 0; i < meshSprite.meshRender.sharedMaterials.length; i++) {
                        var material:Laya.Material = meshSprite.meshRender.sharedMaterials[i];
                        material.once(Laya.Event.LOADED, null, function (mat:Laya.Material):void {
                            mat.renderMode = renderMode;
                        });

                    }
                });
            }
        }
        for (var i = 0; i < spirit3D._childs.length; i++)
            this.setMeshParams(spirit3D._childs[i], renderMode);
    }

}
new D3Base_RigitAnimationSample();