package materialModule {
    import laya.d3.core.Camera;
    import laya.d3.core.MeshSprite3D;
    import laya.d3.core.PhasorSpriter3D;
    import laya.d3.core.Sprite3D;
    import laya.d3.core.light.DirectionLight;
	import laya.d3.core.material.StandardMaterial;
    import laya.d3.core.render.RenderState;
    import laya.d3.core.scene.Scene;
    import laya.d3.graphics.IndexBuffer3D;
    import laya.d3.graphics.VertexBuffer3D;
    import laya.d3.math.Quaternion;
    import laya.d3.math.Vector3;
    import laya.d3.math.Vector4;
    import laya.d3.resource.models.Mesh;
    import laya.display.Stage;
    import laya.events.Event;
    import laya.ui.Button;
    import laya.utils.Browser;
    import laya.utils.Handler;
    import laya.utils.Stat;
    import laya.webgl.WebGLContext;
    import common.CameraMoveScript;
    import common.Tool;
    
    /**
     * ...
     * @author
     */
    public class StandardMaterialLoad {
        
        private var rotation:Vector3 = new Vector3(0, 0.01, 0);
        
        public function StandardMaterialLoad() {
            Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Stage.SCALE_FULL;
            Laya.stage.screenMode = Stage.SCREEN_NONE;
            Stat.show();
            
            var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
            
            var camera:Camera = scene.addChild(new Camera(0, 0.1, 100)) as Camera;
            camera.transform.translate(new Vector3(0, 0.9, 1.5));
            camera.transform.rotate(new Vector3( -15, 0, 0), true, false);
			
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
            directionLight.color = new Vector3(0.6, 0.6, 0.6);
            directionLight.direction = new Vector3(1, -1, -1);
            
            var layaMonkey:MeshSprite3D = scene.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/skinModel/LayaMonkey/Assets/LayaMonkey/LayaMonkey-LayaMonkey.lm"))) as MeshSprite3D;
			//加载材质
			layaMonkey.meshRender.material = StandardMaterial.load("../../../../res/threeDimen/skinModel/LayaMonkey/Assets/LayaMonkey/Materials/T_Diffuse.lmat");
            layaMonkey.transform.localScale = new Vector3(0.3, 0.3, 0.3);
            layaMonkey.transform.rotation = new Quaternion(0.7071068, 0, 0, -0.7071067);
            
            Laya.timer.frameLoop(1, this, function():void {
                layaMonkey.transform.rotate(rotation, false);
            });
        }
    }
}