package laya.webgl.shader.d2 {
	import laya.renders.Render;
	import laya.webgl.shader.Shader;
	import laya.webgl.shader.ShaderValue;
	
	public class Shader2X extends Shader {
		public var _params2dQuick2:Array = null;
		public var _shaderValueWidth:Number = 0;
		public var _shaderValueHeight:Number = 0;
		
		public function Shader2X(vs:String, ps:String, saveName:* = null, nameMap:* = null, bindAttrib:Array=null) {
			super(vs, ps, saveName, nameMap, bindAttrib);
		}
		
		//TODO:coverage
		override protected function _disposeResource():void {
			super._disposeResource();
			_params2dQuick2 = null;
		}
		
		//TODO:coverage
		public function upload2dQuick2(shaderValue:ShaderValue):void {
			upload(shaderValue, _params2dQuick2 || _make2dQuick2());
		}
		
		//去掉size的所有的uniform
		public function _make2dQuick2():Array {
			if (!_params2dQuick2) {
				_params2dQuick2 = [];
				
				var params:Array = _params, one:*;
				for (var i:int = 0, n:int = params.length; i < n; i++) {
					one = params[i];
					if (one.name !== "size") _params2dQuick2.push(one);
				}
			}
			return _params2dQuick2;
		}
		
		public static function create(vs:String, ps:String, saveName:* = null, nameMap:* = null, bindAttrib:Array=null):Shader {
			return new Shader2X(vs, ps, saveName, nameMap, bindAttrib);
		}
	}

}