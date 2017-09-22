var GlitterDemo = (function () {
    function GlitterDemo() {
        this.scaleDelta = 0;
        this.scaleValue = 0;
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        var scene = Laya.stage.addChild(new Laya.Scene());
        this.pos1 = new Laya.Vector3(0, 0, -0.5);
        this.pos2 = new Laya.Vector3(0, 0, 0.5);
        var camera = scene.addChild(new Laya.Camera(0, 1, 1000));
        camera.transform.translate(new Laya.Vector3(0, 6, 10));
        camera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
        camera.addComponent(CameraMoveScript);
        this.glitter = scene.addChild(new Laya.Glitter());
        var glitterTemplet = this.glitter.templet;
        var glitterMaterial = this.glitter.glitterRender.sharedMaterial;
        glitterMaterial.diffuseTexture = Laya.Texture2D.load("../../res/threeDimen/layabox.png");
        glitterMaterial.albedo = new Laya.Vector4(1.3, 1.3, 1.3, 1);
        glitterTemplet.lifeTime = 1.3;
        glitterTemplet.minSegmentDistance = 0.1;
        glitterTemplet.minInterpDistance = 0.6;
        glitterTemplet.maxSlerpCount = 128;
        glitterTemplet.maxSegments = 600;
        Laya.timer.frameLoop(1, this, this.loop);
    }
    GlitterDemo.prototype.loop = function () {
        this.scaleValue = Math.sin(this.scaleDelta += 0.01);
        this.pos1.elements[0] = this.pos2.elements[0] = this.scaleValue * 13;
        this.pos1.elements[1] = Math.sin(this.scaleValue * 20) * 2;
        this.pos2.elements[1] = Math.sin(this.scaleValue * 20) * 2;
        this.glitter.addGlitterByPositions(this.pos1, this.pos2);
    };
    return GlitterDemo;
}());
new GlitterDemo;
