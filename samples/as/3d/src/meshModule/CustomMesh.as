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
    import laya.d3.resource.Texture2D;
    import laya.d3.resource.models.BoxMesh;
    import laya.d3.resource.models.CapsuleMesh;
    import laya.d3.resource.models.CylinderMesh;
    import laya.d3.resource.models.Mesh;
    import laya.d3.resource.models.PlaneMesh;
    import laya.d3.resource.models.SphereMesh;
    import laya.d3.resource.models.SubMesh;
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
    public class CustomMesh {
        
        public var sprite3D:Sprite3D;
        public var debugModel:Boolean = false;
        
        private var phasorSpriter3D:PhasorSpriter3D;
        
        private var vertex1:Vector3 = new Vector3();
        private var vertex2:Vector3 = new Vector3();
        private var vertex3:Vector3 = new Vector3();
        private var color:Vector4 = new Vector4(0, 1, 0, 1);
        
        private var curStateIndex:int = 0;
        
        public function CustomMesh() {
			
            Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Stage.SCALE_FULL;
            Laya.stage.screenMode = Stage.SCREEN_NONE;
            Stat.show();
            
            var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
            
            var camera:Camera = scene.addChild(new Camera(0, 0.1, 100)) as Camera;
            camera.transform.translate(new Vector3(0, 2, 5));
            camera.transform.rotate(new Vector3(-15, 0, 0), true, false);
            
            var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
            directionLight.color = new Vector3(0.6, 0.6, 0.6);
            directionLight.direction = new Vector3(1, -1, -1);
            
            sprite3D = scene.addChild(new Sprite3D()) as Sprite3D;
            
            //平面
            var plane:MeshSprite3D = sprite3D.addChild(new MeshSprite3D(new PlaneMesh(6, 6, 10, 10))) as MeshSprite3D;
            
            //正方体
            var box:MeshSprite3D = sprite3D.addChild(new MeshSprite3D(new BoxMesh(0.5, 0.5, 0.5))) as MeshSprite3D;
            box.transform.position = new Vector3(1.5, 0.25, 0.6);
            box.transform.rotate(new Vector3(0, 45, 0), false, false);
            
            //球体
            var sphere:MeshSprite3D = sprite3D.addChild(new MeshSprite3D(new SphereMesh(0.25))) as MeshSprite3D;
            sphere.transform.position = new Vector3(0.5, 0.25, 0.6);
            
            //圆柱体
            var cylinder:MeshSprite3D = sprite3D.addChild(new MeshSprite3D(new CylinderMesh(0.25, 1))) as MeshSprite3D;
            cylinder.transform.position = new Vector3(-0.5, 0.5, 0.6);
            
            //胶囊体
            var capsule:MeshSprite3D = sprite3D.addChild(new MeshSprite3D(new CapsuleMesh(0.25, 1))) as MeshSprite3D;
            capsule.transform.position = new Vector3(-1.5, 0.5, 0.6);
            
			phasorSpriter3D = new PhasorSpriter3D();
            Laya.timer.frameLoop(1, this, function():void {
                
                sprite3D.active = !debugModel;
                if (debugModel) {
                    phasorSpriter3D.begin(WebGLContext.LINES, camera);
                    Tool.linearModel(sprite3D, phasorSpriter3D, color, vertex1, vertex2, vertex3);
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