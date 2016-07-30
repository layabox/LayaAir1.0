module GlitterSample {
    import Vector3 = Laya.Vector3;


    export class GlitterSample {
        private glitter: Laya.Glitter;
        private sampler: GlitterStripSampler = new GlitterStripSampler();
        private scene: Laya.Scene;

        constructor() {
            //是否抗锯齿
            //Config.isAntialias = true;
            Laya3D.init(0, 0);
            Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
            Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
            Laya.Stat.show();

            this.scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

            this.scene.currentCamera = (this.scene.addChild(new Laya.Camera(0, 1, 1000))) as Laya.BaseCamera;
            this.scene.currentCamera.transform.translate(new Vector3(0, 5, 10));
            this.scene.currentCamera.transform.rotate(new Vector3(-30, 0, 0), true, false);

            var setting = new Laya.GlitterSettings();
            setting.texturePath = "../../res/threeDimen/layabox.png";
            setting.lifeTime = 0.5;
            setting.minSegmentDistance = 0.1;//最小距离，小于抛弃
            setting.minInterpDistance = 0.6;//最大插值距离，超过则插值
            setting.maxSlerpCount = 128;
            setting.color = new Laya.Vector4(0.8, 0.6, 0.3, 0.8);
            setting.maxSegments = 1000;

            this.glitter = this.scene.addChild(new Laya.Glitter(setting)) as Laya.Glitter;

            Laya.timer.frameLoop(1, this, this.loop);
        }

        private loop(): void {
            var projectViewMat = (this.scene.currentCamera as Laya.Camera).projectionViewMatrix;
            this.sampler.getSampleP4();
            this.glitter.templet.addVertexPosition(this.sampler.pos1, this.sampler.pos2);
        }
    }
}
new GlitterSample.GlitterSample();