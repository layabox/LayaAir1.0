package laya.webgl.text 
{
	import laya.filters.ColorFilter;
	import laya.maths.Matrix;
	import laya.resource.Texture;
	import laya.utils.Stat;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.submit.Submit;
	import laya.webgl.submit.SubmitTexture;
	import laya.webgl.utils.MeshQuadTexture;
	/**
	 * ...
	 * @author laoxie
	 */
	public class CharSubmitCache 
	{
		private static var __posPool:Array = [];
		private static var __nPosPool:int = 0;
		
		private var _data:Array = [];
		private var _ndata:int = 0;
		private var _tex:Texture;
		private var _imgId:int;
		private var _clipid:int =-1;
		private var _clipMatrix:Matrix = new Matrix();
		public var _enbale:Boolean = false;
		
		public var _colorFiler:ColorFilter;
		
		public function CharSubmitCache() 
		{
			
		}
		
		public function clear():void
		{
			_tex = null;
			_imgId =-1;
			_ndata = 0;
			_enbale = false;
			_colorFiler = null;
		}
		
		public function destroy():void
		{
			clear();
			_data.length = 0;
			_data = null;
		}
		
		public function add(ctx:WebGLContext2D,tex:Texture,imgid:int,pos:Array, uv:Array, color:uint):void
		{
			if (_ndata > 0 && (_tex != tex || _imgId != imgid || 
				(_clipid>=0 && _clipid!=ctx._clipInfoID) ))
			{
				submit(ctx);
			}
			
			_clipid = ctx._clipInfoID;
			ctx._globalClipMatrix.copyTo(_clipMatrix);
			_tex = tex;
			_imgId = imgid;
			_colorFiler = ctx._colorFiler;
			
			_data[_ndata] = pos;
			_data[_ndata+1] = uv;
			_data[_ndata + 2] = color;
			_ndata += 3;
		}
		
		public function getPos():Array
		{
			if (__nPosPool == 0)
				return new Array(8);
			return __posPool[--__nPosPool];
		}
		
		public function enable(value:Boolean,ctx:WebGLContext2D):void
		{
			if (value === _enbale)
				return;
			_enbale = value;
			_enbale || submit(ctx);
		}
		
		public function submit(ctx:WebGLContext2D):void
		{
			var n:int = _ndata;
			if (!n)
				return;
			
			var _mesh:MeshQuadTexture = ctx._mesh;
			
			var colorFiler:ColorFilter=ctx._colorFiler;
			ctx._colorFiler=_colorFiler;			
			var submit:SubmitTexture  = SubmitTexture.create(ctx,_mesh , Value2D.create(ShaderDefines2D.TEXTURE2D, 0));
			ctx._submits[ctx._submits._length++] = ctx._curSubmit = submit;
			submit.shaderValue.textureHost = _tex;
			submit._key.other = _imgId;			
			ctx._colorFiler = colorFiler;			
			ctx._copyClipInfo(submit, _clipMatrix);
			submit.clipInfoID = _clipid;
			
			for (var i:int = 0; i < n; i += 3)
			{
				_mesh.addQuad(_data[i], _data[i + 1] , _data [i + 2], true);
				__posPool[__nPosPool++]=_data[i];
			}
			
			n /= 3;
			submit._numEle += n*6;
			_mesh.indexNum += n*6;
			_mesh.vertNum += n*4;
			ctx._drawCount += n;
			_ndata = 0;
			
			if (Stat.loopCount % 100 == 0)
				_data.length = 0;
		}
		
	}

}