package laya.webgl.display
{
	import laya.display.Graphics;
	import laya.renders.Render;
	import laya.system.System;
	import laya.utils.RunDriver;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.Buffer2D;
	
	public class GraphicsGL extends Graphics
	{
		
		public function GraphicsGL()
		{
			super();
			
		}
		
		public function setShader(shader:Shader):void {
			_saveToCmd(Render.context._setShader, [shader]);
		}
		
		public function setIBVB(x:Number, y:Number, ib:Buffer2D, vb:Buffer2D, numElement:int, shader:Shader):void {
			_saveToCmd(Render.context._setIBVB, [x,y,ib,vb,numElement,shader]);
		}
		
		
		public function drawParticle(x:Number,y:Number,ps:*):void
		{
			var pt:*=RunDriver.createParticleTemplate2D(ps);
			pt.x=x;
			pt.y=y;
			_saveToCmd(Render.context._drawParticle, [pt]);
		}
	}
}