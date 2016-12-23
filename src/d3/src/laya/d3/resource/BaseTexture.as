package laya.d3.resource {
	import laya.d3.utils.Size;
	import laya.renders.Render;
	import laya.resource.Resource;
	
	/**
	 * <code>BaseTexture</code> 纹理的父类，抽象类，不允许实例。
	 */
	public class BaseTexture extends Resource {
		/** @private */
		protected var _width:int;
		/** @private */
		protected var _height:int;
		/** @private */
		protected var _size:Size;
		/** @private */
		protected var _repeat:Boolean;
		/** @private */
		protected var _mipmap:Boolean;
		/** @private */
		protected var _minFifter:int;
		/** @private */
		protected var _magFifter:int;
		/** @private */
		protected var _source:*;
		public var _conchTexture:*//NATIVE
		
		/**
		 * 获取宽度。
		 */
		public function get width():int {
			return _width;
		}
		
		/**
		 * 获取高度。
		 */
		public function get height():int {
			return _height;
		}
		
		/**
		 * 获取尺寸。
		 */
		public function get size():Size {
			return _size;
		}
		
		/**
		 * 是否使用重复模式纹理寻址
		 */
		public function get repeat():Boolean {
			return _repeat;
		}
		
		/**
		 * 是否使用mipLevel
		 */
		public function get mipmap():Boolean {
			return _mipmap;
		}
		
		/**
		 * 是否使用mipLevel
		 */
		public function set mipmap(value:Boolean):void {
			_mipmap = value;
			if (_mipmap != value) {
				_conchTexture && _conchTexture.setMipMap(value);
			}
		}
		
		/**
		 * 缩小过滤器
		 */
		public function get minFifter():int {
			return _minFifter;
		}
		
		/**
		 * 缩小过滤器
		 */
		public function set minFifter(value:int):void {
			_minFifter = value;
			if (_minFifter != value) {
				_conchTexture && _conchTexture.setMinFifter(value);
			}
		}
		
		/**
		 * 放大过滤器
		 */
		public function get magFifter():int {
			return _magFifter;
		}
		
		/**
		 * 放大过滤器
		 */
		public function set magFifter(value:int):void {
			_magFifter = value;
			if (value != _magFifter) {
				_conchTexture && _conchTexture.setMaxFifter(value);
			}
		}
		
		/**
		 * 获取纹理资源。
		 */
		public function get source():* {
			activeResource();
			return _source;
		}
		
		/**
		 * 创建一个 <code>BaseTexture</code> 实例。
		 */
		public function BaseTexture() {
			if (Render.isConchNode) {//NATIVE
				_conchTexture = __JS__("new ConchTexture()");
			}
			_repeat = true;
			mipmap = true;
			minFifter = -1;
			magFifter = -1;
		
		}
		
		override public function dispose():void {
			resourceManager.removeResource(this);
			super.dispose();
		}
	
	}

}