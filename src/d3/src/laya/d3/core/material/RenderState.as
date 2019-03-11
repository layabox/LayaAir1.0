package laya.d3.core.material {
	import laya.d3.core.IClone;
	import laya.d3.core.Transform3D;
	import laya.d3.math.Vector4;
	import laya.layagl.LayaGL;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>RenderState</code> 类用于控制渲染状态。
	 */
	public class RenderState implements IClone {
		/**剔除枚举_不剔除。*/
		public static const CULL_NONE:int = 0;
		/**剔除枚举_剔除正面。*/
		public static const CULL_FRONT:int = 1;
		/**剔除枚举_剔除背面。*/
		public static const CULL_BACK:int = 2;
		
		/**混合枚举_禁用。*/
		public static const BLEND_DISABLE:int = 0;
		/**混合枚举_启用_RGB和Alpha统一混合。*/
		public static const BLEND_ENABLE_ALL:int = 1;
		/**混合枚举_启用_RGB和Alpha单独混合。*/
		public static const BLEND_ENABLE_SEPERATE:int = 2;
		
		/**混合参数枚举_零,例：RGB(0,0,0),Alpha:(1)。*/
		public static const BLENDPARAM_ZERO:int = 0;
		/**混合参数枚举_一,例：RGB(1,1,1),Alpha:(1)。*/
		public static const BLENDPARAM_ONE:int = 1;
		/**混合参数枚举_源颜色,例：RGB(Rs, Gs, Bs)，Alpha(As)。*/
		public static const BLENDPARAM_SRC_COLOR:int = 0x0300;
		/**混合参数枚举_一减源颜色,例：RGB(1-Rs, 1-Gs, 1-Bs)，Alpha(1-As)。*/
		public static const BLENDPARAM_ONE_MINUS_SRC_COLOR:int = 0x0301;
		/**混合参数枚举_目标颜色,例：RGB(Rd, Gd, Bd),Alpha(Ad)。*/
		public static const BLENDPARAM_DST_COLOR:int = 0x0306;
		/**混合参数枚举_一减目标颜色,例：RGB(1-Rd, 1-Gd, 1-Bd)，Alpha(1-Ad)。*/
		public static const BLENDPARAM_ONE_MINUS_DST_COLOR:int = 0x0307;
		/**混合参数枚举_源透明,例:RGB(As, As, As),Alpha(1-As)。*/
		public static const BLENDPARAM_SRC_ALPHA:int = 0x0302;
		/**混合参数枚举_一减源阿尔法,例:RGB(1-As, 1-As, 1-As),Alpha(1-As)。*/
		public static const BLENDPARAM_ONE_MINUS_SRC_ALPHA:int = 0x0303;
		/**混合参数枚举_目标阿尔法，例：RGB(Ad, Ad, Ad),Alpha(Ad)。*/
		public static const BLENDPARAM_DST_ALPHA:int = 0x0304;
		/**混合参数枚举_一减目标阿尔法,例：RGB(1-Ad, 1-Ad, 1-Ad),Alpha(Ad)。*/
		public static const BLENDPARAM_ONE_MINUS_DST_ALPHA:int = 0x0305;
		/**混合参数枚举_阿尔法饱和，例：RGB(min(As, 1 - Ad), min(As, 1 - Ad), min(As, 1 - Ad)),Alpha(1)。*/
		public static const BLENDPARAM_SRC_ALPHA_SATURATE:int = 0x0308;
		
		/**混合方程枚举_加法,例：source + destination*/
		public static const BLENDEQUATION_ADD:int = 0;
		/**混合方程枚举_减法，例：source - destination*/
		public static const BLENDEQUATION_SUBTRACT:int = 1;
		/**混合方程枚举_反序减法，例：destination - source*/
		public static const BLENDEQUATION_REVERSE_SUBTRACT:int = 2;
		
		/**深度测试函数枚举_关闭深度测试。*/
		public static const DEPTHTEST_OFF:int = 0/*WebGLContext.NEVER*/;
		/**深度测试函数枚举_从不通过。*/
		public static const DEPTHTEST_NEVER:int = 0x0200/*WebGLContext.NEVER*/;
		/**深度测试函数枚举_小于时通过。*/
		public static const DEPTHTEST_LESS:int = 0x0201/*WebGLContext.LESS*/;
		/**深度测试函数枚举_等于时通过。*/
		public static const DEPTHTEST_EQUAL:int = 0x0202/*WebGLContext.EQUAL*/;
		/**深度测试函数枚举_小于等于时通过。*/
		public static const DEPTHTEST_LEQUAL:int = 0x0203/*WebGLContext.LEQUAL*/;
		/**深度测试函数枚举_大于时通过。*/
		public static const DEPTHTEST_GREATER:int = 0x0204/*WebGLContext.GREATER*/;
		/**深度测试函数枚举_不等于时通过。*/
		public static const DEPTHTEST_NOTEQUAL:int = 0x0205/*WebGLContext.NOTEQUAL*/;
		/**深度测试函数枚举_大于等于时通过。*/
		public static const DEPTHTEST_GEQUAL:int = 0x0206/*WebGLContext.GEQUAL*/;
		/**深度测试函数枚举_总是通过。*/
		public static const DEPTHTEST_ALWAYS:int = 0x0207/*WebGLContext.ALWAYS*/;
		
		/**渲染剔除状态。*/
		public var cull:int;
		/**透明混合。*/
		public var blend:int;
		/**源混合参数,在blend为BLEND_ENABLE_ALL时生效。*/
		public var srcBlend:int;
		/**目标混合参数,在blend为BLEND_ENABLE_ALL时生效。*/
		public var dstBlend:int;
		/**RGB源混合参数,在blend为BLEND_ENABLE_SEPERATE时生效。*/
		public var srcBlendRGB:int;
		/**RGB目标混合参数,在blend为BLEND_ENABLE_SEPERATE时生效。*/
		public var dstBlendRGB:int;
		/**Alpha源混合参数,在blend为BLEND_ENABLE_SEPERATE时生效。*/
		public var srcBlendAlpha:int;
		/**Alpha目标混合参数,在blend为BLEND_ENABLE_SEPERATE时生效。*/
		public var dstBlendAlpha:int;
		/**混合常量颜色。*/
		public var blendConstColor:Vector4;
		/**混合方程。*/
		public var blendEquation:int;
		/**RGB混合方程。*/
		public var blendEquationRGB:int;
		/**Alpha混合方程。*/
		public var blendEquationAlpha:int;
		/**深度测试函数。*/
		public var depthTest:int;
		/**是否深度写入。*/
		public var depthWrite:Boolean;
		
		/**
		 * 创建一个 <code>RenderState</code> 实例。
		 */
		public function RenderState() {
			cull = CULL_BACK;
			blend = BLEND_DISABLE;
			srcBlend = BLENDPARAM_ONE;
			dstBlend = BLENDPARAM_ZERO;
			srcBlendRGB = BLENDPARAM_ONE;
			dstBlendRGB = BLENDPARAM_ZERO;
			srcBlendAlpha = BLENDPARAM_ONE;
			dstBlendAlpha = BLENDPARAM_ZERO;
			blendConstColor = new Vector4(1, 1, 1, 1);
			blendEquation = BLENDEQUATION_ADD;
			blendEquationRGB = BLENDEQUATION_ADD;
			blendEquationAlpha = BLENDEQUATION_ADD;
			depthTest = DEPTHTEST_LEQUAL;
			depthWrite = true;
		}
		
		/**
		 * 设置渲染相关状态。
		 */
		public function _setRenderStateBlendDepth():void {
			var gl:WebGLContext = LayaGL.instance;
			WebGLContext.setDepthMask(gl, depthWrite);
			if (depthTest === DEPTHTEST_OFF)
				WebGLContext.setDepthTest(gl, false);
			else {
				WebGLContext.setDepthTest(gl, true);
				WebGLContext.setDepthFunc(gl, depthTest);
			}
			
			switch (blend) {
			case BLEND_DISABLE: 
				WebGLContext.setBlend(gl, false);
				break;
			case BLEND_ENABLE_ALL: 
				WebGLContext.setBlend(gl, true);
				WebGLContext.setBlendFunc(gl, srcBlend, dstBlend);
				break;
			case BLEND_ENABLE_SEPERATE: 
				WebGLContext.setBlend(gl, true);
				//TODO:
				break;
			}
		}
		
		/**
		 * 设置渲染相关状态。
		 */
		public function _setRenderStateFrontFace(isTarget:Boolean, transform:Transform3D):void {
			var gl:WebGLContext = LayaGL.instance;
			var forntFace:int;
			switch (cull) {
			case CULL_NONE: 
				WebGLContext.setCullFace(gl, false);
				break;
			case CULL_FRONT: 
				WebGLContext.setCullFace(gl, true);
				if (isTarget) {
					if (transform && transform._isFrontFaceInvert)
						forntFace = WebGLContext.CCW;
					else
						forntFace = WebGLContext.CW;
				} else {
					if (transform && transform._isFrontFaceInvert)
						forntFace = WebGLContext.CW;
					else
						forntFace = WebGLContext.CCW;
				}
				WebGLContext.setFrontFace(gl, forntFace);
				break;
			case CULL_BACK: 
				WebGLContext.setCullFace(gl, true);
				if (isTarget) {
					if (transform && transform._isFrontFaceInvert)
						forntFace = WebGLContext.CW;
					else
						forntFace = WebGLContext.CCW;
				} else {
					if (transform && transform._isFrontFaceInvert)
						forntFace = WebGLContext.CCW;
					else
						forntFace = WebGLContext.CW;
				}
				WebGLContext.setFrontFace(gl, forntFace);
				break;
			}
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(dest:*):void {
			var destState:RenderState = dest as RenderState;
			destState.cull = cull;
			destState.blend = blend;
			destState.srcBlend = srcBlend;
			destState.dstBlend = dstBlend;
			destState.srcBlendRGB = srcBlendRGB;
			destState.dstBlendRGB = dstBlendRGB;
			destState.srcBlendAlpha = srcBlendAlpha;
			destState.dstBlendAlpha = dstBlendAlpha;
			blendConstColor.cloneTo(destState.blendConstColor);
			destState.blendEquation = blendEquation;
			destState.blendEquationRGB = blendEquationRGB;
			destState.blendEquationAlpha = blendEquationAlpha;
			destState.depthTest = depthTest;
			destState.depthWrite = depthWrite;
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var dest:RenderState = __JS__("new this.constructor()");
			cloneTo(dest);
			return dest;
		}
	
	}

}