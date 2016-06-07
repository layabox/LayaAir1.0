/*[IF-FLASH]*/
package {
	
	/**
	 *  XML适配类，本类只用于适配js原生XML接口，在AS环境下提供对应的代码提示，代码真正执行时执行原生jsXML代码
	 */
	public dynamic class XmlDom {
		/**
		 * NodeList 对象，表示节点集合。
		 */
		public var childNodes:Array;
		/**
		 * Node 对象，节点的子节点。
		 */
		public var firstChild:XmlDom;
		/**
		 * 被选节点的最后一个子节点。如果选定的节点没有子节点，则该属性返回 NULL。
		 */
		public var lastChild:XmlDom;
		/**
		 * 被选元素的本地名称（元素名称）。如果选定的节点不是元素或属性，则该属性返回 NULL。
		 */
		public var localName:String;
		/**
		 * 指定节点之后紧跟的节点，在相同的树层级中。被返回的节点以 Node 对象返回。
		 */
		public var nextSibling:XmlDom;
		/**
		 * 指定节点的节点名称。
		 * 如果节点是元素节点，则 nodeName 属性返回标签名。
		 * 入股节点是属性节点，则 nodeName 属性返回属性的名称。
		 * 对于其他节点类型，nodeName 属性返回不同节点类型的不同名称。
		 */
		public var nodeName:String;
		/**
		 * 以数字值返回指定节点的节点类型。
		 * 如果节点是元素节点，则 nodeType 属性将返回 1。
		 * 如果节点是属性节点，则 nodeType 属性将返回 2。
		 */
		public var nodeType:String;
		/**
		 * 设置或返回指定节点的节点值。
		 */
		public var nodeValue:*;
		/**
		 * 以 Node 对象的形式返回指定节点的父节点。如果指定节点没有父节点，则返回 null。
		 */
		public var parentNode:XmlDom;
		/**
		 * 返回指定节点的属性集合，即 NamedNodeMap。
		 */
		public var attributes:Object;
		
		/**
		 * 添加的节点。
		 * @param	node 您希望添加的节点对象。
		 * @return
		 */
		public function appendChild(node:XmlDom):XmlDom {
			return null;
		}
		
		/**
		 * 删除子节点。
		 * @param	node
		 * @return
		 */
		public function removeChild(node:XmlDom):XmlDom {
			return null;
		}
		
		/**
		 * 克隆节点。
		 * @return
		 */
		public function cloneNode():XmlDom {
			return null;
		}
		
		/**
		 * 返回带有指定标签名的对象集合。
		 * @param	name
		 * @return
		 */
		public function getElementsByTagName(name:String):Array {
			return null;
		}
		
		/**
		 * 返回带有指定名称和命名空间的所有元素的一个节点列表。
		 * @param	ns 字符串值，可规定需检索的命名空间名称。值 "*" 可匹配所有的标签。
		 * @param	name 字符串值，可规定需检索的标签名。值 "*" 可匹配所有的标签。
		 * @return
		 */
		public function getElementsByTagNameNS(ns:String, name:String):Array {
			return null;
		}
		
		/**
		 * 把指定属性设置或修改为指定的值。
		 * @param	name 您希望添加的属性的名称。
		 * @param	value 您希望添加的属性值。
		 */
		public function setAttribute(name:String, value:*):void {
		
		}
		
		/**
		 * 返回指定的属性值。
		 * @param	name 需要获得属性值的属性名称。
		 * @return
		 */
		public function getAttribute(name:String):* {
			return null;
		}
		
		/**
		 * 创建或改变具有命名空间的属性。
		 * @param	ns 规定要设置的属性的命名空间 URI。
		 * @param	name 规定要设置的属性的名称。
		 * @param	value 规定要设置的属性的值。
		 */
		public function setAttributeNS(ns:String, name:String, value:*):void {
		
		}
		
		/**
		 * 通过命名空间 URI 和名称来获取属性值。
		 * @param	ns 规定从中获取属性值的命名空间 URI
		 * @param	name 规定从中取得属性值的属性。
		 * @return
		 */
		public function getAttributeNS(ns:String, name:String):* {
			return null;
		}
	}
}