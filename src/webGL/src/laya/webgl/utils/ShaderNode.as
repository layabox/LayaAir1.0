package laya.webgl.utils {
	import laya.utils.Browser;
	import laya.webgl.utils.ShaderCompile;
	
	public class ShaderNode {
		private static var __id:int = 1;
		
		public var childs:Array = [];
		public var text:String = "";
		public var parent:ShaderNode;
		public var name:String;
		public var noCompile:Boolean;
		public var includefiles:Array;
		public var condition:*;
		public var conditionType:int;
		public var useFuns:String = "";
		public var z:int = 0;
		public var src:String;
		
		public function ShaderNode(includefiles:Array) {
			this.includefiles = includefiles;
		}
		
		public function setParent(parent:ShaderNode):void {
			parent.childs.push(this);
			this.z = parent.z + 1;
			this.parent = parent;
		}
		
		public function setCondition(condition:String, type:int):void {
			if (condition) {
				conditionType = type;
				condition = condition.replace(/(\s*$)/g, "");
				this.condition = function():Boolean {
					return this[condition];
				}
				this.condition.__condition = condition;
			}
		}
		
		public function toscript(def:*, out:Array):Array {
			return _toscript(def, out, ++__id);
		}
		
		private function _toscript(def:*, out:Array, id:int):Array {
			if (this.childs.length < 1 && !text) return out;
			var outIndex:int = out.length;
			if (condition) {
				var ifdef:Boolean = !!condition.call(def);
				conditionType === ShaderCompile.IFDEF_ELSE && (ifdef = !ifdef);
				if (!ifdef) return out;
			}
			
			text && out.push(text);
			this.childs.length > 0 && this.childs.forEach(function(o:ShaderNode, index:int, arr:Vector.<ShaderNode>):void {
				o._toscript(def, out, id);
			});
			
			if (includefiles.length > 0 && useFuns.length > 0) {
				var funsCode:String;
				for (var i:int = 0, n:int = includefiles.length; i < n; i++) {
					//如果已经加入了，就不要再加
					if (includefiles[i].curUseID == id) {
						continue;
					}
					funsCode = includefiles[i].file.getFunsScript(useFuns);
					if (funsCode.length > 0) {
						includefiles[i].curUseID = id;
						out[0] = funsCode + out[0];
					}
				}
			}
			
			return out;
		}
	}

}