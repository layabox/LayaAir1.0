package laya.webgl.shader {
	import laya.resource.Resource;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BaseShader extends Resource {
		public static var activeShader:BaseShader;			//等于bindShader或者null
		public static var bindShader:BaseShader;			//当前绑定的shader
		
		public function BaseShader() {
		
		}
	
	}

}