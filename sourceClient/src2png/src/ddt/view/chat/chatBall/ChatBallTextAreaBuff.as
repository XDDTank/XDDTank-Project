// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.chatBall.ChatBallTextAreaBuff

package ddt.view.chat.chatBall
{
    import flash.display.MovieClip;
    import com.pickgliss.ui.ComponentFactory;
    import flash.text.TextFieldAutoSize;

    public class ChatBallTextAreaBuff extends ChatBallTextAreaBase 
    {

        private var _movie:MovieClip;


        override protected function initView():void
        {
            this._movie = ComponentFactory.Instance.creat("tank.view.ChatTextfieldAsset");
            tf = null;
            tf = this._movie["tf"];
            tf.wordWrap = false;
            tf.autoSize = TextFieldAutoSize.LEFT;
            tf.multiline = false;
            tf.x = 0;
            tf.y = 0;
            addChild(tf);
        }

        override public function set text(_arg_1:String):void
        {
            clear();
            _text = _arg_1;
            tf.text = _text;
            tf.width = tf.textWidth;
            tf.height = tf.textHeight;
        }

        override public function dispose():void
        {
            this._movie = null;
            super.dispose();
        }


    }
}//package ddt.view.chat.chatBall

