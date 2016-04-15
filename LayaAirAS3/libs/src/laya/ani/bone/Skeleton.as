package laya.ani.bone {
	import laya.display.Animation;
	import laya.renders.RenderSprite;
	public class Skeleton extends Animation {
		public var _tp_:Templet;
		
		public function Skeleton(tmplete:* = null) {
			if (!tmplete) return;
			_tp_ = tmplete; this._count = tmplete.frameCount;
			this.interval = 1000 / tmplete.frameRate;
			frames = _tp_._graphicsArrs_[0];
		}
		
		public function setTpl(tpl:Templet):void
		{
			_tp_ = tpl; this._count = tpl.frameCount;
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
			_renderType |= RenderSprite.GRAPHICS;
			this.repaint();
		}
		
		public function pause(frame:int=-1):void
		{
			frame > -1 && (index = frame);
			stop();
		}
		
		public override function set index(value:int):void {
			_index = value;

			if ((_graphics = this._frames[value]) != null) {
				this.repaint(); 
				return;
			}
			
			_graphics = _frames[value] = _tp_.planish(value, _frames._index_);
			
			this.repaint();
		}	
	}
}