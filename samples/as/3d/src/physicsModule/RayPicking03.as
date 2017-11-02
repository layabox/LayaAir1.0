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
    import laya.d3.math.Quaternion;
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
    import laya.utils.Tween;
    import laya.webgl.WebGLContext;
    
    public class RayPicking03 {
        
        private var ray:Ray = new Ray(new Vector3(0, 0, 0), new Vector3(0, 0, 0));
        private var point:Vector2 = new Vector2();
        private var _outHitInfo:RaycastHit = new RaycastHit();
        private var _position:Vector3 = new Vector3(0, 0.25, 0);
        private var _upVector3:Vector3 = new Vector3(0, 1, 0);
        private var _quaternion:Quaternion = new Quaternion();
        private var _vector3:Vector3 = new Vector3();
        private var _offsetVector3:Vector3 = new Vector3(0, 0.25, 0);
        private var box:MeshSprite3D;
        
		private var camera:Camera;
        private var label:Label;
        
        public function RayPicking03() {
            
            Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Stage.SCALE_FULL;
            Laya.stage.screenMode = Stage.SCREEN_NONE;
            Stat.show();
            
            var scene:Scene = Laya.stage.addChild(new Scene()) as Scene;
            
            //初始化照相机
            camera = scene.addChild(new Camera(0, 0.1, 100)) as Camera;
            camera.transform.translate(new Vector3(0, 2, 5));
            camera.transform.rotate(new Vector3(-15, 0, 0), true, false);
            camera.clearColor = null;
            
            //方向光
            var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
            directionLight.color = new Vector3(0.6, 0.6, 0.6);
            directionLight.direction = new Vector3(1, -1, -1);
            
            var plane:MeshSprite3D = scene.addChild(new MeshSprite3D(new PlaneMesh(6, 6, 10, 10))) as MeshSprite3D;
            var planeMat:StandardMaterial = new StandardMaterial();
            planeMat.diffuseTexture = Texture2D.load("../../../../res/threeDimen/texture/layabox.png");
            planeMat.albedo = new Vector4(0.9, 0.9, 0.9, 1);
            plane.meshRender.material = planeMat;
            plane.addComponent(MeshCollider);
            
            box = scene.addChild(new MeshSprite3D(new BoxMesh(0.5, 0.5, 0.5))) as MeshSprite3D;
            var mat:StandardMaterial = new StandardMaterial();
            mat.diffuseTexture = Texture2D.load("../../../../res/threeDimen/texture/layabox.png");
            box.meshRender.material = mat;
            box.transform.position = _position;
            
            Laya.timer.frameLoop(1, this, checkHit);
            
            loadUI();
        }
        
        private function checkHit():void {
            
            box.transform.position = _position;
            box.transform.rotation = _quaternion;
            
            //从屏幕空间生成射线
            point.elements[0] = MouseManager.instance.mouseX;
            point.elements[1] = MouseManager.instance.mouseY;
            camera.viewportPointToRay(point, ray);
            
            Physics.rayCast(ray, _outHitInfo, 30, 0);
        }
        
        private function loadUI():void {
            
            label = new Label();
            label.text = "点击移动";
            label.pos(Browser.clientWidth / 2.5, 100);
            label.fontSize = 50;
            label.color = "#40FF40";
            Laya.stage.addChild(label);
            
            //鼠标事件
            Laya.stage.on(Event.MOUSE_UP, this, function():void {
                if (_outHitInfo.distance !== -1) {
                    Vector3.add(_outHitInfo.position, _offsetVector3, _vector3);
                    Tween.to(_position, {x: _vector3.x, y: _vector3.y, z: _vector3.z}, 500/**,Ease.circIn*/);
                    Quaternion.lookAt(box.transform.position, _vector3, _upVector3, _quaternion);
                }
            });
        }
    }

}
