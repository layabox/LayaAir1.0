package laya.ani.bone 
{
	import laya.display.Sprite;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.resource.Texture;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.utils.Buffer;
	import laya.webgl.utils.IndexBuffer2D;
	import laya.webgl.utils.VertexBuffer2D;
	import laya.ani.bone.shader.aniShaderValue;
	import laya.ani.bone.shader.SkinAniShader;
	/**
	 * ...
	 * @author ...
	 */
	public class SkinSprite extends Sprite
	{
		
		private var mVBBuffer:VertexBuffer2D;
		private var mIBBuffer:IndexBuffer2D;
		private var mVBData:Float32Array;
		private var mIBData:Uint16Array;
		
		private var mEleNum:int = 0;
		
		private var mShaderValue:aniShaderValue;
		public function SkinSprite() 
		{
			
		}
		
		public function init(texture:Texture,vs:Array,ps:Array):void
		{
			mVBBuffer = VertexBuffer2D.create();
			mIBBuffer = IndexBuffer2D.create();
			
			mIBData = new Uint16Array();
			var tVBArray:Array;
			var tIBArray:Array;
			if (vs)
			{
				tVBArray = vs;
			}else {
				tVBArray = [];
				var tWidth:int = texture.width;
				var tHeight:int = texture.height;
				var tRed:Number = 1;
				var tGreed:Number = 0.1;
				var tBlue:Number = 0.1;
				var tAlpha:Number = 1;
				tVBArray.push(0, 0, 0, 0, tRed, tGreed, tBlue, tAlpha);
				tVBArray.push(tWidth, 0, 1, 0, tRed, tGreed, tBlue, tAlpha);
				tVBArray.push(tWidth, tHeight, 1, 1, tRed, tGreed, tBlue, tAlpha);
				tVBArray.push(0, tHeight, 0, 1, tRed, tGreed, tBlue, tAlpha);
			}
			if (ps)
			{
				tIBArray = ps;
			}else {
				tIBArray = [];
				tIBArray.push(0, 1, 3, 3, 1, 2);
			}
			mEleNum = tIBArray.length;
			
			mVBData = new Float32Array(tVBArray);
			mIBData = new Uint16Array(tIBArray);
			
			mVBBuffer.append(mVBData);
			mIBBuffer.append(mIBData);
			
			mShaderValue = new aniShaderValue();
			mShaderValue.textureHost = texture;
			
			this._renderType |= RenderSprite.CUSTOM;
		}
		
		override public function customRender(context:RenderContext, x:Number, y:Number):void 
		{
			//super.customRender(context, x, y);
			if (Render.isWebGL)
			{
				(context.ctx as WebGLContext2D).setIBVB(x, y, mIBBuffer, mVBBuffer, mEleNum, null, SkinAniShader.shader, mShaderValue, 0, 0);
			}
			
		}
		
	}

}