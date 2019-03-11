package laya.webgl.text {
	import laya.maths.Point;
	import laya.webgl.resource.CharRenderInfo;
	/**
	 *  文字贴图的大图集。
	 */
	public class TextAtlas {
		public   var texWidth:int = 1024;
		public   var texHeight:int = 1024;
		private  var atlasgrid:AtlasGrid ;
		private  var protectDist:int = 1;
		public   var texture:TextTexture = null;
		public   var charMaps:Object = { };		// 保存文字信息的字典
		public static  var atlasGridW:int = 16;
		
		public function TextAtlas():void {
			texHeight = texWidth = TextRender.atlasWidth;
			texture = TextTexture.getTextTexture( texWidth, texHeight);
			if (texWidth / atlasGridW > 256) {
				atlasGridW = Math.ceil( texWidth / 256);
			}
			atlasgrid = new AtlasGrid(texWidth / atlasGridW, texHeight / atlasGridW, texture.id);
		}
		
		public function setProtecteDist(d:int):void {
			protectDist = d;
		}
		
		/**
		 * 如果返回null，则表示无法加入了
		 * 分配的时候优先选择最接近自己高度的节点
		 * @param	w
		 * @param	h
		 * @return
		 */
		public function getAEmpty(w:int, h:int, pt:Point):Boolean {
			var find:Boolean = atlasgrid.addRect(1, Math.ceil(w / atlasGridW), Math.ceil(h / atlasGridW), pt);
			if (find) {
				pt.x *= atlasGridW;
				pt.y *= atlasGridW;
			}
			return find;
		}
		
		/**
		 * 大图集格子单元的占用率，老的也算上了。只是表示这个大图集还能插入多少东西。
		 */
		public function get usedRate():Number {
			return atlasgrid._used;
		}
		//data 也可能是canvas
		/*
		public function pushData(data:ImageData, node:TextAtlasNode):void {
			texture.addChar(data, node.x, node.y);
		}
		*/
		
		public function destroy():void {
			for ( var k:String in charMaps) {
				var ri:CharRenderInfo = charMaps[k];
				ri.deleted = true;
			}
			texture.discard();
		}
		
		public function printDebugInfo():void {
			
		}
	}
}	