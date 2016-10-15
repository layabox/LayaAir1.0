package laya.d3.resource {
	import laya.d3.utils.Size;
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
		/**@private */
		protected var _loaded:Boolean;
		
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
		
		/**\
		 * 缩小过滤器
		 */
		public function get minFifter():int {
			return _minFifter;
		}
		
		/**
		 * 放大过滤器
		 */
		public function get magFifter():int {
			return _magFifter;
		}
		
		/**
		 * 获取纹理资源。
		 */
		public function get source():* {
			activeResource();
			return _source;
		}
		
		/**
		 * 表示是否加载成功，只能表示初次载入成功（通常包含下载和载入）,并不能完全表示资源是否可立即使用（资源管理机制释放影响等）。
		 */
		public function get loaded():Boolean {
			return _loaded;
		}
		
		/**
		 * 创建一个 <code>BaseTexture</code> 实例。
		 */
		public function BaseTexture() {
			_repeat = true;
			_mipmap = true;
			_minFifter = -1;
			_magFifter = -1;
		}
	
	}

}