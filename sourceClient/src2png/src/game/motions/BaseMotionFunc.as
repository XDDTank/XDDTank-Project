// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.motions.BaseMotionFunc

package game.motions
{
    import flash.geom.Point;

    public class BaseMotionFunc implements IMotionFunction 
    {

        protected var _initial:Point;
        protected var _final:Point;
        protected var _result:Object;
        protected var _lifetime:int;
        protected var _isPlaying:Boolean;

        public function BaseMotionFunc(_arg_1:Object)
        {
            this._lifetime = 0;
            this._initial = new Point(0, 0);
            if (_arg_1.initial)
            {
                this._initial = _arg_1.initial;
            };
            this._final = new Point(0, 0);
            if (_arg_1.final)
            {
                this._final = _arg_1.final;
            };
        }

        public function getVectorByTime(_arg_1:int):Object
        {
            return (null);
        }

        public function getResult():Object
        {
            if ((!(this._isPlaying)))
            {
                return (null);
            };
            return (null);
        }


    }
}//package game.motions

