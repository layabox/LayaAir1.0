package cameraModule {
    import laya.d3.component.animation.SkinAnimations;
    import laya.d3.core.Camera;
    import laya.d3.core.MeshSprite3D;
    import laya.d3.core.Sprite3D;
	import laya.d3.core.light.DirectionLight;
    import laya.d3.core.scene.Scene;
    import laya.d3.math.Matrix4x4;
    import laya.d3.math.Quaternion;
    import laya.d3.math.Vector3;
    import laya.d3.resource.models.Mesh;
    import laya.display.Stage;
    import laya.ui.Image;
    import laya.utils.Handler;
    import laya.utils.Stat;
    
    public class D3SpaceToD2Space {
        
        private var scene:Scene;
		private var camera:Camera;
        private var layaMonkey3D:Sprite3D;
		private var layaMonkey2D:Image;
        private var _position:Vector3 = new Vector3();
		private var _outPos:Vector3 = new Vector3();
        private var scaleDelta:Number = 0;
        
        public function D3SpaceToD2Space() {
            
            Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Stage.SCALE_FULL;
            Laya.stage.screenMode = Stage.SCREEN_NONE;
            Stat.show();
            
            scene = Laya.stage.addChild(new Scene()) as Scene;
            
            camera = scene.addChild(new Camera(0, 0.1, 100)) as Camera;
            camera.transform.translate(new Vector3(0, 0.35, 1));
            camera.transform.rotate(new Vector3( -15, 0, 0), true, false);
			
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
            
            var completeHandler:Handler = Handler.create(this, onComplete);
            
            Laya.loader.create("../../../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh", completeHandler);
        }
        
        public function onComplete():void {
            
            layaMonkey3D = scene.addChild(Sprite3D.load("../../../../res/threeDimen/skinModel/LayaMonkey/LayaMonkey.lh")) as Sprite3D;
            
            layaMonkey2D = Laya.stage.addChild(new Image("../../../../res/threeDimen/monkey.png")) as Image;
            
            Laya.timer.frameLoop(1, this, animate);
        }
        
        private function animate():void {
			
            _position.x = Math.sin(scaleDelta += 0.01);
            layaMonkey3D.transform.position = _position;
            
            camera.viewport.project(layaMonkey3D.transform.position, camera.projectionViewMatrix, _outPos);
            
            layaMonkey2D.pos(_outPos.x / Laya.stage.clientScaleX, _outPos.y / Laya.stage.clientScaleY);
        }
    
    }
}