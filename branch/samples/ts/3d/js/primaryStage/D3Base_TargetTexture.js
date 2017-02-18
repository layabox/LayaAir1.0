var TargetTexture = (function () {
    function TargetTexture() {
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        var scene = Laya.stage.addChild(new Laya.Scene());
        var camera1 = new Laya.Camera(0, 0.1, 100);
        scene.addChild(camera1);
        camera1.transform.translate(new Laya.Vector3(0, 0.8, 1.5));
        camera1.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
        camera1.addComponent(CameraMoveScript);
        this.camera2 = new Laya.Camera(0, 0.1, 100);
        scene.addChild(this.camera2);
        this.camera2.clearColor = new Laya.Vector4(0.0, 0.0, 1.0, 1.0);
        this.camera2.transform.translate(new Laya.Vector3(0, 0.8, 1.5));
        this.camera2.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
        this.camera2.renderTarget = new Laya.RenderTexture(512, 512);
        this.camera2.renderingOrder = -1;
        var mesh0 = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/staticModel/quad/quad-Plane001.lm")));
        mesh0.transform.localPosition = new Laya.Vector3(-0.3, 0.0, 0.0);
        mesh0.transform.localScale = new Laya.Vector3(0.01, 0.01, 0.01);
        this.mesh1 = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/staticModel/quad/quad-Plane001.lm")));
        this.mesh1.transform.localPosition = new Laya.Vector3(0.3, 0.0, 0.0);
        this.mesh1.transform.localScale = new Laya.Vector3(0.01, 0.01, 0.01);
        this.loadUI();
    }
    TargetTexture.prototype.loadUI = function () {
        var _this = this;
        Laya.loader.load(["../../res/threeDimen/ui/button.png"], Laya.Handler.create(null, function () {
            var btn = new Laya.Button();
            btn.skin = "../../res/threeDimen/ui/button.png";
            btn.label = "切换RenderTexture";
            btn.labelBold = true;
            btn.labelSize = 20;
            btn.sizeGrid = "4,4,4,4";
            btn.size(200, 30);
            btn.scale(Laya.Browser.pixelRatio, Laya.Browser.pixelRatio);
            btn.pos(Laya.stage.width / 2 - btn.width * Laya.Browser.pixelRatio / 2, Laya.stage.height - 50 * Laya.Browser.pixelRatio);
            btn.on(Laya.Event.CLICK, _this, function () {
                this.mesh1.meshRender.material.diffuseTexture = this.camera2.renderTarget;
            });
            Laya.stage.addChild(btn);
            Laya.stage.on(Laya.Event.RESIZE, null, function () {
                btn.pos(Laya.stage.width / 2 - btn.width * Laya.Browser.pixelRatio / 2, Laya.stage.height - 50 * Laya.Browser.pixelRatio);
            });
        }));
    };
    return TargetTexture;
}());
new TargetTexture();
