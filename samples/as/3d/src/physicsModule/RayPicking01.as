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
    
    public class RayPicking01 {
        
        private var ray:Ray = new Ray(new Vector3(0, 0, 0), new Vector3(0, 0, 0));
        private var point:Vector2 = new Vector2();
        private var _outHitAllInfo:Vector.<RaycastHit> = new Vector.<RaycastHit>();
        
        private var camera:Camera;
        private var label:Label;
        
        public function RayPicking01() {
            
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
            
            //平面
            var plane:MeshSprite3D = scene.addChild(new MeshSprite3D(new PlaneMesh(6, 6, 10, 10))) as MeshSprite3D;
            var planeMat:StandardMaterial = new StandardMaterial();
            planeMat.diffuseTexture = Texture2D.load("../../../../res/threeDimen/texture/layabox.png");
            planeMat.albedo = new Vector4(0.9, 0.9, 0.9, 1);
            plane.meshRender.material = planeMat;
            plane.addComponent(BoxCollider);
            plane.name = "平面";
            
            //正方体
            var box:MeshSprite3D = scene.addChild(new MeshSprite3D(new BoxMesh(0.5, 0.5, 0.5))) as MeshSprite3D;
            var boxMat:StandardMaterial = new StandardMaterial();
            boxMat.diffuseTexture = Texture2D.load("../../../../res/threeDimen/texture/layabox.png");
            box.meshRender.material = boxMat;
            box.transform.position = new Vector3(1.5, 0.25, 0.5);
            box.transform.rotate(new Vector3(0, 30, 0), false, false);
            box.addComponent(BoxCollider);
            box.name = "正方体";
            
            //球体
            var sphere:MeshSprite3D = scene.addChild(new MeshSprite3D(new SphereMesh(0.25))) as MeshSprite3D;
            var sphereMat:StandardMaterial = new StandardMaterial();
            sphereMat.diffuseTexture = Texture2D.load("../../../../res/threeDimen/texture/layabox.png");
            sphere.meshRender.material = sphereMat;
            sphere.transform.position = new Vector3(0.5, 0.25, 0.5);
            sphere.transform.rotate(new Vector3(0, 90, 0), false, false);
            sphere.addComponent(SphereCollider);
            sphere.name = "球体";
            
            //圆柱体
            var cylinder:MeshSprite3D = scene.addChild(new MeshSprite3D(new CylinderMesh(0.25, 1))) as MeshSprite3D;
            var cylinderMat:StandardMaterial = new StandardMaterial();
            cylinderMat.diffuseTexture = Texture2D.load("../../../../res/threeDimen/texture/layabox.png");
            cylinder.meshRender.material = cylinderMat;
            cylinder.transform.position = new Vector3(-0.5, 0.5, 0.5);
            cylinder.transform.rotate(new Vector3(0, -45, 0), false, false);
            cylinder.addComponent(MeshCollider);
            cylinder.name = "圆柱体";
            
            //胶囊体
            var capsule:MeshSprite3D = scene.addChild(new MeshSprite3D(new CapsuleMesh(0.25, 1))) as MeshSprite3D;
            var capsuleMat:StandardMaterial = new StandardMaterial();
            capsuleMat.diffuseTexture = Texture2D.load("../../../../res/threeDimen/texture/layabox.png");
            capsule.meshRender.material = capsuleMat;
            capsule.transform.position = new Vector3(-1.5, 0.5, 0.5);
            capsule.transform.rotate(new Vector3(0, -45, 0), false, false);
            capsule.addComponent(MeshCollider);
            capsule.name = "胶囊体";
            
            Laya.timer.frameLoop(1, this, checkHit);
            
            loadUI();
        }
        
        private function checkHit():void {
            
            //从屏幕空间生成射线
            point.elements[0] = MouseManager.instance.mouseX;
            point.elements[1] = MouseManager.instance.mouseY;
            camera.viewportPointToRay(point, ray);
            
            //射线检测获取所有检测碰撞到的物体
            Physics.rayCastAll(ray, _outHitAllInfo, 30, 0);
        }
        
        private function loadUI():void {
            
            label = new Label();
            label.text = "点击选取的几何体";
            label.pos(Browser.clientWidth / 2.5, 100);
            label.fontSize = 50;
            label.color = "#40FF40";
            Laya.stage.addChild(label);
            
            //鼠标事件
            Laya.stage.on(Event.MOUSE_UP, this, function():void {
                var str:String = "";
                for (var i:int = 0; i < _outHitAllInfo.length; i++) {
                    str += _outHitAllInfo[i].sprite3D.name + "  ";
                }
				if (_outHitAllInfo.length == 0){
					str = "点击选取的几何体";
				}
                label.text = str;
            });
        }
    
    }
}
