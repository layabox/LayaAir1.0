package laya.ui {
	import laya.ui.Box;
	
	/**
	 * 自适应缩放容器，容器设置大小后，容器大小始终保持stage大小，子内容按照原始最小宽高比缩放
	 */
	public class ScaleBox extends Box {
		private var _oldW:Number = 0;
		private var _oldH:Number = 0;
		
		override public function onEnable():void {
			Laya.stage.on("resize", this, onResize);
			onResize();
		}
		
		override public function onDisable():void {
			Laya.stage.off("resize", this, onResize);
		}
		
		private function onResize():void {
			if (this.width > 0 && this.height > 0) {
				var scale:Number = Math.min(Laya.stage.width / this._oldW, Laya.stage.height / this._oldH);
				super.width = Laya.stage.width;
				super.height = Laya.stage.height;
				this.scale(scale, scale);
			}
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			_oldW = value;
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			_oldH = value;
		}
	}
}