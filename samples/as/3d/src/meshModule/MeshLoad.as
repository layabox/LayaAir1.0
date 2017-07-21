package meshModule {
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
    public class MeshLoad {
        private var curStateIndex:int = 0;
        
        public var debugModel:Boolean = false;
        
        private var phasorSpriter3D:PhasorSpriter3D;
        
        private var vertex1:Vector3 = new Vector3();
        private var vertex2:Vector3 = new Vector3();
        private var vertex3:Vector3 = new Vector3();
        private var color:Vector4 = new Vector4(0, 1, 0, 1);
        
        private var rotation:Vector3 = new Vector3(0, 0.01, 0);
        
        public function MeshLoad() {
            Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Stage.SCALE_FULL;
            Laya.stage.screenMode = Stage.SCREEN_NONE;
            Stat.show();
            
            var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
            
            var camera:Camera = scene.addChild(new Camera(0, 0.1, 100)) as Camera;
            camera.transform.translate(new Vector3(0, 0.8, 1.5));
            camera.transform.rotate(new Vector3( -15, 0, 0), true, false);
			
			var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
            directionLight.ambientColor = new Vector3(0.6, 0.6, 0.6);
            directionLight.specularColor = new Vector3(0.6, 0.6, 0.6);
            directionLight.diffuseColor = new Vector3(0.6, 0.6, 0.6);
            directionLight.direction = new Vector3(1, -1, -1);
            
			//加载网格
            var layaMonkey:MeshSprite3D = scene.addChild(new MeshSprite3D(Mesh.load("../../../../res/threeDimen/skinModel/LayaMonkey/Assets/LayaMonkey/LayaMonkey-LayaMonkey.lm"))) as MeshSprite3D;
            layaMonkey.transform.localScale = new Vector3(0.3, 0.3, 0.3);
            layaMonkey.transform.rotation = new Quaternion(0.7071068, 0, 0, -0.7071067);
            
			phasorSpriter3D = new PhasorSpriter3D();
            Laya.timer.frameLoop(1, this, function():void {
                
				layaMonkey.active = !debugModel;
                layaMonkey.transform.rotate(rotation, false);
				
                if (debugModel) {
                    phasorSpriter3D.begin(WebGLContext.LINES, camera);
                    Tool.linearModel(layaMonkey, phasorSpriter3D, color, vertex1, vertex2, vertex3);
                    phasorSpriter3D.end();
                }
            });
            
            loadUI();
        }
        
        private function loadUI():void {
            Laya.loader.load(["../../../../res/threeDimen/ui/button.png"], Handler.create(null, function():void {
                var changeActionButton:Button = Laya.stage.addChild(new Button("../../../../res/threeDimen/ui/button.png", "正常模式")) as Button;
                changeActionButton.size(160, 40);
                changeActionButton.labelBold = true;
                changeActionButton.labelSize = 30;
                changeActionButton.sizeGrid = "4,4,4,4";
                changeActionButton.scale(Browser.pixelRatio, Browser.pixelRatio);
                changeActionButton.pos(Laya.stage.width / 2 - changeActionButton.width * Browser.pixelRatio / 2, Laya.stage.height - 100 * Browser.pixelRatio);
                changeActionButton.on(Event.CLICK, this, function():void {
                    if (++curStateIndex % 2 == 1) {
                        debugModel = true;
                        changeActionButton.label = "网格模式";
                    }
                    else {
                        debugModel = false;
                        changeActionButton.label = "正常模式";
                    }
                });
            }));
        }
    }
}