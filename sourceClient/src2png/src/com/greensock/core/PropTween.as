// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.core.PropTween

package com.greensock.core
{
    public final class PropTween 
    {

        public var target:Object;
        public var property:String;
        public var start:Number;
        public var change:Number;
        public var name:String;
        public var priority:int;
        public var isPlugin:Boolean;
        public var nextNode:PropTween;
        public var prevNode:PropTween;

        public function PropTween(_arg_1:Object, _arg_2:String, _arg_3:Number, _arg_4:Number, _arg_5:String, _arg_6:Boolean, _arg_7:PropTween=null, _arg_8:int=0)
        {
            this.target = _arg_1;
            this.property = _arg_2;
            this.start = _arg_3;
            this.change = _arg_4;
            this.name = _arg_5;
            this.isPlugin = _arg_6;
            if (_arg_7)
            {
                _arg_7.prevNode = this;
                this.nextNode = _arg_7;
            };
            this.priority = _arg_8;
        }

    }
}//package com.greensock.core

