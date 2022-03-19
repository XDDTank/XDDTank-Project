// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.chatBall.ChatBallAlways

package ddt.view.chat.chatBall
{
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;

    public class ChatBallAlways extends ChatBallBase 
    {

        public function ChatBallAlways()
        {
            this.init();
            this.mouseChildren = false;
            this.mouseEnabled = false;
        }

        private function init():void
        {
            _field = new ChatBallTextAreaPlayer();
        }

        override protected function get field():ChatBallTextAreaBase
        {
            return (_field);
        }

        override public function setText(_arg_1:String, _arg_2:int=0):void
        {
            clear();
            if ((!(paopaoMC)))
            {
                this.newPaopao();
            };
            var _local_3:int = this.globalToLocal(new Point(500, 10)).x;
            this.field.x = ((_local_3 < 0) ? 0 : _local_3);
            this.field.text = _arg_1;
            fitSize(this.field);
            this.show();
        }

        override public function show():void
        {
            super.show();
        }

        override public function hide():void
        {
            super.hide();
            if (((this.field) && (this.field.parent)))
            {
                this.field.parent.removeChild(this.field);
            };
        }

        override public function set width(_arg_1:Number):void
        {
            super.width = _arg_1;
        }

        private function newPaopao():void
        {
            if (paopao)
            {
                removeChild(paopao);
            };
            paopaoMC = ComponentFactory.Instance.creat("ChatBall16000");
            _chatballBackground = new ChatBallBackground(paopaoMC);
            addChild(paopao);
        }

        public function setBGDirection(_arg_1:int):void
        {
            _chatballBackground.scaleX = _arg_1;
            fitSize(this.field);
        }

        override public function dispose():void
        {
            super.dispose();
        }


    }
}//package ddt.view.chat.chatBall

