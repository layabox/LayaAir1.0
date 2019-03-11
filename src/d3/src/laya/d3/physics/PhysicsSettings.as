package laya.d3.physics {
	
	/**
	 * <code>PhysicsSettings</code> 类用于创建物理配置信息。
	 */
	public class PhysicsSettings {
		/**标志集合。*/
		public var flags:int = 0;
		
		/**物理引擎在一帧中用于补偿减速的最大次数。*/
		public var maxSubSteps:int = 1;
		
		/**物理模拟器帧的间隔时间。*/
		public var fixedTimeStep:Number = 1.0 / 60.0;
		
		/**
		 * 创建一个 <code>PhysicsSettings</code> 实例。
		 */
		public function PhysicsSettings() {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		}
	
	}

}