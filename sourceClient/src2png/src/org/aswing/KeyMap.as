// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//org.aswing.KeyMap

package org.aswing
{
    import flash.utils.Dictionary;

    public class KeyMap 
    {

        private var map:Dictionary;

        public function KeyMap()
        {
            this.map = new Dictionary();
        }

        public static function getCodec(_arg_1:KeyType):String
        {
            return (getCodecWithKeySequence(_arg_1.getCodeSequence()));
        }

        public static function getCodecWithKeySequence(_arg_1:Array):String
        {
            return (_arg_1.join("|"));
        }


        public function registerKeyAction(_arg_1:KeyType, _arg_2:Function):void
        {
            var _local_3:String = getCodec(_arg_1);
            var _local_4:Array = this.map[_local_3];
            if (_local_4 == null)
            {
                _local_4 = new Array();
            };
            _local_4.push(new KeyAction(_arg_1, _arg_2));
            this.map[_local_3] = _local_4;
        }

        public function unregisterKeyAction(_arg_1:KeyType, _arg_2:Function):void
        {
            var _local_5:int;
            var _local_6:KeyAction;
            var _local_3:String = getCodec(_arg_1);
            var _local_4:Array = this.map[_local_3];
            if (_local_4)
            {
                _local_5 = 0;
                while (_local_5 < _local_4.length)
                {
                    _local_6 = _local_4[_local_5];
                    if (_local_6.action == _arg_2)
                    {
                        _local_4.splice(_local_5, 1);
                        _local_5--;
                    };
                    _local_5++;
                };
            };
        }

        public function getKeyAction(_arg_1:KeyType):Function
        {
            return (this.getKeyActionWithCodec(getCodec(_arg_1)));
        }

        private function getKeyActionWithCodec(_arg_1:String):Function
        {
            var _local_2:Array = this.map[_arg_1];
            if (((!(_local_2 == null)) && (_local_2.length > 0)))
            {
                return (_local_2[(_local_2.length - 1)].action);
            };
            return (null);
        }

        public function fireKeyAction(_arg_1:Array):Boolean
        {
            var _local_2:String = getCodecWithKeySequence(_arg_1);
            var _local_3:Function = this.getKeyActionWithCodec(_local_2);
            if (_local_3 != null)
            {
                (_local_3());
                return (true);
            };
            return (false);
        }

        public function containsKey(_arg_1:KeyType):Boolean
        {
            return (!(this.map[getCodec(_arg_1)] == null));
        }


    }
}//package org.aswing

import org.aswing.KeyType;

class KeyAction 
{

    /*private*/ var key:KeyType;
    /*private*/ var action:Function;

    public function KeyAction(_arg_1:KeyType, _arg_2:Function)
    {
        this.key = _arg_1;
        this.action = _arg_2;
    }

}


