package {
	import laya.ani.AnimationTemplet;
	import laya.d3.animation.AnimationClip;
	import laya.d3.animation.AnimationNode;
	import laya.d3.component.Script;
	import laya.d3.component.physics.Collider;
	import laya.d3.core.Avatar;
	import laya.d3.core.Layer;
	import laya.d3.core.MeshSprite3D;
	import laya.d3.core.PhasorSpriter3D;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.SkinnedMeshSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.BlinnPhongMaterial;
	import laya.d3.core.material.PBRMaterial;
	import laya.d3.core.material.PBRSpecularMaterial;
	import laya.d3.core.material.PBRStandardMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.material.TerrainMaterial;
	import laya.d3.core.material.WaterMaterial;
	import laya.d3.core.particleShuriKen.ShuriKenParticle3D;
	import laya.d3.core.particleShuriKen.ShurikenParticleMaterial;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.OctreeNode;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Collision;
	import laya.d3.math.ContainmentType;
	import laya.d3.resource.DataTexture2D;
	import laya.d3.resource.Texture2D;
	import laya.d3.resource.TextureCube;
	import laya.d3.resource.models.Mesh;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shader.ShaderInit3D;
	import laya.d3.terrain.TerrainHeightData;
	import laya.d3.terrain.TerrainRes;
	import laya.d3.utils.CollisionManager;
	import laya.d3.utils.Physics;
	import laya.d3.utils.Utils3D;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.net.LoaderManager;
	import laya.net.URL;
	import laya.renders.Render;
	import laya.utils.Browser;
	import laya.utils.Byte;
	import laya.utils.Handler;
	import laya.utils.RunDriver;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.atlas.AtlasResourceManager;
	
	/**
	 * <code>Laya3D</code> 类用于初始化3D设置。
	 */
	public class Laya3D {
		/**@private 层级文件资源标记。*/
		private static const HIERARCHY:String = "SPRITE3DHIERARCHY";
		/**@private 网格的原始资源标记。*/
		private static const MESH:String = "MESH";
		/**@private 材质的原始资源标记。*/
		private static const MATERIAL:String = "MATERIAL";
		/**@private PBR材质资源标记。*/
		private static const PBRMATERIAL:String = "PBRMTL";
		/**@private TextureCube原始资源标记。*/
		private static const TEXTURECUBE:String = "TEXTURECUBE";
		/**@private Terrain原始资源标记。*/
		private static const TERRAIN:String = "TERRAIN";
		
		/**@private */
		private static var _DATA:Object = {offset: 0, size: 0};
		/**@private */
		private static var _strings:Array = ['BLOCK', 'DATA', "STRINGS"];//字符串数组
		/**@private */
		private static var _readData:Byte;
		
		/**@private */
		private static const _innerFirstLevelLoaderManager:LoaderManager = new LoaderManager();//Mesh 
		/**@private */
		private static const _innerSecondLevelLoaderManager:LoaderManager = new LoaderManager();//Material
		/**@private */
		private static const _innerThirdLevelLoaderManager:LoaderManager = new LoaderManager();//TextureCube、TerrainResou
		/**@private */
		private static const _innerFourthLevelLoaderManager:LoaderManager = new LoaderManager();//Texture2D、Image、Avatar、AnimationClip
		
		/**@private */
		public static var _debugPhasorSprite:PhasorSpriter3D;
		
		/**@private */
		public static var debugMode:Boolean = false;
		
		/**
		 * 创建一个 <code>Laya3D</code> 实例。
		 */
		public function Laya3D() {
		}
		
		/**
		 *@private
		 */
		private static function _changeWebGLSize(width:Number, height:Number):void {
			WebGL.onStageResize(width, height);
			RenderState.clientWidth = width;
			RenderState.clientHeight = height;
		}
		
		/**
		 *@private
		 */
		private static function __init__():void {
			var createMap:Object = LoaderManager.createMap;
			createMap["lh"] = [Sprite3D, Laya3D.HIERARCHY];
			createMap["ls"] = [Scene, Laya3D.HIERARCHY];
			createMap["lm"] = [Mesh, Laya3D.MESH];
			createMap["lmat"] = [StandardMaterial, Laya3D.MATERIAL];
			createMap["lpbr"] = [PBRMaterial, Laya3D.MATERIAL];
			createMap["ltc"] = [TextureCube, Laya3D.TEXTURECUBE];
			createMap["jpg"] = [Texture2D, "nativeimage"];
			createMap["jpeg"] = [Texture2D, "nativeimage"];
			createMap["png"] = [Texture2D, "nativeimage"];
			createMap["pkm"] = [Texture2D, Loader.BUFFER];
			createMap["lsani"] = [AnimationTemplet, Loader.BUFFER];
			createMap["lrani"] = [AnimationTemplet, Loader.BUFFER];
			createMap["raw"] = [DataTexture2D, Loader.BUFFER];
			createMap["mipmaps"] = [DataTexture2D, Loader.BUFFER];
			createMap["thdata"] = [TerrainHeightData, Loader.BUFFER];
			createMap["lt"] = [TerrainRes, Laya3D.TERRAIN];
			createMap["lani"] = [AnimationClip, Loader.BUFFER];
			createMap["lav"] = [Avatar, Loader.JSON];
			createMap["ani"] = [AnimationTemplet, Loader.BUFFER];//兼容接口
			
			Loader.parserMap[Laya3D.HIERARCHY] = _loadHierarchy;
			Loader.parserMap[Laya3D.MESH] = _loadMesh;
			Loader.parserMap[Laya3D.MATERIAL] = _loadMaterial;
			Loader.parserMap[Laya3D.TEXTURECUBE] = _loadTextureCube;
			Loader.parserMap[Laya3D.TERRAIN] = _loadTerrain;
			
			_innerFirstLevelLoaderManager.on(Event.ERROR, null, _eventLoadManagerError);
			_innerSecondLevelLoaderManager.on(Event.ERROR, null, _eventLoadManagerError);
			_innerThirdLevelLoaderManager.on(Event.ERROR, null, _eventLoadManagerError);
			_innerFourthLevelLoaderManager.on(Event.ERROR, null, _eventLoadManagerError);
		}
		
		/**
		 *@private
		 */
		private static function READ_BLOCK():Boolean {
			_readData.pos += 4;
			return true;
		}
		
		/**
		 *@private
		 */
		private static function READ_DATA():Boolean {
			_DATA.offset = _readData.getUint32();
			_DATA.size = _readData.getUint32();
			return true;
		}
		
		/**
		 *@private
		 */
		private static function READ_STRINGS():Array {
			var materialUrls:Array = [];
			var _STRINGS:Object = {offset: 0, size: 0};
			_STRINGS.offset = _readData.getUint16();
			_STRINGS.size = _readData.getUint16();
			var ofs:int = _readData.pos;
			_readData.pos = _STRINGS.offset + _DATA.offset;
			
			for (var i:int = 0; i < _STRINGS.size; i++) {
				var string:String = _readData.readUTFString();
				if (string.lastIndexOf(".lmat") !== -1 || string.lastIndexOf(".lpbr") !== -1)
					materialUrls.push(string);
			}
			return materialUrls;
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
		private static function _addHierarchyInnerUrls(urls:Array, urlMap:Object, urlVersion:String, hierarchyBasePath:String, path:String, clas:Class):void {
			var formatSubUrl:String = URL.formatURL(path, hierarchyBasePath);
			(urlVersion) && (formatSubUrl = formatSubUrl + urlVersion);
			urls.push({url: formatSubUrl, clas: clas});
			urlMap[path] = formatSubUrl;
		}
		
		/**
		 *@private
		 */
		private static function _getSprite3DHierarchyInnerUrls(node:Object, firstLevelUrls:Array, secondLevelUrls:Array, fourthLelUrls:Array, urlMap:Object, urlVersion:String, hierarchyBasePath:String):void {
			var i:int, n:int;
			var customProps:Object;
			switch (node.type) {
			case "Scene": //TODO:应该自动序列化类型
				var lightmaps:Array = node.customProps.lightmaps;
				for (i = 0, n = lightmaps.length; i < n; i++) {
					var lightMap:String = lightmaps[i].replace("exr", "png");
					_addHierarchyInnerUrls(fourthLelUrls, urlMap, urlVersion, hierarchyBasePath, lightMap, Texture2D);
				}
				break;
			case "MeshSprite3D": 
			case "TrailSprite3D": 
			case "SkinnedMeshSprite3D": 
				var meshPath:String;
				if (node.instanceParams) {//兼容代码
					meshPath = node.instanceParams.loadPath;
					(meshPath) && (_addHierarchyInnerUrls(firstLevelUrls, urlMap, urlVersion, hierarchyBasePath, meshPath, Mesh));
				} else {
					customProps = node.customProps;
					meshPath = customProps.meshPath;
					(meshPath) && (_addHierarchyInnerUrls(firstLevelUrls, urlMap, urlVersion, hierarchyBasePath, meshPath, Mesh));
					var materials:Array = customProps.materials;
					if (materials)
						for (i = 0, n = materials.length; i < n; i++) {
							var mat:Object = materials[i];
							var clasPaths:Array = mat.type.split('.');
							var clas:Class = Browser.window;
							clasPaths.forEach(function(cls:*):void {
								clas = clas[cls];
							});
							if (typeof(clas) == 'function') _addHierarchyInnerUrls(secondLevelUrls, urlMap, urlVersion, hierarchyBasePath, mat.path, clas);
							else {
								throw('_getSprite3DHierarchyInnerUrls 错误: ' + mat.type + ' 不是类');
							}
						}
				}
				break;
			case "ShuriKenParticle3D": 
				customProps = node.customProps;
				var parMeshPath:String = customProps.meshPath;
				(parMeshPath) && (_addHierarchyInnerUrls(firstLevelUrls, urlMap, urlVersion, hierarchyBasePath, parMeshPath, Mesh));
				var materialData:Object = customProps.material;
				if (materialData) {
					_addHierarchyInnerUrls(secondLevelUrls, urlMap, urlVersion, hierarchyBasePath, materialData.path, ShurikenParticleMaterial);
				} else {//兼容代码
					var materialPath:String = customProps.materialPath;
					if (materialPath) {//兼容代码
						_addHierarchyInnerUrls(secondLevelUrls, urlMap, urlVersion, hierarchyBasePath, materialPath, ShurikenParticleMaterial);
					} else {//兼容代码
						var texturePath:String = customProps.texturePath;
						if (texturePath)
							_addHierarchyInnerUrls(fourthLelUrls, urlMap, urlVersion, hierarchyBasePath, texturePath, Texture2D);
							//else 材质可能为空,非兼容代码
					}
				}
				break;
			case "Terrain": 
				_addHierarchyInnerUrls(fourthLelUrls, urlMap, urlVersion, hierarchyBasePath, node.customProps.dataPath, TerrainRes);
				break;
			}
			
			var components:Object = node.components;
			for (var k:String in components) {
				var component:Object = components[k];
				switch (k) {
				case "Animator": 
					var avatarPath:String = component.avatarPath;
					if (avatarPath) {//兼容代码
						_addHierarchyInnerUrls(fourthLelUrls, urlMap, urlVersion, hierarchyBasePath, avatarPath, Avatar);
					} else {
						var avatarData:Object = component.avatar;
						(avatarData) && (_addHierarchyInnerUrls(fourthLelUrls, urlMap, urlVersion, hierarchyBasePath, avatarData.path, Avatar));
					}
					
					var clipPaths:Vector.<String> = component.clipPaths;
					for (i = 0, n = clipPaths.length; i < n; i++)
						_addHierarchyInnerUrls(fourthLelUrls, urlMap, urlVersion, hierarchyBasePath, clipPaths[i], AnimationClip);
					break;
				}
			}
			
			var children:Array = node.child;
			for (i = 0, n = children.length; i < n; i++)
				_getSprite3DHierarchyInnerUrls(children[i], firstLevelUrls, secondLevelUrls, fourthLelUrls, urlMap, urlVersion, hierarchyBasePath);
		}
		
		/**
		 *@private
		 */
		private static function _loadHierarchy(loader:Loader):void {
			loader.on(Event.LOADED, null, _onHierarchylhLoaded, [loader, loader._class._getGroup()]);
			loader.load(loader.url, Loader.JSON, false, null, true);
		}
		
		/**
		 *@private
		 */
		private static function _onHierarchylhLoaded(loader:Loader, group:String, lhData:Object):void {
			if (loader._class.destroyed) {
				loader.endLoad();
			} else {
				var url:String = loader.url;
				var urlVersion:String = Utils3D.getURLVerion(url);
				var hierarchyBasePath:String = URL.getPath(URL.formatURL(url));
				var firstLevUrls:Array = [];
				var secondLevUrls:Array = [];
				var forthLevUrls:Array = [];
				var urlMap:Object = {};
				_getSprite3DHierarchyInnerUrls(lhData, firstLevUrls, secondLevUrls, forthLevUrls, urlMap, urlVersion, hierarchyBasePath);
				var urlCount:int = firstLevUrls.length + secondLevUrls.length + forthLevUrls.length;
				var totalProcessCount:int = urlCount + 1;
				var weight:Number = 1 / totalProcessCount;
				_onProcessChange(loader, 0, weight, 1.0);
				if (forthLevUrls.length > 0) {
					var processCeil:Number = urlCount / totalProcessCount;
					var processHandler:Handler = Handler.create(null, _onProcessChange, [loader, weight, processCeil], false);
					_innerFourthLevelLoaderManager.create(forthLevUrls, Handler.create(null, _onHierarchyInnerForthLevResouLoaded, [loader, group, processHandler, lhData, urlMap, firstLevUrls, secondLevUrls, weight + processCeil * forthLevUrls.length, processCeil]), processHandler, null, null, 1, true, group);
				} else {
					_onHierarchyInnerForthLevResouLoaded(loader, group, null, lhData, urlMap, firstLevUrls, secondLevUrls, weight, processCeil);
				}
			}
		}
		
		/**
		 *@private
		 */
		private static function _onHierarchyInnerForthLevResouLoaded(loader:Loader, group:String, processHandler:Handler, lhData:Object, urlMap:Object, firstLevUrls:Array, secondLevUrls:Array, processOffset:Number, processCeil:Number):void {
			if (loader._class.destroyed) {
				loader.endLoad();
			} else {
				(processHandler) && (processHandler.recover());
				if (secondLevUrls.length > 0) {
					var process:Handler = Handler.create(null, _onProcessChange, [loader, processOffset, processCeil], false);
					_innerSecondLevelLoaderManager.create(secondLevUrls, Handler.create(null, _onHierarchyInnerSecondLevResouLoaded, [loader, group, process, lhData, urlMap, firstLevUrls, processOffset + processCeil * secondLevUrls.length, processCeil]), processHandler, null, null, 1, true, group);
				} else {
					_onHierarchyInnerSecondLevResouLoaded(loader, group, null, lhData, urlMap, firstLevUrls, processOffset, processCeil);
				}
			}
		}
		
		/**
		 *@private
		 */
		private static function _onHierarchyInnerSecondLevResouLoaded(loader:Loader, group:String, processHandler:Handler, lhData:Object, urlMap:Object, firstLevUrls:Array, processOffset:Number, processCeil:Number):void {
			if (loader._class.destroyed) {
				loader.endLoad();
			} else {
				(processHandler) && (processHandler.recover());
				if (firstLevUrls.length > 0) {
					var process:Handler = Handler.create(null, _onProcessChange, [loader, processOffset, processCeil], false);
					_innerFirstLevelLoaderManager.create(firstLevUrls, Handler.create(null, _onHierarchyInnerFirstLevResouLoaded, [loader, process, lhData, urlMap, /*processOffset + processCeil * firstLevUrls.length, processCeil*/]), processHandler, null, null, 1, true, group);
					
				} else {
					_onHierarchyInnerFirstLevResouLoaded(loader, null, lhData, urlMap);
				}
			}
		}
		
		/**
		 *@private
		 */
		private static function _onHierarchyInnerFirstLevResouLoaded(loader:Loader, processHandler:Handler, lhData:Object, urlMap:Object):void {
			(processHandler) && (processHandler.recover());
			loader.endLoad([lhData, urlMap]);
		}
		
		/**
		 *@private
		 */
		private static function _loadTerrain(loader:Loader):void {
			loader.on(Event.LOADED, null, _onTerrainLtLoaded, [loader, loader._class._getGroup()]);
			loader.load(loader.url, Loader.JSON, false, null, true);
		}
		
		/**
		 *@private
		 */
		private static function _onTerrainLtLoaded(loader:Loader, group:String, ltData:Object):void {
			if (loader._class.destroyed) {
				loader.endLoad();
			} else {
				var url:String = loader.url;
				var urlVersion:String = Utils3D.getURLVerion(url);
				var terrainBasePath:String = URL.getPath(URL.formatURL(url));
				
				var heightMapURL:String, textureURLs:Array = [];
				var urlMap:Object = {};
				var formatUrl:String;
				var i:int, n:int, count:uint;
				
				var heightData:Object = ltData.heightData;
				heightMapURL = heightData.url;
				formatUrl = URL.formatURL(heightMapURL, terrainBasePath);
				(urlVersion) && (formatUrl = formatUrl + urlVersion);
				urlMap[heightMapURL] = formatUrl;
				heightMapURL = formatUrl;
				
				var detailTextures:Array = ltData.detailTexture;
				for (i = 0, n = detailTextures.length; i < n; i++)
					textureURLs.push({url: detailTextures[i].diffuse});
				
				var normalMaps:Array = ltData.normalMap;
				for (i = 0, n = normalMaps.length; i < n; i++)
					textureURLs.push({url: normalMaps[i]});
				
				var alphaMaps:Array = ltData.alphaMap;
				for (i = 0, n = alphaMaps.length; i < n; i++)
					textureURLs.push({url: alphaMaps[i], params: [false, false, WebGLContext.RGBA, true]});
				
				for (i = 0, n = textureURLs.length; i < n; i++) {
					var subUrl:String = textureURLs[i].url;
					formatUrl = URL.formatURL(subUrl, terrainBasePath);
					(urlVersion) && (formatUrl = formatUrl + urlVersion);
					textureURLs[i].url = formatUrl;
					urlMap[subUrl] = formatUrl;
				}
				
				var texsUrlCount:int = textureURLs.length;
				var totalProcessCount:int = texsUrlCount + 2;//heightMap始终为1个
				var weight:Number = 1 / totalProcessCount;
				_onProcessChange(loader, 0, weight, 1.0);
				
				var loadInfo:Object = {heightMapLoaded: false, texturesLoaded: false};//TODO:
				var hmProcessHandler:Handler = Handler.create(null, _onProcessChange, [loader, weight, weight], false);
				_innerFourthLevelLoaderManager.create(heightMapURL, Handler.create(null, _onTerrainHeightMapLoaded, [loader, hmProcessHandler, ltData, urlMap, loadInfo]), hmProcessHandler, null, [heightData.numX, heightData.numZ, heightData.bitType, heightData.value], 1, true, group);
				
				var texsProcessHandler:Handler = Handler.create(null, _onProcessChange, [loader, weight * 2, texsUrlCount / totalProcessCount], false);//TODO:
				_innerFourthLevelLoaderManager.create(textureURLs, Handler.create(null, _onTerrainTexturesLoaded, [loader, texsProcessHandler, ltData, urlMap, loadInfo]), texsProcessHandler, null, null, 1, true, group);
			}
		}
		
		/**
		 *@private
		 */
		private static function _onTerrainHeightMapLoaded(loader:Loader, processHandler:Handler, ltData:Object, urlMap:Object, loadInfo:Object):void {
			loadInfo.heightMapLoaded = true;
			if (loadInfo.texturesLoaded) {
				loader.endLoad([ltData, urlMap]);
				processHandler.recover();
			}
		}
		
		/**
		 *@private
		 */
		private static function _onTerrainTexturesLoaded(loader:Loader, processHandler:Handler, ltData:Object, urlMap:Object, loadInfo:Object):void {
			loadInfo.texturesLoaded = true;
			if (loadInfo.heightMapLoaded) {
				loader.endLoad([ltData, urlMap]);
				processHandler.recover();
			}
		}
		
		/**
		 *@private
		 */
		private static function _loadMesh(loader:Loader):void {
			loader.on(Event.LOADED, null, _onMeshLmLoaded, [loader, loader._class._getGroup()]);
			loader.load(loader.url, Loader.BUFFER, false, null, true);
		}
		
		/**
		 *@private
		 */
		private static function _onMeshLmLoaded(loader:Loader, group:String, lmData:ArrayBuffer):void {
			if (loader._class.destroyed) {
				loader.endLoad();
			} else {
				var url:String = loader.url;
				var urlVersion:String = Utils3D.getURLVerion(url);
				var meshBasePath:String = URL.getPath(URL.formatURL(url));
				
				var urls:Array;
				var urlMap:Object = {};
				var formatSubUrl:String;
				
				var i:int, n:int, count:uint;
				_readData = new Byte(lmData);
				_readData.pos = 0;
				var version:String = _readData.readUTFString();
				switch (version) {
				case "LAYAMODEL:02": 
				case "LAYAMODEL:03": 
				case "LAYAMODEL:0301": 
					var dataOffset:uint = _readData.getUint32();
					_readData.pos = _readData.pos + 4;//跳过数据信息区
					
					count = _readData.getUint16();//跳过内容段落信息区
					_readData.pos = _readData.pos + count * 8;
					
					var offset:uint = _readData.getUint32();//读取字符区
					count = _readData.getUint16();
					_readData.pos = dataOffset + offset;
					
					urls = [];
					for (i = 0; i < count; i++) {
						var string:String = _readData.readUTFString();
						if (string.lastIndexOf(".lmat") !== -1)
							urls.push(string);
					}
					break;
				default: 
					READ_BLOCK();
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
					
				}
				
				for (i = 0, n = urls.length; i < n; i++) {
					var subUrl:String = urls[i];
					formatSubUrl = URL.formatURL(subUrl, meshBasePath);
					(urlVersion) && (formatSubUrl = formatSubUrl + urlVersion);
					urls[i] = formatSubUrl;
					urlMap[subUrl] = formatSubUrl;
				}
				
				if (urls.length > 0) {
					var urlCount:int = 1;
					var totalProcessCount:int = urlCount + 1;
					var lmatWeight:Number = 1 / totalProcessCount;
					_onProcessChange(loader, 0, lmatWeight, 1.0);
					var processHandler:Handler = Handler.create(null, _onProcessChange, [loader, lmatWeight, urlCount / totalProcessCount], false);
					_innerSecondLevelLoaderManager.create(urls, Handler.create(null, _onMeshMateialLoaded, [loader, processHandler, lmData, urlMap]), processHandler, null, null, 1, true, group);
				} else {
					loader.endLoad([lmData, urlMap]);
				}
			}
		}
		
		/**
		 *@private
		 */
		private static function _onMeshMateialLoaded(loader:Loader, processHandler:Handler, lmData:Object, urlMap:Object):void {
			loader.endLoad([lmData, urlMap]);
			processHandler.recover();
		}
		
		/**
		 *@private
		 */
		public static function _getMaterialTexturePath(path:String, urlVersion:String, materialBath:String):String {
			var extenIndex:int = path.length - 4;
			if (path.indexOf(".dds") == extenIndex || path.indexOf(".tga") == extenIndex || path.indexOf(".exr") == extenIndex || path.indexOf(".DDS") == extenIndex || path.indexOf(".TGA") == extenIndex || path.indexOf(".EXR") == extenIndex)
				path = path.substr(0, extenIndex) + ".png";
			
			path = URL.formatURL(path, materialBath);
			(urlVersion) && (path = path + urlVersion);
			return path;
		}
		
		/**
		 *@private
		 */
		private static function _loadMaterial(loader:Loader):void {
			loader.on(Event.LOADED, null, _onMaterilLmatLoaded, [loader, loader._class._getGroup()]);
			loader.load(loader.url, Loader.JSON, false, null, true);
		}
		
		/**
		 *@private
		 */
		private static function _onMaterilLmatLoaded(loader:Loader, group:String, lmatData:Object):void {
			if (loader._class.destroyed) {
				loader.endLoad();
			} else {
				var url:String = loader.url;
				var urlVersion:String = Utils3D.getURLVerion(url);
				var materialBasePath:String = URL.getPath(URL.formatURL(url));
				var urls:Array = [];
				var urlMap:Object = {};
				var customProps:Object = lmatData.customProps;
				var formatSubUrl:String;
				var version:String = lmatData.version;
				if (version) {
					switch (version) {
					case "LAYAMATERIAL:01": 
						var textures:Array = lmatData.props.textures;
						for (var i:int = 0, n:int = textures.length; i < n; i++) {
							var tex:Object = textures[i];
							var path:String = tex.path;
							if (path) {
								var extenIndex:int = path.length - 4;
								if (path.indexOf(".exr") == extenIndex || path.indexOf(".EXR") == extenIndex)
									path = path.substr(0, extenIndex) + ".png";
								formatSubUrl = URL.formatURL(path, materialBasePath);
								(urlVersion) && (formatSubUrl = formatSubUrl + urlVersion);
								urls.push({url: formatSubUrl, params: tex.params});
								urlMap[path] = formatSubUrl;
							}
						}
						break;
					default: 
						throw new Error("Laya3D:unkonwn version.");
					}
				} else {//兼容性代码
					var diffuseTexture:String = customProps.diffuseTexture.texture2D;
					if (diffuseTexture) {
						formatSubUrl = _getMaterialTexturePath(diffuseTexture, urlVersion, materialBasePath);
						urls.push(formatSubUrl);
						urlMap[diffuseTexture] = formatSubUrl;
					}
					
					if (customProps.normalTexture) {
						var normalTexture:String = customProps.normalTexture.texture2D;
						if (normalTexture) {
							formatSubUrl = _getMaterialTexturePath(normalTexture, urlVersion, materialBasePath);
							urls.push(formatSubUrl);
							urlMap[normalTexture] = formatSubUrl;
						}
					}
					
					if (customProps.specularTexture) {
						var specularTexture:String = customProps.specularTexture.texture2D;
						if (specularTexture) {
							formatSubUrl = _getMaterialTexturePath(specularTexture, urlVersion, materialBasePath);
							urls.push(formatSubUrl);
							urlMap[specularTexture] = formatSubUrl;
						}
					}
					
					if (customProps.emissiveTexture) {
						var emissiveTexture:String = customProps.emissiveTexture.texture2D;
						if (emissiveTexture) {
							formatSubUrl = _getMaterialTexturePath(emissiveTexture, urlVersion, materialBasePath);
							urls.push(formatSubUrl);
							urlMap[emissiveTexture] = formatSubUrl;
						}
					}
					
					if (customProps.ambientTexture) {
						var ambientTexture:String = customProps.ambientTexture.texture2D;
						if (ambientTexture) {
							formatSubUrl = _getMaterialTexturePath(ambientTexture, urlVersion, materialBasePath);
							urls.push(formatSubUrl);
							urlMap[ambientTexture] = formatSubUrl;
						}
					}
					
					if (customProps.reflectTexture) {//TODO:区分三、四级
						var reflectTexture:String = customProps.reflectTexture.texture2D;
						if (reflectTexture) {
							formatSubUrl = _getMaterialTexturePath(reflectTexture, urlVersion, materialBasePath);
							urls.push(formatSubUrl);
							urlMap[reflectTexture] = formatSubUrl;
						}
					}
				}
				
				var urlCount:int = urls.length;
				var totalProcessCount:int = urlCount + 1;
				var lmatWeight:Number = 1 / totalProcessCount;
				_onProcessChange(loader, 0, lmatWeight, 1.0);
				if (urlCount > 0) {
					var processHandler:Handler = Handler.create(null, _onProcessChange, [loader, lmatWeight, urlCount / totalProcessCount], false);
					_innerFourthLevelLoaderManager.create(urls, Handler.create(null, _onMateialTexturesLoaded, [loader, processHandler, lmatData, urlMap]), processHandler, Texture2D, null, 1, true, group);//TODO:还有可能是TextureCube,使用三级
				} else {
					_onMateialTexturesLoaded(loader, null, lmatData, null);
				}
			}
		}
		
		/**
		 *@private
		 */
		private static function _onMateialTexturesLoaded(loader:Loader, processHandler:Handler, lmatData:Object, urlMap:Object):void {
			loader.endLoad([lmatData, urlMap]);
			(processHandler) && (processHandler.recover());
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
			if (loader._class.destroyed) {
				loader.endLoad();
			} else {
				var ltcBasePath:String = URL.getPath(URL.formatURL(loader.url));
				var urls:Array = [URL.formatURL(ltcData.px, ltcBasePath), URL.formatURL(ltcData.nx, ltcBasePath), URL.formatURL(ltcData.py, ltcBasePath), URL.formatURL(ltcData.ny, ltcBasePath), URL.formatURL(ltcData.pz, ltcBasePath), URL.formatURL(ltcData.nz, ltcBasePath)];
				var ltcWeight:Number = 1.0 / 7.0;
				_onProcessChange(loader, 0, ltcWeight, 1.0);
				var processHandler:Handler = Handler.create(null, _onProcessChange, [loader, ltcWeight, 6 / 7], false);
				_innerFourthLevelLoaderManager.load(urls, Handler.create(null, _onTextureCubeImagesLoaded, [loader, urls, processHandler]), processHandler, "nativeimage");
			}
		}
		
		/**
		 *@private
		 */
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
		public static function init(width:Number, height:Number, antialias:Boolean = false, alpha:Boolean = false, premultipliedAlpha:Boolean = true, stencil:Boolean = true):void {
			RunDriver.update3DLoop = function():void {
				CollisionManager._triggerCollision();
			}
			
			Config.isAntialias = antialias;
			Config.isAlpha = alpha;
			Config.premultipliedAlpha = premultipliedAlpha;
			Config.isStencil = stencil;
			
			if (!Render.isConchNode && !WebGL.enable()) {
				alert("Laya3D init error,must support webGL!");
				return;
			}
			
			RunDriver.changeWebGLSize = _changeWebGLSize;
			Render.is3DMode = true;
			Laya.init(width, height);
			Layer.__init__();
			Physics.__init__();
			//RenderableSprite3D.__init__();
			//SkinnedMeshSprite3D.__init__();
			//ShuriKenParticle3D.__init__();
			//BaseMaterial.__init__();
			//BlinnPhongMaterial.__init__();
			//StandardMaterial.__init__();
			//PBRMaterial.__init__();
			//PBRStandardMaterial.__init__();
			//PBRSpecularMaterial.__init__();
			//WaterMaterial.__init__();
			//ShurikenParticleMaterial.__init__();
			//TerrainMaterial.__init__();
			ShaderInit3D.__init__();
			MeshSprite3D.__init__();
			AnimationNode.__init__();
			__init__();
			AtlasResourceManager.maxTextureCount = 2;
			
			if (Laya3D.debugMode || OctreeNode.debugMode)
				_debugPhasorSprite = new PhasorSpriter3D();
		}
	
	}
}