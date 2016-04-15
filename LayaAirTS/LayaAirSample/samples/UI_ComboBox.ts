/// <reference path="../../libs/LayaAir.d.ts" />
module ui
{
    import ComboBox=laya.ui.ComboBox;
    import Handler=laya.utils.Handler;

    export class ComboBoxSample
    {
        private skin:string = "res/ui/comboBox.png";

        constructor()
        {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            Laya.loader.load(this.skin, Handler.create(this, this.onLoadComplete));
        }

        private  onLoadComplete():void
        {
            var cb:ComboBox = this.createComboBox(this.skin);
            cb.pos(100, 100);
        }

        private  createComboBox(skin:string):ComboBox
        {
            var comboBox:ComboBox = new ComboBox(skin, "item0,item1,item2,item3,item4,item5");
            comboBox.labelSize = 30;
            comboBox.itemSize = 25;
            comboBox.selectHandler = new Handler(this, this.onSelect, [comboBox]);
            Laya.stage.addChild(comboBox);

            return comboBox;
        }

        private  onSelect(cb:ComboBox):void
        {
            console.log("选中了： " + cb.selectedLabel);
        }
    }
}
new ui.ComboBoxSample();