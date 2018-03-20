/*[IF-FLASH]*/
package laya.flash
{
	public class FlashDOMParser
	{
		public function FlashDOMParser()
		{
			//XML.ignoreComments = false;
			//XML.ignoreProcessingInstructions = false;
			//XML.ignoreWhitespace = false;
		}
		
		public static function parseFromString(value:String):XmlDom
		{
			XML.ignoreComments = false;
			
			var result:XmlDom = new XmlDom();
			
			var xml:XML = new XML("<wrapper>" + value + "</wrapper>");
			
			var children:XMLList = xml.children();
			result.createNode(xml, result);
			
			return result;
		}
	}
}
