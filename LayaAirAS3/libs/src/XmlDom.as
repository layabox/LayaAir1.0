/*[IF-FLASH]*/package{	
	/**
	 *  XML适配类，本类只用于适配js原生XML接口，在AS环境下提供对应的代码提示，代码真正执行时执行原生jsXML代码
	 * @author ww
	 * @version 1.0
	 * @created  2015-9-21 上午11:24:57
	 */
	public dynamic class XmlDom {
		public var childNodes:Array;
		public var firstChild:XmlDom;
		public var lastChild:XmlDom;
		public var localName:String;
		public var nextSibling:XmlDom;
		public var nodeName:String;
		public var nodeType:String;
		public var nodeValue:*;
		public var parentNode:XmlDom;
		public var attributes:Object;
		
		public function appendChild(node:XmlDom):XmlDom 
		{
			return null;
		}
		
		public function removeChild(node:XmlDom):XmlDom 
		{
			return null;
		}
		
		public function cloneNode():XmlDom 
		{
			return null;
		}
		
		public function getElementsByTagName(name:String):Array 
		{
			return null;
		}
		
		public function getElementsByTagNameNS(ns:String, name:String):Array 
		{
			return null;
		}
		
		public function setAttribute(name:String, value:*):void 
		{
		
		}
		
		public function getAttribute(name:String):* 
		{
			return null;
		}
		
		public function setAttributeNS(ns:String, name:String, value:*):void 
		{
		
		}
		
		public function getAttributeNS(ns:String, name:String):* 
		{
			return null;
		}
	}
}