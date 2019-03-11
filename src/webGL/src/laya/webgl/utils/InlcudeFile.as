package laya.webgl.utils {
	
	public class InlcudeFile {
		public var script:String;
		public var codes:* = {};
		public var funs:* = {};
		public var curUseID:int = -1;
		public var funnames:String = "";
		
		public function InlcudeFile(txt:String) {
			script = txt;
			var begin:int = 0, ofs:int, end:int;
			while (true) {
				begin = txt.indexOf("#begin", begin);
				if (begin < 0) break;
				
				end = begin + 5;
				while (true) {
					end = txt.indexOf("#end", end);
					if (end < 0) break;
					if (txt.charAt(end + 4) === 'i')
						end += 5;
					else break;
				}
				
				if (end < 0) {
					throw "add include err,no #end:" + txt;
				}
				
				ofs = txt.indexOf('\n', begin);
				var words:Array = ShaderCompile.splitToWords(txt.substr(begin, ofs - begin), null);
				if (words[1] == 'code') {
					codes[words[2]] = txt.substr(ofs + 1, end - ofs - 1);
				} else if (words[1] == 'function')//#begin function void test()
				{
					ofs = txt.indexOf("function", begin);
					ofs += "function".length;
					funs[words[3]] = txt.substr(ofs + 1, end - ofs - 1);
					funnames += words[3] + ";";
				}
				
				begin = end + 1;
			}
		}
		
		public function getWith(name:String = null):String {
			var r:String = name ? codes[name] : script;
			if (!r) {
				throw "get with error:" + name;
			}
			return r;
		}
		
		public function getFunsScript(funsdef:String):String {
			var r:String = "";
			for (var i:String in funs) {
				if (funsdef.indexOf(i + ";") >= 0) {
					r += funs[i];
				}
			}
			return r;
		}
	
	}

}