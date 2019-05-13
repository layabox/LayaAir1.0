package {
	import laya.d3.animation.AnimationClip;
	import laya.d3.core.Avatar;
	import laya.d3.core.MeshRenderer;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.SkinnedMeshRenderer;
	import laya.d3.core.SkinnedMeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.BlinnPhongMaterial;
	import laya.d3.core.material.EffectMaterial;
	import laya.d3.core.material.ExtendTerrainMaterial;
	import laya.d3.core.material.PBRSpecularMaterial;
	import laya.d3.core.material.PBRStandardMaterial;
	import laya.d3.core.material.SkyBoxMaterial;
	import laya.d3.core.material.SkyProceduralMaterial;
	import laya.d3.core.material.TerrainMaterial;
	import laya.d3.core.material.UnlitMaterial;
	import laya.d3.core.material.WaterPrimaryMaterial;
	import laya.d3.core.particleShuriKen.ShuriKenParticle3D;
	import laya.d3.core.particleShuriKen.ShurikenParticleMaterial;
	import laya.d3.core.pixelLine.PixelLineMaterial;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.core.trail.TrailMaterial;
	import laya.d3.core.trail.TrailSprite3D;
	import laya.d3.graphics.FrustumCulling;
	import laya.d3.math.HalfFloatUtils;
	import laya.d3.physics.PhysicsSettings;
	import laya.d3.resource.RenderTexture;
	import laya.d3.resource.TextureCube;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SkyBox;
	import laya.d3.resource.models.SkyDome;
	import laya.d3.shader.ShaderData;
	import laya.d3.shader.ShaderInit3D;
	import laya.d3.shader.ShaderInstance;
	import laya.d3.terrain.TerrainHeightData;
	import laya.d3.utils.Utils3D;
	import laya.display.Node;
	import laya.events.Event;
	import laya.layagl.CommandEncoder;
	import laya.layagl.LayaGL;
	import laya.net.Loader;
	import laya.net.LoaderManager;
	import laya.net.URL;
	import laya.renders.Render;
	import laya.resource.Resource;
	import laya.utils.Handler;
	import laya.utils.RunDriver;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.resource.Texture2D;
	
	/**
	 * <code>Laya3D</code> 类用于初始化3D设置。
	 */
	public class Laya3D {
		/**Hierarchy资源。*/
		public static const HIERARCHY:String = "HIERARCHY";
		/**Mesh资源。*/
		public static const MESH:String = "MESH";
		/**Material资源。*/
		public static const MATERIAL:String = "MATERIAL";
		/**Texture2D资源。*/
		public static const TEXTURE2D:String = "TEXTURE2D";
		/**TextureCube资源。*/
		public static const TEXTURECUBE:String = "TEXTURECUBE";
		/**AnimationClip资源。*/
		public static const ANIMATIONCLIP:String = "ANIMATIONCLIP";
		/**Avatar资源。*/
		public static const AVATAR:String = "AVATAR";
		/**Terrain资源。*/
		public static const TERRAINHEIGHTDATA:String = "TERRAINHEIGHTDATA";
		/**Terrain资源。*/
		public static const TERRAINRES:String = "TERRAIN";
		
		/**@private */
		private static const _innerFirstLevelLoaderManager:LoaderManager = new LoaderManager();//Mesh 
		/**@private */
		private static const _innerSecondLevelLoaderManager:LoaderManager = new LoaderManager();//Material
		/**@private */
		private static const _innerThirdLevelLoaderManager:LoaderManager = new LoaderManager();//TextureCube、TerrainResou
		/**@private */
		private static const _innerFourthLevelLoaderManager:LoaderManager = new LoaderManager();//Texture2D、Image、Avatar、AnimationClip
		
		/**@private */
		private static var _isInit:Boolean = false;
		
		/**@private */
		public static var _physics3D:Object = window.Physics3D;
		/**@private */
		public static var _enbalePhysics:Boolean = false;
		/**@private */
		public static var _editerEnvironment:Boolean = false;
		/**@private */
		public static var _config:Config3D = new Config3D();
		
		/**@private */
		public static var physicsSettings:PhysicsSettings = new PhysicsSettings();//TODO:
		
		/**
		 * 获取是否可以启用物理。
		 * @param 是否启用物理。
		 */
		static public function get enbalePhysics():* {
			return _enbalePhysics;
		}
		
		/**
		 *@private
		 */
		public static function _cancelLoadByUrl(url:String):void {
			Laya.loader.cancelLoadByUrl(url);
			_innerFirstLevelLoaderManager.cancelLoadByUrl(url);
			_innerSecondLevelLoaderManager.cancelLoadByUrl(url);
			_innerThirdLevelLoaderManager.cancelLoadByUrl(url);
			_innerFourthLevelLoaderManager.cancelLoadByUrl(url);
		}
		
		/**
		 *@private
		 */
		private static function _changeWebGLSize(width:Number, height:Number):void {
			WebGL.onStageResize(width, height);
			RenderContext3D.clientWidth = width;
			RenderContext3D.clientHeight = height;
		}
		
		/**
		 *@private
		 */
		private static function __init__(width:int, height:int, config:Config3D):void {
			Config.isAntialias = config.isAntialias;
			Config.isAlpha = config.isAlpha;
			Config.premultipliedAlpha = config.premultipliedAlpha;
			Config.isStencil = config.isStencil;
			
			if (!WebGL.enable()) {
				alert("Laya3D init error,must support webGL!");
				return;
			}
			
			RunDriver.changeWebGLSize = _changeWebGLSize;
			Render.is3DMode = true;
			Laya.init(width, height);
			if (!Render.supportWebGLPlusRendering) {
				LayaGL.instance = WebGL.mainContext;
				LayaGL.instance.createCommandEncoder = function(reserveSize:int = 128, adjustSize:int = 64, isSyncToRenderThread:Boolean = false):CommandEncoder {
					return new CommandEncoder(this, reserveSize, adjustSize, isSyncToRenderThread);
				}
			}
			//函数里面会有判断isConchApp
			enableNative3D();
			Sprite3D.__init__();
			RenderableSprite3D.__init__();
			MeshSprite3D.__init__();
			SkinnedMeshSprite3D.__init__();
			ShuriKenParticle3D.__init__();
			BaseMaterial.__init__();
			BlinnPhongMaterial.__init__();
			PBRStandardMaterial.__init__();
			PBRSpecularMaterial.__init__();
			SkyProceduralMaterial.__init__();
			UnlitMaterial.__init__();
			TrailSprite3D.__init__();
			TrailMaterial.__init__();
			EffectMaterial.__init__();
			WaterPrimaryMaterial.__init__();
			ShurikenParticleMaterial.__init__();
			TerrainMaterial.__init__();
			ExtendTerrainMaterial.__init__();
			ShaderInit3D.__init__();
			PixelLineMaterial.defaultMaterial.lock = true;
			BlinnPhongMaterial.defaultMaterial.lock = true;
			EffectMaterial.defaultMaterial.lock = true;
			PBRStandardMaterial.defaultMaterial.lock = true;
			PBRSpecularMaterial.defaultMaterial.lock = true;
			UnlitMaterial.defaultMaterial.lock = true;
			ShurikenParticleMaterial.defaultMaterial.lock = true;
			TrailMaterial.defaultMaterial.lock = true;
			SkyProceduralMaterial.defaultMaterial.lock = true;
			SkyBoxMaterial.defaultMaterial.lock = true;
			WaterPrimaryMaterial.defaultMaterial.lock = true;
			Texture2D.__init__();
			TextureCube.__init__();
			SkyBox.__init__();
			SkyDome.__init__();
			FrustumCulling.__init__();
			HalfFloatUtils.__init__();
			
			var createMap:Object = LoaderManager.createMap;
			createMap["lh"] = [Laya3D.HIERARCHY, Sprite3D._parse];
			createMap["ls"] = [Laya3D.HIERARCHY, Scene3D._parse];
			createMap["lm"] = [Laya3D.MESH, Mesh._parse];
			createMap["lmat"] = [Laya3D.MATERIAL, BaseMaterial._parse];
			createMap["ltc"] = [Laya3D.TEXTURECUBE, TextureCube._parse];
			createMap["jpg"] = [Laya3D.TEXTURE2D, Texture2D._parse];
			createMap["jpeg"] = [Laya3D.TEXTURE2D, Texture2D._parse];
			createMap["bmp"] = [Laya3D.TEXTURE2D, Texture2D._parse];
			createMap["gif"] = [Laya3D.TEXTURE2D, Texture2D._parse];
			createMap["png"] = [Laya3D.TEXTURE2D, Texture2D._parse];
			createMap["dds"] = [Laya3D.TEXTURE2D, Texture2D._parse];
			createMap["ktx"] = [Laya3D.TEXTURE2D, Texture2D._parse];
			createMap["pvr"] = [Laya3D.TEXTURE2D, Texture2D._parse];
			createMap["lani"] = [Laya3D.ANIMATIONCLIP, AnimationClip._parse];
			createMap["lav"] = [Laya3D.AVATAR, Avatar._parse];
			createMap["thdata"] = [Laya3D.TERRAINHEIGHTDATA, TerrainHeightData._pharse];
			
			var parserMap:Object = Loader.parserMap;
			parserMap[Laya3D.HIERARCHY] = _loadHierarchy;
			parserMap[Laya3D.MESH] = _loadMesh;
			parserMap[Laya3D.MATERIAL] = _loadMaterial;
			parserMap[Laya3D.TEXTURECUBE] = _loadTextureCube;
			parserMap[Laya3D.TEXTURE2D] = _loadTexture2D;
			parserMap[Laya3D.ANIMATIONCLIP] = _loadAnimationClip;
			parserMap[Laya3D.AVATAR] = _loadAvatar;
			//parserMap[Laya3D.TERRAINRES] = _loadTerrain;
			//parserMap[Laya3D.TERRAINHEIGHTDATA] = _loadTerrain;
			
			_innerFirstLevelLoaderManager.on(Event.ERROR, null, _eventLoadManagerError);
			_innerSecondLevelLoaderManager.on(Event.ERROR, null, _eventLoadManagerError);
			_innerThirdLevelLoaderManager.on(Event.ERROR, null, _eventLoadManagerError);
			_innerFourthLevelLoaderManager.on(Event.ERROR, null, _eventLoadManagerError);
		}
		
		private static function enableNative3D():void {
			if (Render.isConchApp) {
				__JS__("LayaGL = window.LayaGLContext");
				var shaderData:* = ShaderData;
				var shader3D:* = ShaderInstance;
				var skinnedMeshRender:* = SkinnedMeshRenderer;
				var avatar:* = Avatar;
				var frustumCulling:* = FrustumCulling;
				var meshRender:* = MeshRenderer;
				if (Render.supportWebGLPlusRendering) {
					//替换ShaderData的函数
					shaderData.prototype._initData = shaderData.prototype._initDataForNative;
					shaderData.prototype.setBool = shaderData.prototype.setBoolForNative;
					shaderData.prototype.getBool = shaderData.prototype.getBoolForNative;
					shaderData.prototype.setInt = shaderData.prototype.setIntForNative;
					shaderData.prototype.getInt = shaderData.prototype.getIntForNative;
					shaderData.prototype.setNumber = shaderData.prototype.setNumberForNative;
					shaderData.prototype.getNumber = shaderData.prototype.getNumberForNative;
					shaderData.prototype.setVector = shaderData.prototype.setVectorForNative;
					shaderData.prototype.getVector = shaderData.prototype.getVectorForNative;
					shaderData.prototype.setVector2 = shaderData.prototype.setVector2ForNative;
					shaderData.prototype.getVector2 = shaderData.prototype.getVector2ForNative;
					shaderData.prototype.setVector3 = shaderData.prototype.setVector3ForNative;
					shaderData.prototype.getVector3 = shaderData.prototype.getVector3ForNative;
					shaderData.prototype.setQuaternion = shaderData.prototype.setQuaternionForNative;
					shaderData.prototype.getQuaternion = shaderData.prototype.getQuaternionForNative;
					shaderData.prototype.setMatrix4x4 = shaderData.prototype.setMatrix4x4ForNative;
					shaderData.prototype.getMatrix4x4 = shaderData.prototype.getMatrix4x4ForNative;
					shaderData.prototype.setBuffer = shaderData.prototype.setBufferForNative;
					shaderData.prototype.getBuffer = shaderData.prototype.getBufferForNative;
					shaderData.prototype.setTexture = shaderData.prototype.setTextureForNative;
					shaderData.prototype.getTexture = shaderData.prototype.getTextureForNative;
					shaderData.prototype.setAttribute = shaderData.prototype.setAttributeForNative;
					shaderData.prototype.getAttribute = shaderData.prototype.getAttributeForNative;
					shaderData.prototype.cloneTo = shaderData.prototype.cloneToForNative;
					shaderData.prototype.getData = shaderData.prototype.getDataForNative;
					shader3D.prototype._uniformMatrix2fv = shader3D.prototype._uniformMatrix2fvForNative;
					shader3D.prototype._uniformMatrix3fv = shader3D.prototype._uniformMatrix3fvForNative;
					shader3D.prototype._uniformMatrix4fv = shader3D.prototype._uniformMatrix4fvForNative;
					meshRender.prototype._renderUpdateWithCamera = meshRender.prototype._renderUpdateWithCameraForNative;
				}
				//Matrix4x4.multiply = Matrix4x4.multiplyForNative;
				if (Render.supportWebGLPlusCulling) {
					frustumCulling.renderObjectCulling = FrustumCulling.renderObjectCullingNative;
				}
				
				if (Render.supportWebGLPlusAnimation) {
					avatar.prototype._cloneDatasToAnimator = avatar.prototype._cloneDatasToAnimatorNative;
					__JS__("FloatKeyframe = window.conchFloatKeyframe");
					__JS__("Vector3Keyframe = window.conchFloatArrayKeyframe");
					__JS__("QuaternionKeyframe = window.conchFloatArrayKeyframe");
					__JS__("KeyframeNode = window.conchKeyframeNode");
					__JS__("KeyframeNodeList = window.conchKeyframeNodeList");
					var animationClip:* = AnimationClip;
					animationClip.prototype._evaluateClipDatasRealTime = animationClip.prototype._evaluateClipDatasRealTimeForNative;
				}
			}
			WebGL.shaderHighPrecision = false;
			var precisionFormat:* = LayaGL.instance.getShaderPrecisionFormat(WebGLContext.FRAGMENT_SHADER, WebGLContext.HIGH_FLOAT);
			precisionFormat.precision ? WebGL.shaderHighPrecision = true : WebGL.shaderHighPrecision = false;
		}
		
		/**
		 *@private
		 */
		private static function formatRelativePath(base:String, value:String):String {
			var path:String;
			path = base + value;
			
			var char1:String = value.charAt(0);
			if (char1 === ".") {
				var parts:Array = path.split("/");
				for (var i:int = 0, len:int = parts.length; i < len; i++) {
					if (parts[i] == '..') {
						var index:int = i - 1;
						if (index > 0 && parts[index] !== '..') {
							parts.splice(index, 2);
							i -= 2;
						}
					}
				}
				path = parts.join('/');
			}
			return path;
		}
		
		/**
		 * @private
		 */
		private static function _endLoad(loader:Loader, content:* = null, subResous:Array = null):void {
			if (subResous) {
				for (var i:int = 0, n:int = subResous.length; i < n; i++) {
					var resou:Resource = Loader.getRes(subResous[i]) as Resource;
					(resou) && (resou._removeReference());//加载失败SubResous为空
				}
			}
			loader.endLoad(content);
		}
		
		/**
		 *@private
		 */
		private static function _eventLoadManagerError(msg:String):void {
			Laya.loader.event(Event.ERROR, msg);
		}
		
		/**
		 *@private
		 */
		private static function _addHierarchyInnerUrls(urls:Array, urlMap:Array, urlVersion:String, hierarchyBasePath:String, path:String, type:String, constructParams:Object = null, propertyParams:Object = null):String {
			var formatUrl:String = formatRelativePath(hierarchyBasePath, path);
			(urlVersion) && (formatUrl = formatUrl + urlVersion);
			urls.push({url: formatUrl, type: type, constructParams: constructParams, propertyParams: propertyParams});
			urlMap.push(formatUrl);
			return formatUrl;
		}
		
		/**
		 *@private
		 */
		private static function _getSprite3DHierarchyInnerUrls(node:Object, firstLevelUrls:Array, secondLevelUrls:Array, thirdLevelUrls:Array, fourthLelUrls:Array, subUrls:Array, urlVersion:String, hierarchyBasePath:String):void {
			var i:int, n:int;
			
			var props:Object = node.props;
			switch (node.type) {
			case "Scene3D": //TODO:应该自动序列化类型
				var lightmaps:Array = props.lightmaps;
				for (i = 0, n = lightmaps.length; i < n; i++) {
					var lightMap:Object = lightmaps[i];
					lightMap.path = _addHierarchyInnerUrls(fourthLelUrls, subUrls, urlVersion, hierarchyBasePath, lightMap.path, Laya3D.TEXTURE2D, lightMap.constructParams, lightMap.propertyParams);
				}
				var reflectionTextureData:String = props.reflectionTexture;
				(reflectionTextureData) && (props.reflectionTexture = _addHierarchyInnerUrls(thirdLevelUrls, subUrls, urlVersion, hierarchyBasePath, reflectionTextureData, Laya3D.TEXTURECUBE));
				
				if (props.sky) {
					var skyboxMaterial:Object = props.sky.material;
					(skyboxMaterial) && (skyboxMaterial.path = _addHierarchyInnerUrls(secondLevelUrls, subUrls, urlVersion, hierarchyBasePath, skyboxMaterial.path, Laya3D.MATERIAL));
				}
				break;
			case "Camera": 
				var skyboxMatData:Object = props.skyboxMaterial;
				(skyboxMatData) && (skyboxMatData.path = _addHierarchyInnerUrls(secondLevelUrls, subUrls, urlVersion, hierarchyBasePath, skyboxMatData.path, Laya3D.MATERIAL));
				break;
			case "TrailSprite3D": 
			case "MeshSprite3D": 
			case "SkinnedMeshSprite3D": 
				var meshPath:String = props.meshPath;
				(meshPath) && (props.meshPath = _addHierarchyInnerUrls(firstLevelUrls, subUrls, urlVersion, hierarchyBasePath, meshPath, Laya3D.MESH));
				var materials:Array = props.materials;
				if (materials)
					for (i = 0, n = materials.length; i < n; i++)
						materials[i].path = _addHierarchyInnerUrls(secondLevelUrls, subUrls, urlVersion, hierarchyBasePath, materials[i].path, Laya3D.MATERIAL);
				break;
			case "ShuriKenParticle3D": 
				var parMeshPath:String = props.meshPath;
				(parMeshPath) && (props.meshPath = _addHierarchyInnerUrls(firstLevelUrls, subUrls, urlVersion, hierarchyBasePath, parMeshPath, Laya3D.MESH));
				props.material.path = _addHierarchyInnerUrls(secondLevelUrls, subUrls, urlVersion, hierarchyBasePath, props.material.path, Laya3D.MATERIAL);
				break;
			case "Terrain": 
				_addHierarchyInnerUrls(fourthLelUrls, subUrls, urlVersion, hierarchyBasePath, props.dataPath, TERRAINRES);
				break;
			}
			
			var components:Array = node.components;
			if (components) {
				for (var k:int = 0, p:int = components.length; k < p; k++) {
					var component:Object = components[k];
					switch (component.type) {
					case "Animator": 
						var avatarPath:String = component.avatarPath;
						var avatarData:Object = component.avatar;
						(avatarData) && (avatarData.path = _addHierarchyInnerUrls(fourthLelUrls, subUrls, urlVersion, hierarchyBasePath, avatarData.path, AVATAR));
						var clipPaths:Vector.<String> = component.clipPaths;
						if (!clipPaths) {
							var layersData:Array = component.layers;
							for (i = 0; i < layersData.length; i++) {
								var states:Array = layersData[i].states;
								for (var j:int = 0, m:int = states.length; j < m; j++) {
									var clipPath:String = states[j].clipPath;
									(clipPath) && (states[j].clipPath = _addHierarchyInnerUrls(fourthLelUrls, subUrls, urlVersion, hierarchyBasePath, clipPath, ANIMATIONCLIP));
								}
							}
						} else {
							for (i = 0, n = clipPaths.length; i < n; i++)
								clipPaths[i] = _addHierarchyInnerUrls(fourthLelUrls, subUrls, urlVersion, hierarchyBasePath, clipPaths[i], ANIMATIONCLIP);
						}
						break;
					case "PhysicsCollider": 
					case "Rigidbody3D": 
					case "CharacterController": 
						var shapes:Array = component.shapes;
						for (i = 0; i < shapes.length; i++) {
							var shape:Object = shapes[i];
							if (shape.type === "MeshColliderShape") {
								var mesh:String = shape.mesh;
								(mesh) && (shape.mesh = _addHierarchyInnerUrls(firstLevelUrls, subUrls, urlVersion, hierarchyBasePath, mesh, Laya3D.MESH));
							}
						}
						break;
					}
				}
			}
			
			var children:Array = node.child;
			for (i = 0, n = children.length; i < n; i++)
				_getSprite3DHierarchyInnerUrls(children[i], firstLevelUrls, secondLevelUrls, thirdLevelUrls, fourthLelUrls, subUrls, urlVersion, hierarchyBasePath);
		}
		
		/**
		 *@private
		 */
		private static function _loadHierarchy(loader:Loader):void {
			loader.on(Event.LOADED, null, _onHierarchylhLoaded, [loader]);
			loader.load(loader.url, Loader.JSON, false, null, true);
		}
		
		/**
		 *@private
		 */
		private static function _onHierarchylhLoaded(loader:Loader, lhData:Object):void {
			var url:String = loader.url;
			var urlVersion:String = Utils3D.getURLVerion(url);
			var hierarchyBasePath:String = URL.getPath(url);
			var firstLevUrls:Array = [];
			var secondLevUrls:Array = [];
			var thirdLevUrls:Array = [];
			var forthLevUrls:Array = [];
			var subUrls:Array = [];
			_getSprite3DHierarchyInnerUrls(lhData.data, firstLevUrls, secondLevUrls, thirdLevUrls, forthLevUrls, subUrls, urlVersion, hierarchyBasePath);
			var urlCount:int = firstLevUrls.length + secondLevUrls.length + forthLevUrls.length;
			var totalProcessCount:int = urlCount + 1;
			var weight:Number = 1 / totalProcessCount;
			_onProcessChange(loader, 0, weight, 1.0);
			if (forthLevUrls.length > 0) {
				var processCeil:Number = urlCount / totalProcessCount;
				var processHandler:Handler = Handler.create(null, _onProcessChange, [loader, weight, processCeil], false);
				_innerFourthLevelLoaderManager._create(forthLevUrls, false, Handler.create(null, _onHierarchyInnerForthLevResouLoaded, [loader, processHandler, lhData, subUrls, firstLevUrls, secondLevUrls, thirdLevUrls, weight + processCeil * forthLevUrls.length, processCeil]), processHandler, null, null, null, 1, true);
			} else {
				_onHierarchyInnerForthLevResouLoaded(loader, null, lhData, subUrls, firstLevUrls, secondLevUrls, thirdLevUrls, weight, processCeil);
			}
		}
		
		/**
		 *@private
		 */
		private static function _onHierarchyInnerForthLevResouLoaded(loader:Loader, processHandler:Handler, lhData:Object, subUrls:Array, firstLevUrls:Array, secondLevUrls:Array, thirdLevUrls:Array, processOffset:Number, processCeil:Number):void {
			(processHandler) && (processHandler.recover());
			if (thirdLevUrls.length > 0) {
				var process:Handler = Handler.create(null, _onProcessChange, [loader, processOffset, processCeil], false);
				_innerThirdLevelLoaderManager._create(thirdLevUrls, false, Handler.create(null, _onHierarchyInnerThirdLevResouLoaded, [loader, process, lhData, subUrls, firstLevUrls, secondLevUrls, processOffset + processCeil * secondLevUrls.length, processCeil]), processHandler, null, null, null, 1, true);
			} else {
				_onHierarchyInnerThirdLevResouLoaded(loader, null, lhData, subUrls, firstLevUrls, secondLevUrls, processOffset, processCeil);
			}
		}
		
		/**
		 *@private
		 */
		private static function _onHierarchyInnerThirdLevResouLoaded(loader:Loader, processHandler:Handler, lhData:Object, subUrls:Array, firstLevUrls:Array, secondLevUrls:Array, processOffset:Number, processCeil:Number):void {
			(processHandler) && (processHandler.recover());
			if (secondLevUrls.length > 0) {
				var process:Handler = Handler.create(null, _onProcessChange, [loader, processOffset, processCeil], false);
				_innerSecondLevelLoaderManager._create(secondLevUrls, false, Handler.create(null, _onHierarchyInnerSecondLevResouLoaded, [loader, process, lhData, subUrls, firstLevUrls, processOffset + processCeil * secondLevUrls.length, processCeil]), processHandler, null, null, null, 1, true);
			} else {
				_onHierarchyInnerSecondLevResouLoaded(loader, null, lhData, subUrls, firstLevUrls, processOffset, processCeil);
			}
		}
		
		/**
		 *@private
		 */
		private static function _onHierarchyInnerSecondLevResouLoaded(loader:Loader, processHandler:Handler, lhData:Object, subUrls:Array, firstLevUrls:Array, processOffset:Number, processCeil:Number):void {
			(processHandler) && (processHandler.recover());
			if (firstLevUrls.length > 0) {
				var process:Handler = Handler.create(null, _onProcessChange, [loader, processOffset, processCeil], false);
				_innerFirstLevelLoaderManager._create(firstLevUrls, false, Handler.create(null, _onHierarchyInnerFirstLevResouLoaded, [loader, process, lhData, subUrls /*processOffset + processCeil * firstLevUrls.length, processCeil*/]), processHandler, null, null, null, 1, true);
			} else {
				_onHierarchyInnerFirstLevResouLoaded(loader, null, lhData, subUrls);
			}
		}
		
		/**
		 *@private
		 */
		private static function _onHierarchyInnerFirstLevResouLoaded(loader:Loader, processHandler:Handler, lhData:Object, subUrls:Array):void {
			(processHandler) && (processHandler.recover());
			loader._cache = loader._createCache;
			var item:Node = lhData.data.type === "Scene3D" ? Scene3D._parse(lhData, loader._propertyParams, loader._constructParams) : Sprite3D._parse(lhData, loader._propertyParams, loader._constructParams);
			_endLoad(loader, item, subUrls);
		}
		
		/**
		 *@private
		 */
		private static function _loadMesh(loader:Loader):void {
			loader.on(Event.LOADED, null, _onMeshLmLoaded, [loader]);
			loader.load(loader.url, Loader.BUFFER, false, null, true);
		}
		
		/**
		 *@private
		 */
		private static function _onMeshLmLoaded(loader:Loader, lmData:ArrayBuffer):void {
			loader._cache = loader._createCache;
			var mesh:Mesh = Mesh._parse(lmData, loader._propertyParams, loader._constructParams);
			_endLoad(loader, mesh);
		}
		
		/**
		 *@private
		 */
		private static function _loadMaterial(loader:Loader):void {
			loader.on(Event.LOADED, null, _onMaterilLmatLoaded, [loader]);
			loader.load(loader.url, Loader.JSON, false, null, true);
		}
		
		/**
		 *@private
		 */
		private static function _onMaterilLmatLoaded(loader:Loader, lmatData:Object):void {
			var url:String = loader.url;
			var urlVersion:String = Utils3D.getURLVerion(url);
			var materialBasePath:String = URL.getPath(url);
			var urls:Array = [];
			var subUrls:Array = [];
			var customProps:Object = lmatData.customProps;
			var formatSubUrl:String;
			var version:String = lmatData.version;
			switch (version) {
			case "LAYAMATERIAL:01": 
			case "LAYAMATERIAL:02": 
				var i:int, n:int;
				var textures:Array = lmatData.props.textures;
				if (textures) {
					for (i = 0, n = textures.length; i < n; i++) {
						var tex2D:Object = textures[i];
						var tex2DPath:String = tex2D.path;
						if (tex2DPath) {
							formatSubUrl = formatRelativePath(materialBasePath, tex2DPath);
							(urlVersion) && (formatSubUrl = formatSubUrl + urlVersion);
							
							urls.push({url: formatSubUrl, constructParams: tex2D.constructParams, propertyParams: tex2D.propertyParams});//不指定类型,自动根据后缀判断Texture2D或TextureCube
							subUrls.push(formatSubUrl);
							tex2D.path = formatSubUrl;
						}
					}
				}
				break;
			default: 
				throw new Error("Laya3D:unkonwn version.");
			}
			
			var urlCount:int = urls.length;
			var totalProcessCount:int = urlCount + 1;
			var lmatWeight:Number = 1 / totalProcessCount;
			_onProcessChange(loader, 0, lmatWeight, 1.0);
			if (urlCount > 0) {
				var processHandler:Handler = Handler.create(null, _onProcessChange, [loader, lmatWeight, urlCount / totalProcessCount], false);
				_innerFourthLevelLoaderManager._create(urls, false, Handler.create(null, _onMateialTexturesLoaded, [loader, processHandler, lmatData, subUrls]), processHandler, null, null, null, 1, true);//TODO:还有可能是TextureCube,使用三级
			} else {
				_onMateialTexturesLoaded(loader, null, lmatData, null);
			}
		}
		
		/**
		 *@private
		 */
		private static function _onMateialTexturesLoaded(loader:Loader, processHandler:Handler, lmatData:Object, subUrls:Array):void {
			loader._cache = loader._createCache;
			var mat:BaseMaterial = BaseMaterial._parse(lmatData, loader._propertyParams, loader._constructParams);
			_endLoad(loader, mat, subUrls);
			(processHandler) && (processHandler.recover());
		}
		
		/**
		 *@private
		 */
		private static function _loadAvatar(loader:Loader):void {
			loader.on(Event.LOADED, null, function(data:*):void {
				loader._cache = loader._createCache;
				var avatar:Avatar = Avatar._parse(data, loader._propertyParams, loader._constructParams);
				_endLoad(loader, avatar);
			});
			loader.load(loader.url, Loader.JSON, false, null, true);
		}
		
		/**
		 *@private
		 */
		private static function _loadAnimationClip(loader:Loader):void {
			loader.on(Event.LOADED, null, function(data:*):void {
				loader._cache = loader._createCache;
				var clip:AnimationClip = AnimationClip._parse(data, loader._propertyParams, loader._constructParams);
				_endLoad(loader, clip);
			});
			loader.load(loader.url, Loader.BUFFER, false, null, true);
		}
		
		/**
		 *@private
		 */
		private static function _loadTexture2D(loader:Loader):void {
			var url:String = loader.url;
			var index:int = url.lastIndexOf('.') + 1;
			var verIndex:int = url.indexOf('?');
			var endIndex:int = verIndex == -1 ? url.length : verIndex;
			var ext:String = url.substr(index, endIndex - index);
			var type:String;
			switch (ext) {
			case "jpg": 
			case "jpeg": 
			case "bmp": 
			case "gif": 
			case "png": 
				type = "nativeimage";
				break;
			case "dds": 
			case "ktx": 
			case "pvr": 
				type = Loader.BUFFER;
				break;
			}
			
			//需要先注册,否则可能同步加载完成没来得及注册就完成
			loader.on(Event.LOADED, null, function(image:*):void {
				loader._cache = loader._createCache;
				var tex:Texture2D = Texture2D._parse(image, loader._propertyParams, loader._constructParams);
				_endLoad(loader, tex);
			});
			loader.load(loader.url, type, false, null, true);
		}
		
		/**
		 *@private
		 */
		private static function _loadTextureCube(loader:Loader):void {
			loader.on(Event.LOADED, null, _onTextureCubeLtcLoaded, [loader]);
			loader.load(loader.url, Loader.JSON, false, null, true);
		}
		
		/**
		 *@private
		 */
		private static function _onTextureCubeLtcLoaded(loader:Loader, ltcData:Object):void {
			var ltcBasePath:String = URL.getPath(loader.url);
			var urls:Array = [formatRelativePath(ltcBasePath, ltcData.front), formatRelativePath(ltcBasePath, ltcData.back), formatRelativePath(ltcBasePath, ltcData.left), formatRelativePath(ltcBasePath, ltcData.right), formatRelativePath(ltcBasePath, ltcData.up), formatRelativePath(ltcBasePath, ltcData.down)];
			var ltcWeight:Number = 1.0 / 7.0;
			_onProcessChange(loader, 0, ltcWeight, 1.0);
			var processHandler:Handler = Handler.create(null, _onProcessChange, [loader, ltcWeight, 6 / 7], false);
			_innerFourthLevelLoaderManager.load(urls, Handler.create(null, _onTextureCubeImagesLoaded, [loader, urls, processHandler]), processHandler, "nativeimage");
		
		}
		
		/**
		 *@private
		 */
		private static function _onTextureCubeImagesLoaded(loader:Loader, urls:Array, processHandler:Handler):void {
			var images:Array = new Array(6);
			for (var i:int = 0; i < 6; i++)
				images[i] = Loader.getRes(urls[i]);
			
			loader._cache = loader._createCache;
			var tex:TextureCube = TextureCube._parse(images, loader._propertyParams, loader._constructParams);
			
			processHandler.recover();
			for (i = 0; i < 6; i++)
				Loader.clearRes(urls[i]);
			_endLoad(loader, tex);
		}
		
		/**
		 *@private
		 */
		private static function _onProcessChange(loader:Loader, offset:Number, weight:Number, process:Number):void {
			process = offset + process * weight;
			(process < 1.0) && (loader.event(Event.PROGRESS, process));
		}
		
		/**
		 * 初始化Laya3D相关设置。
		 * @param	width  3D画布宽度。
		 * @param	height 3D画布高度。
		 */
		public static function init(width:Number, height:Number, config:Config3D = null, compolete:Handler = null):void {
			if (_isInit)
				return;
			_isInit = true;
			config = config || Config3D._default;
			config.cloneTo(_config);
			_editerEnvironment = _config._editerEnvironment;
			var physics3D:Function = window.Physics3D;
			if (physics3D == null) {
				_enbalePhysics = false;
				__init__(width, height, _config);
				compolete && compolete.run();
			} else {
				_enbalePhysics = true;
				physics3D(_config.defaultPhysicsMemory * 1024 * 1024).then(function():void {
					__init__(width, height, _config);
					compolete && compolete.run();
				});
			}
		}
		
		/**
		 * 创建一个 <code>Laya3D</code> 实例。
		 */
		public function Laya3D() {
		}
	
	}
}