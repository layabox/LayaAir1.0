class StaticModel_3DSpaceTo2DSpace {
	private skinMesh: Laya.MeshSprite3D;
	private skinAni: Laya.SkinAnimations;
	private outPos: Laya.Vector3;
	private projectViewMat: Laya.Matrix4x4;
	private offset0: Laya.Vector3 = new Laya.Vector3(0.01, 0, 0);
	private offset1: Laya.Vector3 = new Laya.Vector3(-0.01, 0, 0);
	private totalOffset: number = 0;
	private b: Boolean = true;

	constructor() {

		Laya3D.init(0, 0,true);
		Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
		Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
		Laya.Stat.show();

		this.outPos = new Laya.Vector3();
		this.projectViewMat = new Laya.Matrix4x4();


		var scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

        var camera = scene.addChild(new Laya.Camera(0, 0.1, 100)) as Laya.Camera;
		scene.currentCamera = camera
		scene.currentCamera.transform.translate(new Laya.Vector3(0, 0.8, 1.5));
		scene.currentCamera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);

		var mesh = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm"))) as Laya.MeshSprite3D;
		mesh.transform.localScale = new Laya.Vector3(0.5, 0.5, 0.5);

		var monkey: Laya.Image = new Laya.Image("../../res/apes/monkey2.png");
		Laya.stage.addChild(monkey);

		Laya.timer.frameLoop(1, this, () => {

			if (Math.abs(this.totalOffset) > 0.5)
				this.b = !this.b;

			if (this.b) {
				this.totalOffset += this.offset0.x;
				mesh.transform.translate(this.offset0);
			} else {
				this.totalOffset += this.offset1.x;
				mesh.transform.translate(this.offset1);
			}

			Laya.Matrix4x4.multiply(camera.projectionMatrix, camera.viewMatrix, this.projectViewMat);
			camera.viewport.project(mesh.transform.position, this.projectViewMat, this.outPos);
			monkey.pos(this.outPos.x, this.outPos.y);
		});
	}
}
new StaticModel_3DSpaceTo2DSpace();