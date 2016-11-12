package laya.webgl.resource {
	
	public interface IMergeAtlasBitmap {
		function get atlasSource():*;
		function get allowMerageInAtlas():Boolean;
		
		function set enableMerageInAtlas(value:Boolean):void;
		function get enableMerageInAtlas():Boolean;
		
		function clearAtlasSource():void;
	}
}