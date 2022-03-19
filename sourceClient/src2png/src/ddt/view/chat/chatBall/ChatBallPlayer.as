// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.chatBall.ChatBallPlayer

package ddt.view.chat.chatBall
{
    import flash.utils.Timer;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;

    public class ChatBallPlayer extends ChatBallBase 
    {

        private var _currentPaopaoType:int = 0;
        private var _field2:ChatBallTextAreaBuff;

        public function ChatBallPlayer()
        {
            this.init();
            this.mouseChildren = false;
            this.mouseEnabled = false;
        }

        private function init():void
        {
            _field = new ChatBallTextAreaPlayer();
            this._field2 = new ChatBallTextAreaBuff();
        }

        override protected function get field():ChatBallTextAreaBase
        {
            if (this._currentPaopaoType != 9)
            {
                return (_field);
            };
            return (this._field2);
        }

        override public function setText(_arg_1:String, _arg_2:int=0):void
        {
            clear();
            if (_arg_2 == 9)
            {
                _popupTimer = new Timer(2700, 1);
            }
            else
            {
                _popupTimer = new Timer(4000, 1);
            };
            if (((!(this._currentPaopaoType == _arg_2)) || (paopaoMC == null)))
            {
                this._currentPaopaoType = _arg_2;
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
            beginPopDelay();
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
            if (this._currentPaopaoType != 9)
            {
                paopaoMC = ComponentFactory.Instance.creat(("ChatBall1600" + String(this._currentPaopaoType)));
            }
            else
            {
                paopaoMC = ComponentFactory.Instance.creat("SpecificBall001");
            };
            _chatballBackground = new ChatBallBackground(paopaoMC);
            addChild(paopao);
        }

        override public function dispose():void
        {
            this._field2.dispose();
            super.dispose();
        }


    }
}//package ddt.view.chat.chatBall

