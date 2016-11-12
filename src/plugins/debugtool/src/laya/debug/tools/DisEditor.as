///////////////////////////////////////////////////////////
//  DisEditor.as
//  Macromedia ActionScript Implementation of the Class DisEditor
//  Created on:      2015-12-24 下午4:20:25
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools
{
	import laya.display.Graphics;
	import laya.display.Sprite;
	import laya.maths.Rectangle;
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-12-24 下午4:20:25
	 */
	public class DisEditor
	{
		public function DisEditor()
		{
		}
		public var rec:Sprite=new Sprite();
		public var rootContainer:Sprite=new Sprite();
		public var tar:Sprite;
		
		public function setTarget(target:Sprite):void
		{
			tar=target;
			var g:Graphics;
			g=rec.graphics;
			g.clear();
			var bounds:Rectangle;
			bounds = tar.getSelfBounds();
			//trace("tarRec:",bounds.toString());
			g.drawRect(bounds.x,bounds.y,bounds.width,bounds.height,null,"#00ff00");
			
			createSameDisChain();
			Laya.stage.addChild(rootContainer);
		}
		public function createSameDisChain():void
		{
			var tParent:Sprite;
			var cpParent:Sprite;
			var preTar:Sprite;
			preTar=rec;
			tParent=tar;
			while(tParent&&tParent!=Laya.stage)
			{
				cpParent=new Sprite();
				cpParent.addChild(preTar);
				cpParent.x=tParent.x;
				cpParent.y=tParent.y;
				cpParent.scaleX=tParent.scaleX;
				cpParent.scaleY=tParent.scaleY;
				cpParent.rotation=tParent.rotation;
				cpParent.scrollRect = tParent.scrollRect;
				preTar = cpParent;
				
				//preTar=tParent;
				tParent=tParent.parent as Sprite;
			}
			
			rootContainer.removeChildren();
			rootContainer.addChild(preTar);
		}
	}
}