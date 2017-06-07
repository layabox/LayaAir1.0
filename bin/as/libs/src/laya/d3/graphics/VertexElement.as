package laya.d3.graphics {
	
	/**
	 * <code>VertexElement</code> 类用于创建顶点结构分配。
	 */
	public class VertexElement {
		public var offset:int;
		public var elementFormat:String;
		public var elementUsage:int;
		//public var usageIndex:int;//TODO:待确定是否添加
		
		public function VertexElement(offset:int, elementFormat:String, elementUsage:int)//增加:usageIndex:int
		{
			this.offset = offset;
			this.elementFormat = elementFormat;
			this.elementUsage = elementUsage;
			//this.usageIndex = usageIndex;
		}
	
	}
}