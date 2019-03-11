package laya.d3.core.scene {
	import laya.d3.CastShadowList;
	import laya.d3.Input3D;
	import laya.d3.component.Animator;
	import laya.d3.component.Script3D;
	import laya.d3.component.SimpleSingletonList;
	import laya.d3.core.BaseCamera;
	import laya.d3.core.Camera;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.light.LightSprite;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.graphics.FrustumCulling;
	import laya.d3.graphics.StaticBatchManager;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.math.Viewport;
	import laya.d3.physics.PhysicsComponent;
	import laya.d3.physics.PhysicsSimulation;
	import laya.d3.resource.RenderTexture;
	import laya.d3.resource.TextureCube;
	import laya.d3.resource.models.SkyBox;
	import laya.d3.resource.models.SkyDome;
	import laya.d3.resource.models.SkyRenderer;
	import laya.d3.shader.DefineDatas;
	import laya.d3.shader.Shader3D;
	import laya.d3.shader.ShaderData;
	import laya.d3.shader.ShaderInit3D;
	import laya.d3.shadowMap.ParallelSplitShadowMap;
	import laya.d3.utils.Utils3D;
	import laya.display.Sprite;
	import laya.display.SpriteConst;
	import laya.layagl.CommandEncoder;
	import laya.layagl.LayaGL;
	import laya.net.Loader;
	import laya.renders.Render;
	import laya.resource.Context;
	import laya.resource.ICreateResource;
	import laya.resource.ISingletonElement;
	import laya.utils.Handler;
	import laya.utils.Timer;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.resource.BaseTexture;
	import laya.webgl.resource.RenderTexture2D;
	import laya.webgl.resource.Texture2D;
	import laya.webgl.submit.ISubmit;
	import laya.webgl.submit.Submit;
	import laya.webgl.submit.SubmitKey;
	import laya.webgl.utils.Buffer;
	
	/**
	 * <code>Scene3D</code> 类用于实现场景。
	 */
	public class Scene3D extends Sprite implements ISubmit, ICreateResource {
		/**@private */
		public static const REFLECTIONMODE_SKYBOX:int = 0;
		/**@private */
		public static const REFLECTIONMODE_CUSTOM:int = 1;
		
		/**@private */
		public static var SHADERDEFINE_FOG:int;
		/**@private */
		public static var SHADERDEFINE_DIRECTIONLIGHT:int;
		/**@private */
		public static var SHADERDEFINE_POINTLIGHT:int;
		/**@private */
		public static var SHADERDEFINE_SPOTLIGHT:int;
		/**@private */
		public static var SHADERDEFINE_CAST_SHADOW:int;
		/**@private */
		public static var SHADERDEFINE_SHADOW_PSSM1:int;
		/**@private */
		public static var SHADERDEFINE_SHADOW_PSSM2:int;
		/**@private */
		public static var SHADERDEFINE_SHADOW_PSSM3:int;
		/**@private */
		public static var SHADERDEFINE_SHADOW_PCF_NO:int;
		/**@private */
		public static var SHADERDEFINE_SHADOW_PCF1:int;
		/**@private */
		public static var SHADERDEFINE_SHADOW_PCF2:int;
		/**@private */
		public static var SHADERDEFINE_SHADOW_PCF3:int;
		/**@private */
		public static var SHADERDEFINE_REFLECTMAP:int;
		
		public static const FOGCOLOR:int = Shader3D.propertyNameToID("u_FogColor");
		public static const FOGSTART:int = Shader3D.propertyNameToID("u_FogStart");
		public static const FOGRANGE:int = Shader3D.propertyNameToID("u_FogRange");
		
		public static const LIGHTDIRECTION:int = Shader3D.propertyNameToID("u_DirectionLight.Direction");
		public static const LIGHTDIRCOLOR:int = Shader3D.propertyNameToID("u_DirectionLight.Color");
		
		public static const POINTLIGHTPOS:int = Shader3D.propertyNameToID("u_PointLight.Position");
		public static const POINTLIGHTRANGE:int = Shader3D.propertyNameToID("u_PointLight.Range");
		public static const POINTLIGHTATTENUATION:int = Shader3D.propertyNameToID("u_PointLight.Attenuation");
		public static const POINTLIGHTCOLOR:int = Shader3D.propertyNameToID("u_PointLight.Color");
		
		public static const SPOTLIGHTPOS:int = Shader3D.propertyNameToID("u_SpotLight.Position");
		public static const SPOTLIGHTDIRECTION:int = Shader3D.propertyNameToID("u_SpotLight.Direction");
		public static const SPOTLIGHTSPOTANGLE:int = Shader3D.propertyNameToID("u_SpotLight.Spot");
		public static const SPOTLIGHTRANGE:int = Shader3D.propertyNameToID("u_SpotLight.Range");
		public static const SPOTLIGHTCOLOR:int = Shader3D.propertyNameToID("u_SpotLight.Color");
		
		public static const SHADOWDISTANCE:int = Shader3D.propertyNameToID("u_shadowPSSMDistance");
		public static const SHADOWLIGHTVIEWPROJECT:int = Shader3D.propertyNameToID("u_lightShadowVP");
		public static const SHADOWMAPPCFOFFSET:int = Shader3D.propertyNameToID("u_shadowPCFoffset");
		public static const SHADOWMAPTEXTURE1:int = Shader3D.propertyNameToID("u_shadowMap1");
		public static const SHADOWMAPTEXTURE2:int = Shader3D.propertyNameToID("u_shadowMap2");
		public static const SHADOWMAPTEXTURE3:int = Shader3D.propertyNameToID("u_shadowMap3");
		
		public static const AMBIENTCOLOR:int = Shader3D.propertyNameToID("u_AmbientColor");
		public static const REFLECTIONTEXTURE:int = Shader3D.propertyNameToID("u_ReflectTexture");
		public static const REFLETIONINTENSITY:int = Shader3D.propertyNameToID("u_ReflectIntensity");
		public static const TIME:int = Shader3D.propertyNameToID("u_Time");
		public static const ANGLEATTENUATIONTEXTURE:int = Shader3D.propertyNameToID("u_AngleTexture");
		public static const RANGEATTENUATIONTEXTURE:int = Shader3D.propertyNameToID("u_RangeTexture");
		public static const POINTLIGHTMATRIX:int = Shader3D.propertyNameToID("u_PointLightMatrix");
		public static const SPOTLIGHTMATRIX:int = Shader3D.propertyNameToID("u_SpotLightMatrix");
		
		/**
		 *@private
		 */
		public static function _parse(data:*, propertyParams:Object = null, constructParams:Array = null):Scene3D {
			var json:Object = data.data;
			//if (json.type !== "Scene3D")
			//throw new Error("Scene: the .lh file root type must be Scene,please use other function to  load  this file.");
			
			var outBatchSprits:Vector.<RenderableSprite3D> = new Vector.<RenderableSprite3D>();
			var scene:Scene3D = Utils3D._createNodeByJson(json, outBatchSprits) as Scene3D;
			StaticBatchManager.combine(null, outBatchSprits);
			return scene;
		}
		
		/**
		 * 加载场景,注意:不缓存。
		 * @param url 模板地址。
		 * @param complete 完成回调。
		 */
		public static function load(url:String, complete:Handler):void {
			Laya.loader.create(url, complete, null, Laya3D.HIERARCHY);
		}
		
		/**@private */
		private var _url:String;
		/**@private */
		private var _group:String;
		/** @private */
		private var _lights:Vector.<LightSprite> = new Vector.<LightSprite>();
		/** @private */
		private var _lightmaps:Vector.<Texture2D>;
		/** @private */
		private var _skyRenderer:SkyRenderer = new SkyRenderer();
		/** @private */
		private var _reflectionMode:int = 1;
		/** @private */
		private var _enableLightCount:int = 3;
		/** @private */
		private var _renderTargetTexture:RenderTexture2D;
		/** @private */
		private var _enableFog:Boolean;
		/**@private */
		public var _physicsSimulation:PhysicsSimulation;
		/**@private */
		private var _input:Input3D = new Input3D();
		/**@private */
		private var _timer:Timer = Laya.timer;
		
		/** @private 只读,不允许修改。*/
		public var _collsionTestList:Vector.<int> = new Vector.<int>();
		
		/** @private */
		public var _shaderValues:ShaderData;
		/** @private */
		public var _defineDatas:DefineDatas;
		/** @private */
		public var _renders:SimpleSingletonList = new SimpleSingletonList();
		/** @private */
		public var _opaqueQueue:RenderQueue = new RenderQueue(false);
		/** @private */
		public var _transparentQueue:RenderQueue = new RenderQueue(true);
		/** @private 相机的对象池*/
		public var _cameraPool:Vector.<BaseCamera> = new Vector.<BaseCamera>();
		/**@private */
		public var _animatorPool:SimpleSingletonList = new SimpleSingletonList();
		/**@private */
		public var _scriptPool:SimpleSingletonList = new SimpleSingletonList();
		
		/** @private */
		public var _castShadowRenders:CastShadowList = new CastShadowList();
		
		/**当前创建精灵所属遮罩层。*/
		public var currentCreationLayer:int = Math.pow(2, 0);
		/** 是否启用灯光。*/
		public var enableLight:Boolean = true;
		
		/** 四/八叉树的根节点。*/
		public var treeRoot:OctreeNode;
		/** 四/八叉树的尺寸。*/
		public var treeSize:Vector3;
		/** 四/八叉树的层数。*/
		public var treeLevel:int;
		
		//阴影相关变量
		public var parallelSplitShadowMaps:Vector.<ParallelSplitShadowMap>;
		
		/**@private */
		public var _key:SubmitKey = new SubmitKey();
		
		private var _time:Number = 0;
		
		/**@private [NATIVE]*/
		private var _glCommandEncoder:CommandEncoder;
		/**@private	[NATIVE]*/
		public var _cullingBufferIndices:Int32Array;
		/**@private	[NATIVE]*/
		public var _cullingBufferResult:Int32Array;
		
		/**@private [Editer]*/
		public var _pickIdToSprite:Object = new Object();
		
		/**
		 * @private
		 * [Editer]
		 */
		public function _allotPickColorByID(id:int, pickColor:Vector4):void {
			
			var pickColorR:int = Math.floor(id / (255 * 255));
			id -= pickColorR * 255 * 255;
			var pickColorG:int = Math.floor(id / 255);
			id -= pickColorG * 255;
			var pickColorB:int = id;
			
			var pickColore:Float32Array = pickColor.elements;
			pickColore[0] = pickColorR / 255;
			pickColore[1] = pickColorG / 255;
			pickColore[2] = pickColorB / 255;
			pickColore[3] = 1.0;
		}
		
		/**
		 * @private
		 * [Editer]
		 */
		public function _searchIDByPickColor(pickColor:Vector4):int {
			var pickColore:Float32Array = pickColor.elements;
			var id:int = pickColore[0] * 255 * 255 + pickColore[1] * 255 + pickColore[2];
			return id;
		}
		
		/**
		 * 获取资源的URL地址。
		 * @return URL地址。
		 */
		public function get url():String {
			return _url;
		}
		
		/**
		 * 获取是否允许雾化。
		 * @return 是否允许雾化。
		 */
		public function get enableFog():Boolean {
			return _enableFog;
		}
		
		/**
		 * 设置是否允许雾化。
		 * @param value 是否允许雾化。
		 */
		public function set enableFog(value:Boolean):void {
			if (_enableFog !== value) {
				_enableFog = value;
				if (value) {
					_defineDatas.add(Scene3D.SHADERDEFINE_FOG);
				} else
					_defineDatas.remove(Scene3D.SHADERDEFINE_FOG);
			}
		}
		
		/**
		 * 获取雾化颜色。
		 * @return 雾化颜色。
		 */
		public function get fogColor():Vector3 {
			return _shaderValues.getVector(Scene3D.FOGCOLOR) as Vector3;
		}
		
		/**
		 * 设置雾化颜色。
		 * @param value 雾化颜色。
		 */
		public function set fogColor(value:Vector3):void {
			_shaderValues.setVector(Scene3D.FOGCOLOR, value);
		}
		
		/**
		 * 获取雾化起始位置。
		 * @return 雾化起始位置。
		 */
		public function get fogStart():Number {
			return _shaderValues.getNumber(Scene3D.FOGSTART);
		}
		
		/**
		 * 设置雾化起始位置。
		 * @param value 雾化起始位置。
		 */
		public function set fogStart(value:Number):void {
			_shaderValues.setNumber(Scene3D.FOGSTART, value);
		}
		
		/**
		 * 获取雾化范围。
		 * @return 雾化范围。
		 */
		public function get fogRange():Number {
			return _shaderValues.getNumber(Scene3D.FOGRANGE);
		}
		
		/**
		 * 设置雾化范围。
		 * @param value 雾化范围。
		 */
		public function set fogRange(value:Number):void {
			_shaderValues.setNumber(Scene3D.FOGRANGE, value);
		}
		
		/**
		 * 获取环境光颜色。
		 * @return 环境光颜色。
		 */
		public function get ambientColor():Vector3 {
			return _shaderValues.getVector(Scene3D.AMBIENTCOLOR) as Vector3;
		}
		
		/**
		 * 设置环境光颜色。
		 * @param value 环境光颜色。
		 */
		public function set ambientColor(value:Vector3):void {
			_shaderValues.setVector(Scene3D.AMBIENTCOLOR, value);
		}
		
		/**
		 * 获取天空渲染器。
		 * @return 天空渲染器。
		 */
		public function get skyRenderer():SkyRenderer {
			return _skyRenderer;
		}
		
		/**
		 * 获取反射贴图。
		 * @return 反射贴图。
		 */
		public function get customReflection():TextureCube {
			return _shaderValues.getTexture(Scene3D.REFLECTIONTEXTURE) as TextureCube;
		}
		
		/**
		 * 设置反射贴图。
		 * @param 反射贴图。
		 */
		public function set customReflection(value:TextureCube):void {
			_shaderValues.setTexture(Scene3D.REFLECTIONTEXTURE, value);
			if (value)
				_defineDatas.add(Scene3D.SHADERDEFINE_REFLECTMAP);
			else
				_defineDatas.remove(Scene3D.SHADERDEFINE_REFLECTMAP);
		}
		
		/**
		 * 获取反射强度。
		 * @return 反射强度。
		 */
		public function get reflectionIntensity():Number {
			return _shaderValues.getNumber(Scene3D.REFLETIONINTENSITY);
		}
		
		/**
		 * 设置反射强度。
		 * @param 反射强度。
		 */
		public function set reflectionIntensity(value:Number):void {
			value = Math.max(Math.min(value, 1.0), 0.0);
			_shaderValues.setNumber(Scene3D.REFLETIONINTENSITY, value);
		}
		
		/**
		 * 获取物理模拟器。
		 * @return 物理模拟器。
		 */
		public function get physicsSimulation():PhysicsSimulation {
			return _physicsSimulation;
		}
		
		/**
		 * 获取反射模式。
		 * @return 反射模式。
		 */
		public function get reflectionMode():int {
			return _reflectionMode;
		}
		
		/**
		 * 设置反射模式。
		 * @param value 反射模式。
		 */
		public function set reflectionMode(value:int):void {
			_reflectionMode = value;
		}
		
		/**
		 * 获取场景时钟。
		 */
		override public function get timer():Timer {
			return _timer;
		}
		
		/**
		 * 设置场景时钟。
		 */
		public function set timer(value:Timer):void {
			_timer = value;
		}
		
		/**
		 *	获取输入。
		 * 	@return  输入。
		 */
		public function get input():Input3D {
			return _input;
		}
		
		/**
		 * 创建一个 <code>Scene3D</code> 实例。
		 */
		public function Scene3D() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			if (Render.isConchApp) {//[NATIVE]
				_glCommandEncoder = LayaGL.instance.createCommandEncoder(102400, 2560, false);
				_conchData._int32Data[SpriteConst.POSLAYAGL3D] = _glCommandEncoder.getPtrID();
				_renderType |= SpriteConst.LAYAGL3D;
				_setRenderType(_renderType);
				var callback:* = __JS__("this._callbackFuncObj");
				if (!callback) {
					callback = __JS__("this._callbackFuncObj = new CallbackFuncObj()");
				}
				_conchData._int32Data[SpriteConst.POSCALLBACK_OBJ_ID] = callback.id;
				callback.addCallbackFunc(3, (renderCallbackFromNative as Object).bind(this));
				_conchData._int32Data[SpriteConst.POSLAYA3D_FUN_ID] = 3;
			}
			if (Laya3D._enbalePhysics)
				_physicsSimulation = new PhysicsSimulation(Laya3D.physicsSettings);
			
			_lightmaps = new Vector.<Texture2D>();
			_defineDatas = new DefineDatas();
			_shaderValues = new ShaderData(null);
			parallelSplitShadowMaps = new Vector.<ParallelSplitShadowMap>();
			
			enableFog = false;
			fogStart = 300;
			fogRange = 1000;
			fogColor = new Vector3(0.7, 0.7, 0.7);
			ambientColor = new Vector3(0.212, 0.227, 0.259);
			reflectionIntensity = 1.0;
			(WebGL.shaderHighPrecision) && (_defineDatas.add(Shader3D.SHADERDEFINE_HIGHPRECISION));
			
			if (Render.isConchApp) {//[NATIVE]
				_cullingBufferIndices = new Int32Array(1024);
				_cullingBufferResult = new Int32Array(1024);
			}
			
			_shaderValues.setTexture(Scene3D.RANGEATTENUATIONTEXTURE, ShaderInit3D._rangeAttenTex);
			
			//var angleAttenTex:Texture2D = Texture2D.buildTexture2D(64, 64, BaseTexture.FORMAT_Alpha8, TextureGenerator.haloTexture);
			//_shaderValues.setTexture(Scene3D.ANGLEATTENUATIONTEXTURE, angleAttenTex);
			_scene = this;
			if (Laya3D._enbalePhysics && !PhysicsSimulation.disableSimulation)//不引物理库初始化Input3D会内存泄漏 
				_input.__init__(Render.canvas, this);
		}
		
		/**
		 * @private
		 */
		private function _setLightmapToChildNode(sprite:Sprite3D):void {
			if (sprite is RenderableSprite3D)
				(sprite as RenderableSprite3D)._render._applyLightMapParams();
			
			var children:Array = sprite._children;
			for (var i:int = 0, n:int = children.length; i < n; i++)
				_setLightmapToChildNode(children[i]);
		}
		
		/**
		 *@private
		 */
		private function _update():void {
			var delta:Number = timer._delta / 1000;
			_time += delta;
			_shaderValues.setNumber(Scene3D.TIME, _time);
			
			var simulation:PhysicsSimulation = _physicsSimulation;
			if (Laya3D._enbalePhysics && !PhysicsSimulation.disableSimulation) {
				simulation._updatePhysicsTransformFromRender();
				PhysicsComponent._addUpdateList = false;//物理模拟器会触发_updateTransformComponent函数,不加入更新队列
				//simulate physics
				simulation._simulate(delta);
				//update character sprite3D transforms from physics engine simulation
				simulation._updateCharacters();
				PhysicsComponent._addUpdateList = true;
				
				//handle frame contacts
				simulation._updateCollisions();
				
				//send contact events
				simulation._eventScripts();
				
				_input._update();//允许物理才更新
			}
			
			_updateScript();
			Animator._update(this);
			_lateUpdateScript();
		}
		
		/**
		 * @private
		 */
		private function _binarySearchIndexInCameraPool(camera:BaseCamera):int {
			var start:int = 0;
			var end:int = _cameraPool.length - 1;
			var mid:int;
			while (start <= end) {
				mid = Math.floor((start + end) / 2);
				var midValue:int = _cameraPool[mid]._renderingOrder;
				if (midValue == camera._renderingOrder)
					return mid;
				else if (midValue > camera._renderingOrder)
					end = mid - 1;
				else
					start = mid + 1;
			}
			return start;
		}
		
		/**
		 * @private
		 */
		public function _setCreateURL(url:String):void {
			_url = url;
		}
		
		/**
		 * @private
		 */
		public function _getGroup():String {
			return _group;
		}
		
		/**
		 * @private
		 */
		public function _setGroup(value:String):void {
			_group = value;
		}
		
		/**
		 * @private
		 */
		private function _updateScript():void {
			var pool:SimpleSingletonList = _scriptPool;
			var elements:Vector.<ISingletonElement> = pool.elements;
			for (var i:int = 0, n:int = pool.length; i < n; i++) {
				var script:Script3D = elements[i] as Script3D;
				(script && script.enabled) && (script.onUpdate());
			}
		}
		
		/**
		 * @private
		 */
		private function _lateUpdateScript():void {
			var pool:SimpleSingletonList = _scriptPool;
			var elements:Vector.<ISingletonElement> = pool.elements;
			for (var i:int = 0, n:int = pool.length; i < n; i++) {
				var script:Script3D = elements[i] as Script3D;
				(script && script.enabled) && (script.onLateUpdate());
			}
		}
		
		/**
		 * @private
		 */
		public function _preRenderScript():void {
			var pool:SimpleSingletonList = _scriptPool;
			var elements:Vector.<ISingletonElement> = pool.elements;
			for (var i:int = 0, n:int = pool.length; i < n; i++) {
				var script:Script3D = elements[i] as Script3D;
				(script && script.enabled) && (script.onPreRender());
			}
		}
		
		/**
		 * @private
		 */
		public function _postRenderScript():void {
			var pool:SimpleSingletonList = _scriptPool;
			var elements:Vector.<ISingletonElement> = pool.elements;
			for (var i:int = 0, n:int = pool.length; i < n; i++) {
				var script:Script3D = elements[i] as Script3D;
				(script && script.enabled) && (script.onPostRender());
			}
		}
		
		/**
		 * 初始化八叉树。
		 * @param	width 八叉树宽度。
		 * @param	height 八叉树高度。
		 * @param	depth 八叉树深度。
		 * @param	center 八叉树中心点
		 * @param	level 八叉树层级。
		 */
		public function initOctree(width:int, height:int, depth:int, center:Vector3, level:int = 6):void {
			treeSize = new Vector3(width, height, depth);
			treeLevel = level;
			treeRoot = new OctreeNode(this, 0);
			treeRoot.initRoot(center, treeSize);
		}
		
		/**
		 * @private
		 */
		protected function _prepareSceneToRender():void {
			var lightCount:int = _lights.length;
			if (lightCount > 0) {
				var renderLightCount:int = 0;
				for (var i:int = 0; i < lightCount; i++) {
					if (!_lights[i]._prepareToScene())//TODO:应该直接移除
						continue;
					renderLightCount++;
					if (renderLightCount >= _enableLightCount)
						break;
				}
			}
		}
		
		/**
		 * @private
		 */
		public function _addCamera(camera:BaseCamera):void {
			var index:int = _binarySearchIndexInCameraPool(camera);
			var order:int = camera._renderingOrder;
			var count:int = _cameraPool.length;
			while (index < count && _cameraPool[index]._renderingOrder <= order)
				index++;
			_cameraPool.splice(index, 0, camera);
		}
		
		/**
		 * @private
		 */
		public function _removeCamera(camera:BaseCamera):void {
			_cameraPool.splice(_cameraPool.indexOf(camera), 1);
		}
		
		/**
		 * @private
		 */
		public function _preCulling(context:RenderContext3D, camera:Camera):void {
			if (camera.useOcclusionCulling) {
				//if (treeRoot)
				//FrustumCulling.renderObjectCullingOctree(camera, this, context);
				//else
				FrustumCulling.renderObjectCulling(camera, this, context, _renders);
			} else {
				FrustumCulling.renderObjectCulling(null, this, context, _renders);
			}
		}
		
		/**
		 * @private
		 */
		public function _clear(gl:WebGLContext, state:RenderContext3D):void {
			var viewport:Viewport = state.viewport;
			var camera:BaseCamera = state.camera;
			var renderTarget:RenderTexture = camera.renderTarget;
			var vpW:Number = viewport.width;
			var vpH:Number = viewport.height;
			var vpX:Number = viewport.x;
			var vpY:Number = camera._canvasHeight - viewport.y - vpH;
			gl.viewport(vpX, vpY, vpW, vpH);
			var flag:int = WebGLContext.DEPTH_BUFFER_BIT;
			
			var clearFlag:int = camera.clearFlag;
			if (clearFlag === BaseCamera.CLEARFLAG_SKY && !(camera.skyRenderer._isAvailable() || _skyRenderer._isAvailable()))
				clearFlag = BaseCamera.CLEARFLAG_SOLIDCOLOR;
			
			switch (clearFlag) {
			case BaseCamera.CLEARFLAG_SOLIDCOLOR: 
				var clearColor:Vector4 = camera.clearColor;
				if (clearColor) {
					gl.enable(WebGLContext.SCISSOR_TEST);
					gl.scissor(vpX, vpY, vpW, vpH);
					var clearColorE:Float32Array = clearColor.elements;
					gl.clearColor(clearColorE[0], clearColorE[1], clearColorE[2], clearColorE[3]);
					flag |= WebGLContext.COLOR_BUFFER_BIT;
				}
				
				if (renderTarget) {
					(clearColor) || (flag = WebGLContext.COLOR_BUFFER_BIT);
					switch (renderTarget.depthStencilFormat) {
					case BaseTexture.FORMAT_DEPTH_16: 
						flag |= WebGLContext.DEPTH_BUFFER_BIT;
						break;
					case BaseTexture.FORMAT_STENCIL_8: 
						flag |= WebGLContext.STENCIL_BUFFER_BIT;
						break;
					case BaseTexture.FORMAT_DEPTHSTENCIL_16_8: 
						flag |= WebGLContext.DEPTH_BUFFER_BIT;
						flag |= WebGLContext.STENCIL_BUFFER_BIT;
						break;
					}
				}
				gl.clear(flag);
				
				if (clearColor)
					gl.disable(WebGLContext.SCISSOR_TEST);
				break;
			case BaseCamera.CLEARFLAG_SKY: 
			case BaseCamera.CLEARFLAG_DEPTHONLY: 
				if (renderTarget) {
					flag = WebGLContext.COLOR_BUFFER_BIT;
					switch (renderTarget.depthStencilFormat) {
					case BaseTexture.FORMAT_DEPTH_16: 
						flag |= WebGLContext.DEPTH_BUFFER_BIT;
						break;
					case BaseTexture.FORMAT_STENCIL_8: 
						flag |= WebGLContext.STENCIL_BUFFER_BIT;
						break;
					case BaseTexture.FORMAT_DEPTHSTENCIL_16_8: 
						flag |= WebGLContext.DEPTH_BUFFER_BIT;
						flag |= WebGLContext.STENCIL_BUFFER_BIT
						break;
					}
				}
				gl.clear(flag);
				break;
			case BaseCamera.CLEARFLAG_NONE: 
				break;
			default: 
				throw new Error("BaseScene:camera clearFlag invalid.");
			}
		}
		
		/**
		 * @private
		 */
		public function _renderScene(gl:WebGLContext, state:RenderContext3D, customShader:Shader3D = null, replacementTag:String = null):void {
			var camera:BaseCamera = state.camera;
			var position:Vector3 = camera.transform.position;
			camera.renderTarget ? _opaqueQueue._render(state, true, customShader, replacementTag) : _opaqueQueue._render(state, false, customShader, replacementTag);//非透明队列
			if (camera.clearFlag === BaseCamera.CLEARFLAG_SKY) {
				if (camera.skyRenderer._isAvailable())
					camera.skyRenderer._render(state);
				else if (_skyRenderer._isAvailable())
					_skyRenderer._render(state);
			}
			camera.renderTarget ? _transparentQueue._render(state, true, customShader, replacementTag) : _transparentQueue._render(state, false, customShader, replacementTag);//透明队列
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _parse(data:Object):void {
			var lightMapsData:Array = data.lightmaps;
			if (lightMapsData) {
				var lightMapCount:int = lightMapsData.length;
				var lightmaps:Vector.<Texture2D> = _lightmaps;
				lightmaps.length = lightMapCount;
				for (var i:int = 0; i < lightMapCount; i++)
					lightmaps[i] = Loader.getRes(lightMapsData[i].path);
				
				setlightmaps(lightmaps);
			}
			
			var ambientColorData:Array = data.ambientColor;
			if (ambientColorData) {
				var ambCol:Vector3 = ambientColor;
				ambCol.fromArray(ambientColorData);
				ambientColor = ambCol;
			}
			
			var skyData:Object = data.sky;
			if (skyData) {
				_skyRenderer.material = Loader.getRes(skyData.material.path);
				switch (skyData.mesh) {
				case "SkyBox": 
					_skyRenderer.mesh = SkyBox.instance;
					break;
				case "SkyDome": 
					_skyRenderer.mesh = SkyDome.instance;
					break;
				default: 
					skyRenderer.mesh = SkyBox.instance;
				}
			}
			var reflectionTextureData:String = data.reflectionTexture;
			reflectionTextureData && (customReflection = Loader.getRes(reflectionTextureData));
			
			enableFog = data.enableFog;
			fogStart = data.fogStart;
			fogRange = data.fogRange;
			var fogColorData:Array = data.fogColor;
			if (fogColorData) {
				var fogCol:Vector3 = fogColor;
				fogCol.fromArray(fogColorData);
				fogColor = fogCol;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onActive():void {
			Laya.stage._scene3Ds.push(this);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onInActive():void {
			var scenes:Array = Laya.stage._scene3Ds;
			scenes.splice(scenes.indexOf(this), 1);
		}
		
		/**
		 * @private
		 */
		public function _addLight(light:LightSprite):void {
			if (_lights.indexOf(light) < 0) _lights.push(light);
		}
		
		/**
		 * @private
		 */
		public function _removeLight(light:LightSprite):void {
			var index:int = _lights.indexOf(light);
			index >= 0 && (_lights.splice(index, 1));
		}
		
		/**
		 *通过蒙版值获取蒙版是否显示。
		 * @param mask 蒙版值。
		 * @return 是否显示。
		 */
		public function isLayerVisible(layer:int, camera:Camera):Boolean {
			return (Math.pow(2,layer) & camera.cullingMask) != 0;
		}
		
		/**
		 * @private
		 */
		public function addTreeNode(renderObj:BaseRender):void {
			treeRoot.addTreeNode(renderObj);
		}
		
		/**
		 * @private
		 */
		public function removeTreeNode(renderObj:BaseRender):void {
			if (!treeSize) return;
			if (renderObj._treeNode) {
				renderObj._treeNode.removeObject(renderObj);
			}
		}
		
		/**
		 * @private
		 */
		public function _addRenderObject(render:BaseRender):void {
			if (treeRoot) {
				addTreeNode(render);
			} else {
				_renders.add(render);
				if (Render.isConchApp) {//[NATIVE]
					var indexInList:int = render._getIndexInList();
					var length:int = _cullingBufferIndices.length;
					if (indexInList >= length) {
						var tempIndices:Int32Array = _cullingBufferIndices;
						var tempResult:Int32Array = _cullingBufferResult;
						_cullingBufferIndices = new Int32Array(length + 1024);
						_cullingBufferResult = new Int32Array(length + 1024);
						_cullingBufferIndices.set(tempIndices, 0);
						_cullingBufferResult.set(tempResult, 0);
					}
					_cullingBufferIndices[indexInList] = render._cullingBufferIndex;
				}
			}
		}
		
		/**
		 * @private
		 */
		public function _removeRenderObject(render:BaseRender):void {
			if (treeRoot) {
				removeTreeNode(render);
			} else {
				var endRender:BaseRender;
				if (Render.isConchApp) {//[NATIVE]
					endRender = _renders.elements[_renders.length - 1] as BaseRender;
				}
				_renders.remove(render);
				if (Render.isConchApp) {//[NATIVE]
					_cullingBufferIndices[endRender._getIndexInList()] = endRender._cullingBufferIndex;
				}
			}
		}
		
		/**
		 * @private
		 */
		public function _addShadowCastRenderObject(render:BaseRender):void {
			if (treeRoot) {
				addTreeNode(render);
			} else {
				_castShadowRenders.add(render);
			}
		}
		
		/**
		 * @private
		 */
		public function _removeShadowCastRenderObject(render:BaseRender):void {
			if (treeRoot) {
				removeTreeNode(render);
			} else {
				_castShadowRenders.remove(render);
			}
		}
		
		/**
		 * @private
		 */
		public function _getRenderQueue(index:int):RenderQueue {
			if (index < BaseMaterial.RENDERQUEUE_TRANSPARENT)
				return _opaqueQueue;
			else
				return _transparentQueue;
		}
		
		/**
		 * 设置光照贴图。
		 * @param value 光照贴图。
		 */
		public function setlightmaps(value:Vector.<Texture2D>):void {
			_lightmaps = value;
			for (var i:int = 0, n:int = _children.length; i < n; i++)
				_setLightmapToChildNode(_children[i]);
		}
		
		/**
		 * 获取光照贴图。
		 * @return 获取光照贴图。
		 */
		public function getlightmaps():Vector.<Texture2D> {
			return _lightmaps;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy(destroyChild:Boolean = true):void {
			if (destroyed)
				return;
			super.destroy(destroyChild);
			_skyRenderer.destroy();
			_skyRenderer = null;
			_lights = null;
			_lightmaps = null;
			_renderTargetTexture = null;
			_shaderValues = null;
			_renders = null;
			_castShadowRenders = null;
			_cameraPool = null;
			treeRoot = null;
			treeSize = null;
			parallelSplitShadowMaps = null;
			_physicsSimulation && _physicsSimulation._destroy();
			Loader.clearRes(url);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function render(ctx:Context, x:Number, y:Number):void {
			//TODO:外层应该设计为接口调用
			(ctx as WebGLContext2D)._curSubmit = Submit.RENDERBASE;//打断2D合并的renderKey
			_children.length > 0 && ctx.addRenderObject(this);
		}
		
		/**
		 * @private
		 */
		public function renderSubmit():int {
			var gl:* = LayaGL.instance;
			if (Render.isConchApp) {//[NATIVE]
				if (_glCommandEncoder)
					_glCommandEncoder.clearEncoding();
				gl.beginCommandEncoding(_glCommandEncoder);
			}
			
			_prepareSceneToRender();
			
			var i:int, n:int, n1:int;
			for (i = 0, n = _cameraPool.length, n1 = n - 1; i < n; i++) {
				if (Render.isConchApp)
					ShaderData.setRuntimeValueMode((i == n1) ? true : false);
				var camera:Camera = _cameraPool[i] as Camera;
				camera.enableRender && camera.render();
			}
			if (Render.isConchApp) {//[NATIVE]
				gl.endCommandEncoding();
				
				Buffer._bindedVertexBuffer = null;
				Buffer._bindedIndexBuffer = null;
			}
			WebGLContext2D.set2DRenderConfig();//还原2D配置
			return 1;
		}
		
		/**
		 * @private
		 */
		public function getRenderType():int {
			return 0;
		}
		
		/**
		 * @private
		 */
		public function releaseRender():void {
		}
		
		/**
		 * @private
		 */
		public function reUse(context:WebGLContext2D, pos:int):int {
			return 0;
		}
		
		public function renderCallbackFromNative():void {
			//执行逻辑
			_update();
			//正常渲染
			renderSubmit();
		}
		
		/**
		 * @inheritDoc
		 */
		public function renderToNative(context:*, x:Number, y:Number):void {
			/*
			   if (!LayaGLTemplate.GLS[_renderType]) {
			   LayaGLTemplate.createByRenderType(_renderType);
			   }
			 */
			context.gl.block(_conchData);
		}
	}
}