package laya.device.media
{
	import laya.device.media.HtmlVideo;
	import laya.utils.Browser;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.renders.Render;
	
	import laya.layagl.LayaGL;

	/**
	 * @private
	 */
	public class WebGLVideo extends HtmlVideo
	{
		private var gl:WebGLContext;
		private var preTarget:*;
		private var preTexture:*;
		
		private static var curBindSource:*;
		
		public function WebGLVideo()
		{
			super();
			
			if(!Render.isConchApp && Browser.onIPhone)
				return;
			
			gl = __JS__("Render.isConchApp ? LayaGLContext.instance : WebGL.mainContext");
			_source = gl.createTexture();
			
			//preTarget = WebGLContext.curBindTexTarget; 
			//preTexture = WebGLContext.curBindTexValue;
			
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, _source);
			
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_S, WebGLContext.CLAMP_TO_EDGE);
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_T, WebGLContext.CLAMP_TO_EDGE);
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MAG_FILTER, WebGLContext.LINEAR);
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MIN_FILTER, WebGLContext.LINEAR);
			
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, null);

			//(preTarget && preTexture) && (WebGLContext.bindTexture(gl, preTarget, preTexture));
		}
		
		public function updateTexture():void
		{
			if(!Render.isConchApp && Browser.onIPhone)
				return;
			
 			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, _source);
			
			gl.texImage2D(WebGLContext.TEXTURE_2D, 0, WebGLContext.RGB, WebGLContext.RGB, WebGLContext.UNSIGNED_BYTE, video);
			
			curBindSource = _source;
		}
		
		public function get _glTexture():*
		{
			return _source;
		}
		
		public override function destroy():void {
			if (_source)
			{
				gl = __JS__("Render.isConchApp ? LayaGLContext.instance : WebGL.mainContext");
				
				if (curBindSource == _source)
				{
					WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, null);
					curBindSource = null;
				}

				gl.deleteTexture(_source);
			}

			super.destroy();
		}

	}
}