package laya.d3.core.particleShuriKen.module {
	import laya.d3.math.Vector2;
	
	/**
	 * <code>TextureSheetAnimation</code> 类用于创建粒子帧动画。
	 */
	public class TextureSheetAnimation {
		/**纹理平铺。*/
		public var title:Vector2;
		/**类型,0为whole sheet、1为singal row。*/
		public var type:int;
		/**是否随机行，type为1时有效。*/
		public var randomRow:Boolean;
		/**时间帧率。*/
		public var frame:FrameOverTime;
		/**开始帧率。*/
		public var startFrame:StartFrame;
		/**循环次数。*/
		public var cycles:int;
		/**UV通道类型,0为Noting,1为Everything,待补充,暂不支持。*/
		public var enableUVChannels:int;
		/**是否启用*/
		public var enbale:Boolean;
		
		/**
		 * 创建一个 <code>TextureSheetAnimation</code> 实例。
		 * @param frame 动画帧。
		 * @param  startFrame 开始帧。
		 */
		public function TextureSheetAnimation(frame:FrameOverTime, startFrame:StartFrame) {
			title = new Vector2(1, 1);
			type = 0;
			randomRow = true;
			cycles = 1;
			enableUVChannels = 1;//TODO:待补充
			this.frame = frame;
			this.startFrame = startFrame;
		}
	
	}

}