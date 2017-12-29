package laya.d3.core.light {
	import laya.d3.core.ComponentNode;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Vector3;
	import laya.d3.shadowMap.ParallelSplitShadowMap;
	
	/**
	 * <code>LightSprite</code> 类用于创建灯光的父类。
	 */
	public class LightSprite extends Sprite3D {
		/** 灯光烘培类型-实时。*/
		public static var LIGHTMAPBAKEDTYPE_REALTIME:int = 0;
		/** 灯光烘培类型-混合。*/
		public static var LIGHTMAPBAKEDTYPE_MIXED:int = 1;
		/** 灯光烘培类型-烘焙。*/
		public static var LIGHTMAPBAKEDTYPE_BAKED:int = 2;
		
		/** @private */
		protected var _intensityColor:Vector3;
		
		/** @private */
		protected var _intensity:Number;
		/** @private */
		protected var _shadow:Boolean;
		/** @private */
		protected var _shadowFarPlane:int;
		/** @private */
		protected var _shadowMapSize:int;
		/** @private */
		protected var _shadowMapCount:int;
		/** @private */
		protected var _shadowMapPCFType:int;
		/** @private */
		protected var _parallelSplitShadowMap:ParallelSplitShadowMap;
		/** @private */
		public var _lightmapBakedType:int;
		
		/** 灯光颜色。 */
		public var color:Vector3;
		
		/**
		 * 获取灯光强度。
		 * @return 灯光强度
		 */
		public function get intensity():Number {
			return _intensity;
		}
		
		/**
		 * 设置灯光强度。
		 * @param value 灯光强度
		 */
		public function set intensity(value:Number):void {
			_intensity = value;
		}
		
		/**
		 * 获取是否产生阴影。
		 * @return 是否产生阴影。
		 */
		public function get shadow():Boolean {
			return _shadow;
		}
		
		/**
		 * 设置是否产生阴影。
		 * @param value 是否产生阴影。
		 */
		public function set shadow(value:Boolean):void {
			throw new Error("LightSprite: must override it.");
		
		}
		
		/**
		 * 获取阴影最远范围。
		 * @return 阴影最远范围。
		 */
		public function get shadowDistance():Number {
			return _shadowFarPlane;
		}
		
		/**
		 * 设置阴影最远范围。
		 * @param value 阴影最远范围。
		 */
		public function set shadowDistance(value:Number):void {
			_shadowFarPlane = value;
			(_parallelSplitShadowMap) && (_parallelSplitShadowMap.setFarDistance(value));
		}
		
		/**
		 * 获取阴影贴图尺寸。
		 * @return 阴影贴图尺寸。
		 */
		public function get shadowResolution():Number {
			return _shadowMapSize;
		}
		
		/**
		 * 设置阴影贴图尺寸。
		 * @param value 阴影贴图尺寸。
		 */
		public function set shadowResolution(value:Number):void {
			_shadowMapSize = value;
			(_parallelSplitShadowMap) && (_parallelSplitShadowMap.setShadowMapTextureSize(value));
		}
		
		/**
		 * 获取阴影分段数。
		 * @return 阴影分段数。
		 */
		public function get shadowPSSMCount():int {
			return _shadowMapCount;
		}
		
		/**
		 * 设置阴影分段数。
		 * @param value 阴影分段数。
		 */
		public function set shadowPSSMCount(value:int):void {
			_shadowMapCount = value;
			(_parallelSplitShadowMap) && (_parallelSplitShadowMap.PSSMNum = value);
		}
		
		/**
		 * 获取阴影PCF类型。
		 * @return PCF类型。
		 */
		public function get shadowPCFType():int {
			return _shadowMapPCFType;
		}
		
		/**
		 * 设置阴影PCF类型。
		 * @param value PCF类型。
		 */
		public function set shadowPCFType(value:int):void {
			_shadowMapPCFType = value;
			(_parallelSplitShadowMap) && (_parallelSplitShadowMap.setPCFType(value));
		}
		
		/**
		 * 获取灯光烘培类型。
		 */
		public function get lightmapBakedType():int {
			return _lightmapBakedType;
		}
		
		/**
		 * 设置灯光烘培类型。
		 */
		public function set lightmapBakedType(value:int):void {
			if (_lightmapBakedType !== value) {
				_lightmapBakedType = value;
				if (_activeInHierarchy) {
					if (value !== LIGHTMAPBAKEDTYPE_BAKED)
						_scene._addLight(this);
					else
						_scene._removeLight(this);
				}
			}
		}
		
		/**
		 * 创建一个 <code>LightSprite</code> 实例。
		 */
		public function LightSprite() {
			super();
			_intensity = 1.0;
			_intensityColor = new Vector3();
			color = new Vector3(1.0, 1.0, 1.0);
			_shadow = false;
			_shadowFarPlane = 8;
			_shadowMapSize = 512;
			_shadowMapCount = 1;
			_shadowMapPCFType = 0;
			_lightmapBakedType = LIGHTMAPBAKEDTYPE_REALTIME;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _parseCustomProps(rootNode:ComponentNode, innerResouMap:Object, customProps:Object, nodeData:Object):void {
			var colorData:Array = customProps.color;
			var colorE:Float32Array = color.elements;
			colorE[0] = colorData[0];
			colorE[1] = colorData[1];
			colorE[2] = colorData[2];
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _addSelfRenderObjects():void {
			(lightmapBakedType !== LIGHTMAPBAKEDTYPE_BAKED) && (_scene._addLight(this));
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _clearSelfRenderObjects():void {
			(lightmapBakedType !== LIGHTMAPBAKEDTYPE_BAKED) && (_scene._removeLight(this));
		}
		
		/**
		 * 更新灯光相关渲染状态参数。
		 * @param state 渲染状态参数。
		 */
		public function _prepareToScene(state:RenderState):Boolean {
			return false;
		}
		
		/**
		 * 获取灯光的漫反射颜色。
		 * @return 灯光的漫反射颜色。
		 */
		public function get diffuseColor():Vector3 {
			trace("LightSprite: discard property,please use color property instead.");
			return color;
		}
		
		/**
		 * 设置灯光的漫反射颜色。
		 * @param value 灯光的漫反射颜色。
		 */
		public function set diffuseColor(value:Vector3):void {
			trace("LightSprite: discard property,please use color property instead.");
			color = value;
		}
	}
}