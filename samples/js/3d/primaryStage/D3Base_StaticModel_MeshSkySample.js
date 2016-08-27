Laya3D.init(0, 0,true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
Laya.Stat.show();

var Vector4 = Laya.Vector4;
var scene = Laya.stage.addChild(new Laya.Scene());
var camera = new Laya.Camera(0, 0.1, 100);
scene.currentCamera = scene.addChild(camera);
scene.currentCamera.transform.translate(new Laya.Vector3(0.3, 0.3, 0.6));
scene.currentCamera.transform.rotate(new Laya.Vector3(-12, 0, 0), true, false);


scene.currentCamera.addComponent(CameraMoveScript);

var skySprite3D = scene.addChild(new Laya.Sprite3D());
var skySampleScript = skySprite3D.addComponent(SkySampleScript);
skySampleScript.skySprite = skySprite3D;
skySampleScript.cameraSprite = camera;

//可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
skySprite3D.loadHierarchy("../../res/threeDimen/staticModel/simpleScene/B00IT006M.v3f.lh");
skySprite3D.once(Laya.Event.HIERARCHY_LOADED, null, function (sprite) {
	var meshTemplet = sprite.getChildAt(0).templet;
	var meshSprite = sprite.getChildAt(0);
	var mesh = meshSprite.meshFilter.sharedMesh;
    mesh.once(Laya.Event.LOADED, null, function (templet) {
		for (var i = 0; i < meshSprite.meshRender.shadredMaterials.length; i++) {
			var material = meshSprite.meshRender.shadredMaterials[i];
			material.once(Laya.Event.LOADED, null, function (mat) {
				mat.albedo = new Vector4(3.5, 3.5, 3.5, 1.0);
				mat.renderMode = Laya.Material.RENDERMODE_SKY;
			});
		}
	});
});