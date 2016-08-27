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
class Camera_Ortho_2DMix3D_Sample {
    private skinMesh: Laya.MeshSprite3D;
    private skinAni: Laya.SkinAnimations;
    private translate: Laya.Vector3 = new Laya.Vector3(200, 100, 0);//理解为屏幕坐标，左上角为（0，0）
    private convertTranslate: Laya.Vector3 = new Laya.Vector3(0, 0, 0);

    private skin: string = "../../res/ui/button-1.png";

    constructor() {
        Laya3D.init(0, 0,true);
        Laya.stage.scaleMode = Laya.Stage.SCALE_FULL;
        Laya.stage.screenMode = Laya.Stage.SCREEN_NONE;
        Laya.Stat.show();

        //****************************2D背景************************
        var dialog = new Laya.Image("../../res/bg.jpg");
        dialog.pos(0, 0);
        Laya.stage.addChild(dialog);
        //**********************************************************


        //****************************3D场景***************************
        var scene = Laya.stage.addChild(new Laya.Scene()) as Laya.Scene;
        scene.currentCamera = (scene.addChild(new Laya.Camera(0, 0.1, 300))) as Laya.Camera;
        scene.currentCamera.transform.translate(new Laya.Vector3(0, 0, 150));
        scene.currentCamera.clearColor = null;
        scene.currentCamera.orthographicProjection = true;
        var mesh = scene.addChild(new Laya.MeshSprite3D(Laya.Mesh.load("../../res/threeDimen/staticModel/sphere/sphere-Sphere001.lm"))) as Laya.MeshSprite3D;

        Laya.Utils3D.convert3DCoordTo2DScreenCoord(this.translate, this.convertTranslate);
        mesh.transform.localPosition = this.convertTranslate;
        mesh.transform.localScale = new Laya.Vector3(100, 100, 100);//球的直径在三维空间中为1米（放大100倍，此时为100米），当正交投影矩阵的宽高等同于像素宽高时，一米可认为一个像素，所以球等于200个像素,可与2D直接混合。
        //窗口尺寸变化相关属性重置。
        Laya.stage.on(Laya.Event.RESIZE, this,  ()=> {
            scene.currentCamera.orthographicVerticalSize = Laya.RenderState.clientHeight;
            Laya.Utils3D.convert3DCoordTo2DScreenCoord(this.translate, this.convertTranslate);
            mesh.transform.localPosition = this.convertTranslate;
        });
        //************************************************************


        //****************************2D UI***************************
        Laya.loader.load(this.skin, Laya.Handler.create(this, this.onLoadComplete));
        //************************************************************
    }

    private onLoadComplete(e: any = null): void {
        var cb = this.createComboBox(this.skin);
        cb.pos(80, 90);
    }

    private createComboBox(skin: string): Laya.Button {
        var btn = new Laya.Button(this.skin);
        Laya.stage.addChild(btn);
        return btn;
    }
}
new Camera_Ortho_2DMix3D_Sample();