// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.TextFieldO

package cmodule.decry
{
    import flash.text.TextField;
    import cmodule.decry.gstate;
    import flash.text.TextFormat;

    internal class TextFieldO extends IO 
    {

        private var m_trace:Boolean;
        private var m_tf:TextField;

        public function TextFieldO(_arg_1:TextField, _arg_2:Boolean=false)
        {
            this.m_tf = _arg_1;
            this.m_trace = _arg_2;
        }

        override public function write(_arg_1:int, _arg_2:int):int
        {
            var _local_3:int = _arg_2;
            var _local_4:String = "";
            while (_local_3--)
            {
                _local_4 = (_local_4 + String.fromCharCode(gstate._mru8(_arg_1)));
                _arg_1++;
            };
            if (this.m_trace)
            {
                trace(_local_4);
            };
            var _local_5:int = this.m_tf.length;
            this.m_tf.replaceText(_local_5, _local_5, _local_4);
            var _local_6:int = this.m_tf.length;
            var _local_7:TextFormat = this.m_tf.getTextFormat(_local_5, _local_6);
            _local_7.bold = true;
            this.m_tf.setTextFormat(_local_7, _local_5, _local_6);
            this.m_tf.setSelection(_local_6, _local_6);
            return (_arg_2);
        }


    }
}//package cmodule.decry

