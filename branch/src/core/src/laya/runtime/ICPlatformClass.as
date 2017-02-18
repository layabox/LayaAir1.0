package laya.runtime 
{
	
	/**
	 * ...
	 * @author hugao
	 */
	public interface ICPlatformClass 
	{
		/**
		 * 创建平台类
		 * @param	clsName  类全名
		 * @return 创建的类
		 */
		function createClass(clsName:String):IPlatformClass;
	}
	
}