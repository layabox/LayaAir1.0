package laya.device.media
{
	import laya.device.media.HtmlVideo;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	/**
	 * @private
	 */
	public class WebGLVideo extends HtmlVideo
	{
		private var gl:WebGLContext;
		private var preTarget:*;
		private var preTexture:*;
		
		public function WebGLVideo()
		{
			super();
			
			gl = WebGL.mainContext;
			_source = gl.createTexture();
			
			preTarget = WebGLContext.curBindTexTarget;
			preTexture = WebGLContext.curBindTexValue;
			
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, _source);
			
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_S, WebGLContext.CLAMP_TO_EDGE);
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_T, WebGLContext.CLAMP_TO_EDGE);
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MAG_FILTER, WebGLContext.LINEAR);
			gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MIN_FILTER, WebGLContext.LINEAR);
			
			(preTarget && preTexture) && (WebGLContext.bindTexture(gl, preTarget, preTexture));
		}
		
		public function updateTexture():void
		{
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, _source);
			
			gl.texImage2D(WebGLContext.TEXTURE_2D, 0, WebGLContext.RGB, WebGLContext.RGB, WebGLContext.UNSIGNED_BYTE, video);
		}
	}
}