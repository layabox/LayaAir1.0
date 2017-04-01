class StaticModel_MeshSample {

	constructor() {
		Laya3D.init(0, 0,true);
		Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
		Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
		Laya.Stat.show();

		var scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;

		var camera = scene.addChild(new Laya.Camera(0, 0.1, 100)) as Laya.Camera;
		camera.transform.translate(new Laya.Vector3(0, 0.8, 1.5));
		camera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);

		var mesh = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm"))) as Laya.MeshSprite3D;
		mesh.transform.localPosition = new Laya.Vector3(-0.3, 0.0, 0.0);
		mesh.transform.localScale = new Laya.Vector3(0.5, 0.5, 0.5);
	}
}
new StaticModel_MeshSample();