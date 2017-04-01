module GlitterSample {
    import Vector3 = Laya.Vector3;


    export class GlitterSample {
        private glitter: Laya.Glitter;
        private sampler: GlitterStripSampler = new GlitterStripSampler();
        private scene: Laya.Scene;

        constructor() {

            Laya3D.init(0, 0,true);
            Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
            Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
            Laya.Stat.show();

            this.scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

            this.camera = (this.scene.addChild(new Laya.Camera(0, 1, 1000))) as Laya.BaseCamera;
            this.camera.transform.translate(new Vector3(0, 5, 10));
            this.camera.transform.rotate(new Vector3(-30, 0, 0), true, false);

            this.glitter = this.scene.addChild(new Laya.Glitter()) as Laya.Glitter;
            var glitterTemplet:Laya.GlitterTemplet = this.glitter.templet;
            (this.glitter.glitterRender.sharedMaterial as Laya.GlitterMaterial).diffuseTexture =Laya.Texture2D.load("../../res/threeDimen/layabox.png");
            glitterTemplet.lifeTime = 0.5;
            glitterTemplet.minSegmentDistance = 0.1;//最小距离，小于抛弃
            glitterTemplet.minInterpDistance = 0.6;//最大插值距离，超过则插值
            glitterTemplet.maxSlerpCount = 128;
            glitterTemplet.color = new Laya.Vector4(0.8, 0.6, 0.3, 0.8);
            glitterTemplet.maxSegments = 600;

            Laya.timer.frameLoop(1, this, this.loop);
        }

        private loop(): void {
            var projectViewMat = (this.camera as Laya.Camera).projectionViewMatrix;
            this.sampler.getSampleP4();
            this.glitter.addGlitterByPositions(this.sampler.pos1, this.sampler.pos2);
        }
    }
}
new GlitterSample.GlitterSample();