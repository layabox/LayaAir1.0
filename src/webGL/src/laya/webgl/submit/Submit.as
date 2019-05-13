package laya.webgl.submit {
	import laya.resource.Texture;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.BlendMode;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.utils.CONST3D2D;
	import laya.webgl.utils.Mesh2D;
	
	public class Submit implements ISubmit {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static const TYPE_2D:int = 10000;
		public static const TYPE_CANVAS:int = 10003;
		public static const TYPE_CMDSETRT:int = 10004;
		public static const TYPE_CUSTOM:int = 10005;
		public static const TYPE_BLURRT:int = 10006;
		public static const TYPE_CMDDESTORYPRERT:int = 10007;
		public static const TYPE_DISABLESTENCIL:int = 10008;
		public static const TYPE_OTHERIBVB:int = 10009;
		public static const TYPE_PRIMITIVE:int = 10010;
		public static const TYPE_RT:int = 10011;
		public static const TYPE_BLUR_RT:int = 10012;
		public static const TYPE_TARGET:int = 10013;
		public static const TYPE_CHANGE_VALUE:int = 10014;
		public static const TYPE_SHAPE:int = 10015;
		public static const TYPE_TEXTURE:int = 10016;
		public static const TYPE_FILLTEXTURE:int = 10017;
		
		public static const KEY_ONCE:int = -1;
		public static const KEY_FILLRECT:int = 1;
		public static const KEY_DRAWTEXTURE:int = 2;
		public static const KEY_VG:int = 3;
		public static const KEY_TRIANGLES:int = 4;
		
		public static var RENDERBASE:Submit;
		public static var ID:int = 1;
		public static var preRender:ISubmit=null;	//上一个submit，主要用来比较key,以减少uniform的重复提交。

		protected static var _poolSize:int = 0;
		protected static var POOL:Array =[];
		
		public var clipInfoID:int = -1;	//用来比较clipinfo
		
		public var _mesh:Mesh2D=null;			//代替 _vb,_ib
		public var _blendFn:Function=null;
		protected var _id:int=0;
		//protected var _isSelfVb:Boolean = false;
		
		public var _renderType:int=0;
		
		public var _parent:Submit=null;
		
		//渲染key，通过key判断是否是同一个
		public var _key:SubmitKey=new SubmitKey();
		
		// 从VB中什么地方开始画，画到哪
		public var _startIdx:int=0;		//indexbuffer 的偏移，单位是byte
		public var _numEle:int=0;

		public var _ref:int=1;
		
		public var shaderValue:Value2D=null;
		
		public static function __init__():void {
			var s:Submit = RENDERBASE = new Submit(-1);
			s.shaderValue = new Value2D(0, 0);
			s.shaderValue.ALPHA = 1;
			s._ref = 0xFFFFFFFF;
		}
		
		public function Submit(renderType:int = TYPE_2D) {
			_renderType = renderType;
			_id =++ID;
		}
		
		//TODO:coverage
		public function getID():int
		{
			return _id;
		}
		
		public function releaseRender():void {
			
			if (RENDERBASE == this)
				return;
				
			if( (--this._ref) <1)
			{
				POOL[_poolSize++] = this;
				shaderValue.release();
				shaderValue=null;
				//_vb = null;
				//_mesh.destroy();
				_mesh = null;
				_parent && (_parent.releaseRender(), _parent = null);
			}
		}
		
		//TODO:coverage
		public function getRenderType():int {
			return _renderType;
		}
		
		public function renderSubmit():int {
			if (_numEle === 0 || !_mesh || _numEle == 0) return 1;//怎么会有_numEle是0的情况?
			
			var _tex:Texture = shaderValue.textureHost;
			if (_tex) {
				var source:* = _tex._getSource();
				if (!source)
					return 1;
				shaderValue.texture = source;
			}
			
			var gl:WebGLContext = WebGL.mainContext;
			_mesh.useMesh(gl);
			//_ib._bind_upload() || _ib._bind();
			//_vb._bind_upload() || _vb._bind();
			
			shaderValue.upload();
			
			
			if (BlendMode.activeBlendFunction !== _blendFn) {
				WebGLContext.setBlend(gl, true);
				_blendFn(gl);
				BlendMode.activeBlendFunction = _blendFn;
			}
			gl.drawElements(WebGLContext.TRIANGLES, this._numEle, WebGLContext.UNSIGNED_SHORT, this._startIdx);
			
			Stat.renderBatches++;
			Stat.trianglesFaces += _numEle / 3;
			
			return 1;
		}
		
		/**
		 * 基于o和传入的其他参数来初始化submit对象
		 * @param	o
		 * @param	context
		 * @param	mesh
		 * @param	pos
		 */
		//TODO:coverage
		protected function _cloneInit(o:Submit,context:WebGLContext2D, mesh:Mesh2D, pos:int):void
		{
			;
			o._ref=1;
			//o._ib = ib;
			//o._vb = vb;
			o._mesh = mesh;
			o._id = _id;
			//o._isSelfVb = _isSelfVb;
			o._key.copyFrom(_key);
			o._parent = this;
			o._blendFn = _blendFn;
			o._renderType = _renderType;
			o._startIdx = pos * CONST3D2D.BYTES_PIDX;
			o._numEle = _numEle;
			o.shaderValue = shaderValue;
			shaderValue.ref++;
			this._ref++;
		}
		
		//TODO:coverage
		public function clone(context:WebGLContext2D,mesh:Mesh2D,pos:int):ISubmit
		{
			;
			/*
			if (_key.submitType===-1 || _isSelfVb) return null;
			var o:Submit = _poolSize ? POOL[--_poolSize] : new Submit();
			_cloneInit(o, context, ib, vb, pos);
			return o;
			*/
			return null;
		}
		
		//TODO:coverage
		public function reUse(context:WebGLContext2D, pos:int):int
		{
			;
			return 0;
			/*
			_ref++;
			
			if (_isSelfVb)
			{
				return pos;
			}	
			_ib = context._ib;
			_vb = context._vb;
			_startIdx = pos / 8 * 6;
		    return pos + _numEle / 6 * 16;
			*/
		}
		
		//TODO:coverage
		public function toString():String
		{
			return "ibindex:" + _startIdx + " num:" + _numEle+" key="+_key;
		}
		
		/*
		   create方法只传对submit设置的值
		 */
		//TODO:coverage
		public static function create(context:WebGLContext2D, mesh:Mesh2D, sv:Value2D):Submit {
			;
			var o:Submit = _poolSize ? POOL[--_poolSize] : new Submit();
			o._ref = 1;
			o._mesh = mesh;
			o._key.clear();
			o._startIdx = mesh.indexNum * CONST3D2D.BYTES_PIDX;
			o._numEle = 0;
			var blendType:int = context._nBlendType;
			o._blendFn = context._targets ? BlendMode.targetFns[blendType] : BlendMode.fns[blendType];
			o.shaderValue = sv;
			o.shaderValue.setValue(context._shader2D);
			var filters:Array = context._shader2D.filters;
			filters && o.shaderValue.setFilters(filters);			
			return o;
		}
		
		/**
		 * 创建一个矢量submit
		 * @param	ctx
		 * @param	mesh
		 * @param	numEle		对应drawElement的第二个参数:count
		 * @param	offset		drawElement的时候的ib的偏移。
		 * @param	sv			Value2D
		 * @return
		 */
		public static function createShape(ctx:WebGLContext2D, mesh:Mesh2D, numEle:int, sv:Value2D):Submit {
			var o:Submit = _poolSize ? POOL[--_poolSize]:(new Submit());
			o._mesh = mesh;
			o._numEle = numEle;
			o._startIdx = mesh.indexNum * 2;
			o._ref=1;
			o.shaderValue = sv;
			o.shaderValue.setValue(ctx._shader2D);
			var blendType:int = ctx._nBlendType;
			o._key.blendShader = blendType;
			o._blendFn = ctx._targets ? BlendMode.targetFns[blendType] : BlendMode.fns[blendType];
			return o;
		}
	}

}