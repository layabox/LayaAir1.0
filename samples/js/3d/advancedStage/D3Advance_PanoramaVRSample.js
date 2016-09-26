Laya3D.init(0, 0,true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_HORIZONTAL;
Laya.Stat.show();

var scene = Laya.stage.addChild(new Laya.VRScene());

var camera = new Laya.VRCamera( 0.03, 0, 0, 0.1, 100);
scene.currentCamera = scene.addChild(camera);
scene.currentCamera.addComponent(VRCameraMoveScript);

(function loadScene(){
    var mesh = scene.addChild(new Laya.MeshSprite3D(new Laya.Sphere(1, 20, 20)));

    var material = new Laya.Material();
    material.renderMode = Laya.Material.RENDERMODE_OPAQUEDOUBLEFACE;
    mesh.meshRender.sharedMaterial = material;

    Laya.loader.load("../../res/threeDimen/panorama/panorama.jpg", Laya.Handler.create(null, function (texture) {
        texture.bitmap.mipmap = true;
        texture.bitmap.enableMerageInAtlas = false;
        material.diffuseTexture = texture;
    }));
})();

