/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Utils = laya.utils.Utils;
    var Network_XML = (function () {
        function Network_XML() {
            Laya.init(100, 100);
            var xmlValueContainsError = "<root><item>item a</item><item>item b</item>somethis...</root1>";
            var xmlValue = "<root><item>item a</item><item>item b</item>somethings...</root>";
            this.proessXML(Utils.parseXMLFromString(xmlValueContainsError));
            console.log("\n");
            this.proessXML(Utils.parseXMLFromString(xmlValue));
        }
        // 使用xml
        Network_XML.prototype.proessXML = function (xml) {
            var parserError = this.getParserError(xml);
            if (parserError) {
                console.log(parserError);
            }
            else {
                this.printDirectChildren(xml);
            }
        };
        // 是否存在解析错误
        Network_XML.prototype.getParserError = function (xml) {
            var error = xml.firstChild.firstChild.nodeName == "parsererror";
            return error ? xml.firstChild.firstChild.textContent : null;
        };
        // 打印直接子级
        Network_XML.prototype.printDirectChildren = function (xml) {
            var rootNode = xml.firstChild;
            var nodes = rootNode.childNodes;
            for (var i = 0; i < nodes.length; i++) {
                var node = nodes[i];
                // 本节点为元素节点
                if (node.nodeType == 1) {
                    console.log("节点名称: " + node.nodeName);
                    console.log("元素节点，第一个子节点值为：" + node.firstChild.nodeValue);
                }
                else if (node.nodeType == 3) {
                    console.log("文本节点：" + node.nodeValue);
                }
                console.log("\n");
            }
        };
        return Network_XML;
    }());
    laya.Network_XML = Network_XML;
})(laya || (laya = {}));
new laya.Network_XML();
