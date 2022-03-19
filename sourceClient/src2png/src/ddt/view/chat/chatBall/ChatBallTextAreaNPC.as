// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.chatBall.ChatBallTextAreaNPC

package ddt.view.chat.chatBall
{
    import road7th.utils.StringHelper;
    import flash.text.TextFieldAutoSize;
    import flash.text.StyleSheet;

    public class ChatBallTextAreaNPC extends ChatBallTextAreaBase 
    {

        protected const maxTxtWidth:int = 140;

        private var _plainString:String;


        override protected function initView():void
        {
            super.initView();
        }

        override public function set text(_arg_1:String):void
        {
            clear();
            _text = _arg_1;
            _text = (("<p>" + _text) + "</p>");
            this._plainString = StringHelper.rePlaceHtmlTextField(_text);
            this.setFormat();
            tf.autoSize = TextFieldAutoSize.LEFT;
            tf.width = this.maxTxtWidth;
            tf.htmlText = _text;
            this.fitScale();
        }

        protected function setFormat():void
        {
            var _local_1:StyleSheet = new StyleSheet();
            _local_1.parseCSS(((("p{font-size:12px;text-align:center;font-weight:normal;}" + ".red{color:#FF0000}") + ".blue{color:#0000FF}") + ".green{color:#00FF00}"));
            tf.styleSheet = _local_1;
        }

        protected function fitScale():void
        {
            var _local_4:int;
            var _local_1:int;
            var _local_2:int = tf.numLines;
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                _local_4 = tf.getLineLength(_local_3);
                if (_local_1 < _local_4)
                {
                    _local_1 = _local_4;
                };
                _local_3++;
            };
            if (_local_1 < 8)
            {
                tf.width = (_local_1 * 17);
            }
            else
            {
                tf.width = this.maxTxtWidth;
            };
        }


    }
}//package ddt.view.chat.chatBall

