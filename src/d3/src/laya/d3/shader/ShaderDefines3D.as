package laya.d3.shader {
	import laya.renders.Render;
	import laya.webgl.shader.ShaderDefines;
	
	/**
	 * @private
	 * <code>ShaderDefines3D</code> 类用于创建3DshaderDefine相关。
	 */
	public class ShaderDefines3D extends ShaderDefines {
		public static const FSHIGHPRECISION:int = 0x80;
		
		public static const VR:int = 0x40;
		public static const FOG:int = 0x200;
		public static const DIRECTIONLIGHT:int = 0x1000;
		public static const POINTLIGHT:int = 0x2000;
		public static const SPOTLIGHT:int = 0x4000;
		
		//public static const MIXUV:int = 0x10000;//TODO：
		public static const DIFFUSEMAP:int = 0x1;
		public static const NORMALMAP:int = 0x2;
		public static const SPECULARMAP:int = 0x4;
		public static const EMISSIVEMAP:int = 0x8;
		public static const AMBIENTMAP:int = 0x10;
		public static const REFLECTMAP:int = 0x20;
		public static const UVTRANSFORM:int = 0x100;
		public static const UV:int = 0x400;
		public static const COLOR:int = 0x800;
		public static const BONE:int = 0x8000;
		public static const SKINNED:int = 0x10000;
		public static const ALPHATEST:int = 0x20000;
		public static const PARTICLE3D:int = 0x40000;
		
		//ShurikenParticle
		public static const SPHERHBILLBOARD:int = 0x80000;
		public static const STRETCHEDBILLBOARD:int = 0x100000;
		public static const HORIZONTALBILLBOARD:int = 0x200000;
		public static const VERTICALBILLBOARD:int = 0x400000;
		
		public static const COLOROVERLIFETIME:int = 0x800000;
		public static const RANDOMCOLOROVERLIFETIME:int = 0x1000000;
		
		public static const SIZEOVERLIFETIME:int = 0x2000000;
		public static const ROTATIONOVERLIFETIME:int = 0x4000000;
		public static const TEXTURESHEETANIMATION:int = 0x8000000;
		public static const VELOCITYOVERLIFETIME:int = 0x10000000;
		
		private static var _name2int:Object = {};
		private static var _int2name:Array = [];
		private static var _int2nameMap:Array = [];
		
		public static function __init__():void {
			reg("FSHIGHPRECISION", FSHIGHPRECISION);
			
			reg("DIFFUSEMAP", DIFFUSEMAP);
			reg("NORMALMAP", NORMALMAP);
			reg("SPECULARMAP", SPECULARMAP);
			reg("EMISSIVEMAP", EMISSIVEMAP);
			reg("AMBIENTMAP", AMBIENTMAP);
			reg("REFLECTMAP", REFLECTMAP);
			reg("PARTICLE3D", PARTICLE3D);
			
			reg("COLOR", COLOR);
			reg("UV", UV);
			reg("SKINNED", SKINNED);
			reg("DIRECTIONLIGHT", DIRECTIONLIGHT);
			reg("POINTLIGHT", POINTLIGHT);
			reg("SPOTLIGHT", SPOTLIGHT);
			reg("BONE", BONE);
			reg("ALPHATEST", ALPHATEST);
			reg("UVTRANSFORM", UVTRANSFORM);
			//reg("MIXUV", MIXUV);
			reg("FOG", FOG);
			reg("VR", VR);
			
			reg("SPHERHBILLBOARD", SPHERHBILLBOARD);
			reg("STRETCHEDBILLBOARD", STRETCHEDBILLBOARD);
			reg("HORIZONTALBILLBOARD", HORIZONTALBILLBOARD);
			reg("VERTICALBILLBOARD", VERTICALBILLBOARD);
			reg("COLOROVERLIFETIME", COLOROVERLIFETIME);
			reg("RANDOMCOLOROVERLIFETIME", RANDOMCOLOROVERLIFETIME);
			
			reg("SIZEOVERLIFETIME", SIZEOVERLIFETIME);
			
			reg("ROTATIONOVERLIFETIME", ROTATIONOVERLIFETIME);
			reg("TEXTURESHEETANIMATION", TEXTURESHEETANIMATION);
			reg("VELOCITYOVERLIFETIME", VELOCITYOVERLIFETIME);
		}
		
		public function ShaderDefines3D() {
			super(_name2int, _int2name, _int2nameMap);
		}
		
		public static function reg(name:String, value:int):void {
			_reg(name, value, _name2int, _int2name);
			if (Render.isConchNode) {//NATIVE
				__JS__("conch.regShaderDefine&&conch.regShaderDefine(name,value);")
			}
		}
		
		public static function toText(value:int, _int2name:Array, _int2nameMap:Object):* {
			return _toText(value, _int2name, _int2nameMap);
		}
		
		public static function toInt(names:String):int {
			return _toInt(names, _name2int);
		}
	
	}

}