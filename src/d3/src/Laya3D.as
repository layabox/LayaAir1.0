package {
	import laya.ani.AnimationTemplet;
	import laya.d3.core.Layer;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.GlitterMaterial;
	import laya.d3.core.material.ParticleMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.particleShuriKen.ShurikenParticleMaterial;
	import laya.d3.core.particleShuriKen.ShurikenParticleSystem;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.TextureCube;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.Sky;
	import laya.d3.shader.ShaderDefines3D;
	import laya.d3.utils.Utils3D;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.net.LoaderManager;
	import laya.net.URL;
	import laya.particle.shader.ParticleShader;
	import laya.renders.Render;
	import laya.utils.Byte;
	import laya.utils.ClassUtils;
	import laya.utils.Handler;
	import laya.utils.RunDriver;
	import laya.webgl.WebGL;
	import laya.webgl.shader.Shader;
	
	/**
	 * <code>Laya3D</code> 类用于初始化3D设置。
	 */
	public class Laya3D {
		/**@private */
		private static var _DATA:Object = {offset: 0, size: 0};
		/**@private */
		private static var _strings:Array = ['BLOCK', 'DATA', "STRINGS"];//字符串数组
		/**@private */
		private static var _readData:Byte;
		
		/**@private */
		private static const _innerTextureCubeLoaderManager:LoaderManager = new LoaderManager();
		/**@private */
		private static const _innerMaterialLoaderManager:LoaderManager = new LoaderManager();
		/**@private */
		private static const _innerMeshLoaderManager:LoaderManager = new LoaderManager();
		/**@private */
		private static const _innerSprite3DHierarchyLoaderManager:LoaderManager = new LoaderManager();
		
		/**@private 层级文件资源标记。*/
		private static const SPRITE3DHIERARCHY:String = "SPRITE3DHIERARCHY";
		/**@private 网格的原始资源标记。*/
		private static const MESH:String = "MESH";
		/**@private 材质的原始资源标记。*/
		private static const MATERIAL:String = "MATERIAL";
		/**@private TextureCube原始资源标记。*/
		private static const TEXTURECUBE:String = "TEXTURECUBE";
		
		/**
		 * 创建一个 <code>Laya3D</code> 实例。
		 */
		public function Laya3D() {
		}
		
		private static function _changeWebGLSize(width:Number, height:Number):void {
			WebGL.onStageResize(width, height);
			RenderState.clientWidth = width;
			RenderState.clientHeight = height;
		}
		
		private static function _initShader():void {
			Shader.addInclude("LightHelper.glsl", __INCLUDESTR__("laya/d3/shader/files/LightHelper.glsl"));
			Shader.addInclude("VRHelper.glsl", __INCLUDESTR__("laya/d3/shader/files/VRHelper.glsl"));
			
			var vs:String, ps:String;
			var shaderNameMap:Object = {
			'a_Position': VertexElementUsage.POSITION0, 
			'a_Color': VertexElementUsage.COLOR0, 
			'a_Normal': VertexElementUsage.NORMAL0, 
			'a_Texcoord0': VertexElementUsage.TEXTURECOORDINATE0, 
			'a_Texcoord1': VertexElementUsage.TEXTURECOORDINATE1, 
			'a_TexcoordNext0': VertexElementUsage.NEXTTEXTURECOORDINATE0, 
			'a_BoneWeights': VertexElementUsage.BLENDWEIGHT0, 
			'a_BoneIndices': VertexElementUsage.BLENDINDICES0, 
			'a_Tangent0': VertexElementUsage.TANGENT0, 
			'u_CameraPos': BaseScene.CAMERAPOS, 
			'u_FogStart': BaseScene.FOGSTART, 
			'u_FogRange': BaseScene.FOGRANGE, 
			'u_FogColor': BaseScene.FOGCOLOR, 
			'u_DirectionLight.Direction': BaseScene.LIGHTDIRECTION, 
			'u_DirectionLight.Diffuse': BaseScene.LIGHTDIRDIFFUSE, 
			'u_DirectionLight.Ambient': BaseScene.LIGHTDIRAMBIENT, 
			'u_DirectionLight.Specular': BaseScene.LIGHTDIRSPECULAR, 
			'u_PointLight.Position': BaseScene.POINTLIGHTPOS, 
			'u_PointLight.Range': BaseScene.POINTLIGHTRANGE, 
			'u_PointLight.Attenuation': BaseScene.POINTLIGHTATTENUATION, 
			'u_PointLight.Diffuse': BaseScene.POINTLIGHTDIFFUSE, 
			'u_PointLight.Ambient': BaseScene.POINTLIGHTAMBIENT, 
			'u_PointLight.Specular': BaseScene.POINTLIGHTSPECULAR, 
			'u_SpotLight.Position': BaseScene.SPOTLIGHTPOS, 
			'u_SpotLight.Direction': BaseScene.SPOTLIGHTDIRECTION, 
			'u_SpotLight.Range': BaseScene.SPOTLIGHTRANGE, 
			'u_SpotLight.Spot': BaseScene.SPOTLIGHTSPOT, 
			'u_SpotLight.Attenuation': BaseScene.SPOTLIGHTATTENUATION, 
			'u_SpotLight.Diffuse': BaseScene.SPOTLIGHTDIFFUSE, 
			'u_SpotLight.Ambient': BaseScene.SPOTLIGHTAMBIENT, 
			'u_SpotLight.Specular': BaseScene.SPOTLIGHTSPECULAR, 
			'u_WorldMat': StandardMaterial.WORLDMATRIX, 
			'u_DiffuseTexture': StandardMaterial.DIFFUSETEXTURE, 
			'u_SpecularTexture': StandardMaterial.SPECULARTEXTURE, 
			'u_NormalTexture': StandardMaterial.NORMALTEXTURE, 
			'u_AmbientTexture': StandardMaterial.AMBIENTTEXTURE, 
			'u_ReflectTexture': StandardMaterial.REFLECTTEXTURE, 
			'u_MvpMatrix': StandardMaterial.MVPMATRIX, 
			'u_Bones': StandardMaterial.Bones, 
			'u_Albedo': StandardMaterial.ALBEDO, 
			'u_AlphaTestValue': StandardMaterial.ALPHATESTVALUE, 
			'u_UVMatrix': StandardMaterial.UVMATRIX, 
			'u_UVAge': StandardMaterial.UVAGE, 
			'u_UVAniAge': StandardMaterial.UVANIAGE, 
			'u_MaterialDiffuse': StandardMaterial.MATERIALDIFFUSE, 
			'u_MaterialAmbient': StandardMaterial.MATERIALAMBIENT, 
			'u_MaterialSpecular': StandardMaterial.MATERIALSPECULAR, 
			'u_MaterialReflect': StandardMaterial.MATERIALREFLECT}
			
			var SIMPLE:int = Shader.nameKey.add("SIMPLE");
			vs = __INCLUDESTR__("laya/d3/shader/files/PixelSimpleTextureSkinnedMesh.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/PixelSimpleTextureSkinnedMesh.ps");
			Shader.preCompile(SIMPLE, vs, ps, shaderNameMap);
			
			var SIMPLEVEXTEX:int = Shader.nameKey.add("SIMPLEVEXTEX");
			vs = __INCLUDESTR__("laya/d3/shader/files/VertexSimpleTextureSkinnedMesh.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/VertexSimpleTextureSkinnedMesh.ps");
			Shader.preCompile(SIMPLEVEXTEX, vs, ps, shaderNameMap);
			
			shaderNameMap = {
			'a_Position': VertexElementUsage.POSITION0, 
			'a_Texcoord': VertexElementUsage.TEXTURECOORDINATE0, 
			'u_FogStart': BaseScene.FOGSTART, 
			'u_FogRange': BaseScene.FOGRANGE, 
			'u_FogColor': BaseScene.FOGCOLOR, 
			'u_CameraPos': BaseScene.CAMERAPOS, 
			'u_WorldMat': StandardMaterial.WORLDMATRIX, 
			'u_BlendTexture': StandardMaterial.DIFFUSETEXTURE, 
			'u_LayerTexture0': StandardMaterial.NORMALTEXTURE, 
			'u_LayerTexture1': StandardMaterial.SPECULARTEXTURE, 
			'u_LayerTexture2': StandardMaterial.EMISSIVETEXTURE, 
			'u_LayerTexture3': StandardMaterial.AMBIENTTEXTURE, 
			'u_MvpMatrix': StandardMaterial.MVPMATRIX, 
			'u_Albedo': StandardMaterial.ALBEDO, 
			'u_Ambient': StandardMaterial.MATERIALAMBIENT, 
			'u_UVMatrix': StandardMaterial.UVMATRIX};
			var TERRAIN:int = Shader.nameKey.add("TERRAIN");
			vs = __INCLUDESTR__("laya/d3/shader/files/modelTerrain.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/modelTerrain.ps");
			Shader.preCompile(TERRAIN, vs, ps, shaderNameMap);
			
			shaderNameMap = {
			'a_CornerTextureCoordinate': VertexElementUsage.CORNERTEXTURECOORDINATE0, 
			'a_Position': VertexElementUsage.POSITION0, 
			'a_Velocity': VertexElementUsage.VELOCITY0, 
			'a_StartColor': VertexElementUsage.STARTCOLOR0, 
			'a_EndColor': VertexElementUsage.ENDCOLOR0, 
			'a_SizeRotation': VertexElementUsage.SIZEROTATION0, 
			'a_Radius': VertexElementUsage.RADIUS0, 
			'a_Radian': VertexElementUsage.RADIAN0, 
			'a_AgeAddScale': VertexElementUsage.STARTLIFETIME, 
			'a_Time': VertexElementUsage.TIME0, 
			'u_WorldMat': ParticleMaterial.WORLDMATRIX, 
			'u_View': ParticleMaterial.VIEWMATRIX, 
			'u_Projection': ParticleMaterial.PROJECTIONMATRIX, 
			'u_ViewportScale': ParticleMaterial.VIEWPORTSCALE, 
			'u_CurrentTime': ParticleMaterial.CURRENTTIME, 
			'u_Duration': ParticleMaterial.DURATION, 
			'u_Gravity': ParticleMaterial.GRAVITY, 
			'u_EndVelocity': ParticleMaterial.ENDVELOCITY, 
			'u_texture': ParticleMaterial.DIFFUSETEXTURE};
			var PARTICLE:int = Shader.nameKey.add("PARTICLE");
			Shader.preCompile(PARTICLE, ParticleShader.vs, ParticleShader.ps, shaderNameMap);
			
			shaderNameMap = {
			'a_CornerTextureCoordinate': VertexElementUsage.CORNERTEXTURECOORDINATE0, 
			'a_Position': VertexElementUsage.POSITION0, 
			'a_Direction': VertexElementUsage.DIRECTION, 
			'a_StartColor': VertexElementUsage.STARTCOLOR0, 
			'a_EndColor': VertexElementUsage.ENDCOLOR0, 
			'a_StartSize': VertexElementUsage.STARTSIZE, 
			'a_StartRotation0': VertexElementUsage.STARTROTATION0, 
			'a_StartRotation1': VertexElementUsage.STARTROTATION1, 
			'a_StartRotation2': VertexElementUsage.STARTROTATION2, 
			'a_StartLifeTime': VertexElementUsage.STARTLIFETIME, 
			'a_StartSpeed': VertexElementUsage.STARTSPEED, 
			'a_Time': VertexElementUsage.TIME0, 
			'a_Random0': VertexElementUsage.RANDOM0, 
			'a_Random1': VertexElementUsage.RANDOM1, 
			'a_SimulationWorldPostion': VertexElementUsage.SIMULATIONWORLDPOSTION, 
			'u_WorldPosition': ShurikenParticleMaterial.WORLDPOSITION, 
			'u_WorldRotationMat': ShurikenParticleMaterial.WORLDROTATIONMATRIX, 
			'u_ThreeDStartRotation': ShurikenParticleMaterial.THREEDSTARTROTATION, 
			'u_ScalingMode': ShurikenParticleMaterial.SCALINGMODE, 
			'u_PositionScale': ShurikenParticleMaterial.POSITIONSCALE, 
			'u_SizeScale': ShurikenParticleMaterial.SIZESCALE, 
			'u_View': ShurikenParticleMaterial.VIEWMATRIX, 
			'u_Projection': ShurikenParticleMaterial.PROJECTIONMATRIX, 
			'u_CurrentTime': ShurikenParticleMaterial.CURRENTTIME, 
			'u_Gravity': ShurikenParticleMaterial.GRAVITY, 
			'u_texture': ShurikenParticleMaterial.DIFFUSETEXTURE, 
			'u_CameraDirection': ShurikenParticleMaterial.CAMERADIRECTION, 
			'u_CameraUp': ShurikenParticleMaterial.CAMERAUP, 
			'u_StretchedBillboardLengthScale': ShurikenParticleMaterial.STRETCHEDBILLBOARDLENGTHSCALE, 
			'u_StretchedBillboardSpeedScale': ShurikenParticleMaterial.STRETCHEDBILLBOARDSPEEDSCALE, 
			'u_ColorOverLifeGradientAlphas': ShurikenParticleMaterial.COLOROVERLIFEGRADIENTALPHAS, 
			'u_ColorOverLifeGradientColors': ShurikenParticleMaterial.COLOROVERLIFEGRADIENTCOLORS, 
			'u_MaxColorOverLifeGradientAlphas': ShurikenParticleMaterial.MAXCOLOROVERLIFEGRADIENTALPHAS, 
			'u_MaxColorOverLifeGradientColors': ShurikenParticleMaterial.MAXCOLOROVERLIFEGRADIENTCOLORS, 
			'u_SimulationSpace': ShurikenParticleMaterial.SIMULATIONSPACE, 
			'u_VOLType': ShurikenParticleMaterial.VOLTYPE, 
			'u_VOLVelocityConst': ShurikenParticleMaterial.VOLVELOCITYCONST, 
			'u_VOLVelocityGradientX': ShurikenParticleMaterial.VOLVELOCITYGRADIENTX, 
			'u_VOLVelocityGradientY': ShurikenParticleMaterial.VOLVELOCITYGRADIENTY, 
			'u_VOLVelocityGradientZ': ShurikenParticleMaterial.VOLVELOCITYGRADIENTZ, 
			'u_VOLVelocityConstMax': ShurikenParticleMaterial.VOLVELOCITYCONSTMAX, 
			'u_VOLVelocityGradientMaxX': ShurikenParticleMaterial.VOLVELOCITYGRADIENTXMAX, 
			'u_VOLVelocityGradientMaxY': ShurikenParticleMaterial.VOLVELOCITYGRADIENTYMAX, 
			'u_VOLVelocityGradientMaxZ': ShurikenParticleMaterial.VOLVELOCITYGRADIENTZMAX, 
			'u_VOLSpaceType': ShurikenParticleMaterial.VOLSPACETYPE, 
			'u_SOLType': ShurikenParticleMaterial.SOLTYPE, 
			'u_SOLSeprarate': ShurikenParticleMaterial.SOLSEPRARATE, 
			'u_SOLSizeGradient': ShurikenParticleMaterial.SOLSIZEGRADIENT, 
			'u_SOLSizeGradientX': ShurikenParticleMaterial.SOLSIZEGRADIENTX, 
			'u_SOLSizeGradientY': ShurikenParticleMaterial.SOLSIZEGRADIENTY, 
			'u_SOLSizeGradientZ': ShurikenParticleMaterial.SOLSizeGradientZ, 
			'u_SOLSizeGradientMax': ShurikenParticleMaterial.SOLSizeGradientMax, 
			'u_SOLSizeGradientMaxX': ShurikenParticleMaterial.SOLSIZEGRADIENTXMAX, 
			'u_SOLSizeGradientMaxY': ShurikenParticleMaterial.SOLSIZEGRADIENTYMAX, 
			'u_SOLSizeGradientMaxZ': ShurikenParticleMaterial.SOLSizeGradientZMAX, 
			'u_ROLType': ShurikenParticleMaterial.ROLTYPE, 
			'u_ROLSeprarate': ShurikenParticleMaterial.ROLSEPRARATE, 
			'u_ROLAngularVelocityConst': ShurikenParticleMaterial.ROLANGULARVELOCITYCONST, 
			'u_ROLAngularVelocityConstSeprarate': ShurikenParticleMaterial.ROLANGULARVELOCITYCONSTSEPRARATE, 
			'u_ROLAngularVelocityGradient': ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENT, 
			'u_ROLAngularVelocityGradientX': ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENTX, 
			'u_ROLAngularVelocityGradientY': ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENTY, 
			'u_ROLAngularVelocityGradientZ': ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENTZ, 
			'u_ROLAngularVelocityConstMax': ShurikenParticleMaterial.ROLANGULARVELOCITYCONSTMAX, 
			'u_ROLAngularVelocityConstMaxSeprarate': ShurikenParticleMaterial.ROLANGULARVELOCITYCONSTMAXSEPRARATE, 
			'u_ROLAngularVelocityGradientMax': ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENTMAX, 
			'u_ROLAngularVelocityGradientMaxX': ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENTXMAX, 
			'u_ROLAngularVelocityGradientMaxY': ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENTYMAX, 
			'u_ROLAngularVelocityGradientMaxZ': ShurikenParticleMaterial.ROLANGULARVELOCITYGRADIENTZMAX, 
			'u_TSAType': ShurikenParticleMaterial.TEXTURESHEETANIMATIONTYPE, 
			'u_TSACycles': ShurikenParticleMaterial.TEXTURESHEETANIMATIONCYCLES, 
			'u_TSASubUVLength': ShurikenParticleMaterial.TEXTURESHEETANIMATIONSUBUVLENGTH, 
			'u_TSAGradientUVs': ShurikenParticleMaterial.TEXTURESHEETANIMATIONGRADIENTUVS, 
			'u_TSAMaxGradientUVs': ShurikenParticleMaterial.TEXTURESHEETANIMATIONGRADIENTMAXUVS};
			var PARTICLESHURIKEN:int = Shader.nameKey.add("PARTICLESHURIKEN");
			vs = __INCLUDESTR__("laya/d3/shader/files/ParticleShuriKen.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/ParticleShuriKen.ps");
			Shader.preCompile(PARTICLESHURIKEN, vs, ps, shaderNameMap);
			
			shaderNameMap = {
			'a_Position': VertexElementUsage.POSITION0, 
			'a_Texcoord0': VertexElementUsage.TEXTURECOORDINATE0, 
			'a_Time': GlitterMaterial.TIME, 
			'u_Texture': GlitterMaterial.DIFFUSETEXTURE, 
			'u_MvpMatrix': GlitterMaterial.MVPMATRIX, 
			'u_Albedo': GlitterMaterial.ALBEDO, 
			'u_CurrentTime': GlitterMaterial.CURRENTTIME, 
			'u_Color': GlitterMaterial.UNICOLOR, 
			'u_Duration': GlitterMaterial.DURATION};
			
			var GLITTER:int = Shader.nameKey.add("GLITTER");
			vs = __INCLUDESTR__("laya/d3/shader/files/Glitter.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/Glitter.ps");
			Shader.preCompile(GLITTER, vs, ps, shaderNameMap);
			
			shaderNameMap = {
			'a_Position': VertexElementUsage.POSITION0, 
			'u_MvpMatrix': Sky.MVPMATRIX, 
			'u_Intensity': Sky.INTENSITY, 
			'u_AlphaBlending': Sky.ALPHABLENDING, 
			'u_CubeTexture': Sky.DIFFUSETEXTURE};
			var skyBox:int = Shader.nameKey.add("SkyBox");
			vs = __INCLUDESTR__("laya/d3/shader/files/SkyBox.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/SkyBox.ps");
			Shader.preCompile(skyBox, vs, ps, shaderNameMap);
			
			shaderNameMap = {
			'a_Position': VertexElementUsage.POSITION0, 
			'a_Texcoord0': VertexElementUsage.TEXTURECOORDINATE0, 
			'u_MvpMatrix': Sky.MVPMATRIX, 
			'u_Intensity': Sky.INTENSITY, 
			'u_AlphaBlending': Sky.ALPHABLENDING, 
			'u_texture': Sky.DIFFUSETEXTURE};
			var skyDome:int = Shader.nameKey.add("SkyDome");
			vs = __INCLUDESTR__("laya/d3/shader/files/SkyDome.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/SkyDome.ps");
			Shader.preCompile(skyDome, vs, ps, shaderNameMap);
		}
		
		private static function _initResourceLoad():void {
			//ClassUtils.regClass("Sprite3D", Sprite3D);
			//ClassUtils.regClass("MeshSprite3D", MeshSprite3D);
			//ClassUtils.regClass("Material", BaseMaterial);
			
			var createMap:Object = LoaderManager.createMap;
			createMap["lh"] = [Sprite3D, Laya3D.SPRITE3DHIERARCHY];
			createMap["lm"] = [Mesh, Laya3D.MESH];
			createMap["lmat"] = [StandardMaterial, Laya3D.MATERIAL];
			createMap["ltc"] = [TextureCube, Laya3D.TEXTURECUBE];
			createMap["jpg"] = [Texture2D, "nativeimage"];
			createMap["jpeg"] = [Texture2D, "nativeimage"];
			createMap["png"] = [Texture2D, "nativeimage"];
			createMap["lsani"] = [AnimationTemplet, Loader.BUFFER];
			createMap["lrani"] = [AnimationTemplet, Loader.BUFFER];
			
			createMap["ani"] = [AnimationTemplet, Loader.BUFFER];//兼容接口
			createMap["lani"] = [AnimationTemplet, Loader.BUFFER];//兼容接口
			
			Loader.parserMap[Laya3D.SPRITE3DHIERARCHY] = _loadSprite3DHierarchy;
			Loader.parserMap[Laya3D.MESH] = _loadMesh;
			Loader.parserMap[Laya3D.MATERIAL] = _loadMaterial;
			Loader.parserMap[Laya3D.TEXTURECUBE] = _loadTextureCube;
		}
		
		/** @private */
		private static function READ_BLOCK():Boolean {
			_readData.pos += 4;
			return true;
		}
		
		/** @private */
		private static function READ_DATA():Boolean {
			_DATA.offset = _readData.getUint32();
			_DATA.size = _readData.getUint32();
			return true;
		}
		
		/** @private */
		private static function READ_STRINGS():Array {
			var materialUrls:Array = [];
			var _STRINGS:Object = {offset: 0, size: 0};
			_STRINGS.offset = _readData.getUint16();
			_STRINGS.size = _readData.getUint16();
			var ofs:int = _readData.pos;
			_readData.pos = _STRINGS.offset + _DATA.offset;
			
			for (var i:int = 0; i < _STRINGS.size; i++) {
				var string:String = _readData.readUTFString();
				if (string.lastIndexOf(".lmat") !== -1)
					materialUrls.push(string);
			}
			return materialUrls;
		}
		
		/** @private */
		private static function _getSprite3DHierarchyInnerUrls(hierarchyNode:Object, urls:Array, urlMap:Object, urlVersion:String):void {
			var path:String;
			var clas:Class;
			switch (hierarchyNode.type) {
			case "MeshSprite3D": 
				path = hierarchyNode.instanceParams.loadPath;
				clas = Mesh;
				break;
			case "ShuriKenParticle3D": 
				path = hierarchyNode.customProps.texturePath;
				clas = Texture2D;
				break;
			}
			
			if (path) {
				var formatSubUrl:String = URL.formatURL(path);
				(urlVersion) && (formatSubUrl = formatSubUrl + urlVersion);
				urls.push({url:formatSubUrl,clas:clas});
				urlMap[path] = formatSubUrl;
			}
			
			var children:Array = hierarchyNode.child;
			for (var i:int = 0, n:int = children.length; i < n; i++)
				_getSprite3DHierarchyInnerUrls(children[i], urls, urlMap, urlVersion);
		}
		
		/** @private */
		private static function _loadSprite3DHierarchy(loader:Loader):void {
			var lmLoader:Loader = new Loader();
			lmLoader.on(Event.COMPLETE, null, _onSprite3DHierarchylhLoaded, [loader]);
			lmLoader.load(loader.url, Loader.TEXT, false, null, true);
		}
		
		/** @private */
		private static function _onSprite3DHierarchylhLoaded(loader:Loader, lhData:String):void {
			var url:String = loader.url;
			var urlVersion:String = Utils3D.getURLVerion(url);
			var preBasePath:String = URL.basePath;
			URL.basePath = URL.getPath(URL.formatURL(url));
			
			var urls:Array = [];
			var urlMap:Object = {};
			var hierarchyData:Object = JSON.parse(lhData);
			
			_getSprite3DHierarchyInnerUrls(hierarchyData, urls, urlMap, urlVersion);
			var urlCount:int = urls.length;
			var totalProcessCount:int = urlCount + 1;
			var lhWeight:Number = 1 / totalProcessCount;
			_onProcessChange(loader, 0, lhWeight, 1.0);
			
			if (urlCount > 0) {
				var processHandler:Handler = Handler.create(null, _onProcessChange, [loader, lhWeight, urlCount / totalProcessCount], false);
				_innerSprite3DHierarchyLoaderManager.create(urls, Handler.create(null, _onSprite3DMeshsLoaded, [loader, processHandler, lhData, urlMap]), processHandler);
			} else {
				_onSprite3DMeshsLoaded(loader, null, lhData, null);
			}
			
			URL.basePath = preBasePath;
		}
		
		/** @private */
		private static function _onSprite3DMeshsLoaded(loader:Loader, processHandler:Handler, lhData:Object, urlMap:Object):void {
			loader.endLoad([lhData, urlMap]);
			(processHandler) && (processHandler.recover());
		}
		
		/** @private */
		private static function _loadMesh(loader:Loader):void {
			var lmLoader:Loader = new Loader();
			lmLoader.on(Event.COMPLETE, null, _onMeshLmLoaded, [loader]);
			lmLoader.load(loader.url, Loader.BUFFER, false, null, true);
		}
		
		/** @private */
		private static function _onMeshLmLoaded(loader:Loader, lmData:ArrayBuffer):void {
			var url:String = loader.url;
			var urlVersion:String = Utils3D.getURLVerion(url);
			var preBasePath:String = URL.basePath;
			URL.basePath = URL.getPath(URL.formatURL(url));
			
			var urls:Array;
			var urlMap:Object = {};
			var formatSubUrl:String;
			
			_readData = new Byte(lmData);
			_readData.pos = 0;
			_readData.readUTFString();
			READ_BLOCK();
			
			var i:int, n:int;
			for (i = 0; i < 2; i++) {
				var index:int = _readData.getUint16();
				var blockName:String = _strings[index];
				var fn:Function = Laya3D["READ_" + blockName];
				if (fn == null) throw new Error("model file err,no this function:" + index + " " + blockName);
				
				if (i === 1)
					urls = fn.call();
				else
					fn.call()
			}
			
			for (i = 0, n = urls.length; i < n; i++) {
				var subUrl:String = urls[i];
				formatSubUrl = URL.formatURL(subUrl);
				(urlVersion) && (formatSubUrl = formatSubUrl + urlVersion);
				urls[i] = formatSubUrl;
				urlMap[subUrl] = formatSubUrl;
			}
			
			var urlCount:int = 1;//TODO:以后可能为零
			var totalProcessCount:int = urlCount + 1;
			var lmatWeight:Number = 1 / totalProcessCount;
			_onProcessChange(loader, 0, lmatWeight, 1.0);
			var processHandler:Handler = Handler.create(null, _onProcessChange, [loader, lmatWeight, urlCount / totalProcessCount], false);
			_innerMeshLoaderManager.create(urls, Handler.create(null, _onMeshMateialLoaded, [loader, processHandler, lmData, urlMap]), processHandler, StandardMaterial);
			URL.basePath = preBasePath;
		}
		
		/** @private */
		private static function _onMeshMateialLoaded(loader:Loader, processHandler:Handler, lmData:Object, urlMap:Object):void {
			loader.endLoad([lmData, urlMap]);
			processHandler.recover();
		}
		
		/** @private */
		private static function _getMaterialTexturePath(path:String, urlVersion:String):String {
			var extenIndex:int = path.length - 4;
			if (path.indexOf(".dds") == extenIndex || path.indexOf(".tga") == extenIndex || path.indexOf(".exr") == extenIndex || path.indexOf(".DDS") == extenIndex || path.indexOf(".TGA") == extenIndex || path.indexOf(".EXR") == extenIndex)
				path = path.substr(0, extenIndex) + ".png";
			path = URL.formatURL(path);
			(urlVersion) && (path = path + urlVersion);
			return path;
		}
		
		/** @private */
		private static function _loadMaterial(loader:Loader):void {
			var lmatLoader:Loader = new Loader();
			lmatLoader.on(Event.COMPLETE, null, _onMaterilLmatLoaded, [loader]);
			lmatLoader.load(loader.url, Loader.JSON, false, null, true);
		}
		
		/** @private */
		private static function _onMaterilLmatLoaded(loader:Loader, lmatData:Object):void {
			var url:String = loader.url;
			var urlVersion:String = Utils3D.getURLVerion(url);
			var preBasePath:String = URL.basePath;
			URL.basePath = URL.getPath(URL.formatURL(url));
			
			var urls:Array = [];
			var urlMap:Object = {};
			var customProps:Object = lmatData.customProps;
			var formatSubUrl:String;
			var diffuseTexture:String = customProps.diffuseTexture.texture2D;
			if (diffuseTexture) {
				formatSubUrl = _getMaterialTexturePath(diffuseTexture, urlVersion);
				urls.push(formatSubUrl);
				urlMap[diffuseTexture] = formatSubUrl;
			}
			
			var normalTexture:String = customProps.normalTexture.texture2D;
			if (normalTexture) {
				formatSubUrl = _getMaterialTexturePath(normalTexture, urlVersion);
				urls.push(formatSubUrl);
				urlMap[normalTexture] = formatSubUrl;
			}
			
			var specularTexture:String = customProps.specularTexture.texture2D;
			if (specularTexture) {
				formatSubUrl = _getMaterialTexturePath(specularTexture, urlVersion);
				urls.push(formatSubUrl);
				urlMap[specularTexture] = formatSubUrl;
			}
			
			var emissiveTexture:String = customProps.emissiveTexture.texture2D;
			if (emissiveTexture) {
				formatSubUrl = _getMaterialTexturePath(emissiveTexture, urlVersion);
				urls.push(formatSubUrl);
				urlMap[emissiveTexture] = formatSubUrl;
			}
			
			var ambientTexture:String = customProps.ambientTexture.texture2D;
			if (ambientTexture) {
				formatSubUrl = _getMaterialTexturePath(ambientTexture, urlVersion);
				urls.push(formatSubUrl);
				urlMap[ambientTexture] = formatSubUrl;
			}
			
			var reflectTexture:String = customProps.reflectTexture.texture2D;
			if (reflectTexture) {
				formatSubUrl = _getMaterialTexturePath(reflectTexture, urlVersion);
				urls.push(formatSubUrl);
				urlMap[reflectTexture] = formatSubUrl;
			}
			
			var urlCount:int = urls.length;
			var totalProcessCount:int = urlCount + 1;
			var lmatWeight:Number = 1 / totalProcessCount;
			_onProcessChange(loader, 0, lmatWeight, 1.0);
			if (urlCount > 0) {
				var processHandler:Handler = Handler.create(null, _onProcessChange, [loader, lmatWeight, urlCount / totalProcessCount], false);
				_innerMaterialLoaderManager.create(urls, Handler.create(null, _onMateialTexturesLoaded, [loader, processHandler, lmatData, urlMap]), processHandler, Texture2D);//TODO:还有可能是TextureCube
			} else {
				_onMateialTexturesLoaded(loader, null, lmatData, null);
			}
			
			URL.basePath = preBasePath;
		}
		
		/** @private */
		private static function _onMateialTexturesLoaded(loader:Loader, processHandler:Handler, lmatData:Object, urlMap:Object):void {
			loader.endLoad([lmatData, urlMap]);
			(processHandler) && (processHandler.recover());
		}
		
		/** @private */
		private static function _loadTextureCube(loader:Loader):void {
			var ltcLoader:Loader = new Loader();
			ltcLoader.on(Event.COMPLETE, null, _onTextureCubeLtcLoaded, [loader]);
			ltcLoader.load(loader.url, Loader.JSON, false, null, true);
		}
		
		/** @private */
		private static function _onTextureCubeLtcLoaded(loader:Loader, ltcData:Object):void {
			var preBasePath:String = URL.basePath;
			URL.basePath = URL.getPath(URL.formatURL(loader.url));
			var urls:Array = [URL.formatURL(ltcData.px), URL.formatURL(ltcData.nx), URL.formatURL(ltcData.py), URL.formatURL(ltcData.ny), URL.formatURL(ltcData.pz), URL.formatURL(ltcData.nz)];
			var ltcWeight:Number = 1 / 7;
			_onProcessChange(loader, 0, ltcWeight, 1.0);
			var processHandler:Handler = Handler.create(null, _onProcessChange, [loader, ltcWeight, 6 / 7], false);
			_innerTextureCubeLoaderManager.load(urls, Handler.create(null, _onTextureCubeImagesLoaded, [loader, urls, processHandler]), processHandler, "nativeimage");
			URL.basePath = preBasePath;
		}
		
		/** @private */
		private static function _onTextureCubeImagesLoaded(loader:Loader, urls:Array, processHandler:Handler):void {
			var images:Array = [];
			images.length = 6;
			for (var i:int = 0; i < 6; i++) {
				var url:String = urls[i];
				images[i] = Loader.getRes(url);
				Loader.clearRes(url);
			}
			loader.endLoad(images);
			processHandler.recover();
		}
		
		/** @private */
		private static function _onProcessChange(loader:Loader, offset:Number, weight:Number, process:Number):void {
			var process:Number = offset + process * weight;
			(process < 1.0) && (loader.event(Event.PROGRESS, process));
		}
		
		/**
		 * 初始化Laya3D相关设置。
		 * @param	width  3D画布宽度。
		 * @param	height 3D画布高度。
		 */
		public static function init(width:Number, height:Number, antialias:Boolean = false, alpha:Boolean = false, premultipliedAlpha:Boolean = false):void {
			if (!WebGL.enable()) {
				alert("Laya3D init err,must support webGL!");
				return;
			}
			
			_innerTextureCubeLoaderManager.maxLoader = 1;
			_innerMaterialLoaderManager.maxLoader = 1;
			_innerMeshLoaderManager.maxLoader = 1;
			_innerSprite3DHierarchyLoaderManager.maxLoader = 1;
			
			RunDriver.changeWebGLSize = _changeWebGLSize;
			Config.isAntialias = antialias;
			Config.isAlpha = alpha;
			Config.premultipliedAlpha = premultipliedAlpha;
			Render.is3DMode = true;
			Laya.init(width, height);
			Layer.__init__();
			ShaderDefines3D.__init__();
			_initShader();
			_initResourceLoad();
		}
	
	}
}