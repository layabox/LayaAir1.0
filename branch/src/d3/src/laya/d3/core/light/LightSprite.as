package laya.d3.core.light {
	import laya.d3.core.Sprite3D;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Vector3;
	import laya.events.Event;
	
	/**
	 * <code>LightSprite</code> 类用于创建灯光的父类。
	 */
	public class LightSprite extends Sprite3D {
		/** 定义平行光类型的标记。*/
		public static const TYPE_DIRECTIONLIGHT:int = 1;
		/** 定义点光类型的标记。*/
		public static const TYPE_POINTLIGHT:int = 2;
		/** 定义聚光类型的标记。*/
		public static const TYPE_SPOTLIGHT:int = 3;
		
		/** @private */
		protected var _diffuseColor:Vector3;
		/** @private */
		protected var _ambientColor:Vector3;
		/** @private */
		protected var _specularColor:Vector3;
		/** @private */
		protected var _reflectColor:Vector3;
		
		/**
		 * 创建一个 <code>LightSprite</code> 实例。
		 */
		public function LightSprite() {
			super();
			
			on(Event.ADDED, this, _onAdded);
			on(Event.REMOVED, this, _onRemoved);
			
			_diffuseColor = new Vector3(0.8, 0.8, 0.8);
			_ambientColor = new Vector3(0.6, 0.6, 0.6);
			_specularColor = new Vector3(1.0, 1.0, 1.0);
			_reflectColor = new Vector3(1.0, 1.0, 1.0);
		}
		
		/**
		 * @private
		 * 灯光节点移除事件处理函数。
		 */
		private function _onRemoved():void {
			scene._removeLight(this);
		}
		
		/**
		 * @private
		 * 灯光节点添加事件处理函数。
		 */
		private function _onAdded():void {
			scene._addLight(this);
		}
		
		/**
		 * 获取灯光的漫反射颜色。
		 * @return 灯光的漫反射颜色。
		 */
		public function get diffuseColor():Vector3 {
			return _diffuseColor;
		}
		
		/**
		 * 设置灯光的漫反射颜色。
		 * @param value 灯光的漫反射颜色。
		 */
		public function set diffuseColor(value:Vector3):void {
			_diffuseColor = value;
		}
		
		/**
		 * 获取灯光的环境光颜色。
		 * @return 灯光的环境光颜色。
		 */
		public function get ambientColor():Vector3 {
			return _ambientColor;
		}
		
		/**
		 * 设置灯光的环境光颜色。
		 * @param value 灯光的环境光颜色。
		 */
		public function set ambientColor(value:Vector3):void {
			_ambientColor = value;
		}
		
		/**
		 * 获取灯光的高光颜色。
		 * @return 灯光的高光颜色。
		 */
		public function get specularColor():Vector3 {
			return _specularColor;
		}
		
		/**
		 * 设置灯光的高光颜色。
		 * @param value 灯光的高光颜色。
		 */
		public function set specularColor(value:Vector3):void {
			_specularColor = value;
		}
		
		/**
		 * 获取灯光的反射颜色。
		 * @return 灯光的反射颜色。
		 */
		public function get reflectColor():Vector3 {
			return _reflectColor;
		}
		
		/**
		 * 设置灯光的反射颜色。
		 * @param value 灯光的反射颜色。
		 */
		public function set reflectColor(value:Vector3):void {
			_reflectColor = value;
		}
		
		/**
		 * 获取灯光的类型。
		 * @return 灯光的类型。
		 */
		public function get lightType():int {
			return -1;
		}
		
		/**
		 * 更新灯光相关渲染状态参数。
		 * @param state 渲染状态参数。
		 */
		public function updateToWorldState(state:RenderState):void {
		}
	}
}