// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.effect.BaseEffect

package com.pickgliss.effect
{
    import flash.display.DisplayObject;

    public class BaseEffect implements IEffect 
    {

        protected var _target:DisplayObject;
        private var _id:int;

        public function BaseEffect(_arg_1:int)
        {
            this._id = _arg_1;
        }

        public function dispose():void
        {
            this._target = null;
        }

        public function get id():int
        {
            return (this._id);
        }

        public function set id(_arg_1:int):void
        {
            this._id = _arg_1;
        }

        public function initEffect(_arg_1:DisplayObject, _arg_2:Array):void
        {
            this._target = _arg_1;
        }

        public function play():void
        {
        }

        public function stop():void
        {
        }

        public function get target():DisplayObject
        {
            return (this._target);
        }


    }
}//package com.pickgliss.effect

