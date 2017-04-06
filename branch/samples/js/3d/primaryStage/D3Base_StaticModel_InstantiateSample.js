Laya3D.init(0, 0,true);
Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
Laya.Stat.show();

var scene = Laya.stage.addChild(new Laya.Scene());
var Vector4 = Laya.Vector4;
var Vector3 = Laya.Vector3;

var camera = scene.addChild(new Laya.Camera(0, 0.1, 100));
camera.transform.translate(new Laya.Vector3(0, 0.8, 1.5));
camera.transform.rotate(new Laya.Vector3(-30, 0, 0), true, false);

var onComplete = function(){
    var staticMesh = scene.addChild(Laya.Sprite3D.load("../../res/threeDimen/staticModel/simpleScene/B00IT001M000.v3f.lh"));
    staticMesh.transform.localScale = new Vector3(10, 10, 10);
    staticMesh.transform.localPosition = new Vector3(-0.8, 0.0, 0.0);

    var meshSprite = staticMesh.getChildAt(0);
    for (var i = 0; i < meshSprite.meshRender.sharedMaterials.length; i++) {
        var material = meshSprite.meshRender.sharedMaterials[i];
        material.albedo = new Vector4(3.5, 3.5, 3.5, 1.0);
    }

    //一:........................................................................................
    var cloneSprite3D = Laya.Sprite3D.instantiate(staticMesh);
    scene.addChild(cloneSprite3D);
    cloneSprite3D.transform.localScale = new Vector3(10, 10, 10);
    cloneSprite3D.transform.localPosition = new Vector3(0.8, 0.0, 0.0);
    //........................................................................................

    //二:........................................................................................
    //var cloneSprite3D:Sprite3D = Sprite3D.instantiate(staticMesh,null,null,scene);
    //cloneSprite3D.transform.localScale = new Vector3(10, 10, 10);
    //cloneSprite3D.transform.localPosition = new Vector3(0.8, 0.0, 0.0);
    //........................................................................................

    //二:........................................................................................
    //var cloneSprite3D:Sprite3D = Sprite3D.instantiate(staticMesh, new Vector3(0.8, 0.0, 0.0), new Quaternion(), scene);//注意坐标为加入场景后的世界坐标
    //cloneSprite3D.transform.localScale = new Vector3(10, 10, 10);
    //........................................................................................
}

var completeHandler = Laya.Handler.create(this, onComplete);//创建完成事件处理Handler

//一:资源释放。
//1.批量加载复杂模式。
Laya.loader.create("../../res/threeDimen/staticModel/simpleScene/B00IT001M000.v3f.lh", completeHandler);


