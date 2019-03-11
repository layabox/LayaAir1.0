package laya.layagl
{
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.renders.Render;
	import laya.layagl.LayaGL;
	import laya.resource.Texture;
	import laya.utils.ColorUtils;
	
	/**
	 * @private
	 * CommandEncoder
	 */
	public class CommandEncoder {
		public var _idata:Array = [];
		
		//TODO:coverage
		public function CommandEncoder(layagl:*, reserveSize:int, adjustSize:int, isSyncToRenderThread:Boolean) {
		}
		
		//TODO:coverage
		public function getArrayData():Array {
			return _idata;
		}
		
		//TODO:coverage
		public function getPtrID():int {
			return 0;
		}
		
		public function beginEncoding():void {
		
		}
		
		public function endEncoding():void {
		
		}
		
		//TODO:coverage
		public function clearEncoding():void {
			_idata.length = 0;
		}
		
		//TODO:coverage
		public function getCount():int {
			return _idata.length;
		}
		
		//TODO:coverage
		public function add_ShaderValue(o:*):void {
			_idata.push(o);
		}
		
		//TODO:coverage
		public function addShaderUniform(one:*):void {
			add_ShaderValue(one);
		}
	
	}
}