package laya.webgl.resource {
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	/**
	 * WebGLRTMgr 管理WebGLRenderTarget的创建和回收
	 */
	
	public class WebGLRTMgr{
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		static private var dict:*= {};		//key=h*10000+w
		/**
		 * 获得一个renderTarget
		 * 暂时先按照严格大小判断。
		 * 
		 * @param	w
		 * @param	h
		 * @return
		 */
		public static function getRT(w:int, h:int):RenderTexture2D {
			w = w | 0;
			h = h | 0;
			if (w >= 10000){
				console.error('getRT error! w too big');
			}
			var key:int = h * 10000 + w;
			var sw:Array = dict[key];
			var ret:RenderTexture2D;
			if (sw) {
				if (sw.length > 0) {
					ret= sw.pop();
					ret._mgrKey = key;	//只有不再mgr中的才有key
					return ret;
				}
			}
			ret = new RenderTexture2D(w, h,BaseTexture.FORMAT_R8G8B8A8,-1);
			ret._mgrKey = key;
			return ret;
		}

		
		/**
		 * 回收一个renderTarget
		 * @param	rt
		 */
		public static function releaseRT(rt:RenderTexture2D):void {
			//如果_mgrKey<=0表示已经加进来了。
			if (rt._mgrKey <= 0)
				return;
			var sw:Array = dict[rt._mgrKey];
			!sw && (sw = [],dict[rt._mgrKey]=sw);
			rt._mgrKey = 0;
			sw.push(rt);
		}
	}
}