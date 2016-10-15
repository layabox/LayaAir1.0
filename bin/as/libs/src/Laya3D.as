package {
	import laya.d3.core.Layer;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.TextureCube;
	import laya.d3.shader.ShaderDefines3D;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.particle.shader.ParticleShader;
	import laya.renders.Render;
	import laya.utils.ClassUtils;
	import laya.utils.RunDriver;
	import laya.webgl.WebGL;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.Buffer2D;
	
	/**
	 * <code>Laya3D</code> 类用于初始化3D设置。
	 */
	public class Laya3D {
		/**
		 * 创建一个 <code>Laya3D</code> 实例。
		 */
		public function Laya3D() {
		}
		
		private static function _initShader():void{
			Shader.addInclude("LightHelper.glsl", __INCLUDESTR__("laya/d3/shader/files/LightHelper.glsl"));
			Shader.addInclude("VRHelper.glsl", __INCLUDESTR__("laya/d3/shader/files/VRHelper.glsl"));
			
			var vs:String, ps:String;
			var shaderNameMap:*=
			{
				'a_Position':VertexElementUsage.POSITION0,
				'a_Color':VertexElementUsage.COLOR0,
				'a_Normal':VertexElementUsage.NORMAL0,
				'a_Texcoord0':VertexElementUsage.TEXTURECOORDINATE0, 
				'a_Texcoord1':VertexElementUsage.TEXTURECOORDINATE1,
				'a_TexcoordNext0':VertexElementUsage.NEXTTEXTURECOORDINATE0, 
				'a_BoneWeights':VertexElementUsage.BLENDWEIGHT0,
				'a_BoneIndices':VertexElementUsage.BLENDINDICES0,
				'a_Tangent0':VertexElementUsage.TANGENT0,
				'u_WorldMat':Buffer2D.MATRIX1,
				'u_CameraPos':Buffer2D.CAMERAPOS,
			    'u_DiffuseTexture':Buffer2D.DIFFUSETEXTURE,
				'u_SpecularTexture':Buffer2D.SPECULARTEXTURE,
				'u_NormalTexture':Buffer2D.NORMALTEXTURE,
				'u_AmbientTexture':Buffer2D.AMBIENTTEXTURE,
				'u_ReflectTexture':Buffer2D.REFLECTTEXTURE,
				'u_MvpMatrix':Buffer2D.MVPMATRIX,
				'u_Bones':Buffer2D.MATRIXARRAY0,
				'u_FogStart':Buffer2D.FOGSTART,
                'u_FogRange':Buffer2D.FOGRANGE,
                'u_FogColor':Buffer2D.FOGCOLOR,
				'u_Albedo':Buffer2D.ALBEDO,
				'u_AlphaTestValue':Buffer2D.ALPHATESTVALUE,
				'u_UVMatrix':Buffer2D.MATRIX2,
				'u_UVAge':Buffer2D.FLOAT0,
				'u_UVAniAge':Buffer2D.UVAGEX,
				'u_DirectionLight.Direction':Buffer2D.LIGHTDIRECTION,
				'u_DirectionLight.Diffuse':Buffer2D.LIGHTDIRDIFFUSE,
				'u_DirectionLight.Ambient':Buffer2D.LIGHTDIRAMBIENT,
				'u_DirectionLight.Specular':Buffer2D.LIGHTDIRSPECULAR,
				'u_PointLight.Position':Buffer2D.POINTLIGHTPOS,
				'u_PointLight.Range':Buffer2D.POINTLIGHTRANGE,
				'u_PointLight.Attenuation':Buffer2D.POINTLIGHTATTENUATION,
				'u_PointLight.Diffuse':Buffer2D.POINTLIGHTDIFFUSE,
				'u_PointLight.Ambient':Buffer2D.POINTLIGHTAMBIENT,
				'u_PointLight.Specular':Buffer2D.POINTLIGHTSPECULAR,
				'u_MaterialDiffuse':Buffer2D.MATERIALDIFFUSE,
				'u_MaterialAmbient':Buffer2D.MATERIALAMBIENT,
				'u_MaterialSpecular':Buffer2D.MATERIALSPECULAR,
				'u_MaterialReflect':Buffer2D.MATERIALREFLECT,
				'u_SpotLight.Position':Buffer2D.SPOTLIGHTPOS,
				'u_SpotLight.Direction':Buffer2D.SPOTLIGHTDIRECTION,
				'u_SpotLight.Range':Buffer2D.SPOTLIGHTRANGE,
				'u_SpotLight.Spot':Buffer2D.SPOTLIGHTSPOT,
				'u_SpotLight.Attenuation':Buffer2D.SPOTLIGHTATTENUATION,
				'u_SpotLight.Diffuse':Buffer2D.SPOTLIGHTDIFFUSE,
				'u_SpotLight.Ambient':Buffer2D.SPOTLIGHTAMBIENT,
				'u_SpotLight.Specular':Buffer2D.SPOTLIGHTSPECULAR
			};
			var SIMPLE:int = Shader.nameKey.add("SIMPLE");
			vs = __INCLUDESTR__("laya/d3/shader/files/VertexSimpleTextureSkinnedMesh.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/VertexSimpleTextureSkinnedMesh.ps");
			Shader.preCompile(SIMPLE,ShaderDefines3D.VERTEXSHADERING , vs, ps, shaderNameMap);
			vs = __INCLUDESTR__("laya/d3/shader/files/PixelSimpleTextureSkinnedMesh.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/PixelSimpleTextureSkinnedMesh.ps");
			Shader.preCompile(SIMPLE, ShaderDefines3D.PIXELSHADERING, vs, ps, shaderNameMap);
			
			shaderNameMap =
			{
				'a_Position':VertexElementUsage.POSITION0,
				'a_Texcoord':VertexElementUsage.TEXTURECOORDINATE0, 
				'u_FogStart':Buffer2D.FOGSTART,
                'u_FogRange':Buffer2D.FOGRANGE,
                'u_FogColor':Buffer2D.FOGCOLOR,
				'u_WorldMat':Buffer2D.MATRIX1,
				'u_CameraPos':Buffer2D.CAMERAPOS,
				'u_BlendTexture':Buffer2D.DIFFUSETEXTURE,
				'u_LayerTexture0':Buffer2D.NORMALTEXTURE,
				'u_LayerTexture1':Buffer2D.SPECULARTEXTURE,
				'u_LayerTexture2':Buffer2D.EMISSIVETEXTURE,
				'u_LayerTexture3':Buffer2D.AMBIENTTEXTURE,
				'u_MvpMatrix':Buffer2D.MVPMATRIX,
				'u_Albedo':Buffer2D.ALBEDO, 
				'u_Ambient':Buffer2D.MATERIALAMBIENT,
				'u_UVMatrix':Buffer2D.MATRIX2
			};
			var TERRAIN:int = Shader.nameKey.add("TERRAIN");
			vs = __INCLUDESTR__("laya/d3/shader/files/modelTerrain.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/modelTerrain.ps");
			Shader.preCompile(TERRAIN, ShaderDefines3D.VERTEXSHADERING , vs, ps, shaderNameMap);
			Shader.preCompile(TERRAIN, ShaderDefines3D.PIXELSHADERING, vs, ps, shaderNameMap);
			
			shaderNameMap =
			{
				'a_CornerTextureCoordinate':VertexElementUsage.CORNERTEXTURECOORDINATE0,
				'a_Position':VertexElementUsage.POSITION0,
				'a_Velocity':VertexElementUsage.VELOCITY0,
				'a_StartColor':VertexElementUsage.STARTCOLOR0,
				'a_EndColor':VertexElementUsage.ENDCOLOR0,
				'a_SizeRotation':VertexElementUsage.SIZEROTATION0,
				'a_Radius':VertexElementUsage.RADIUS0,
				'a_Radian':VertexElementUsage.RADIAN0,
				'a_AgeAddScale':VertexElementUsage.AGEADDSCALE0,
				'a_Time':VertexElementUsage.TIME0,
				
				'u_WorldMat':Buffer2D.MVPMATRIX,
				'u_View':Buffer2D.MATRIX1,
				'u_Projection':Buffer2D.MATRIX2,
				'u_ViewportScale':Buffer2D.VIEWPORTSCALE,
				'u_CurrentTime':Buffer2D.CURRENTTIME, 
				'u_Duration':Buffer2D.DURATION,
				'u_Gravity':Buffer2D.GRAVITY,
				'u_EndVelocity':Buffer2D.ENDVELOCITY,
				'u_texture':Buffer2D.DIFFUSETEXTURE
			};
			var PARTICLE:int = Shader.nameKey.add("PARTICLE");
			Shader.preCompile(PARTICLE, ShaderDefines3D.VERTEXSHADERING ,ParticleShader.vs, ParticleShader.ps, shaderNameMap);
			Shader.preCompile(PARTICLE, ShaderDefines3D.PIXELSHADERING, ParticleShader.vs, ParticleShader.ps, shaderNameMap);			
			
			shaderNameMap =
			{
				'a_CornerTextureCoordinate':VertexElementUsage.CORNERTEXTURECOORDINATE0,
				'a_Position':VertexElementUsage.POSITION0,
				'a_Velocity':VertexElementUsage.VELOCITY0,
				'a_StartColor':VertexElementUsage.STARTCOLOR0,
				'a_EndColor':VertexElementUsage.ENDCOLOR0,
				'a_SizeRotation':VertexElementUsage.SIZEROTATION0,
				'a_Radius':VertexElementUsage.RADIUS0,
				'a_Radian':VertexElementUsage.RADIAN0,
				'a_AgeAddScale':VertexElementUsage.AGEADDSCALE0,
				'a_Time':VertexElementUsage.TIME0,
				
				'u_WorldMat':Buffer2D.MVPMATRIX,
				'u_View':Buffer2D.MATRIX1,
				'u_Projection':Buffer2D.MATRIX2,
				'u_ViewportScale':Buffer2D.VIEWPORTSCALE,
				'u_CurrentTime':Buffer2D.CURRENTTIME, 
				'u_Duration':Buffer2D.DURATION,
				'u_Gravity':Buffer2D.GRAVITY,
				'u_EndVelocity':Buffer2D.ENDVELOCITY,
				'u_texture':Buffer2D.DIFFUSETEXTURE
			};
			
			var U3DPARTICLE:int = Shader.nameKey.add("U3DPARTICLE");
			Shader.preCompile(U3DPARTICLE, ShaderDefines3D.VERTEXSHADERING ,ParticleShader.vs, ParticleShader.ps, shaderNameMap);
			Shader.preCompile(U3DPARTICLE, ShaderDefines3D.PIXELSHADERING, ParticleShader.vs, ParticleShader.ps, shaderNameMap);
			
			shaderNameMap =
			{
				'a_Position':VertexElementUsage.POSITION0,
				'a_Texcoord0':VertexElementUsage.TEXTURECOORDINATE0,
				'a_Time':Buffer2D.TIME, 
			    'u_Texture':Buffer2D.DIFFUSETEXTURE,
				'u_MvpMatrix':Buffer2D.MVPMATRIX,
				'u_Albedo':Buffer2D.ALBEDO,
				'u_CurrentTime':Buffer2D.CURRENTTIME,
                'u_Color':Buffer2D.UNICOLOR ,
				'u_Duration':Buffer2D.DURATION
			};
			
			var GLITTER:int = Shader.nameKey.add("GLITTER");
			vs = __INCLUDESTR__("laya/d3/shader/files/Glitter.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/Glitter.ps");
			Shader.preCompile(GLITTER, ShaderDefines3D.VERTEXSHADERING ,vs, ps, shaderNameMap);
			Shader.preCompile(GLITTER, ShaderDefines3D.PIXELSHADERING, vs, ps, shaderNameMap);	
			
			
			 shaderNameMap=
			{
				'a_Position':VertexElementUsage.POSITION0,
				'a_Color':VertexElementUsage.COLOR0,
				'a_Texcoord0':VertexElementUsage.TEXTURECOORDINATE0, 
				'a_TexcoordNext0':VertexElementUsage.NEXTTEXTURECOORDINATE0, 
				'a_Texcoord1':VertexElementUsage.TEXTURECOORDINATE1, 
				'a_TexcoordNext1':VertexElementUsage.NEXTTEXTURECOORDINATE1, 
			    'u_DiffuseTexture':Buffer2D.DIFFUSETEXTURE,
				'u_SpecularTexture':Buffer2D.SPECULARTEXTURE,
				'u_MvpMatrix':Buffer2D.MVPMATRIX,
				'u_FogStart':Buffer2D.FOGSTART,
                'u_FogRange':Buffer2D.FOGRANGE,
                'u_FogColor':Buffer2D.FOGCOLOR,
				'u_Albedo':Buffer2D.ALBEDO,
				'u_UVAge':Buffer2D.FLOAT0,
				'u_UVAniAge':Buffer2D.UVAGEX
			};
			
			var SIMPLE_EFFECT:int = Shader.nameKey.add("SIMPLE_EFFECT");
			vs = __INCLUDESTR__("laya/d3/shader/files/SimpleEffect.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/SimpleEffect.ps");
			Shader.preCompile(SIMPLE_EFFECT,ShaderDefines3D.VERTEXSHADERING , vs, ps, shaderNameMap);
			vs = __INCLUDESTR__("laya/d3/shader/files/SimpleEffect.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/SimpleEffect.ps");
			Shader.preCompile(SIMPLE_EFFECT, ShaderDefines3D.PIXELSHADERING, vs, ps, shaderNameMap);
			
			 shaderNameMap=
			{
				'a_Position':VertexElementUsage.POSITION0,
				'u_MvpMatrix':Buffer2D.MVPMATRIX, 
				'u_Intensity':Buffer2D.INTENSITY,
				'u_AlphaBlending':Buffer2D.ALPHABLENDING,
				'u_CubeTexture':Buffer2D.DIFFUSETEXTURE
				
			};
			var skyBox:int = Shader.nameKey.add("SkyBox");
			vs = __INCLUDESTR__("laya/d3/shader/files/SkyBox.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/SkyBox.ps");
			Shader.preCompile(skyBox,ShaderDefines3D.VERTEXSHADERING , vs, ps, shaderNameMap);
			vs = __INCLUDESTR__("laya/d3/shader/files/SkyBox.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/SkyBox.ps");
			Shader.preCompile(skyBox, ShaderDefines3D.PIXELSHADERING, vs, ps, shaderNameMap);
			
			//天空穹庐
			shaderNameMap=
			{
				'a_Position':VertexElementUsage.POSITION0,
				'a_Texcoord0':VertexElementUsage.TEXTURECOORDINATE0,
				'u_MvpMatrix':Buffer2D.MVPMATRIX, 
				'u_Intensity':Buffer2D.INTENSITY,
				'u_AlphaBlending':Buffer2D.ALPHABLENDING,
				'u_texture':Buffer2D.DIFFUSETEXTURE
				
			};
			var skyDome:int = Shader.nameKey.add("SkyDome");
			vs = __INCLUDESTR__("laya/d3/shader/files/SkyDome.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/SkyDome.ps");
			Shader.preCompile(skyDome,ShaderDefines3D.VERTEXSHADERING , vs, ps, shaderNameMap);
			vs = __INCLUDESTR__("laya/d3/shader/files/SkyDome.vs");
			ps = __INCLUDESTR__("laya/d3/shader/files/SkyDome.ps");
			Shader.preCompile(skyDome, ShaderDefines3D.PIXELSHADERING, vs, ps, shaderNameMap);
		}
		
		private static function _regClassforJson():void {
			ClassUtils.regClass("Sprite3D", Sprite3D);
			ClassUtils.regClass("MeshSprite3D", MeshSprite3D);
			ClassUtils.regClass("Material", BaseMaterial);
		}
		
		private static function _loadTexture2D(loader:Loader):void {
			var url:String = loader.url;
			var preBasePath:String = URL.basePath;
			URL.basePath = URL.getPath(url);//此处更换URL路径会影响模型寻找贴图的路径
			var texture2D:Texture2D = new Texture2D(url);
			URL.basePath = preBasePath;
			texture2D.on(Event.LOADED, null, function(tex2D:Texture2D):void {
				loader.endLoad(tex2D);
			});
		}
		
		private static function _loadTextureCube(loader:Loader):void {
			var urls:Array = loader.url.split(',');
			var preBasePath:String = URL.basePath;
			URL.basePath = URL.getPath(urls[0]);//此处更换URL路径会影响模型寻找贴图的路径
			var textureCube:TextureCube = new TextureCube(urls);
			URL.basePath = preBasePath;
			textureCube.on(Event.LOADED, null, function(imgCube:TextureCube):void {
				loader.endLoad(imgCube);
			});
		}
		
		//private static function _loadMesh(loader:Loader,mesh:Mesh):void
		//{
			//var url:String = URL.formatURL(loader.url);
			//if (!mesh) {
				//mesh = new Mesh(url);
				//var loader:Loader = new Loader();
				//loader.once(Event.COMPLETE, null, function(data:ArrayBuffer):void {
					//new LoadModel(data, mesh, mesh._materials, url);
					//mesh._loaded = true;
					//mesh.event(Event.LOADED, mesh);
					//loader.endLoad(mesh);
				//});
				//loader.load(url, Loader.BUFFER,false);
			//}
		//}
		//private static function _loadMaterial(loader:Loader):void {
		//Laya.loader.load(loader.url, Handler.create(null, function(data:Object):void {
		//var m:Material = new Material();
		//var preBasePath:String = URL.basePath;
		//URL.basePath = URL.getPath(URL.formatURL(loader.url));
		//ClassUtils.createByJson(data, m, null, Handler.create(null, Utils3D._parseMaterial, null, false));
		//URL.basePath = preBasePath;
		//loader.endLoad(m);
		//}), null, Loader.TEXT, 1);
		//}
		
		/**
		 * 初始化Laya3D相关设置。
		 * @param	width  3D画布宽度。
		 * @param	height 3D画布高度。
		 */
		public static function init(width:Number, height:Number, antialias:Boolean = false):void {
			if (!WebGL.enable()) {
				alert("Laya3D init err,must support webGL!");
				return;
			}
			
			Loader.parserMap[Loader.TEXTURE2D] = _loadTexture2D;
			Loader.parserMap[Loader.TEXTURECUBE] = _loadTextureCube;
			//Loader.parserMap = {"Mesh": _loadMesh};
			
			RunDriver.changeWebGLSize = function(width:Number, height:Number):void {
				WebGL.onStageResize(width, height);
				RenderState.clientWidth = width;
				RenderState.clientHeight = height;
			}
			Config.isAntialias = antialias;
			Render.is3DMode = true;
			Laya.init(width, height);
			Layer.__init__();
			ShaderDefines3D.__init__();
			_initShader();
			_regClassforJson();
		}
		
		
	
		
	}
}