class StaticModel_MeshSample {
	private skinMesh: Laya.Mesh;
	private skinAni: Laya.SkinAnimations;

	constructor() {

		Laya.Laya3D.init(0, 0);
		Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
		Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
		Laya.Stat.show();

		var scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

		scene.currentCamera = scene.addChild(new Laya.Camera(new Laya.Viewport(0, 0, Laya.stage.width, Laya.stage.height), Math.PI / 3, 0, 0.1, 100)) as Laya.Camera;
		scene.currentCamera.transform.translate(new Laya.Vector3(0, 0.8, 1.5));
		scene.currentCamera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
		Laya.stage.on(Laya.Event.RESIZE, null, () => {
            (scene.currentCamera as Laya.Camera).viewport = new Laya.Viewport(0, 0, Laya.stage.width, Laya.stage.height);
		});

		var mesh = scene.addChild(new Laya.Mesh()) as Laya.Mesh;
		mesh.load("threeDimen/staticModel/sphere/sphere-Sphere001.lm");
		mesh.transform.localPosition = new Laya.Vector3(-0.3, 0.0, 0.0);
		mesh.transform.localScale = new Laya.Vector3(0.5, 0.5, 0.5);
	}
}
new StaticModel_MeshSample();