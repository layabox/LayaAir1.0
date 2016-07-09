var skinMesh;
var skinAni;


Laya.Laya3D.init(0, 0);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
Laya.Stat.show();

var scene = Laya.stage.addChild(new Laya.Scene());

scene.currentCamera = scene.addChild(new Laya.Camera(new Laya.Viewport(0, 0, Laya.stage.width, Laya.stage.height), Math.PI / 3, 0, 0.1, 100));
scene.currentCamera.transform.translate(new Laya.Vector3(0, 0.8, 1.5));
scene.currentCamera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
Laya.stage.on(Laya.Event.RESIZE, null, function () {
				scene.currentCamera.viewport = new Laya.Viewport(0, 0, Laya.stage.width, Laya.stage.height);
});

var staticMesh = scene.addChild(new Laya.Sprite3D());
staticMesh.on(Laya.Event.HIERARCHY_LOADED, null, function (sprite) {
				var templet = sprite.getChildAt(0).templet;
				templet.on(Laya.Event.LOADED, null, function (templet) {
        for (var i = 0; i < templet.materials.length; i++) {
            var material = templet.materials[i];
            material.luminance = 3.5;
        }
				});
});
staticMesh.loadHierarchy("threeDimen/staticModel/simpleScene/B00IT001M000.v3f.lh");
staticMesh.transform.localScale = new Laya.Vector3(10, 10, 10);
