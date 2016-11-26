package laya.display.quick 
{
	import laya.renders.RenderContext;
	import laya.resource.Texture;
	import laya.utils.Stat;
	/**
	 * ...
	 * @author laoxie
	 */
	public class QkAni extends QkImage 
	{
		private var _textures:Array = [];
		private var _startTm:Number=0;
		private var _interval:Number;
		private var _preChgTm:Number;
		
		public function QkAni() 
		{
			super();
		}
		
		public function setTextures(value:Array):void
		{
			_textures = value.concat();
			texture = _textures[0];
			_preChgTm = 0;
		}
		
		public function start(interval:Number):void
		{
			_startTm = Laya.timer.currTimer;
			_interval = interval;
			_preChgTm = 0;
		}
		
		public override function render(context:RenderContext, x:Number, y:Number):void {
			
			if (_startTm < 0 || _textures.length===0) return;
			
			var tm:Number = Laya.timer.currTimer;
			if ( (tm - _preChgTm) >= _interval)
			{
				_preChgTm = tm;
				
				var i:int = Math.floor( (tm - _startTm) / _interval ) % _textures.length;				
				var t:Texture = _textures[ i ]; 				
				if (t !== _tex)
				{
					texture = t;
				}
			}
			
			if (!_tex) return;
			
			_changeType && _preRender();
			
			var ctx:*= context.ctx;
			(_renderKey !== ctx._renderKey) && (_renderKey=ctx.willDrawTexture(_tex, alpha));
			_renderKey>0 && ctx.addTextureVb(_vbdata, x+_offsetX+_x, y+_offsetY+_y);
			
			Stat.spriteCount ++;
		}
		
	}

}