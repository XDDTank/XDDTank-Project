// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.smallMap.SmallBox

package game.view.smallMap
{
    import phy.object.SmallObject;
    import flash.display.Graphics;

    public class SmallBox extends SmallObject 
    {

        private var _movieTime:Number = 0.8;

        public function SmallBox()
        {
            _radius = 3;
            _color = 0xFFFFFF;
        }

        override public function onFrame(_arg_1:int):void
        {
            _elapsed = (_elapsed + _arg_1);
            if (_elapsed >= (this._movieTime * 1000))
            {
                _elapsed = 0;
            };
            this.draw();
        }

        override protected function draw():void
        {
            var _local_1:Graphics = graphics;
            _local_1.clear();
            var _local_2:Number = (_elapsed / (this._movieTime * 1000));
            _local_1.beginFill(_color, _local_2);
            _local_1.drawCircle(0, 0, _radius);
            _local_1.endFill();
        }


    }
}//package game.view.smallMap

