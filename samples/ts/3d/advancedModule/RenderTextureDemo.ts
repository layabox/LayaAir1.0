class RenderTextureDemo {
    private scene: Laya.Scene;
    private renderTargetCamera: Laya.Camera;

    private layaPlane: Laya.Sprite3D;
    constructor() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        this.scene = Laya.stage.addChild(Laya.Scene.load("../../res/threeDimen/scene/Arena/Arena.ls")) as Laya.Scene;

        var camera: Laya.Camera = this.scene.addChild(new Laya.Camera(0, 0.1, 1000)) as Laya.Camera;
        camera.transform.translate(new Laya.Vector3(0, 0.5, 1));
        camera.transform.rotate(new Laya.Vector3(-10, 0, 0), true, false);
        camera.addComponent(CameraMoveScript);

        this.renderTargetCamera = this.scene.addChild(new Laya.Camera(0, 0.1, 1000)) as Laya.Camera;
        this.renderTargetCamera.transform.translate(new Laya.Vector3(0, 0.5, 1));
        this.renderTargetCamera.transform.rotate(new Laya.Vector3(-10, 0, 0), true, false);
        this.renderTargetCamera.renderTarget = new Laya.RenderTexture(2048, 2048);
        this.renderTargetCamera.renderingOrder = -1;
        this.renderTargetCamera.addComponent(CameraMoveScript);

        var directionLight: Laya.DirectionLight = this.scene.addChild(new Laya.DirectionLight()) as Laya.DirectionLight;
        directionLight.color = new Laya.Vector3(0.7, 0.6, 0.6);
        directionLight.direction = new Laya.Vector3(0, -1.0, -1.0);

        var layaMonkey: Laya.Sprite3D = this.scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh")) as Laya.Sprite3D;

        this.layaPlane = this.scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/staticModel/LayaPlane/LayaPlane.lh")) as Laya.Sprite3D;

        Laya.loader.create([
            "../../res/threeDimen/scene/Arena/Arena.ls",
            "../../res/threeDimen/staticModel/LayaPlane/LayaPlane.lh"
        ], Laya.Handler.create(this, this.onComplete));
    }
    private onComplete(): void {

        this.setMaterials(this.scene.getChildByName("scene") as Laya.Sprite3D);
        this.layaPlane.transform.localPosition = new Laya.Vector3(0, 0.5, -1);

        Laya.loader.load(["../../res/threeDimen/ui/button.png"], Laya.Handler.create(this, function (): void {
            var changeActionButton: Laya.Button = Laya.stage.addChild(new Laya.Button("../../res/threeDimen/ui/button.png", "渲染目标")) as Laya.Button;
            changeActionButton.size(160, 40);
            changeActionButton.labelBold = true;
            changeActionButton.labelSize = 30;
            changeActionButton.sizeGrid = "4,4,4,4";
            changeActionButton.scale(Laya.Browser.pixelRatio, Laya.Browser.pixelRatio);
            changeActionButton.pos(Laya.stage.width / 2 - changeActionButton.width * Laya.Browser.pixelRatio / 2, Laya.stage.height - 100 * Laya.Browser.pixelRatio);
            changeActionButton.on(Laya.Event.CLICK, this, function (): void {
                (this.layaPlane.getChildAt(0) as Laya.MeshSprite3D).meshRender.material.diffuseTexture = this.renderTargetCamera.renderTarget;
            });
        }));
    }

    private setMaterials(spirit3D: Laya.Sprite3D): void {
        if (spirit3D instanceof Laya.MeshSprite3D) {
            var meshSprite: Laya.MeshSprite3D = spirit3D as Laya.MeshSprite3D;
            for (var i: number = 0; i < meshSprite.meshRender.sharedMaterials.length; i++) {
                var mat: Laya.StandardMaterial = meshSprite.meshRender.sharedMaterials[i] as Laya.StandardMaterial;
                mat.disableLight();
            }
        }
        for (var i: number = 0; i < spirit3D._childs.length; i++)
            this.setMaterials(spirit3D._childs[i]);
    }
}
new RenderTextureDemo;