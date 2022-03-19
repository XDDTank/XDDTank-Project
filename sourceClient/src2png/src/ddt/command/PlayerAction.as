// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.command.PlayerAction

package ddt.command
{
    public class PlayerAction 
    {

        public var type:String;
        public var stopAtEnd:Boolean;
        public var frames:Array;
        public var repeat:Boolean;
        public var replaceSame:Boolean;

        public function PlayerAction(_arg_1:String, _arg_2:Array, _arg_3:Boolean, _arg_4:Boolean, _arg_5:Boolean)
        {
            this.type = _arg_1;
            this.frames = _arg_2;
            this.replaceSame = _arg_3;
            this.repeat = _arg_4;
            this.stopAtEnd = _arg_5;
        }

        public function canReplace(_arg_1:PlayerAction):Boolean
        {
            if (((this.type == "handclip") && (_arg_1.type == "walk")))
            {
                return (false);
            };
            return ((!(_arg_1.type == this.type)) || (this.replaceSame));
        }

        public function toString():String
        {
            return (this.type);
        }


    }
}//package ddt.command

