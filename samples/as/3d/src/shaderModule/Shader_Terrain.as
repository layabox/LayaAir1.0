package shaderModule {
    import laya.d3.core.BaseCamera;
    import laya.d3.core.Camera;
    import laya.d3.core.MeshSprite3D;
    import laya.d3.core.Sprite3D;
    import laya.d3.core.light.DirectionLight;
    import laya.d3.core.material.StandardMaterial;
    import laya.d3.core.material.TerrainMaterial;
    import laya.d3.core.scene.Scene;
    import laya.d3.graphics.VertexElementUsage;
    import laya.d3.math.Vector2;
    import laya.d3.math.Vector3;
    import laya.d3.math.Vector4;
    import laya.d3.resource.Texture2D;
    import laya.d3.resource.models.CapsuleMesh;
    import laya.d3.resource.models.Mesh;
    import laya.d3.resource.models.SphereMesh;
    import laya.d3.resource.models.SubMesh;
    import laya.d3.shader.Shader3D;
    import laya.d3.shader.ShaderCompile3D;
    import laya.display.Stage;
    import laya.events.Event;
    import laya.utils.Stat;
    import common.CameraMoveScript;
    import shaderModule.customMaterials.CustomMaterial;
    import shaderModule.customMaterials.CustomTerrainMaterial;
    
    /**
     * ...
     * @author
     */
    public class Shader_Terrain {
        
        public function Shader_Terrain() {
            
            Laya3D.init(0, 0, true);
            Laya.stage.scaleMode = Stage.SCALE_FULL;
            Laya.stage.screenMode = Stage.SCREEN_NONE;
            Stat.show();
            
            initShader();
            
            var scene:Scene = Laya.stage.addChild(Scene.load("../../../../res/threeDimen/scene/terrain/terrain.ls")) as Scene;
            
            var camera:Camera = scene.addChild(new Camera(0, 0.1, 1000)) as Camera;
            camera.transform.rotate(new Vector3(-38, 180, 0), false, false);
            camera.transform.translate(new Vector3(-5, 20, -30), false);
            camera.addComponent(CameraMoveScript);
            
            scene.once(Event.HIERARCHY_LOADED, this, function():void {
                setCustomMaterial(scene.getChildAt(2));
            });
        }
        
        public function setCustomMaterial(spirit3D:Sprite3D):void {
            
            if (spirit3D is MeshSprite3D) {
                
                var meshSprite3D:MeshSprite3D = spirit3D as MeshSprite3D;
                var customMaterial:CustomTerrainMaterial = new CustomTerrainMaterial();
                customMaterial.splatAlphaTexture = Texture2D.load("../../../../res/threeDimen/scene/terrain/terrain/splatalpha 0.png");
                customMaterial.lightMapTexture = Texture2D.load("../../../../res/threeDimen/scene/terrain/Assets/Scenes/Level/XunLongShi/Lightmap-0_comp_light.png");
                customMaterial.diffuseTexture1 = Texture2D.load("../../../../res/threeDimen/scene/terrain/terrain/ground_01.jpg");
                customMaterial.diffuseTexture2 = Texture2D.load("../../../../res/threeDimen/scene/terrain/terrain/ground_02.jpg");
                customMaterial.diffuseTexture3 = Texture2D.load("../../../../res/threeDimen/scene/terrain/terrain/ground_03.jpg");
                customMaterial.diffuseTexture4 = Texture2D.load("../../../../res/threeDimen/scene/terrain/terrain/ground_04.jpg");
                customMaterial.setDiffuseScale1(new Vector2(27.92727, 27.92727));
                customMaterial.setDiffuseScale2(new Vector2(13.96364, 13.96364));
                customMaterial.setDiffuseScale3(new Vector2(18.61818, 18.61818));
                customMaterial.setDiffuseScale4(new Vector2(13.96364, 13.96364));
                customMaterial.ambientColor = new Vector3(1, 1, 1);
                customMaterial.diffuseColor = new Vector3(1, 1, 1);
                customMaterial.specularColor = new Vector4(1, 1, 1, 8);
                customMaterial.setLightmapScaleOffset(new Vector4(0.8056641, 0.8056641, 0.001573598, -6.878261E-11));
                meshSprite3D.meshRender.sharedMaterial = customMaterial;
            }
			
            for (var i:int = 0, n:int = spirit3D._childs.length; i < n; i++)
                setCustomMaterial(spirit3D._childs[i]);
        }
        
        private function initShader():void {
            
            var attributeMap:Object = {'a_Position': VertexElementUsage.POSITION0, 'a_Normal': VertexElementUsage.NORMAL0, 'a_Texcoord0': VertexElementUsage.TEXTURECOORDINATE0, 'a_Texcoord1': VertexElementUsage.TEXTURECOORDINATE1};
            var uniformMap:Object = {'u_MvpMatrix': [Sprite3D.MVPMATRIX, Shader3D.PERIOD_SPRITE], 'u_WorldMat': [Sprite3D.WORLDMATRIX, Shader3D.PERIOD_SPRITE], 'u_CameraPos': [BaseCamera.CAMERAPOS, Shader3D.PERIOD_CAMERA], 'u_SplatAlphaTexture': [CustomTerrainMaterial.SPLATALPHATEXTURE, Shader3D.PERIOD_MATERIAL], 'u_NormalTexture': [CustomTerrainMaterial.NORMALTEXTURE, Shader3D.PERIOD_MATERIAL], 'u_LightMapTexture': [CustomTerrainMaterial.LIGHTMAPTEXTURE, Shader3D.PERIOD_MATERIAL], 'u_DiffuseTexture1': [CustomTerrainMaterial.DIFFUSETEXTURE1, Shader3D.PERIOD_MATERIAL], 'u_DiffuseTexture2': [CustomTerrainMaterial.DIFFUSETEXTURE2, Shader3D.PERIOD_MATERIAL], 'u_DiffuseTexture3': [CustomTerrainMaterial.DIFFUSETEXTURE3, Shader3D.PERIOD_MATERIAL], 'u_DiffuseTexture4': [CustomTerrainMaterial.DIFFUSETEXTURE4, Shader3D.PERIOD_MATERIAL], 'u_DiffuseTexture5': [CustomTerrainMaterial.DIFFUSETEXTURE5, Shader3D.PERIOD_MATERIAL], 'u_DiffuseScale1': [CustomTerrainMaterial.DIFFUSESCALE1, Shader3D.PERIOD_MATERIAL], 'u_DiffuseScale2': [CustomTerrainMaterial.DIFFUSESCALE2, Shader3D.PERIOD_MATERIAL], 'u_DiffuseScale3': [CustomTerrainMaterial.DIFFUSESCALE3, Shader3D.PERIOD_MATERIAL], 'u_DiffuseScale4': [CustomTerrainMaterial.DIFFUSESCALE4, Shader3D.PERIOD_MATERIAL], 'u_DiffuseScale5': [CustomTerrainMaterial.DIFFUSESCALE5, Shader3D.PERIOD_MATERIAL], 'u_lightmapScaleOffset': [CustomTerrainMaterial.LIGHTMAPSCALEOFFSET, Shader3D.PERIOD_MATERIAL], 'u_MaterialDiffuse': [CustomTerrainMaterial.MATERIALDIFFUSE, Shader3D.PERIOD_MATERIAL], 'u_MaterialAmbient': [CustomTerrainMaterial.MATERIALAMBIENT, Shader3D.PERIOD_MATERIAL], 'u_MaterialSpecular': [CustomTerrainMaterial.MATERIALSPECULAR, Shader3D.PERIOD_MATERIAL], 'u_DirectionLight.Direction': [Scene.LIGHTDIRECTION, Shader3D.PERIOD_SCENE], 'u_DirectionLight.Diffuse': [Scene.LIGHTDIRDIFFUSE, Shader3D.PERIOD_SCENE], 'u_DirectionLight.Ambient': [Scene.LIGHTDIRAMBIENT, Shader3D.PERIOD_SCENE], 'u_DirectionLight.Specular': [Scene.LIGHTDIRSPECULAR, Shader3D.PERIOD_SCENE]};
            var customTerrianShader:int = Shader3D.nameKey.add("CustomTerrainShader");
            var vs:String = __INCLUDESTR__("customShader/terrainShader.vs");
            var ps:String = __INCLUDESTR__("customShader/terrainShader.ps");
            var customTerrainCompile3D:ShaderCompile3D = ShaderCompile3D.add(customTerrianShader, vs, ps, attributeMap, uniformMap);
            
            CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM1 = customTerrainCompile3D.registerMaterialDefine("CUSTOM_DETAIL_NUM1");
            CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM2 = customTerrainCompile3D.registerMaterialDefine("CUSTOM_DETAIL_NUM2");
            CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM3 = customTerrainCompile3D.registerMaterialDefine("CUSTOM_DETAIL_NUM3");
            CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM4 = customTerrainCompile3D.registerMaterialDefine("CUSTOM_DETAIL_NUM4");
            CustomTerrainMaterial.SHADERDEFINE_DETAIL_NUM5 = customTerrainCompile3D.registerMaterialDefine("CUSTOM_DETAIL_NUM5");
            CustomTerrainMaterial.SHADERDEFINE_LIGHTMAP = customTerrainCompile3D.registerMaterialDefine("CUSTOM_LIGHTMAP");
        
        }
    
    }

}