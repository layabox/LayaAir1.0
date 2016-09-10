//////////////////////////////////////////////////
//         Y
//         ^
//         ¦
//         ¦
//         ¦(0,0)
//  --------------->X  正交视图下的3D坐标系统
//         ¦
//         ¦ 
//         ¦
//         ¦
//
//
//  (0,0)
//  --------------->X  2D坐标系统
// ¦
// ¦ 
// ¦
// ¦
// ¦
// ¦
// ¦
// ˇ
// Y
/////////////////////////////////////////////////
var Camera_Ortho_2DMix3D_Sample = (function () {
    function Camera_Ortho_2DMix3D_Sample() {
        var _this = this;
        this.translate = new Laya.Vector3(200, 100, 0); //理解为屏幕坐标，左上角为（0，0）
        this.convertTranslate = new Laya.Vector3(0, 0, 0);
        this.skin = "../../res/ui/button-1.png";
        Laya3D.init(0, 0, true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();
        //****************************2D背景************************
        var dialog = new Laya.Image("../../res/bg.jpg");
        dialog.pos(0, 0);
        Laya.stage.addChild(dialog);
        //**********************************************************
        //****************************3D场景***************************
        var scene = Laya.stage.addChild(new Laya.Scene());
        scene.currentCamera = (scene.addChild(new Laya.Camera(0, 0.1, 300)));
        scene.currentCamera.transform.translate(new Laya.Vector3(0, 0, 150));
        scene.currentCamera.clearColor = null;
        scene.currentCamera.orthographicProjection = true;
        var mesh = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm")));
        Laya.Utils3D.convert3DCoordTo2DScreenCoord(this.translate, this.convertTranslate);
        mesh.transform.localPosition = this.convertTranslate;
        mesh.transform.localScale = new Laya.Vector3(100, 100, 100); //球的直径在三维空间中为1米（放大100倍，此时为100米），当正交投影矩阵的宽高等同于像素宽高时，一米可认为一个像素，所以球等于200个像素,可与2D直接混合。
        //窗口尺寸变化相关属性重置。
        Laya.stage.on(Laya.Event.RESIZE, this, function () {
            scene.currentCamera.orthographicVerticalSize = Laya.RenderState.clientHeight;
            Laya.Utils3D.convert3DCoordTo2DScreenCoord(_this.translate, _this.convertTranslate);
            mesh.transform.localPosition = _this.convertTranslate;
        });
        //************************************************************
        //****************************2D UI***************************
        Laya.loader.load(this.skin, Laya.Handler.create(this, this.onLoadComplete));
        //************************************************************
    }
    Camera_Ortho_2DMix3D_Sample.prototype.onLoadComplete = function (e) {
        if (e === void 0) { e = null; }
        var cb = this.createComboBox(this.skin);
        cb.pos(80, 90);
    };
    Camera_Ortho_2DMix3D_Sample.prototype.createComboBox = function (skin) {
        var btn = new Laya.Button(this.skin);
        Laya.stage.addChild(btn);
        return btn;
    };
    return Camera_Ortho_2DMix3D_Sample;
}());
new Camera_Ortho_2DMix3D_Sample();
