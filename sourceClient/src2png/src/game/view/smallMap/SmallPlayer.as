// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.smallMap.SmallPlayer

package game.view.smallMap
{
    import __AS3__.vec.Vector;
    import flash.display.Graphics;
    import __AS3__.vec.*;

    public class SmallPlayer extends SmallLiving 
    {

        private static const AttackMaxOffset:int = 4;
        private static const triangleCoords:Vector.<Object> = Vector.<Object>([{
            "x":0,
            "y":-8
        }, {
            "x":4,
            "y":-12
        }, {
            "x":-4,
            "y":-12
        }]);


        override protected function draw():void
        {
            var _local_2:Number;
            var _local_3:Number;
            var _local_4:Number;
            var _local_1:Graphics = graphics;
            if (onMap)
            {
                _local_1.clear();
                _local_1.beginFill(_color);
                _local_1.drawCircle(0, 0, _radius);
                if (_elapsed >= ((MovieTime * 1000) >> 1))
                {
                    _local_2 = (((MovieTime * 1000) - _elapsed) / ((MovieTime * 1000) >> 1));
                }
                else
                {
                    _local_2 = (_elapsed / ((MovieTime * 1000) >> 1));
                };
                if (_isAttacking)
                {
                    _local_3 = (AttackMaxOffset * _local_2);
                    _local_1.moveTo(triangleCoords[0].x, (triangleCoords[0].y - _local_3));
                    _local_1.lineTo(triangleCoords[1].x, (triangleCoords[1].y - _local_3));
                    _local_1.lineTo(triangleCoords[2].x, (triangleCoords[2].y - _local_3));
                };
                _local_1.endFill();
                if (this.isSelf)
                {
                    _local_1.lineStyle(2, _color, _local_2);
                    _local_1.beginFill(0, 0);
                    _local_1.drawCircle(0, 0, ((_radius + 2) + (2 * _local_2)));
                    _local_1.endFill();
                };
            }
            else
            {
                _local_1.beginFill(_color);
                _local_1.drawCircle(0, 0, _radius);
                _local_1.endFill();
            };
        }

        override public function onFrame(_arg_1:int):void
        {
            _elapsed = (_elapsed + _arg_1);
            if (_elapsed >= (MovieTime * 1000))
            {
                _elapsed = 0;
            };
            this.draw();
        }

        override public function set isAttacking(_arg_1:Boolean):void
        {
            super.isAttacking = _arg_1;
            this.draw();
        }

        public function get isSelf():Boolean
        {
            if ((!(_info)))
            {
                return (false);
            };
            return (_info.isSelf);
        }


    }
}//package game.view.smallMap

