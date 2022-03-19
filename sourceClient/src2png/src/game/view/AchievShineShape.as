// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.AchievShineShape

package game.view
{
    import flash.display.Shape;
    import flash.display.Graphics;
    import flash.display.GradientType;

    public class AchievShineShape extends Shape 
    {

        private var _color:int = 0;
        private var _radius:int;
        private var _alphas:Array;
        private var _ratios:Array;


        public function setColor(_arg_1:int):void
        {
            this._color = _arg_1;
            this.draw();
        }

        private function draw():void
        {
            var _local_1:Graphics = graphics;
            _local_1.clear();
            _local_1.beginGradientFill(GradientType.RADIAL, [this._color, this._color], this._alphas, this._ratios);
            _local_1.drawCircle(0, 0, this._radius);
            _local_1.endFill();
        }

        public function set radius(_arg_1:int):void
        {
            this._radius = _arg_1;
            this.draw();
        }

        public function set alphas(_arg_1:String):void
        {
            this._alphas = _arg_1.split(",");
            this.draw();
        }

        public function set ratios(_arg_1:String):void
        {
            this._ratios = _arg_1.split(",");
            this.draw();
        }


    }
}//package game.view

