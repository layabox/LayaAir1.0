package shaderModule {
    import laya.ani.AnimationTemplet;
    import laya.d3.component.animation.SkinAnimations;
    import laya.d3.core.BaseCamera;
    import laya.d3.core.Camera;
    import laya.d3.core.MeshSprite3D;
    import laya.d3.core.SkinnedMeshSprite3D;
    import laya.d3.core.Sprite3D;
    import laya.d3.core.light.DirectionLight;
    import laya.d3.core.material.BaseMaterial;
    import laya.d3.core.scene.Scene;
    import laya.d3.graphics.VertexElementUsage;
    import laya.d3.math.Vector3;
    import laya.d3.resource.Texture2D;
    import laya.d3.resource.models.CapsuleMesh;
    import laya.d3.resource.models.Mesh;
    import laya.d3.resource.models.SphereMesh;
    import laya.d3.shader.Shader3D;
    import laya.d3.shader.ShaderCompile3D;
    import laya.display.Stage;
    import laya.events.Event;
    import laya.utils.Stat;
    import common.CameraMoveScript;
	import shaderModule.customMaterials.CustomMaterial;
    
    /**
     * ...
     * @author
     */
    public class Shader_GlowingEdge {
        private var rotation:Vector3 = new Vector3(0, 0.01, 0);
        
        public function Shader_GlowingEdge() {
            Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Stage.SCALE_FULL;
            Laya.stage.screenMode = Stage.SCREEN_NONE;
            Stat.show();
            
            initShader();
            
            var scene:Scene = Laya.stage.addChild(new Scene());
            
            var camera:Camera = (scene.addChild(new Camera(0, 0.1, 1000))) as Camera;
            camera.transform.translate(new Vector3(0, 0.85, 1.7));
            camera.transform.rotate(new Vector3(-15, 0, 0), true, false);
            camera.addComponent(CameraMoveScript);
            
            var directionLight:DirectionLight = scene.addChild(new DirectionLight()) as DirectionLight;
            directionLight.ambientColor = new Vector3(1, 1, 1);
            directionLight.specularColor = new Vector3(1, 1, 1);
            directionLight.diffuseColor = new Vector3(0.0, 0.3, 1.0);
            directionLight.direction = new Vector3(1, -1, 0);
            
            var dude:Sprite3D = scene.addChild(Sprite3D.load("../../../../res/threeDimen/skinModel/dude/dude.lh")) as Sprite3D;
            
            dude.once(Event.HIERARCHY_LOADED, this, function():void {
                
                var customMaterial1:CustomMaterial = new CustomMaterial();
                customMaterial1.diffuseTexture = Texture2D.load("../../../../res/threeDimen/skinModel/dude/Assets/dude/head.png");
                customMaterial1.marginalColor = new Vector3(1, 0.7, 0);
                
                var customMaterial2:CustomMaterial = new CustomMaterial();
                customMaterial2.diffuseTexture = Texture2D.load("../../../../res/threeDimen/skinModel/dude/Assets/dude/jacket.png");
                customMaterial2.marginalColor = new Vector3(1, 0.7, 0);
                
                var customMaterial3:CustomMaterial = new CustomMaterial();
                customMaterial3.diffuseTexture = Texture2D.load("../../../../res/threeDimen/skinModel/dude/Assets/dude/pants.png");
                customMaterial3.marginalColor = new Vector3(1, 0.7, 0);
                
                var customMaterial4:CustomMaterial = new CustomMaterial();
                customMaterial4.diffuseTexture = Texture2D.load("../../../../res/threeDimen/skinModel/dude/Assets/dude/upBody.png");
                customMaterial4.marginalColor = new Vector3(1, 0.7, 0);
                
                var baseMaterials:Vector.<BaseMaterial> = new Vector.<BaseMaterial>();
                baseMaterials[0] = customMaterial1;
                baseMaterials[1] = customMaterial2;
                baseMaterials[2] = customMaterial3;
                baseMaterials[3] = customMaterial4;
                
                dude.getChildAt(0).getChildAt(0).skinnedMeshRender.sharedMaterials = baseMaterials;
				dude.transform.position = new Vector3(0, 0.5, 0);
            });
            
            var earth:MeshSprite3D = scene.addChild(new MeshSprite3D(new SphereMesh(0.5, 128, 128))) as MeshSprite3D;
            
            var customMaterial:CustomMaterial = new CustomMaterial();
            customMaterial.diffuseTexture = Texture2D.load("../../../../res/threeDimen/texture/earth.png");
            customMaterial.marginalColor = new Vector3(0.0, 0.3, 1.0);
            earth.meshRender.sharedMaterial = customMaterial;
            
            Laya.timer.frameLoop(1, null, function():void {
                earth.transform.rotate(rotation, true);
            });
        }
        
        private function initShader():void {
            var attributeMap:Object = {'a_BoneIndices': VertexElementUsage.BLENDINDICES0, 'a_BoneWeights': VertexElementUsage.BLENDWEIGHT0, 'a_Position': VertexElementUsage.POSITION0, 'a_Normal': VertexElementUsage.NORMAL0, 'a_Texcoord': VertexElementUsage.TEXTURECOORDINATE0};
            var uniformMap:Object = {'u_Bones': [SkinnedMeshSprite3D.BONES, Shader3D.PERIOD_RENDERELEMENT], 'u_CameraPos': [BaseCamera.CAMERAPOS, Shader3D.PERIOD_CAMERA], 'u_MvpMatrix': [Sprite3D.MVPMATRIX, Shader3D.PERIOD_SPRITE], 'u_WorldMat': [Sprite3D.WORLDMATRIX, Shader3D.PERIOD_SPRITE], 'u_texture': [CustomMaterial.DIFFUSETEXTURE, Shader3D.PERIOD_MATERIAL], 'u_marginalColor': [CustomMaterial.MARGINALCOLOR, Shader3D.PERIOD_MATERIAL], 'u_DirectionLight.Direction': [Scene.LIGHTDIRECTION, Shader3D.PERIOD_SCENE], 'u_DirectionLight.Diffuse': [Scene.LIGHTDIRDIFFUSE, Shader3D.PERIOD_SCENE], 'u_DirectionLight.Ambient': [Scene.LIGHTDIRAMBIENT, Shader3D.PERIOD_SCENE], 'u_DirectionLight.Specular': [Scene.LIGHTDIRSPECULAR, Shader3D.PERIOD_SCENE]};
            var customShader:int = Shader3D.nameKey.add("CustomShader");
            var vs:String = __INCLUDESTR__("customShader/glowingEdgeShader.vs");
            var ps:String = __INCLUDESTR__("customShader/glowingEdgeShader.ps");
            ShaderCompile3D.add(customShader, vs, ps, attributeMap, uniformMap);
        }
    }
}