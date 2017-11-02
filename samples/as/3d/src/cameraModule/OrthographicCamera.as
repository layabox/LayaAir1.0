package cameraModule {
    import laya.ani.AnimationTemplet;
    import laya.d3.component.animation.SkinAnimations;
    import laya.d3.core.Camera;
    import laya.d3.core.MeshSprite3D;
    import laya.d3.core.Sprite3D;
    import laya.d3.core.light.DirectionLight;
    import laya.d3.core.material.StandardMaterial;
    import laya.d3.core.render.RenderState;
    import laya.d3.core.scene.Scene;
    import laya.d3.math.Quaternion;
    import laya.d3.math.Vector3;
    import laya.d3.math.Vector4;
    import laya.d3.resource.Texture2D;
    import laya.d3.resource.TextureCube;
    import laya.d3.resource.models.BaseMesh;
    import laya.d3.resource.models.Mesh;
    import laya.d3.utils.Utils3D;
    import laya.display.Stage;
    import laya.events.Event;
    import laya.resource.Texture;
    import laya.ui.Image;
    import laya.utils.Handler;
    import laya.utils.Stat;
    import common.CameraMoveScript;
    
    public class OrthographicCamera {
		
		/**
		 * (pos.x pos.y) 屏幕位置
		 *  pos.z 深度取值范围(-1,1);
		 * */
		private var pos:Vector3 = new Vector3(310, 500, 0);
        private var _translate:Vector3 = new Vector3(0, 0, 0);
        
        public function OrthographicCamera() {
			
            Laya3D.init(1024, 768, true);
            Laya.stage.scaleMode = Stage.SCALE_FIXED_HEIGHT;
            Laya.stage.screenMode = Stage.SCREEN_NONE;
            Stat.show();
            
            var dialog:Image = Laya.stage.addChild(new Image("../../../../res/cartoon2/background.jpg")) as Image;
            
            var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
            
            var camera:Camera = scene.addChild(new Camera(0, 0.1, 1000)) as Camera;
            camera.transform.rotate(new Vector3(-45, 0, 0), false, false);
            camera.transform.translate(new Vector3(5, -10, 1));
            camera.orthographic = true;
			//正交投影垂直矩阵尺寸
            camera.orthographicVerticalSize = 10;
            
            var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
            
            var layaMonkey:Sprite3D = scene.addChild(Sprite3D.load("../../../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh")) as Sprite3D;
            layaMonkey.once(Event.HIERARCHY_LOADED, this, function():void {
                
                layaMonkey.transform.localScale = new Vector3(3, 3, 3);
				//转换2D屏幕坐标系统到3D正交投影下的坐标系统
                camera.convertScreenCoordToOrthographicCoord(pos, _translate);
                layaMonkey.transform.position = _translate;
				
				Laya.stage.on(Event.RESIZE, null, function():void {
                    camera.convertScreenCoordToOrthographicCoord(pos, _translate);
					layaMonkey.transform.position = _translate;
                });
            
            });
			
        
        }
    }
}