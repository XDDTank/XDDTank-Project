// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.animations.ShockingSetCenterAnimation

package game.animations
{
    import flash.geom.Point;
    import game.view.map.MapView;

    public class ShockingSetCenterAnimation extends BaseSetCenterAnimation 
    {

        private var _shocking:int;
        private var _shockDelay:int;
        private var _x:Number;
        private var _y:Number;

        public function ShockingSetCenterAnimation(_arg_1:Number, _arg_2:Number, _arg_3:int=165, _arg_4:Boolean=false, _arg_5:int=0, _arg_6:int=12, _arg_7:int=-1)
        {
            super(_arg_1, _arg_2, _arg_3, false, _arg_5, _arg_7, 48);
            this._shocking = _arg_6;
            this._shockDelay = 0;
        }

        private function shockingOffset():Number
        {
            return (((Math.random() * this._shocking) * 2) - this._shocking);
        }

        override public function update(_arg_1:MapView):Boolean
        {
            var _local_2:Point;
            _life--;
            if (_life < 0)
            {
                _finished = true;
            };
            if ((!(_finished)))
            {
                _local_2 = new Point((_target.x - _arg_1.x), (_target.y - _arg_1.y));
                if (_local_2.length > 192)
                {
                    _arg_1.x = (_arg_1.x + (_local_2.x / 48));
                    _arg_1.y = (_arg_1.y + (_local_2.y / 48));
                }
                else
                {
                    if (_local_2.length >= 4)
                    {
                        _local_2.normalize(4);
                        _arg_1.x = (_arg_1.x + _local_2.x);
                        _arg_1.y = (_arg_1.y + _local_2.y);
                    }
                    else
                    {
                        if (_local_2.length >= 1)
                        {
                            _arg_1.x = (_arg_1.x + _local_2.x);
                            _arg_1.y = (_arg_1.y + _local_2.y);
                        };
                    };
                };
                if ((_life % 2))
                {
                    this._shocking = -(this._shocking);
                    _arg_1.y = (_arg_1.y + this._shocking);
                };
                return (true);
            };
            return (false);
        }


    }
}//package game.animations

