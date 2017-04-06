/*[IF-FLASH]*/package laya.flash 
{
	import flash.display.Shader;
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	/**
	 * ...对Stage3D的Programme3D的包装
	 * @author rivetr
	 */
	public class ProgramObject 
	{
		public static var _context3D : Context3D;
		public var program : Program3D = null;
		public var vsShader : Object = null;
		public var psShader : Object = null;
		public var maxVa : int = 0;
		public var maxTex : int = 0;
		public var deviceset : Boolean = false;
		
		public var stateSet : Object = { };
		public var inSCache : Boolean = true;
		public function ProgramObject() 
		{			
		}
		
		
		
		/**
		 * 删除Program的设备相关数据
		 */
		public function dispose() : void {
			if( program ){
				program.dispose();
				program = null;
				vsShader = null;
				psShader = null;
			}
		}
		
	}

}



