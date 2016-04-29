package laya.ani.bone {
	import laya.display.Animation;
	
	public class Skeleton extends Animation {
		public var _tp_:Templet;
		
		public function Skeleton(tmplete:* = null) {
			if (!tmplete) return;
			_tp_ = tmplete;
			this._count = tmplete.frameCount;
			this.interval = 1000 / tmplete.frameRate;
			frames = _tp_._graphicsArrs_[0];
		}
		
		public function setTpl(tpl:Templet):void {
			_tp_ = tpl;
			this._count = tpl.frameCount;
			this.interval = 1000 / tpl.frameRate;
			setAnim(0);
		}
		
		public function setAnim(index:int):void {
			frames = _tp_._graphicsArrs_[index];
		}
		
		public function stAnimName(str:String):void {
			frames = _tp_._graphicsArrs_[_tp_.animNames[str]];
		}
		
		public override function set frames(value:Array):void {
			this._frames = value;
			this.repaint();
		}
		
		public function pause(frame:int = -1):void {
			frame > -1 && (index = frame);
			stop();
		}
		
		public override function set index(value:int):void {
			_index = value;
			
			if ((this.graphics = this._frames[value]) != null) {
				
			} else {
				this.graphics = this._frames[value] = _tp_.planish(value, this._frames._index_);
			}
		}
	}
}