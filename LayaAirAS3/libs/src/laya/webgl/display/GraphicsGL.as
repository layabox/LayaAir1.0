package laya.webgl.display
{
	import laya.display.Graphics;
	import laya.renders.Render;
	import laya.system.System;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.Buffer;
	
	public class GraphicsGL extends Graphics
	{
		
		public function GraphicsGL()
		{
			super();
			
		}
		
		public function setShader(shader:Shader):void {
			_saveToCmd(Render.context._setShader, arguments);
		}
		
		public function setIBVB(x:Number, y:Number, ib:Buffer, vb:Buffer, numElement:int, shader:Shader):void {
			_saveToCmd(Render.context._setIBVB, arguments);
		}
		
		
		public function drawParticle(x:Number,y:Number,ps:*):void
		{
			var pt:*=System.createParticleTemplate2D(ps);
			pt.x=x;
			pt.y=y;
			_saveToCmd(Render.context.drawParticle, [pt]);
		}
	}
}