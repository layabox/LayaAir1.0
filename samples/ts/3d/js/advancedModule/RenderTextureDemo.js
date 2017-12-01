var RenderTextureDemo = /** @class */ (function () {
    function RenderTextureDemo() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        this.scene = Laya.stage.addChild(Laya.Scene.load("../../res/threeDimen/scene/Arena/Arena.ls"));
        var camera = this.scene.addChild(new Laya.Camera(0, 0.1, 1000));
        camera.transform.translate(new Laya.Vector3(0, 0.5, 1));
        camera.transform.rotate(new Laya.Vector3(-10, 0, 0), true, false);
        camera.addComponent(CameraMoveScript);
        this.renderTargetCamera = this.scene.addChild(new Laya.Camera(0, 0.1, 1000));
        this.renderTargetCamera.transform.translate(new Laya.Vector3(0, 0.5, 1));
        this.renderTargetCamera.transform.rotate(new Laya.Vector3(-10, 0, 0), true, false);
        this.renderTargetCamera.renderTarget = new Laya.RenderTexture(2048, 2048);
        this.renderTargetCamera.renderingOrder = -1;
        this.renderTargetCamera.addComponent(CameraMoveScript);
        var directionLight = this.scene.addChild(new Laya.DirectionLight());
        directionLight.color = new Laya.Vector3(0.7, 0.6, 0.6);
        directionLight.direction = new Laya.Vector3(0, -1.0, -1.0);
        var layaMonkey = this.scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh"));
        this.layaPlane = this.scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/staticModel/LayaPlane/LayaPlane.lh"));
        Laya.loader.create([
            "../../res/threeDimen/scene/Arena/Arena.ls",
            "../../res/threeDimen/staticModel/LayaPlane/LayaPlane.lh"
        ], Laya.Handler.create(this, this.onComplete));
    }
    RenderTextureDemo.prototype.onComplete = function () {
        this.setMaterials(this.scene.getChildByName("scene"));
        this.layaPlane.transform.localPosition = new Laya.Vector3(0, 0.5, -1);
        Laya.loader.load(["../../res/threeDimen/ui/button.png"], Laya.Handler.create(this, function () {
            var changeActionButton = Laya.stage.addChild(new Laya.Button("../../res/threeDimen/ui/button.png", "渲染目标"));
            changeActionButton.size(160, 40);
            changeActionButton.labelBold = true;
            changeActionButton.labelSize = 30;
            changeActionButton.sizeGrid = "4,4,4,4";
            changeActionButton.scale(Laya.Browser.pixelRatio, Laya.Browser.pixelRatio);
            changeActionButton.pos(Laya.stage.width / 2 - changeActionButton.width * Laya.Browser.pixelRatio / 2, Laya.stage.height - 100 * Laya.Browser.pixelRatio);
            changeActionButton.on(Laya.Event.CLICK, this, function () {
                this.layaPlane.getChildAt(0).meshRender.material.diffuseTexture = this.renderTargetCamera.renderTarget;
            });
        }));
    };
    RenderTextureDemo.prototype.setMaterials = function (spirit3D) {
        if (spirit3D instanceof Laya.MeshSprite3D) {
            var meshSprite = spirit3D;
            for (var i = 0; i < meshSprite.meshRender.sharedMaterials.length; i++) {
                var mat = meshSprite.meshRender.sharedMaterials[i];
                mat.disableLight();
            }
        }
        for (var i = 0; i < spirit3D._childs.length; i++)
            this.setMaterials(spirit3D._childs[i]);
    };
    return RenderTextureDemo;
}());
new RenderTextureDemo;
