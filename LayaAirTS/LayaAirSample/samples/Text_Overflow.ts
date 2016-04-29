/// <reference path="../../libs/LayaAir.d.ts" />
module laya {
	import Text = laya.display.Text;

	export class Text_Overflow {
		constructor() {
			Laya.init(550, 400);

			var t1: Text = this.createText();
			t1.overflow = Text.VISIBLE;
			t1.pos(10, 10);

			var t2: Text = this.createText();
			t2.overflow = Text.SCROLL;
			t2.pos(10, 110);

			var t3: Text = this.createText();
			t3.overflow = Text.HIDDEN;
			t3.pos(10, 210);
		}

		private createText(): Text {
			var txt: Text = new Text();

			txt.text =
				"Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
				"Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！\n" +
				"Layabox是HTML5引擎技术提供商与优秀的游戏发行商，面向AS/JS/TS开发者提供HTML5开发技术方案！";

			txt.borderColor = "#FFFF00";

			txt.size(300, 50);
			txt.fontSize = 20;
			txt.color = "#ffffff";

			Laya.stage.addChild(txt);

			return txt;
		}
	}
}
new laya.Text_Overflow();