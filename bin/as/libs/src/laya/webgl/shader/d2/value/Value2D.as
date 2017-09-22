package laya.webgl.shader.d2.value {
	import laya.resource.Bitmap;
	import laya.resource.Texture;
	import laya.webgl.WebGL;
	import laya.webgl.shader.BaseShader;
	import laya.webgl.shader.d2.skinAnishader.SkinSV;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.DrawStyle;
	import laya.webgl.shader.Shader;
	import laya.webgl.shader.ShaderValue;
	import laya.webgl.shader.d2.Shader2D;
	import laya.webgl.shader.d2.Shader2X;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.utils.CONST3D2D;
	import laya.webgl.utils.MatirxArray;
	import laya.webgl.utils.RenderState2D;

	public class Value2D  extends ShaderValue
	{
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/

		public static var _POSITION:Array;
		public static var _TEXCOORD:Array;
		
		protected static var _cache:Array=[];
		protected static var _typeClass:Object = [];
		
		public static var TEMPMAT4_ARRAY:Array=/*[STATIC SAFE]*/ [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];

		private static function _initone(type:int, classT:*):void
		{
			_typeClass[type] = classT;
			_cache[type] = [];
			_cache[type]._length = 0;
		}
		
		public static function __init__():void
		{
			_POSITION = [2, WebGLContext.FLOAT, false, 4 * CONST3D2D.BYTES_PE, 0];
			_TEXCOORD = [2, WebGLContext.FLOAT, false, 4 * CONST3D2D.BYTES_PE, 2 * CONST3D2D.BYTES_PE];
			_initone(ShaderDefines2D.COLOR2D, Color2dSV);
			_initone(ShaderDefines2D.PRIMITIVE, PrimitiveSV);
			_initone(ShaderDefines2D.FILLTEXTURE, FillTextureSV);
			_initone(ShaderDefines2D.SKINMESH, SkinSV);
			_initone(ShaderDefines2D.TEXTURE2D, TextureSV);
			_initone(ShaderDefines2D.TEXTURE2D | ShaderDefines2D.COLORADD,TextSV);	
			_initone(ShaderDefines2D.TEXTURE2D | ShaderDefines2D.FILTERGLOW, TextureSV);
		}
		
		public var defines:ShaderDefines2D = new ShaderDefines2D();
		public var position:Array = _POSITION;
		public var size:Array = [0, 0];
		
		public var alpha:Number = 1.0;
		public var mmat:Array;
		public var ALPHA:Number = 1.0;
		
		public var shader:Shader;
		public var mainID:int;
		public var subID:int=0;
		public var filters:Array;
		
		public var textureHost:Texture;
		public var texture:*;
		public var fillStyle:DrawStyle;
		public var color:Array;
		public var strokeStyle:DrawStyle;
		public var colorAdd:Array;
		public var glTexture:Bitmap;
		/*[IF-FLASH]*/public var mul_mmat:Array;//存储两个矩阵相乘的值，mmat*ummat2
		public var u_mmat2:Array;
		
		private var _inClassCache:Array;
		private var _cacheID:int = 0;
		

		public function Value2D(mainID:int,subID:int)
		{
			this.mainID = mainID;
			this.subID = subID;
			
			this.textureHost = null;
			this.texture = null;
			this.fillStyle = null;
			this.color = null;
			this.strokeStyle = null;
			this.colorAdd = null;
			this.glTexture = null;
			this.u_mmat2 = null;
			/*[IF-FLASH]*/this.mul_mmat = null;
			
			_cacheID = mainID|subID;
			_inClassCache = _cache[_cacheID];
			if (mainID>0 && !_inClassCache)
			{
				_inClassCache = _cache[_cacheID] = [];
				_inClassCache._length = 0;
			}
			//_initDef=(_cacheID == (ShaderDefines2D.TEXTURE2D | ShaderDefines2D.COLORADD))?ShaderDefines2D.COLORADD:mainID;
			clear();
			
		}		
		
		public function setValue(value:Shader2D):void{}
			//throw new Error("todo in subclass");
		
		public function refresh():ShaderValue
		{
			var size:Array = this.size;
			size[0] = RenderState2D.width;
			size[1] = RenderState2D.height;
			alpha = ALPHA * RenderState2D.worldAlpha;
			mmat = RenderState2D.worldMatrix4;
			return this;
		}
		
		private function _ShaderWithCompile():Shader2X
		{
			return  Shader.withCompile2D(0, mainID, defines.toNameDic(), mainID | defines._value, Shader2X.create) as Shader2X;
		}
		
		private function _withWorldShaderDefines():Shader2X
		{
			var defs:ShaderDefines2D = RenderState2D.worldShaderDefines;
			var sd:Shader2X = Shader.sharders[mainID | defines._value | defs.getValue()] as Shader2X;
			if (!sd)
			{
				var def:Object = {};
				var dic:Object;
				var name:String;
				 dic = defines.toNameDic(); for (name in dic) def[name] = "";
				 dic = defs.toNameDic(); for (name in dic) def[name] = "";
				sd=Shader.withCompile2D(0, mainID, def, mainID | defines._value| defs.getValue(), Shader2X.create) as Shader2X;
			}
			var worldFilters:Array = RenderState2D.worldFilters; 
			if (!worldFilters) return sd;
			
			var n:int = worldFilters.length,f:*;
			for (var i:int = 0; i < n; i++)
			{
				( (f= worldFilters[i])) && f.action.setValue(this);
			}
			
			return sd;
		}
		
		public function upload():void
		{
			var renderstate2d:*= RenderState2D;
			alpha = ALPHA * renderstate2d.worldAlpha;
			
			if ( RenderState2D.worldMatrix4 !== RenderState2D.TEMPMAT4_ARRAY) defines.add(ShaderDefines2D.WORLDMAT);
			(WebGL.shaderHighPrecision) && (defines.add(ShaderDefines2D.SHADERDEFINE_FSHIGHPRECISION));
			var sd:Shader2X = renderstate2d.worldShaderDefines?_withWorldShaderDefines():(Shader.sharders[mainID | defines._value] as Shader2X || _ShaderWithCompile());
			
			var params:Array;
			 
			this.size[0]  = renderstate2d.width, this.size[1] = renderstate2d.height;
			mmat = renderstate2d.worldMatrix4;			
			/*[IF-FLASH]*/MatirxArray.ArrayMul(mmat, this.u_mmat2, TEMPMAT4_ARRAY);
			/*[IF-FLASH]*/mul_mmat = TEMPMAT4_ARRAY;
			
			if (BaseShader.activeShader!==sd)
			{
				if (sd._shaderValueWidth !==  renderstate2d.width ||  sd._shaderValueHeight !== renderstate2d.height){
					sd._shaderValueWidth  = renderstate2d.width;
					sd._shaderValueHeight = renderstate2d.height;
				}
				else{
					params = sd._params2dQuick2 || sd._make2dQuick2();
				}
				sd.upload(this, params);
			}
			else
			{
				if (sd._shaderValueWidth !==  renderstate2d.width ||  sd._shaderValueHeight !== renderstate2d.height){
					sd._shaderValueWidth  = renderstate2d.width;
					sd._shaderValueHeight = renderstate2d.height;
				}
				else{
				   params = (sd._params2dQuick1) || sd._make2dQuick1();
				}
				sd.upload(this, params);
			}
			
		}
		
		public function setFilters(value:Array):void
		{
			filters = value;
			if (!value) 
				return;
				
			var n:int = value.length, f:*;
			for (var i:int = 0; i < n; i++)
			{
				f = value[i];
				if (f)
				{
					defines.add(f.type);//搬到setValue中
					f.action.setValue(this);
				}
			}
		}
		
		public function clear():void
		{
			defines.setValue(subID);
		}
		
		public function release():void
		{
			_inClassCache[_inClassCache._length++] = this;
			this.fillStyle = null;
			this.strokeStyle = null;
			this.clear();
		}
		
		public static function create(mainType:int,subType:int):Value2D
		{
			var types:Array = _cache[mainType|subType];
			if (types._length)
				return types[--types._length];
			else
				return new _typeClass[mainType|subType](subType);
		}
	}

}