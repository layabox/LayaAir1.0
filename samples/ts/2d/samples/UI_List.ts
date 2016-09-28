module laya {
    import Stage = Laya.Stage;
    import List = Laya.List;
    import Handler = Laya.Handler;
    import WebGL = Laya.WebGL;

    export class UI_List {
        constructor() {
            // 不支持WebGL时自动切换至Canvas
            Laya.init(800, 600, WebGL);

            Laya.stage.alignV = Stage.ALIGN_MIDDLE;
            Laya.stage.alignH = Stage.ALIGN_CENTER;

            Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.stage.bgColor = "#232628";

            this.setup();
        }

        private setup(): void {
            var list: List = new List();

            list.itemRender = Item;

            list.repeatX = 1;
            list.repeatY = 4;

            list.x = (Laya.stage.width - Item.WID) / 2;
            list.y = (Laya.stage.height - Item.HEI * list.repeatY) / 2;

            // 使用但隐藏滚动条
            list.vScrollBarSkin = "";

            list.selectEnable = true;
            list.selectHandler = new Handler(this, this.onSelect);

            list.renderHandler = new Handler(this, this.updateItem);
            Laya.stage.addChild(list);

            // 设置数据项为对应图片的路径
            var data: Array<string> = [];
            for (var i: number = 0; i < 10; ++i) {
                data.push("../../res/ui/listskins/1.jpg");
                data.push("../../res/ui/listskins/2.jpg");
                data.push("../../res/ui/listskins/3.jpg");
                data.push("../../res/ui/listskins/4.jpg");
                data.push("../../res/ui/listskins/5.jpg");
            }
            list.array = data;
        }

        private updateItem(cell: Item, index: number): void {
            cell.setImg(cell.dataSource);
        }

        private onSelect(index: number): void {
            console.log("当前选择的索引：" + index);
        }
    }

    import Box = Laya.Box;
    import Image = Laya.Image;
    class Item extends Box {
        public static WID: number = 373;
        public static HEI: number = 85;

        private img: Image;

        constructor(){
            super();
            this.size(Item.WID, Item.HEI);
            this.img = new Image();
            this.addChild(this.img);
        }

        public setImg(src: string): void {
            this.img.skin = src;
        }
    }
}
new laya.UI_List();