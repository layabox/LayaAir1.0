package laya.ui {
	
	/**组件接口，实现了编辑器组件类型。*/
	public interface IComponent {
		/**
		 * XML 数据。
		 */
		function get comXml():Object;
		function set comXml(value:Object):void;
	}
}