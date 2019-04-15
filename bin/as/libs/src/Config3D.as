package {
	import laya.d3.core.IClone;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>Config3D</code> 类用于创建3D初始化配置。
	 */
	public class Config3D implements IClone {
		/**@private	*/
		public static var _default:Config3D = new Config3D();
		
		/**@private	*/
		private var _defaultPhysicsMemory:int = 16;
		/**@private	*/
		public var _editerEnvironment:Boolean = false;
		
		/** 是否开启抗锯齿。*/
		public var isAntialias:Boolean = true;
		/** 设置画布是否透明。*/
		public var isAlpha:Boolean = false;
		/** 设置画布是否预乘。*/
		public var premultipliedAlpha:Boolean = true;
		/** 设置画布的是否开启模板缓冲。*/
		public var isStencil:Boolean = true;
		/** 是否开启八叉树裁剪。*/
		public var octreeCulling:Boolean = false;
		/** 八叉树初始化尺寸。*/
		public var octreeInitialSize:Number = 64.0;
		/** 八叉树初始化中心。*/
		public var octreeInitialCenter:Vector3 = new Vector3(0, 0, 0);
		/** 八叉树最小尺寸。*/
		public var octreeMinNodeSize:Number = 2.0;
		/** 八叉树松散值。*/
		public var octreeLooseness:Number = 1.25;
		/** 
		 * 是否开启视锥裁剪调试。
		 * 如果开启八叉树裁剪,使用红色绘制高层次八叉树节点包围盒,使用蓝色绘制低层次八叉节点包围盒,精灵包围盒和八叉树节点包围盒颜色一致,但Alpha为半透明。如果视锥完全包含八叉树节点,八叉树节点包围盒和精灵包围盒变为蓝色,同样精灵包围盒的Alpha为半透明。
		 * 如果不开启八叉树裁剪,使用绿色像素线绘制精灵包围盒。
		 */
		public var debugFrustumCulling:Boolean = false;
		
		/**
		 * 获取默认物理功能初始化内存，单位为M。
		 * @return 默认物理功能初始化内存。
		 */
		public function get defaultPhysicsMemory():int {
			return _defaultPhysicsMemory;
		}
		
		/**
		 * 设置默认物理功能初始化内存，单位为M。
		 * @param value 默认物理功能初始化内存。
		 */
		public function set defaultPhysicsMemory(value:int):void {
			if (value < 16)//必须大于16M
				throw "defaultPhysicsMemory must large than 16M";
			_defaultPhysicsMemory = value;
		}
		
		/**
		 * 创建一个 <code>Config3D</code> 实例。
		 */
		public function Config3D() {
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(dest:*):void {//[实现IClone接口]
			var destConfig3D:Config3D = dest as Config3D;
			destConfig3D._defaultPhysicsMemory = _defaultPhysicsMemory;
			destConfig3D._editerEnvironment = _editerEnvironment;
			destConfig3D.isAntialias = isAntialias;
			destConfig3D.isAlpha = isAlpha;
			destConfig3D.premultipliedAlpha = premultipliedAlpha;
			destConfig3D.isStencil = isStencil;
			destConfig3D.octreeCulling = octreeCulling;
			octreeInitialCenter.cloneTo(destConfig3D.octreeInitialCenter);
			destConfig3D.octreeMinNodeSize = octreeMinNodeSize;
			destConfig3D.octreeLooseness = octreeLooseness;
			destConfig3D.debugFrustumCulling = debugFrustumCulling;
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {//[实现IClone接口]
			var dest:Config3D = new Config3D();
			cloneTo(dest);
			return dest;
		}
	
	}

}