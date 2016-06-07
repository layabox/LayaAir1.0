package laya.webgl.resource {
	
	/**
	 * ...
	 * @author laya
	 */
	public interface IMergeAtlasBitmap {
		function get atlasSource():*;
		function get allowMerageInAtlas():Boolean;
		
		function set enableMerageInAtlas(value:Boolean):void;
		function get enableMerageInAtlas():Boolean;
		
		function clearAtlasSource():void;
	}
}