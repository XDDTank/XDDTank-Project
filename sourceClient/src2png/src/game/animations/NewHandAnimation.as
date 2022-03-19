// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.animations.NewHandAnimation

package game.animations
{
    import flash.geom.Point;
    import game.view.map.MapView;

    public class NewHandAnimation extends BaseSetCenterAnimation 
    {

        public function NewHandAnimation(_arg_1:Number, _arg_2:Number, _arg_3:int=0, _arg_4:Boolean=false, _arg_5:int=0, _arg_6:int=4, _arg_7:Object=null)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        }

        override public function canAct():Boolean
        {
            if (_life <= 0)
            {
                return (false);
            };
            return (true);
        }

        override public function prepare(_arg_1:AnimationSet):void
        {
            _target.x = ((_arg_1.stageWidth / 2) - _target.x);
            _target.y = ((_arg_1.stageHeight / 2) - _target.y);
            _target.x = ((_target.x < _arg_1.minX) ? _arg_1.minX : ((_target.x > 0) ? 0 : _target.x));
            _target.y = ((_target.y < _arg_1.minY) ? _arg_1.minY : ((_target.y > 0) ? 0 : _target.y));
        }

        override public function update(_arg_1:MapView):Boolean
        {
            var _local_2:Point;
            _life--;
            if (_life <= 0)
            {
                return (false);
            };
            if ((!(_directed)))
            {
                _tween.target = _target;
                _local_2 = _tween.update(_arg_1);
                _arg_1.x = _local_2.x;
                _arg_1.y = _local_2.y;
            }
            else
            {
                _arg_1.x = _target.x;
                _arg_1.y = _target.y;
            };
            return (true);
        }


    }
}//package game.animations

