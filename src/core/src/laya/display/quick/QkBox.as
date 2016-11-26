package laya.display.quick 
{
	import laya.display.Node;
	import laya.display.Sprite;
	import laya.renders.RenderContext;
	
	/**
	 * ...
	 * @author laoxie
	 */
	public class QkBox extends Sprite 
	{
		
		public function QkBox() 
		{
			
		}
		
		public override function render(context:RenderContext, x:Number, y:Number):void {
			x += _x;
			y += _y;
			var childs:Array = _childs;
			var o:Sprite;
			for (var i:int = 0, sz:int = _childs.length; i < sz; i++)
			{
				(o=childs[i])._style.visible && o.render(context, x, y);
			}
			_repaint = 0;
		}
	}

}