(function()
{
	var Utils = laya.utils.Utils;

	(function(){
			Laya.init(550, 400);
			setup();
	})();
	function setup()
	{
		var xmlValueContainsError = "<root><item>item a</item><item>item b</item>somethis...</root1>";
		var xmlValue = "<root><item>item a</item><item>item b</item>somethings...</root>";
		
		proessXML(xmlValueContainsError);
		console.log("\n");
		proessXML(xmlValue);
	}
	function proessXML(source)
	{
		try
		{
			var xml = Utils.parseXMLFromString(source);
		}
		catch (e)
		{
			console.log(e.massage);
			return;
		}
		
		printDirectChildren(xml);
	}
	function printDirectChildren(xml)
	{
		var rootNode = xml.firstChild ;
		
		var nodes = rootNode.childNodes;
		for (var i = 0; i < nodes.length; i++)
		{
			var node = nodes[i];
			
			// 本节点为元素节点
			if (node.nodeType == 1)
			{
				console.log("节点名称: " + node.nodeName);
				console.log("元素节点，第一个子节点值为：" + node.firstChild.nodeValue);
			}
			// 本节点是文本节点
			else if (node.nodeType == 3)
			{
				console.log("文本节点：" + node.nodeValue);
			}
			console.log("\n");
		}
	}
})();
