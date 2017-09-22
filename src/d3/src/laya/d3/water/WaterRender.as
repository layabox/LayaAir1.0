package laya.d3.water 
{
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.render.BaseRender;
	import laya.d3.core.Sprite3D;
	
	/**
	 * ...
	 * @author ...
	 */
	public class WaterRender extends BaseRender {
		
		public function WaterRender(owner:RenderableSprite3D) {
			super(owner);
		}
		
		override protected function _calculateBoundingSphere():void {
			
		}
		
		override protected function _calculateBoundingBox():void  {
			
		}
		
		override public function _destroy():void {
			super._destroy();
		}
	}
}