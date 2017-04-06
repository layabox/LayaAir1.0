package laya.particle.particleUtils
{
	
	/**
	 * 
	 *  @private
	 * 
	 * @created  2015-8-25 下午3:41:07
	 */
	public class CMDParticle
	{
		public function CMDParticle()
		{
		}
		/**
		 * 最大帧
		 */
		public var maxIndex:int;
		/**
		 * 帧命令数组
		 */
		public var cmds:Array;
		/**
		 * 粒子id 
		 */
		public var id:int;
		public function setCmds(cmds:Array):void
		{
			this.cmds=cmds;
			maxIndex=cmds.length-1;
		}
	}
}