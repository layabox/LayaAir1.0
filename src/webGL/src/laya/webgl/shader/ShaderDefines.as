package laya.webgl.shader {
	
	public class ShaderDefines {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		public var _value:int = 0;
		
		private var _name2int:Object;
		private var _int2name:Array;
		private var _int2nameMap:Array;
		
		public function ShaderDefines(name2int:Object, int2name:Array, int2nameMap:Array) {
			_name2int = name2int;
			_int2name = int2name;
			_int2nameMap = int2nameMap;
		}
		
		public function add(value:*):int {
			if (value is String) value = _name2int[value];
			_value |= value;
			return _value;
		}
		
		public function addInt(value:int):int {
			_value |= value;
			return _value;
		}
		
		public function remove(value:*):int {
			if (value is String) value = _name2int[value];
			_value &= (~value);
			return _value;
		}
		
		public function isDefine(def:int):Boolean {
			return (_value & def) === def;
		}
		
		public function getValue():int {
			return _value;
		}
		
		public function setValue(value:int):void {
			_value = value;
		}
		
		public function toNameDic():Object {
			var r:String = _int2nameMap[_value];
			return r ? r : _toText(_value, _int2name, _int2nameMap);
		}
		
		public static function _reg(name:String, value:int, _name2int:Object, _int2name:Array):void {
			_name2int[name] = value;
			_int2name[value] = name;
		}
		
		public static function _toText(value:int, _int2name:Array, _int2nameMap:Object):Object {
			var r:String = _int2nameMap[value];
			if (r) return r;
			var o:Object = {};
			var d:int = 1;
			for (var i:int = 0; i < 32; i++) {
				d = 1 << i;
				if (d > value) break;
				if (value & d) {
					var name:String = _int2name[d];
					name && (o[name] = "");
				}
			}
			_int2nameMap[value] = o;
			return o;
		}
		
		public static function _toInt(names:String, _name2int:Object):int {
			var words:Array = names.split('.');
			var num:int = 0;
			for (var i:int = 0, n:int = words.length; i < n; i++) {
				var value:int = _name2int[words[i]];
				if (!value) throw new Error("Defines to int err:" + names + "/" + words[i]);
				num |= value;
			}
			return num;
		}
	}

}