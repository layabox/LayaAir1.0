package physicsModule {
    import laya.d3.component.physics.BoxCollider;
    import laya.d3.component.physics.MeshCollider;
    import laya.d3.component.physics.SphereCollider;
    import laya.d3.core.Camera;
    import laya.d3.core.Layer;
    import laya.d3.core.MeshSprite3D;
    import laya.d3.core.PhasorSpriter3D;
    import laya.d3.core.Sprite3D;
    import laya.d3.core.light.DirectionLight;
    import laya.d3.core.material.StandardMaterial;
    import laya.d3.core.render.RenderState;
    import laya.d3.core.scene.Scene;
    import laya.d3.math.Plane;
    import laya.d3.math.Ray;
    import laya.d3.math.Vector2;
    import laya.d3.math.Vector3;
    import laya.d3.math.Vector4;
    import laya.d3.resource.Texture2D;
    import laya.d3.resource.models.BoxMesh;
    import laya.d3.resource.models.CapsuleMesh;
    import laya.d3.resource.models.CylinderMesh;
    import laya.d3.resource.models.Mesh;
    import laya.d3.resource.models.PlaneMesh;
    import laya.d3.resource.models.SphereMesh;
    import laya.d3.utils.Physics;
    import laya.d3.utils.RaycastHit;
    import laya.display.Stage;
    import laya.events.Event;
    import laya.events.MouseManager;
    import laya.ui.Label;
    import laya.utils.Browser;
    import laya.utils.Stat;
    import laya.webgl.WebGLContext;
    import common.CameraMoveScript;
    
    public class RayPicking02 {
        
        private var ray:Ray = new Ray(new Vector3(0, 0, 0), new Vector3(0, 0, 0));
        private var point:Vector2 = new Vector2();
        private var _outHitInfo:RaycastHit = new RaycastHit();
        private var _position:Vector3 = new Vector3(0, 0, 0);
        private var _offset:Vector3 = new Vector3(0, 0.25, 0);
        
        private var scene:Scene;
        private var camera:Camera;
        private var label:Label;
        
        public function RayPicking02() {
            
            Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Stage.SCALE_FULL;
            Laya.stage.screenMode = Stage.SCREEN_NONE;
            Stat.show();
            
            scene = Laya.stage.addChild(new Scene()) as Scene;
            
            //初始化照相机
            camera = scene.addChild(new Camera(0, 0.1, 100)) as Camera;
            camera.transform.translate(new Vector3(0, 2, 5));
            camera.transform.rotate(new Vector3(-15, 0, 0), true, false);
            camera.clearColor = null;
            
            //方向光
            var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
            directionLight.color = new Vector3(0.6, 0.6, 0.6);
            directionLight.direction = new Vector3(1, -1, -1);
            
            //平面
            var plane:MeshSprite3D = scene.addChild(new MeshSprite3D(new PlaneMesh(6, 6, 10, 10))) as MeshSprite3D;
            var planeMat:StandardMaterial = new StandardMaterial();
            planeMat.diffuseTexture = Texture2D.load("../../../../res/threeDimen/texture/layabox.png");
            planeMat.albedo = new Vector4(0.9, 0.9, 0.9, 1);
            plane.meshRender.material = planeMat;
            var meshCollider:MeshCollider = plane.addComponent(MeshCollider) as MeshCollider;
			meshCollider.mesh = plane.meshFilter.sharedMesh;
			
            Laya.timer.frameLoop(1, this, checkHit);
            
            loadUI();
        }
        
        private function checkHit():void {
            
            //从屏幕空间生成射线
            point.elements[0] = MouseManager.instance.mouseX;
            point.elements[1] = MouseManager.instance.mouseY;
            camera.viewportPointToRay(point, ray);
            
            Physics.rayCast(ray, _outHitInfo, 30, 0);
        }
        
        private function loadUI():void {
            
            label = new Label();
            label.text = "点击放置";
            label.pos(Browser.clientWidth / 2.5, 100);
            label.fontSize = 50;
            label.color = "#40FF40";
            Laya.stage.addChild(label);
            
            //鼠标事件
            Laya.stage.on(Event.MOUSE_UP, this, function():void {
                
                if (_outHitInfo.distance !== -1) {
                    var sphere:MeshSprite3D = scene.addChild(new MeshSprite3D(new SphereMesh(0.25, 16, 16))) as MeshSprite3D;
                    var mat:StandardMaterial = new StandardMaterial();
                    mat.diffuseTexture = Texture2D.load("../../../../res/threeDimen/texture/layabox.png");
                    mat.albedo = new Vector4(Math.random(), Math.random(), Math.random(), 1);
                    sphere.meshRender.material = mat;
                    Vector3.add(_outHitInfo.position, _offset, _position);
                    sphere.transform.position = _position;
                    sphere.transform.rotate(new Vector3(0, 90, 0), false, false);
                }
            });
        }
    }
}
