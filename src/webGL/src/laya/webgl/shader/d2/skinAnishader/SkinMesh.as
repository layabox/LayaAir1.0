package laya.webgl.shader.d2.skinAnishader 
{
	import laya.maths.Matrix;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.resource.Texture;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.utils.Buffer;
	import laya.webgl.utils.IndexBuffer2D;
	import laya.webgl.utils.VertexBuffer2D;
	import laya.webgl.shader.d2.skinAnishader.aniShaderValue;
	import laya.webgl.shader.d2.skinAnishader.SkinAniShader;
	import laya.webgl.WebGLContext;
	/**
	 * 这里销毁的问题，后面待确认
	 * @author ...
	 */
	public class SkinMesh
	{
		
		private var mVBBuffer:VertexBuffer2D;
		private var mIBBuffer:IndexBuffer2D;
		private var mVBData:Float32Array;
		private var mIBData:Uint16Array;
		private var mEleNum:int = 0;
		private var mShaderValue:aniShaderValue;
		private var mTexture:Texture;
		public var transform:Matrix;
		
		public function SkinMesh() 
		{
			
		}
		
		public function init(texture:Texture, vs:Array, ps:Array):void
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
				var tGreed:Number = 1;
				var tBlue:Number = 1;
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
			
			mTexture = texture;
			if (mShaderValue == null)
			{
				mShaderValue = new aniShaderValue();
			}
		}
		
		public function render(context:*, x:Number, y:Number):void 
		{
			if (Render.isWebGL)
			{
				mShaderValue.textureHost = mTexture;
				(context as WebGLContext2D).setIBVB(x, y, mIBBuffer, mVBBuffer, mEleNum, transform, SkinAniShader.getInstance(), mShaderValue, 0, 0);
			}
			
		}
		
	}

}