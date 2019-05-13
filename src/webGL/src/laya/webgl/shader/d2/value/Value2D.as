package laya.webgl.shader.d2.value {
	import laya.resource.Texture;
	import laya.webgl.WebGL;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.shader.d2.skinAnishader.SkinSV;
	import laya.webgl.WebGLContext;
	import laya.webgl.shader.Shader;
	import laya.webgl.shader.ShaderValue;
	import laya.webgl.shader.d2.Shader2D;
	import laya.webgl.shader.d2.Shader2X;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.utils.RenderState2D;

	public class Value2D{
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/

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
			_initone(ShaderDefines2D.PRIMITIVE, PrimitiveSV);
			_initone(ShaderDefines2D.SKINMESH, SkinSV);
			_initone(ShaderDefines2D.TEXTURE2D, TextureSV);
			_initone(ShaderDefines2D.TEXTURE2D | ShaderDefines2D.FILTERGLOW, TextureSV);
		}
		
		public var defines:ShaderDefines2D = new ShaderDefines2D();
		
		public var size:Array = [0, 0];
		
		public var alpha:Number = 1.0;	//这个目前只给setIBVB用。其他的都放到attribute的color中了
		public var mmat:Array;		//worldmatrix，是4x4的，因为为了shader使用方便。 TODO 换成float32Array
		public var u_MvpMatrix:Array; 
		public var texture:*;
		
		public var ALPHA:Number = 1.0;	//这个？
		
		public var shader:Shader;
		public var mainID:int;
		public var subID:int=0;
		public var filters:Array;
		
		public var textureHost:Texture;
		//public var fillStyle:DrawStyle;			//TODO 这个有什么用？
		public var color:Array;
		//public var strokeStyle:DrawStyle;
		public var colorAdd:Array;
		public var u_mmat2:Array;
		public var ref:int = 1;
		protected var _attribLocation:Array;	//[name,location,name,location...] 由继承类赋值。这个最终会传给对应的shader
		
		private var _inClassCache:Array;
		private var _cacheID:int = 0;
		public var clipMatDir:Array = [WebGLContext2D._MAXSIZE, 0, 0, WebGLContext2D._MAXSIZE];
		public var clipMatPos:Array = [0, 0];
		public var clipOff:Array = [0,0];			// 裁剪是否需要加上偏移，cacheas normal用
		//public var clipDir:Array = [WebGLContext2D._MAXSIZE, 0, 0, WebGLContext2D._MAXSIZE];		//裁剪信息
		//public var clipRect:Array = [0, 0];						//裁剪位置
		
		public function Value2D(mainID:int,subID:int)
		{
			this.mainID = mainID;
			this.subID = subID;
			
			this.textureHost = null;
			this.texture = null;
			//this.fillStyle = null;
			this.color = null;
			//this.strokeStyle = null;
			this.colorAdd = null;
			this.u_mmat2 = null;
			
			_cacheID = mainID|subID;
			_inClassCache = _cache[_cacheID];
			if (mainID>0 && !_inClassCache)
			{
				_inClassCache = _cache[_cacheID] = [];
				_inClassCache._length = 0;
			}
			clear();
			
		}		
		
		public function setValue(value:Shader2D):void{}
			//throw new Error("todo in subclass");
		
		//不知道什么意思，这个名字太难懂，反正只有submitIBVB中用到。直接把代码拷贝到哪里
		//public function refresh():ShaderValue
		
		private function _ShaderWithCompile():Shader2X
		{
			var ret:Shader2X =  Shader.withCompile2D(0, mainID, defines.toNameDic(), mainID | defines._value, Shader2X.create, _attribLocation) as Shader2X;
			//ret.setAttributesLocation(_attribLocation); 由于上面函数的流程的修改，导致这里已经晚了
			return ret;
		}
		
		public function upload():void{
			var renderstate2d:*= RenderState2D;
			
			// 如果有矩阵的话，就设置 WORLDMAT 宏
			RenderState2D.worldMatrix4 === RenderState2D.TEMPMAT4_ARRAY ||  defines.addInt(ShaderDefines2D.WORLDMAT);
			mmat = renderstate2d.worldMatrix4;
			
			if (RenderState2D.matWVP) {
				defines.addInt(ShaderDefines2D.MVP3D);
				u_MvpMatrix = RenderState2D.matWVP.elements;
			}

			var sd:Shader2X = Shader.sharders[mainID | defines._value] || _ShaderWithCompile();
				
			if (sd._shaderValueWidth !==  renderstate2d.width ||  sd._shaderValueHeight !== renderstate2d.height){
				this.size[0] = renderstate2d.width;
				this.size[1] = renderstate2d.height;
				sd._shaderValueWidth  = renderstate2d.width;
				sd._shaderValueHeight = renderstate2d.height;
				sd.upload(this as ShaderValue, null);
			}
			else{
				sd.upload(this as ShaderValue, sd._params2dQuick2 || sd._make2dQuick2());
			}
		}

		//TODO:coverage
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
			defines._value=subID + (WebGL.shaderHighPrecision?ShaderDefines2D.SHADERDEFINE_FSHIGHPRECISION:0);
			clipOff[0] = 0;
		}
		
		public function release():void
		{
			if ( (--ref)< 1) 
			{
				_inClassCache && (_inClassCache[_inClassCache._length++] = this);
				//this.fillStyle = null;
				//this.strokeStyle = null;
				this.clear();
				this.filters = null;
				this.ref = 1;
				this.clipOff[0] = 0;
			}
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