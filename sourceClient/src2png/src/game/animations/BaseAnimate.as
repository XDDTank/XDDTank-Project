// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.animations.BaseAnimate

package game.animations
{
    import game.view.map.MapView;

    public class BaseAnimate implements IAnimate 
    {

        protected var _level:int = 0;
        protected var _finished:Boolean;
        protected var _ownerID:int;


        public function get level():int
        {
            return (this._level);
        }

        public function prepare(_arg_1:AnimationSet):void
        {
        }

        public function canAct():Boolean
        {
            return (!(this._finished));
        }

        public function update(_arg_1:MapView):Boolean
        {
            this._finished = true;
            return (false);
        }

        public function canReplace(_arg_1:IAnimate):Boolean
        {
            return (true);
        }

        public function cancel():void
        {
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

