package {
	
	/**
	 * <code>Config3D</code> 类用于创建3D初始化配置。
	 */
	public class Config3D {
		/**@private	*/
		public static var _defaultConfig:Config3D = new Config3D();
		
		/**@private	*/
		private var _defaultPhysicsMemory:int = 16;
		
		/**@private	*/
		public var _editerEnvironment:Boolean = false;
		
		/**
		 * 是否开启抗锯齿。
		 */
		public var isAntialias:Boolean = true;
		/**
		 * 设置画布是否透明。
		 */
		public var isAlpha:Boolean = false;
		/**
		 * 设置画布是否预乘。
		 */
		public var premultipliedAlpha:Boolean = true;
		/**
		 * 设置画布的是否开启模板缓冲。
		 */
		public var isStencil:Boolean = true;
		
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
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		}
	
	}

}