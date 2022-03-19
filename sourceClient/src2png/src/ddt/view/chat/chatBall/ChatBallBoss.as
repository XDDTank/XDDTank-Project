// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.chatBall.ChatBallBoss

package ddt.view.chat.chatBall
{
    import flash.events.Event;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;

    public class ChatBallBoss extends ChatBallBase 
    {

        public function ChatBallBoss()
        {
            POP_DELAY = 2000;
            super();
            this.init();
        }

        private function init():void
        {
            _field = new ChatBallTextAreaBoss();
            _field.addEventListener(Event.COMPLETE, this.__onTextDisplayCompleted);
        }

        override public function setText(_arg_1:String, _arg_2:int=0):void
        {
            clear();
            if (paopaoMC == null)
            {
                this.newPaopao();
            };
            if (_arg_2 == 1)
            {
                (_field as ChatBallTextAreaBoss).animation = false;
            }
            else
            {
                (_field as ChatBallTextAreaBoss).animation = true;
            };
            var _local_3:int = this.globalToLocal(new Point(500, 10)).x;
            _field.x = ((_local_3 < 0) ? 0 : _local_3);
            _field.text = _arg_1;
            fitSize(_field);
            this.show();
        }

        override public function show():void
        {
            super.show();
        }

        private function newPaopao():void
        {
            paopaoMC = ComponentFactory.Instance.creat("ChatBall16000");
            _chatballBackground = new ChatBallBackground(paopaoMC);
            addChild(paopao);
        }

        private function __onTextDisplayCompleted(_arg_1:Event):void
        {
            beginPopDelay();
        }

        override public function dispose():void
        {
            super.dispose();
        }


    }
}//package ddt.view.chat.chatBall

