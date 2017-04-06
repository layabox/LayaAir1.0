package laya.debug.tools
{

	
	/**
	 * 一些字符串操作函数
	 * @author ww
	 * 
	 */
	public class StringTool
	{
		public function StringTool()
		{
		}
		
		/**
		 * 返回全大写 
		 * @param str
		 * @return 
		 */
		public static function toUpCase(str:String):String
		{
			return str.toUpperCase();
		}
		
		/**
		 * 返回全小写 
		 * @param str
		 * @return 
		 */
		public static function toLowCase(str:String):String
		{
			return str.toLowerCase();
		}
		/**
		 * 返回首字母大写 
		 * @param str
		 * @return 
		 */		
		public static function toUpHead(str:String):String
		{
			var rst:String;
			if(str.length<=1) return str.toUpperCase();
			rst=str.charAt(0).toUpperCase()+str.substr(1);
			return rst;
		}
		
		/**
		 * 返回首字母小写 
		 * @param str
		 * @return 
		 */		
		public static function toLowHead(str:String):String
		{
			var rst:String;
			if(str.length<=1) return str.toLowerCase();
			rst=str.charAt(0).toLowerCase()+str.substr(1);
			return rst;
		}
		
		
		/**
		 * 包名转路径名 
		 * @param packageName
		 * @return 
		 */
		public static function packageToFolderPath(packageName:String):String
		{
			var rst:String;
			rst=packageName.replace(".","/");
			return rst;
		}
		public static function insert(str:String,iStr:String,index:int):String
		{
			return str.substring(0,index)+iStr+str.substr(index);
		}
		public static function insertAfter(str:String,iStr:String,tarStr:String,isLast:Boolean=false):String
		{
			var i:int;
			if(isLast)
			{
				i=str.lastIndexOf(tarStr);
			}else
			{
				i=str.indexOf(tarStr);
			}
			if(i>=0)
			{
				return insert(str,iStr,i+tarStr.length);
			}
			return str;
		}
		public static function insertBefore(str:String,iStr:String,tarStr:String,isLast:Boolean=false):String
		{
			var i:int;
			if(isLast)
			{
				i=str.lastIndexOf(tarStr);
			}else
			{
				i=str.indexOf(tarStr);
			}
			
			if(i>=0)
			{
				return insert(str,iStr,i);
			}
			return str;
		}
		public static function insertParamToFun(funStr:String,params:Array):String
		{
			var oldParam:Array;
			oldParam=getParamArr(funStr);
			var inserStr:String;
			inserStr=params.join(",");
			if(oldParam.length>0)
			{
				inserStr=","+inserStr;
			}
			return insertBefore(funStr,inserStr,")",true);
			
		}
		/**
		 * 去除空格和换行符
		 * @param str
		 * @return 
		 */
		public static function trim(str:String,vList:Array=null):String
		{
			if(!vList)
			{
				vList=[" ","\r","\n","\t",String.fromCharCode(65279)];
			}
			var rst:String;
			var i:int;
			var len:int;
			rst=str;
			len=vList.length;
			for(i=0;i<len;i++)
			{
				rst=getReplace(rst,vList[i],"");
			}
			return rst;
		}
		public static const emptyStrDic:Object=
			{
				" ":true,
				"\r":true,
				"\n":true,
				"\t":true
			};
		public static function isEmpty(str:String):Boolean
		{
			if(str.length<1) return true;
			return emptyStrDic.hasOwnProperty(str);
		}
		public static function trimLeft(str:String):String
		{
			var i:int;
			i=0;
		    var len:int;
			len=str.length;
			while(isEmpty(str.charAt(i))&&i<len)
			{
				i++;
			}
			if(i<len)
			{
				return str.substr(i);
			}
			return "";
		}
		public static function trimRight(str:String):String
		{
			var i:int;
			i=str.length-1;
//			trace(str+" "+str.length);
			while(isEmpty(str.charAt(i))&&i>=0)
			{
//				i=str.length-1;
				i--;
			}
//			trace(str.charAt(i));
			var rst:String;
			rst=str.substring(0,i)
//			trace(rst+" "+rst.length);
			if(i>=0)
			{
				return str.substring(0,i+1);
			}
			return "";
		}
		public static function trimSide(str:String):String
		{
			var rst:String;
			rst=trimLeft(str);
			rst=trimRight(rst);
			return rst;
		}
		
		public static var specialChars:Object={"*":true,"&":true,"%":true,"#":true,"?":true};
		public static function isOkFileName(fileName:String):Boolean
		{
			if(StringTool.trimSide(fileName)=="") return false;
			var i:int,len:int;
			len=fileName.length;
			for(i=0;i<len;i++)
			{
				if(specialChars[fileName.charAt(i)]) return false;
			}
			return true;
		}
		public static function trimButEmpty(str:String):String
		{
			return trim(str,["\r","\n","\t"]);
		}
		
		public static function removeEmptyStr(strArr:Array):Array
		{
			var i:int;
			i=strArr.length-1;
			var str:String;
			for(i=i;i>=0;i--)
			{
				str=strArr[i];
				str=StringTool.trimSide(str);
				
				if(isEmpty(str))
				{
					strArr.splice(i,1);
				}else
				{
					strArr[i]=str;
				}
			}
			return strArr;
		}
		public static function ifNoAddToTail(str:String,sign:String):String
		{
			if(str.indexOf(sign)>=0)
			{
				return str;
			}
			return str+sign;
		}


		public static function trimEmptyLine(str:String):String
		{
			var i:int;
			var len:int;
			var tLines:Array;
		    var tLine:String;
			tLines=str.split("\n");
			for(i=tLines.length-1;i>=0;i--)
			{
				tLine=tLines[i];
				if(isEmptyLine(tLine))
				{
					tLines.splice(i,1);
				}
			}
			return tLines.join("\n");
		}


		public static function isEmptyLine(str:String):Boolean
		{
			str=StringTool.trim(str);
			if(str=="") return true;
			return false;
		}
		public static function removeCommentLine(lines:Array):Array
		{
			var rst:Array;
			rst=[];
			var i:int;
			var tLine:String;
			var adptLine:String;
			i=0;
			var len:int;
			var index:int;
			len=lines.length;
			while(i<len)
			{
				adptLine = tLine = lines[i];
				index = tLine.indexOf("/**");
				if(index>=0)
				{
					adptLine=tLine.substring(0,index-1);
					addIfNotEmpty(rst,adptLine);
					//				    i++;
					while(i<len)
					{
						tLine = lines[i];
						index = tLine.indexOf("*/");
						if(index>=0)
						{
							adptLine=tLine.substring(index+2);
							addIfNotEmpty(rst,adptLine);
							break;
						}
						i++;
					}
				}else if(tLine.indexOf("//")>=0)
				{
					if(StringTool.trim(tLine).indexOf("//")==0)
					{
					}else
					{
						addIfNotEmpty(rst,adptLine);
					}
				}else
				{
					addIfNotEmpty(rst,adptLine);
				}
				i++;
			}
			
			return rst;
		}

		public static function addIfNotEmpty(arr:Array,str:String):void
		{
			if(!str) return;
			var tStr:String;
			tStr=trim(str);
			if(tStr!="")
			{
				arr.push(str);
			}
		}
		public static function trimExt(str:String,vars:Array):String
		{
			var rst:String;
			rst=trim(str);
			var i:int;
			var len:int;
			len=vars.length;
			for(i=0;i<len;i++)
			{
				rst=getReplace(rst,vars[i],"");
			}
			return rst;
		}
		public static function getBetween(str:String,left:String,right:String,ifMax:Boolean=false):String
		{
			if(!str) return "";
			if(!left) return "";
			if(!right) return "";
			var lId:int;
			var rId:int;
			lId=str.indexOf(left);
			if(lId<0) return"";
			if(ifMax)
			{
				rId=str.lastIndexOf(right);
				if(rId<lId) return "";
			}else
			{
				rId=str.indexOf(right,lId+1);
			}
			
			if(rId<0) return "";
			return str.substring(lId+left.length,rId);
		}
		public static function getSplitLine(line:String,split:String=" "):Array
		{
			return line.split(split);
		}
		public static function getLeft(str:String,sign:String):String
		{
			var i:int;
			i=str.indexOf(sign);
			return str.substr(0,i);
		}
		public static function getRight(str:String,sign:String):String
		{
			var i:int;
			i=str.indexOf(sign);
			return str.substr(i+1);
		}
		public static function delelteItem(arr:Array):void
		{
			while (arr.length>0)
			{
				if(arr[0]=="")
				{
					arr.shift();
				}else
				{
					break;
				}
			}
		}
		public static function getWords(line:String):Array
		{
			var rst:Array=getSplitLine(line);
			delelteItem(rst);
			return rst;
		}

		public static function getLinesI(startLine:int,endLine:int,lines:Array):Array
		{
			var i:int;
			var rst:Array=[];
			for(i=startLine;i<=endLine;i++)
			{
				rst.push(lines[i]);
			}
			return rst;
		}
		public static function structfy(str:String,inWidth:int=4,removeEmpty:Boolean=true):String
		{
			if(removeEmpty)
			{
				str=StringTool.trimEmptyLine(str);
			}
			var lines:Array;
			var tIn:int;
			tIn=0;
			var tInStr:String;
			tInStr=getEmptyStr(0);
			lines=str.split("\n");
			var i:int;
			var len:int;
			var tLineStr:String;
			len=lines.length;
			for(i=0;i<len;i++)
			{
				tLineStr=lines[i];
//				tLineStr=StringTool.trimSide(tLineStr);
				tLineStr=StringTool.trimLeft(tLineStr);
				tLineStr=StringTool.trimRight(tLineStr);
				tIn+=getPariCount(tLineStr);
//				if(tLineStr=="}")
//				{
//					tLineStr=getEmptyStr(tIn*2)+tLineStr;
//				}else
//				{
//					tLineStr=tInStr+tLineStr;
//				}
				if(tLineStr.indexOf("}")>=0)
				{
					tInStr=getEmptyStr(tIn*inWidth);
				}
				tLineStr=tInStr+tLineStr;
				lines[i]=tLineStr;
				tInStr=getEmptyStr(tIn*inWidth);
				
			}
			return lines.join("\n");
		}
		public static var emptyDic:Object={};
		public static function getEmptyStr(width:int):String
		{
			if(!emptyDic.hasOwnProperty(width))
			{
				var i:int;
				var len:int;
				len=width;
				var rst:String;
				rst="";
				for(i=0;i<len;i++)
				{
					rst+=" ";
				}
				emptyDic[width]=rst;
			}
			return emptyDic[width];
		}
		public static function getPariCount(str:String,inChar:String="{",outChar:String="}"):int
		{
			var varDic:Object;
			varDic={};
			varDic[inChar]=1;
			varDic[outChar]=-1;
			var i:int;
			var len:int;
			var tChar:String;
			len=str.length;
			var rst:int;
			rst=0;
			for(i=0;i<len;i++)
			{
				tChar=str.charAt(i);
				if(varDic.hasOwnProperty(tChar))
				{
					rst+=varDic[tChar];
				}
			}
			return rst;
		}
		public static function readInt(str:String,startI:int=0):Number
		{
			var rst:Number;
			rst=0;
			var tNum:int;
			var tC:String;
			var i:int;
			var isBegin:Boolean;
			isBegin=false;
			var len:int;
			len=str.length;
			for(i=startI;i<len;i++)
			{
				tC=str.charAt(i);
				if(Number(tC)>0||tC=="0")
				{
					rst=10*rst+Number(tC);
					if(rst>0) isBegin=true;
				}else
				{
					if(isBegin) return rst;
				}
			}
			return rst;
		}
		/**
		 * 替换文本 
		 * @param str
		 * @param oStr
		 * @param nStr
		 * @return 
		 */
		public static function getReplace(str:String,oStr:String,nStr:String):String
		{
			if(!str) return "";
//			if(!oStr) return str;
//			if(!nStr) return str;
			var rst:String;
			rst=str.replace(new RegExp(oStr, "g"),nStr);
			return rst;
		}
		public static function getWordCount(str:String,findWord:String):int
		{
			var rg:RegExp=new RegExp(findWord, "g")
			return str.match(rg).length;
		}
		public static function getResolvePath(path:String,basePath:String):String
		{
			if(isAbsPath(path))
			{
				return path;
			}
			var tSign:String;
			tSign="\\";
			if(basePath.indexOf("/")>=0)
			{
				tSign="/";
			}
			if(basePath.charAt(basePath.length-1)==tSign)
			{
				basePath=basePath.substr(0,basePath.length-1);
			}
			var parentSign:String;
			parentSign=".."+tSign;
			var tISign:String;
			tISign="."+tSign;
			var pCount:int;
			pCount=getWordCount(path,parentSign);
			path=StringTool.getReplace(path,parentSign,"");
			path=StringTool.getReplace(path,tISign,"");
			var i:int;
			var len:int;
			len=pCount;
			var iPos:int;
			for(i=0;i<len;i++)
			{
				basePath=removeLastSign(path,tSign);
			}
			return basePath+tSign+path;
		}
		public static function isAbsPath(path:String):Boolean
		{
			if(path.indexOf(":")>=0) return true;
			return false;
		}
		public static function removeLastSign(str:String,sign:String):String
		{
			var iPos:int;
			iPos=str.lastIndexOf(sign);
			str=str.substring(0,iPos);
			return str;
		}
		public static function getParamArr(str:String):Array
		{
			var paramStr:String;
			paramStr= StringTool.getBetween(str,"(",")",true);
			if(trim(paramStr).length<1) return [];
			return paramStr.split(",");
		}
		
		
		public static function copyStr(str:String):String
		{
			return str.substring();
		}
	
		/**
		 * 将Array转成字符串
		 * @param arr
		 * @return 
		 */
		public static function ArrayToString(arr:Array):String
		{
			var rst:String;
			rst="[{items}]".replace(new RegExp("\\{items\\}", "g"),  getArrayItems(arr));
			return rst;
		}
		
		public static function getArrayItems(arr:Array):String
		{
			var rst:String;
			
			if(arr.length<1) return "";
			rst=parseItem(arr[0]);
			
			var i:int;
			var len:int;
			len=arr.length;
			for(i=1;i<len;i++)
			{
				rst+=","+parseItem(arr[i]);
			}
			
			
			return rst;
		}
		public static function parseItem(item:*):String
		{
			var rst:String;
			rst="\""+item+"\"";
			return "";
		}

		public static var alphaSigns:Object=null;
		public static function initAlphaSign():void
		{
			if (alphaSigns) return;
			alphaSigns = { };
			addSign("a","z",alphaSigns);
			addSign("A","Z",alphaSigns);
			addSign("0","9",alphaSigns);
		}
		public static function addSign(ss:String,e:String,tar:Object):void
		{
			var i:int;
			var len:int;
			var s:int;
			s=ss.charCodeAt(0);
			len=e.charCodeAt(0);
			for(i=s;i<=len;i++)
			{
				tar[String.fromCharCode(i)]=true;
				trace("add :"+String.fromCharCode(i));
			}
		}
		public static function isPureAlphaNum(str:String):Boolean
		{
			initAlphaSign();
			if (!str) return true;
			var i:int, len:int;
			len = str.length;
			for (i = 0; i < len; i++)
			{
				if (!alphaSigns[str.charAt(i)]) return false;
			}
			return true;
		}
	}
}