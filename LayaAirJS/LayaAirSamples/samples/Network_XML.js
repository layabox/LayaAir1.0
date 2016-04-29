var Utils = Laya.Utils;

Laya.init(100, 100);

var xmlValueContainsError = "<root><item>item a</item><item>item b</item>somethis...</root1>";
var xmlValue = "<root><item>item a</item><item>item b</item>somethings...</root>";

proessXML(Utils.parseXMLFromString(xmlValueContainsError));
console.log("\n");
proessXML(Utils.parseXMLFromString(xmlValue));

// 使用xml
function proessXML(xml)
{
	var parserError = getParserError(xml);
	if (parserError)
	{
		console.log(parserError);
	}
	else
	{
		printDirectChildren(xml);
	}
}

// 是否存在解析错误
function getParserError(xml)
{
	var error = xml.firstChild.firstChild.nodeName == "parsererror";
	return error ? xml.firstChild.firstChild.textContent : null;
}

// 打印直接子级
function printDirectChildren(xml)
{
	var rootNode = xml.firstChild;

	var nodes = rootNode.childNodes;
	for (var i = 0; i < nodes.length; i++)
	{
		var node = nodes[i];

		// 本节点为元素节点
		if (node.nodeType == 1)
		{
			console.log("节点名称： " + node.nodeName);
			console.log("元素节点，第一个子节点值为：" + node.firstChild.nodeValue);
		}
		// 本节点是文本节点
		else if(node.nodeType == 3)
		{
			console.log("文本节点：" + node.nodeValue);
		}
		console.log("\n");
	}
}