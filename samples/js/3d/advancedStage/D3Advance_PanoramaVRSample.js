Laya3D.init(0, 0,true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_HORIZONTAL;
Laya.Stat.show();

var scene = Laya.stage.addChild(new Laya.VRScene());
var leftViewport = new Laya.Viewport(0, 0, Laya.RenderState.clientWidth / 2, Laya.RenderState.clientHeight);
var rightViewport = new Laya.Viewport(Laya.RenderState.clientWidth / 2, 0, Laya.RenderState.clientWidth / 2, Laya.RenderState.clientHeight);

var camera = new Laya.VRCamera( 0.03, 0, 0, 0.1, 100);
camera = scene.addChild(camera);
camera.addComponent(VRCameraMoveScript);

(function loadScene(){
    var mesh = scene.addChild(new Laya.MeshSprite3D(new Laya.SphereMesh(1, 20, 20)));

    var material = new Laya.StandardMaterial();
    material.renderMode = Laya.BaseMaterial.RENDERMODE_OPAQUEDOUBLEFACE;
    mesh.meshRender.sharedMaterial = material;

    Laya.loader.load("../../res/threeDimen/panorama/panorama.jpg", Laya.Handler.create(null, function (texture) {
        texture.bitmap.mipmap = true;
        texture.bitmap.enableMerageInAtlas = false;
        material.diffuseTexture = texture;
    }));
})();

