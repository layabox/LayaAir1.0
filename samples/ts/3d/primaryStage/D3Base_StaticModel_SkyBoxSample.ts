class StaticModel_SkyBoxSample{

    constructor(){

        Laya3D.init(0, 0,true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        var scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;
        scene.shadingMode = Laya.BaseScene.VERTEX_SHADING;

        var camera = scene.addChild(new Laya.Camera(0, 0.1, 100)) as Laya.Camera;
        camera.transform.translate(new Laya.Vector3(0, 0.8, 1.5));
        camera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);
        camera.clearFlag = Laya.BaseCamera.CLEARFLAG_SKY;
        var skyBox = new Laya.SkyBox();
        camera.sky = skyBox;
        camera.addComponent(CameraMoveScript);

        //可采用预加载资源方式，避免异步加载资源问题，则无需注册事件。
        Laya.loader.load("../../res/threeDimen/skyBox/px.jpg,../../res/threeDimen/skyBox/nx.jpg,../../res/threeDimen/skyBox/py.jpg,../../res/threeDimen/skyBox/ny.jpg,../../res/threeDimen/skyBox/pz.jpg,../../res/threeDimen/skyBox/nz.jpg",
            Laya.Handler.create(null,function(texture):void{
                skyBox.textureCube = texture;
            }), null, Laya.Loader.TEXTURECUBE);

        var mesh = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm"))) as Laya.MeshSprite3D;

    }
}
new StaticModel_SkyBoxSample();