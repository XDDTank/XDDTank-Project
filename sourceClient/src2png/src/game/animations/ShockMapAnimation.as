// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.animations.ShockMapAnimation

package game.animations
{
    import phy.object.PhysicalObj;
    import game.objects.SimpleBomb;
    import game.view.map.MapView;

    public class ShockMapAnimation implements IAnimate 
    {

        private var _bomb:PhysicalObj;
        private var _finished:Boolean;
        private var _age:Number;
        private var _life:Number;
        private var _radius:Number;
        private var _x:Number;
        private var _y:Number;
        private var _scale:int;
        private var _level:int;
        private var _ownerID:int;

        public function ShockMapAnimation(_arg_1:PhysicalObj, _arg_2:Number=7, _arg_3:Number=0, _arg_4:int=2, _arg_5:int=10000)
        {
            var _local_6:SimpleBomb;
            super();
            this._age = 0;
            this._life = _arg_3;
            this._finished = false;
            this._bomb = _arg_1;
            this._radius = _arg_2;
            this._scale = 1;
            this._level = _arg_4;
            this._ownerID = _arg_5;
            if ((this._bomb is SimpleBomb))
            {
                _local_6 = (this._bomb as SimpleBomb);
                if (((_local_6.target) && (_local_6.owner)))
                {
                    if ((_local_6.target.x - _local_6.owner.pos.x) < 0)
                    {
                        this._scale = -1;
                    };
                };
            };
        }

        public function get level():int
        {
            return (this._level);
        }

        public function get scale():int
        {
            return (this._scale);
        }

        public function canAct():Boolean
        {
            return ((!(this._finished)) || (this._life > 0));
        }

        public function canReplace(_arg_1:IAnimate):Boolean
        {
            return (true);
        }

        public function prepare(_arg_1:AnimationSet):void
        {
        }

        public function cancel():void
        {
            this._finished = true;
            this._life = 0;
        }

        public function update(_arg_1:MapView):Boolean
        {
            this._life--;
            if ((!(this._finished)))
            {
                if (this._age == 0)
                {
                    this._x = _arg_1.x;
                    this._y = _arg_1.y;
                };
                this._age = (this._age + 0.25);
                if (this._age < 1.5)
                {
                    this._radius = -(this._radius);
                    _arg_1.x = (this._x + (this._radius * this.scale));
                    _arg_1.y = (this._y + this._radius);
                }
                else
                {
                    _arg_1.x = this._x;
                    _arg_1.y = this._y;
                    this._finished = true;
                };
                return (true);
            };
            return (false);
        }

        public function get finish():Boolean
        {
            return (this._finished);
        }

        public function get ownerID():int
        {
            return (this._ownerID);
        }


    }
}//package game.animations

