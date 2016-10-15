var StaticModel_3DSpaceTo2DSpace = (function () {
    function StaticModel_3DSpaceTo2DSpace() {
        var _this = this;
        this.offset0 = new Laya.Vector3(0.01, 0, 0);
        this.offset1 = new Laya.Vector3(-0.01, 0, 0);
        this.totalOffset = 0;
        this.b = true;
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        this.outPos = new Laya.Vector3();
        this.projectViewMat = new Laya.Matrix4x4();
        var scene = Laya.stage.addChild(new Laya.Scene());
        var camera = (scene.addChild(new Laya.Camera(0, 0.1, 100)));
        camera.transform.translate(new Laya.Vector3(0, 1.8, 1.5));
        camera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
        var mesh = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm")));
        mesh.transform.localScale = new Laya.Vector3(0.5, 0.5, 0.5);
        var monkey = new Laya.Image("../../res/apes/monkey2.png");
        Laya.stage.addChild(monkey);
        Laya.timer.frameLoop(1, this, function () {
            if (Math.abs(_this.totalOffset) > 0.5)
                _this.b = !_this.b;
            if (_this.b) {
                _this.totalOffset += _this.offset0.x;
                mesh.transform.translate(_this.offset0);
            }
            else {
                _this.totalOffset += _this.offset1.x;
                mesh.transform.translate(_this.offset1);
            }
            Laya.Matrix4x4.multiply(camera.projectionMatrix, camera.viewMatrix, _this.projectViewMat);
            camera.viewport.project(mesh.transform.position, _this.projectViewMat, _this.outPos);
            monkey.pos(_this.outPos.x, _this.outPos.y);
        });
    }
    return StaticModel_3DSpaceTo2DSpace;
}());
new StaticModel_3DSpaceTo2DSpace();
