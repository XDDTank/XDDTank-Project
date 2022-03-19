// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.action.FunctionAction

package com.pickgliss.action
{
    public class FunctionAction extends BaseAction 
    {

        private var _fun:Function;

        public function FunctionAction(_arg_1:Function)
        {
            this._fun = _arg_1;
        }

        override public function act():void
        {
            this._fun();
        }


    }
}//package com.pickgliss.action

