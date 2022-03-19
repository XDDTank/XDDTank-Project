// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//roomList.movingNotification.MovingNotificationView

package roomList.movingNotification
{
    import flash.display.Sprite;
    import flash.display.Shape;
    import com.pickgliss.ui.text.FilterFrameText;
    import __AS3__.vec.Vector;
    import flash.text.TextFormat;
    import flash.utils.Timer;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.TimerEvent;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class MovingNotificationView extends Sprite 
    {

        private var _list:Array;
        private var _mask:Shape;
        private var _currentIndex:uint;
        private var _currentMovingFFT:FilterFrameText;
        private var _textFields:Vector.<FilterFrameText> = new Vector.<FilterFrameText>();
        private var _keyWordTF:TextFormat;
        private var _timer:Timer;

        public function MovingNotificationView()
        {
            this.init();
        }

        private function init():void
        {
            this._currentIndex = 0;
            this._timer = new Timer(15000);
            scrollRect = ComponentFactory.Instance.creatCustomObject("roomList.MovingNotification.DisplayRect");
            this._keyWordTF = ComponentFactory.Instance.model.getSet("roomList.MovingNotificationKeyWordTF");
        }

        public function get list():Array
        {
            return (this._list);
        }

        public function set list(_arg_1:Array):void
        {
            if (((_arg_1) && (!(this._list == _arg_1))))
            {
                this._list = _arg_1;
                this.updateTextFields();
                this.updateCurrentTTF();
            };
            if (this._list)
            {
                this._timer.addEventListener(TimerEvent.TIMER, this.stopEnterFrame);
                addEventListener(Event.ENTER_FRAME, this.moveFFT);
            };
        }

        private function stopEnterFrame(_arg_1:TimerEvent):void
        {
            this._timer.stop();
            addEventListener(Event.ENTER_FRAME, this.moveFFT);
        }

        private function clearTextFields():void
        {
            var _local_1:FilterFrameText = this._textFields.shift();
            while (_local_1 != null)
            {
                ObjectUtils.disposeObject(_local_1);
                _local_1 = this._textFields.shift();
            };
        }

        private function updateTextFields():void
        {
            var _local_2:FilterFrameText;
            var _local_3:String;
            var _local_4:Vector.<uint>;
            var _local_5:Vector.<uint>;
            this.clearTextFields();
            var _local_1:int;
            while (_local_1 < this._list.length)
            {
                _local_2 = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroomList.MovingNotificationText");
                _local_3 = this._list[_local_1];
                _local_4 = new Vector.<uint>();
                _local_5 = new Vector.<uint>();
                while (_local_3.indexOf("{") > -1)
                {
                    _local_4.push(_local_3.indexOf("{"));
                    _local_5.push(_local_3.indexOf("}"));
                    _local_3 = _local_3.replace("{", "");
                    _local_3 = _local_3.replace("}", "");
                };
                _local_2.text = _local_3;
                while (_local_4.length > 0)
                {
                    _local_2.setTextFormat(this._keyWordTF, _local_4.shift(), (_local_5.shift() - 1));
                };
                this._textFields.push(_local_2);
                if ((!(contains(_local_2))))
                {
                    addChildAt(_local_2, 0);
                };
                _local_1++;
            };
        }

        private function updateCurrentTTF():void
        {
            this._currentIndex = Math.round((Math.random() * (this._list.length - 1)));
            this._currentMovingFFT = this._textFields[this._currentIndex];
        }

        private function moveFFT(_arg_1:Event):void
        {
            if (this._currentMovingFFT)
            {
                this._currentMovingFFT.y = (this._currentMovingFFT.y - 1);
                if (this._currentMovingFFT.y == 0)
                {
                    this._timer.start();
                    removeEventListener(Event.ENTER_FRAME, this.moveFFT);
                };
                if (this._currentMovingFFT.y < -(this._currentMovingFFT.textHeight + 2))
                {
                    this._currentMovingFFT.y = 22;
                    this.updateCurrentTTF();
                };
            };
        }

        public function dispose():void
        {
            removeEventListener(Event.ENTER_FRAME, this.moveFFT);
            this._timer.removeEventListener(TimerEvent.TIMER, this.stopEnterFrame);
            this._timer.stop();
            this.clearTextFields();
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package roomList.movingNotification

