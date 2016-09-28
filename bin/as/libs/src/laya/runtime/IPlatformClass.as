package laya.runtime 
{
	
	/**
	 * ...
	 * @author hugao
	 */
	public interface IPlatformClass extends IPlatform
	{
		/**
		 * 创建对象
		 * @param	...args  构造函数的参数
		 * @return  创建出来的对象
		 */
		function newObject(...args):IPlatform;
	}
	
}