package laya.webgl.utils {
	import laya.utils.Browser;
	import laya.webgl.shader.Shader;
	
	public class ShaderCompile {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static const IFDEF_NO:int = 0;
		public static const IFDEF_YES:int = 1;
		public static const IFDEF_ELSE:int = 2;
		
		private var _VS:ShaderScriptBlock;
		private var _PS:ShaderScriptBlock;
		private var _VSTXT:String;
		private var _PSTXT:String;
		private var _nameMap:*;
		
		public function ShaderCompile(name:Number, vs:String, ps:String, nameMap:*, includeFiles:*) {
			//先要去掉注释,还没有完成			
			_VSTXT = vs;
			_PSTXT = ps;
			function split(str:String):Array//这里要修改
			{
				//replace(/(^\s*)|(\s*$)/g,"").split(/\s+/)
				var words:Array = str.split(' ');
				var out:Array = [];
				for (var i:int = 0; i < words.length; i++)
					words[i].length > 0 && out.push(words[i]);
				return out;
			}
			
			function c(script:String):ShaderScriptBlock {
				var i:int, n:int, ofs:int, words:Array, condition:Function;
				
				var top:ShaderScriptBlock = new ShaderScriptBlock(IFDEF_NO, null, null, null);
				var parent:ShaderScriptBlock = top;
				
				var lines:Array = script.split('\n');
				for (i = 0, n = lines.length; i < n; i++) {
					var line:String = lines[i];
					if (line.indexOf("#ifdef") >= 0)//这里有问题,主要是空格
					{
						words = split(line);
						parent = new ShaderScriptBlock(IFDEF_YES, words[1], "", parent);
						continue;
					}
					if (line.indexOf("#else") >= 0) {
						condition = parent.condition;
						parent = new ShaderScriptBlock(IFDEF_ELSE, null, "", parent.parent);
						parent.condition = condition;
						continue;
					}
					if (line.indexOf("#endif") >= 0) {
						parent = parent.parent;
						continue;
					}
					
					if (line.indexOf("#include") >= 0)//这里有问题,主要是空格
					{
						words = split(line);
						var fname:String = words[1];
						var chr:String = fname.charAt(0);
						if (chr === '"' || chr === "'") {
							fname = fname.substr(1, fname.length - 2);
							ofs = fname.lastIndexOf(chr);
							if (ofs > 0) fname = fname.substr(0, ofs);
						}
						ofs = words[0].indexOf('?');
						var str:String = ofs > 0 ? words[0].substr(ofs + 1) : words[0];
						new ShaderScriptBlock(IFDEF_YES, str, includeFiles[fname], parent);
						continue;
					}
					if (parent.childs.length > 0 && parent.childs[parent.childs.length - 1].type === IFDEF_NO) {
						parent.childs[parent.childs.length - 1].text += "\n" + line;
					} else new ShaderScriptBlock(IFDEF_NO, null, line, parent);
				}
				return top;
			}
			_VS = c(vs);
			_PS = c(ps);
			_nameMap = nameMap;
		}
		
		public function createShader(define:*, shaderName:*, createShader:Function):Shader {
			var defMap:* = {};
			var defineStr:String = "";
			if (define) {
				for (var i:String in define) {
					defineStr += "#define " + i + "\n";
					defMap[i] = true;
				}
			}
			//trace("createShader:" + defineStr);
			var vs:Array = _VS.toscript(defMap, []);
			var ps:Array = _PS.toscript(defMap, []);
			return (createShader as Function || Shader.create as Function)(defineStr + vs.join('\n'), defineStr + ps.join('\n'), shaderName, _nameMap);
		}
	}

}
import laya.utils.Browser;
import laya.utils.RunDriver;
import laya.webgl.utils.ShaderCompile;

class ShaderScriptBlock {
	/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
	public var type:int;
	public var condition:Function;
	public var text:String;
	public var childs:Vector.<ShaderScriptBlock> = new Vector.<ShaderScriptBlock>;
	public var parent:ShaderScriptBlock;
	
	public function ShaderScriptBlock(type:int, condition:String, text:String, parent:ShaderScriptBlock) {
		this.type = type;
		this.text = text;
		this.parent = parent;
		parent && parent.childs.push(this);
		
		if (!condition) return;
		
		/*[IF-FLASH]*/
		this.condition = RunDriver.createShaderCondition(condition);
		/*[IF-FLASH]*/
		return;
		
		//把条件的变量名加上this.
		var newcondition:String = "";
		var preIsParam:Boolean = false, isParam:Boolean;
		for (var i:int = 0, n:int = condition.length; i < n; i++) {
			var c:String = condition.charAt(i);
			isParam = "!&|() \t".indexOf(c) < 0;//不是运算符
			if (preIsParam != isParam) {
				isParam && (newcondition += "this.");
				preIsParam = isParam;
			}
			newcondition += c;
		}
		this.condition = RunDriver.createShaderCondition(newcondition);
	}
	
	public function toscript(def:*, out:Array):Array {
		if (type === ShaderCompile.IFDEF_NO) {
			text && out.push(text);
		}
		
		if (this.childs.length < 1 && !text) return out;
		
		if (type !== ShaderCompile.IFDEF_NO) {
			var ifdef:Boolean = !!condition.call(def);
			type === ShaderCompile.IFDEF_ELSE && (ifdef = !ifdef);
			if (!ifdef) return out;
			text && out.push(text);
		}
		
		this.childs.length > 0 && this.childs.forEach(function(o:ShaderScriptBlock, index:int, arr:Vector.<ShaderScriptBlock>):void {
			o.toscript(def, out)
		});
		
		return out;
	}
}