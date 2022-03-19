// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.CheckCodeMixedBack

package game.view
{
    import flash.display.Sprite;

    public class CheckCodeMixedBack extends Sprite 
    {

        private static const CUVER_MAX:int = 10;
        private static const PointNum:int = 20;
        private static const CuverNum:int = 20;

        private var _width:Number;
        private var _height:Number;
        private var _color:uint;
        private var _renderBox:Sprite;
        private var masker:Sprite;

        public function CheckCodeMixedBack(_arg_1:Number, _arg_2:Number, _arg_3:Number)
        {
            this._color = _arg_3;
            this._height = _arg_2;
            this._width = _arg_1;
            this._renderBox = new Sprite();
            addChild(this._renderBox);
            this.createPoint();
            this.creatCurver();
            this.render();
        }

        private function createPoint():void
        {
            this._renderBox.graphics.beginFill(this._color, 0.5);
            var _local_1:int;
            while (_local_1 < PointNum)
            {
                this._renderBox.graphics.drawCircle((Math.random() * this._width), (Math.random() * this._height), (Math.random() * 1.5));
                _local_1++;
            };
            this._renderBox.graphics.endFill();
        }

        private function creatCurver():void
        {
            var _local_2:Number;
            var _local_3:Number;
            this._renderBox.graphics.lineStyle(1, this._color, 0.5);
            var _local_1:int;
            while (_local_1 < CuverNum)
            {
                _local_2 = (Math.random() * this._width);
                _local_3 = (Math.random() * this._height);
                this._renderBox.graphics.moveTo((_local_2 + ((Math.random() * CUVER_MAX) - CUVER_MAX)), (_local_3 + ((Math.random() * CUVER_MAX) - CUVER_MAX)));
                this._renderBox.graphics.curveTo((_local_2 + ((Math.random() * CUVER_MAX) - CUVER_MAX)), (_local_3 + ((Math.random() * CUVER_MAX) - CUVER_MAX)), _local_2, _local_3);
                _local_1++;
            };
            this._renderBox.graphics.endFill();
        }

        private function render():void
        {
            addChild(this._renderBox);
        }


    }
}//package game.view

