/// <reference path="../../libs/LayaAir.d.ts" />
var laya;
(function (laya) {
    var Utils = laya.utils.Utils;
    var TransferFormat_XML = (function () {
        function TransferFormat_XML() {
            Laya.init(100, 100);
            var xmlValueContainsError = "<root><item>item a</item><item>item b</item>somethis...</root1>";
            var xmlValue = "<root><item>item a</item><item>item b</item>somethis...</root>";
            this.proessXML(Utils.parseXMLFromString(xmlValueContainsError));
            console.log("\n");
            this.proessXML(Utils.parseXMLFromString(xmlValue));
        }
        // 使用xml
        TransferFormat_XML.prototype.proessXML = function (xml) {
            var parserError = this.getParserError(xml);
            if (parserError) {
                console.log(parserError);
            }
            else {
                this.printDirectChildren(xml);
            }
        };
        // 是否存在解析错误
        TransferFormat_XML.prototype.getParserError = function (xml) {
            var error = xml.firstChild.firstChild.nodeName == "parsererror";
            return error ? xml.firstChild.firstChild.textContent : null;
        };
        // 打印直接子级
        TransferFormat_XML.prototype.printDirectChildren = function (xml) {
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
        return TransferFormat_XML;
    }());
    laya.TransferFormat_XML = TransferFormat_XML;
})(laya || (laya = {}));
new laya.TransferFormat_XML();
