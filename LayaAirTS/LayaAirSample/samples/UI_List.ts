/// <reference path="../../libs/LayaAir.d.ts" />
module ui
{
    import List=laya.ui.List;
    import Handler=laya.utils.Handler;

     export class ListSample 
     {
        constructor()
        {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            var list:List = new List();
            list.itemRender = Item;
            list.pos(90, 30);
            list.repeatX = 1;
            list.repeatY = 4;
            // 使用但隐藏滚动条
            list.vScrollBarSkin = "";
            list.selectEnable = true;
            list.selectHandler = new Handler(this, this.onSelect);
            list.renderHandler = new Handler(this, this.updateItem);
            Laya.stage.addChild(list);
            // 设置数据项为对应图片的路径
            var data = [];
            for(var i:number = 0;i<10;i++)
            {
                data.push("res/ui/listskins/1.jpg");
                data.push("res/ui/listskins/2.jpg");
                data.push("res/ui/listskins/3.jpg");
                data.push("res/ui/listskins/4.jpg");
                data.push("res/ui/listskins/5.jpg");
            }

            list.array = data;
        }

        private  updateItem(cell:Item, index:number):void 
        {
            cell.setImg(cell.dataSource);
        }

        private  onSelect(index:number):void 
        {
            console.log("当前选择的索引：" + index);
        }
    }
}
import Box=laya.ui.Box;
class Item extends Box 
{
    private  img:laya.ui.Image;
    constructor()
    {
        super();
        this.size(373, 85);
        this.img = new laya.ui.Image();
        this.addChild(this.img);
    }

    public setImg(src:string):void 
    {
        this.img.skin = src;
    }
}
new ui.ListSample();