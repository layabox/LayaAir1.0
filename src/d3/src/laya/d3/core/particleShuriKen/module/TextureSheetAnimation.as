package laya.d3.core.particleShuriKen.module {
	import laya.d3.core.IClone;
	import laya.d3.math.Vector2;
	
	/**
	 * <code>TextureSheetAnimation</code> 类用于创建粒子帧动画。
	 */
	public class TextureSheetAnimation implements IClone {
		/**@private */
		private var _frame:FrameOverTime;
		/**@private */
		private var _startFrame:StartFrame;
		
		/**纹理平铺。*/
		public var tiles:Vector2;
		/**类型,0为whole sheet、1为singal row。*/
		public var type:int;
		/**是否随机行，type为1时有效。*/
		public var randomRow:Boolean;
		/**行索引,type为1时有效。*/
		public var rowIndex:int;
		/**循环次数。*/
		public var cycles:int;
		/**UV通道类型,0为Noting,1为Everything,待补充,暂不支持。*/
		public var enableUVChannels:int;
		/**是否启用*/
		public var enable:Boolean;
		
		/**获取时间帧率。*/
		public function get frame():FrameOverTime {
			return _frame;
		}
		
		/**获取开始帧率。*/
		public function get startFrame():StartFrame {
			return _startFrame;
		}
		
		/**
		 * 创建一个 <code>TextureSheetAnimation</code> 实例。
		 * @param frame 动画帧。
		 * @param  startFrame 开始帧。
		 */
		public function TextureSheetAnimation(frame:FrameOverTime, startFrame:StartFrame) {
			tiles = new Vector2(1, 1);
			type = 0;
			randomRow = true;
			rowIndex = 0;
			cycles = 1;
			enableUVChannels = 1;//TODO:待补充
			_frame = frame;
			_startFrame = startFrame;
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destTextureSheetAnimation:TextureSheetAnimation = destObject as TextureSheetAnimation;
			tiles.cloneTo(destTextureSheetAnimation.tiles);
			destTextureSheetAnimation.type = type;
			destTextureSheetAnimation.randomRow = randomRow;
			_frame.cloneTo(destTextureSheetAnimation._frame);
			_startFrame.cloneTo(destTextureSheetAnimation._startFrame);
			destTextureSheetAnimation.cycles = cycles;
			destTextureSheetAnimation.enableUVChannels = enableUVChannels;
			destTextureSheetAnimation.enable = enable;
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var destFrame:FrameOverTime;
			switch (_frame.type) {
			case 0: 
				destFrame = FrameOverTime.createByConstant(_frame.constant);
				break;
			case 1: 
				destFrame = FrameOverTime.createByOverTime(_frame.frameOverTimeData.clone());
				break;
			case 2: 
				destFrame = FrameOverTime.createByRandomTwoConstant(_frame.constantMin, _frame.constantMax);
				break;
			case 3: 
				destFrame = FrameOverTime.createByRandomTwoOverTime(_frame.frameOverTimeDataMin.clone(), _frame.frameOverTimeDataMax.clone());
				break;
			}
			
			var destStartFrame:StartFrame;
			switch (_startFrame.type) {
			case 0: 
				destStartFrame = StartFrame.createByConstant(_startFrame.constant);
				break;
			case 1: 
				destStartFrame = StartFrame.createByRandomTwoConstant(_startFrame.constantMin, _startFrame.constantMax);
				break;
			}
			
			var destTextureSheetAnimation:TextureSheetAnimation = __JS__("new this.constructor(destFrame,destStartFrame)");
			tiles.cloneTo(destTextureSheetAnimation.tiles);
			destTextureSheetAnimation.type = type;
			destTextureSheetAnimation.randomRow = randomRow;
			destTextureSheetAnimation.cycles = cycles;
			destTextureSheetAnimation.enableUVChannels = enableUVChannels;
			destTextureSheetAnimation.enable = enable;
			return destTextureSheetAnimation;
		}
	
	}

}