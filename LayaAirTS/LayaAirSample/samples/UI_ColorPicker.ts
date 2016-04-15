/// <reference path="../../libs/LayaAir.d.ts" />
module ui {
    import ColorPicker = laya.ui.ColorPicker;
    import Handler = laya.utils.Handler;

    export class ColorPickerSample
    {
       private skin:string = "res/ui/colorPicker.png";

       constructor()
       {
            Laya.init(550, 400);
            Laya.stage.scaleMode = laya.display.Stage.SCALE_SHOWALL;
            Laya.loader.load(this.skin, Handler.create(this, this.onColorPickerSkinLoaded));
        }

        private onColorPickerSkinLoaded():void
        {
            var colorPicker:ColorPicker = new ColorPicker();
            colorPicker.skin = this.skin;
            colorPicker.selectedColor = "#ff0033";
            colorPicker.pos(100, 100);
            colorPicker.changeHandler = new Handler(this, this.onChangeColor, [colorPicker]);
            Laya.stage.addChild(colorPicker);

            this.onChangeColor(colorPicker);
        }
        private onChangeColor(colorPicker:ColorPicker): void
        {
            console.log("你选中的颜色：" + colorPicker.selectedColor);
        }
    }
}
new ui.ColorPickerSample();