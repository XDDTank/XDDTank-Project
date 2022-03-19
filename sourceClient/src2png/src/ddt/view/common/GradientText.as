// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.common.GradientText

package ddt.view.common
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.text.TextFormat;
    import flash.geom.Matrix;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.GradientType;
    import com.pickgliss.utils.ObjectUtils;

    public class GradientText extends Sprite implements Disposeable 
    {

        public static var RandomColors:Array = [65508, 0xFF0066, 0xFFCC00, 14978897, 0x96FF00, 14483225, 10400767, 16742025, 50943, 13390591];
        public static var randomFont:Array = ["AdLib BT", "Arial Black", "VAG Rounded Std Thin", "Britannic Bold", "Berlin Sans FB Demi", "Benguiat Bk BT", "Kabel Ult BT", "Tw Cen MT Condensed Extra Bold", "Cooper Std Black", "Copperplate Gothic Bold", "CastleTUlt", "FrnkGothITC Hv BT"];
        public static var randomFontSize:Array = [0, 2];

        private var _field:FilterFrameText;
        private var _textFormat:TextFormat;
        private var graidenBox:Sprite;
        private var currentMatix:Matrix;
        private var currentColors:Array;
        private var randomColor:Array;

        public function GradientText(_arg_1:FilterFrameText, _arg_2:Array=null)
        {
            this._field = _arg_1;
            this._textFormat = ComponentFactory.Instance.model.getSet("game.vaneGradientTextTF");
            this.randomColor = ((_arg_2) ? _arg_2 : RandomColors);
            addChild(this._field);
            this.graidenBox = new Sprite();
            addChild(this.graidenBox);
        }

        public function setText(_arg_1:String, _arg_2:Boolean=true, _arg_3:Boolean=false):void
        {
            this._field.text = _arg_1;
            this.render(_arg_2, _arg_3);
        }

        public function get text():String
        {
            return (this._field.text);
        }

        public function set autoSize(_arg_1:String):void
        {
            this._field.autoSize = _arg_1;
        }

        private function render(_arg_1:Boolean, _arg_2:Boolean):void
        {
            if (_arg_2)
            {
                this.setTextStyle(this.getRandomFont());
            };
            if (_arg_1)
            {
                this.drawBox();
            }
            else
            {
                this.drawBoxWithCurrent();
            };
            this.graidenBox.x = this._field.x;
            this.graidenBox.y = this._field.y;
            this._field.cacheAsBitmap = true;
            this.graidenBox.cacheAsBitmap = true;
            this.graidenBox.mask = this._field;
        }

        private function drawBox():void
        {
            var _local_1:Array = [1, 1];
            var _local_2:Array = [0, 0xFF];
            this.currentMatix = new Matrix();
            this.currentMatix.createGradientBox((this._field.width / 2), this._field.height, (Math.PI / 4), 0, 0);
            this.currentColors = this.getRandomColors();
            this.graidenBox.graphics.clear();
            this.graidenBox.graphics.beginGradientFill(GradientType.LINEAR, this.currentColors, _local_1, _local_2, this.currentMatix);
            this.graidenBox.graphics.drawRect(0, 0, (this._field.width / 2), this._field.height);
            this.graidenBox.graphics.endFill();
            this.currentMatix = new Matrix();
            this.currentMatix.createGradientBox((this._field.width / 2), this._field.height, (Math.PI / 4), 0, 0);
            this.currentColors = this.getRandomColors();
            this.graidenBox.graphics.beginGradientFill(GradientType.LINEAR, this.currentColors, _local_1, _local_2, this.currentMatix);
            this.graidenBox.graphics.drawRect((this._field.width / 2), 0, (this._field.width / 2), this._field.height);
            this.graidenBox.graphics.endFill();
        }

        private function drawBoxWithCurrent():void
        {
            var _local_1:Array = [1, 1];
            var _local_2:Array = [0, 0xFF];
            this.graidenBox.graphics.clear();
            this.graidenBox.graphics.beginGradientFill(GradientType.LINEAR, this.currentColors, _local_1, _local_2, this.currentMatix);
            this.graidenBox.graphics.drawRect(0, 0, this._field.width, this._field.height);
            this.graidenBox.graphics.endFill();
        }

        private function getRandomColors():Array
        {
            var _local_1:Array = [];
            _local_1 = this.randomColor[int(((Math.random() * 10000) % 16))];
            var _local_2:int = _local_1[0];
            var _local_3:int = _local_1[1];
            return ([_local_2, _local_3]);
        }

        private function getRandomFont():String
        {
            return (randomFont[int(((Math.random() * 10000) % randomFont.length))]);
        }

        private function getRandomFontSize():int
        {
            return (randomFontSize[int(((Math.random() * 10000) % randomFontSize.length))]);
        }

        private function setTextStyle(_arg_1:String):void
        {
            this._textFormat.font = _arg_1;
            var _local_2:int = this.getRandomFontSize();
            switch (_arg_1)
            {
                case "AdLib BT":
                    this._textFormat.size = (16 + _local_2);
                    this._field.x = 5.5;
                    this._field.y = 3.5;
                    break;
                case "Arial Black":
                    this._textFormat.size = (18 + _local_2);
                    this._field.x = 5.2;
                    this._field.y = 0.4;
                    break;
                case "VAG Rounded Std Thin":
                    this._textFormat.size = (18 + _local_2);
                    this._field.x = 7.4;
                    this._field.y = 3;
                    break;
                case "Britannic Bold":
                    this._textFormat.size = (19 + _local_2);
                    this._field.x = 5.9;
                    this._field.y = 2.7;
                    break;
                case "Berlin Sans FB Demi":
                    this._textFormat.size = (21 + _local_2);
                    this._field.x = 5.4;
                    this._field.y = 0.3;
                    break;
                case "Benguiat Bk BT":
                    this._textFormat.size = (19 + _local_2);
                    this._field.x = 4.7;
                    this._field.y = 1.6;
                    break;
                case "Kabel Ult BT":
                    this._textFormat.size = (18 + _local_2);
                    this._field.x = 7.3;
                    this._field.y = 2.3;
                    break;
                case "Tw Cen MT Condensed Extra Bold":
                    this._textFormat.size = (20 + _local_2);
                    this._field.x = 7.7;
                    this._field.y = 1.7;
                    break;
                case "Cooper Std Black":
                    this._textFormat.size = (18 + _local_2);
                    this._field.x = 6.1;
                    this._field.y = 0.4;
                    break;
                case "Copperplate Gothic Bold":
                    this._textFormat.size = (19 + _local_2);
                    this._field.x = 3.8;
                    this._field.y = 2.9;
                    break;
                case "CastleTUlt":
                    this._textFormat.size = (19 + _local_2);
                    this._field.x = 5.9;
                    this._field.y = 2.1;
                    break;
                case "FrnkGothITC Hv BT":
                    this._textFormat.size = (18 + _local_2);
                    this._field.x = 6.2;
                    this._field.y = 1.9;
                    break;
            };
            this._field.setTextFormat(this._textFormat);
        }

        public function dispose():void
        {
            ObjectUtils.disposeObject(this._field);
            this._field = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view.common

