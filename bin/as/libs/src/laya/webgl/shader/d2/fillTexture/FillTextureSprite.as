package laya.webgl.shader.d2.fillTexture 
{
	import laya.maths.Matrix;
	import laya.renders.Render;
	import laya.resource.Texture;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.utils.IndexBuffer2D;
	import laya.webgl.utils.VertexBuffer2D;
	/**
	 * ...
	 * @author 
	 */
	public class FillTextureSprite 
	{
		
		private var mVBBuffer:VertexBuffer2D;
		private var mIBBuffer:IndexBuffer2D;
		private var mVBData:Float32Array;
		private var mIBData:Uint16Array;
		private var mEleNum:int = 0;
		private var mShaderValue:FillTextureShaderValue;
		private var mTexture:Texture;
		public var transform:Matrix;
		
		public function FillTextureSprite() 
		{
			
		}
		
		public function initTexture(texture:Texture, x:Number, y:Number, width:Number, height:Number, offsetX:Number, offsetY:Number):void
		{
			mTexture = texture;
			if (mVBBuffer)
			{
				mVBBuffer.dispose();
			}
			if (mIBBuffer)
			{
				mIBBuffer.dispose();
			}
			mVBBuffer = VertexBuffer2D.create();
			mIBBuffer = IndexBuffer2D.create();
			
			mIBData = new Uint16Array();
			var tVBArray:Array;
			var tIBArray:Array;
			tVBArray = [];
			
			var w:Number = texture.bitmap.width, h:Number = texture.bitmap.height, uv:Array = texture.uv;
			var tTextureX:Number = uv[0] * w;
			var tTextureY:Number = uv[1] * h;
			var tTextureW:Number = (uv[2] - uv[0]) * w;
			var tTextureH:Number = (uv[5] - uv[3]) * h;
			var tU:Number = width / tTextureW;
			var tV:Number = height / tTextureH;
			var tWidth:int = width;
			var tHeight:int = height;
			var tRed:Number = 1;
			var tGreed:Number = 1;
			var tBlue:Number = 1;
			var tAlpha:Number = 1;
			tVBArray.push(x, y, 0, 0, tRed, tGreed, tBlue, tAlpha);
			tVBArray.push(x + tWidth, y, tU, 0, tRed, tGreed, tBlue, tAlpha);
			tVBArray.push(x + tWidth, y + tHeight, tU, tV, tRed, tGreed, tBlue, tAlpha);
			tVBArray.push(x, y + tHeight, 0, tV, tRed, tGreed, tBlue, tAlpha);
			
			tIBArray = [];
			tIBArray.push(0, 1, 3, 3, 1, 2);
			
			mEleNum = tIBArray.length;
			
			mVBData = new Float32Array(tVBArray);
			mIBData = new Uint16Array(tIBArray);
			
			mVBBuffer.append(mVBData);
			mIBBuffer.append(mIBData);
			
			mTexture = texture;
			if (mShaderValue == null) {	
				mShaderValue = new FillTextureShaderValue();
			}
			mShaderValue.u_offset[0] = -offsetX / tTextureW;
			mShaderValue.u_offset[1] = -offsetY / tTextureH;
			mShaderValue.u_texRange[0] = tTextureX / w;
			mShaderValue.u_texRange[1] = tTextureW / w;
			mShaderValue.u_texRange[2] = tTextureY / h;
			mShaderValue.u_texRange[3] = tTextureH / h;
		}
		
		public function render(context:*, x:Number, y:Number):void 
		{
			if (Render.isWebGL)
			{
				mShaderValue.textureHost = mTexture;
				context.setIBVB(x, y, mIBBuffer, mVBBuffer, mEleNum, transform, FillTextureShader.shader, mShaderValue, 0, 0);
			}
			
		}
		
	}

}