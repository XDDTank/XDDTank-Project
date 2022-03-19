// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.chatBall.ChatBallTextAreaPlayer

package ddt.view.chat.chatBall
{
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    public class ChatBallTextAreaPlayer extends ChatBallTextAreaBase 
    {

        private const _SMALL_W:int = 80;
        private const _MIDDLE_W:int = 100;
        private const _BIG_H:int = 70;
        private const _BIG_W:int = 120;

        protected var hiddenTF:TextField;
        private var _textWidth:int;
        private var _indexOfEnd:int;


        override protected function initView():void
        {
            tf.autoSize = TextFieldAutoSize.LEFT;
            tf.multiline = true;
            tf.wordWrap = true;
            addChild(tf);
            tf.x = 0;
            tf.y = 0;
        }

        override public function set text(_arg_1:String):void
        {
            tf.htmlText = _arg_1;
            _arg_1 = tf.text;
            this.chooseSize(_arg_1);
            tf.text = _arg_1;
            tf.width = this._textWidth;
            if (tf.height >= this._BIG_H)
            {
                tf.height = this._BIG_H;
            };
            this._indexOfEnd = 0;
            if (tf.numLines > 4)
            {
                this._indexOfEnd = (tf.getLineOffset(4) - 3);
                _arg_1 = (_arg_1.substring(0, this._indexOfEnd) + "...");
            };
            tf.text = _arg_1;
        }

        protected function chooseSize(_arg_1:String):void
        {
            this._indexOfEnd = -1;
            var _local_2:TextFormat = tf.defaultTextFormat;
            this.hiddenTF = new TextField();
            this.setTextField(this.hiddenTF);
            _local_2.letterSpacing = 1;
            this.hiddenTF.defaultTextFormat = _local_2;
            _local_2.align = TextFormatAlign.CENTER;
            tf.defaultTextFormat = _local_2;
            this.hiddenTF.text = _arg_1;
            var _local_3:int = this.hiddenTF.textWidth;
            if (_local_3 < this._SMALL_W)
            {
                this._textWidth = this._SMALL_W;
                return;
            };
            if (_local_3 < ((this._SMALL_W * 2) + 10))
            {
                this._textWidth = this._MIDDLE_W;
                return;
            };
            this._textWidth = this._BIG_W;
        }

        override public function get width():Number
        {
            return (tf.width);
        }

        override public function get height():Number
        {
            return (tf.height);
        }

        public function setTextField(_arg_1:TextField):void
        {
            _arg_1.autoSize = TextFieldAutoSize.LEFT;
        }

        override public function dispose():void
        {
            this.hiddenTF = null;
        }


    }
}//package ddt.view.chat.chatBall

