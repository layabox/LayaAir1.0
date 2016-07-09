package
{
	import laya.utils.Utils;
	
	public class Network_XML
	{
		
		public function Network_XML()
		{
			Laya.init(550, 400);
			
			setup();
		}
		
		private function setup():void
		{
			var xmlValueContainsError:String = "<root><item>item a</item><item>item b</item>somethis...</root1>";
			var xmlValue:String = "<root><item>item a</item><item>item b</item>somethings...</root>";
			
			proessXML(xmlValueContainsError);
			trace("\n");
			proessXML(xmlValue);
		}
		
		// 使用xml
		private function proessXML(source:String):void
		{
			try
			{
				var xml:XmlDom = Utils.parseXMLFromString(source);
			}
			catch (e:Error)
			{
				trace(e.massage);
				return;
			}
			
			printDirectChildren(xml);
		}
		
		// 打印直接子级
		private function printDirectChildren(xml:XmlDom):void
		{
			var rootNode:XmlDom = xml.firstChild as XmlDom;
			
			var nodes:Array = rootNode.childNodes;
			for (var i:int = 0; i < nodes.length; i++)
			{
				var node:Object = nodes[i];
				
				// 本节点为元素节点
				if (node.nodeType == 1)
				{
					trace("节点名称: " + node.nodeName);
					trace("元素节点，第一个子节点值为：" + node.firstChild.nodeValue);
				}
				// 本节点是文本节点
				else if (node.nodeType == 3)
				{
					trace("文本节点：" + node.nodeValue);
				}
				trace("\n");
			}
		}
	
	}
}