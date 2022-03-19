// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.singleView.SingleMapInfoPanel

package room.view.singleView
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import room.model.RoomInfo;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.utils.Timer;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.TimerEvent;
    import ddt.events.RoomEvent;
    import flash.events.Event;
    import ddt.manager.SocketManager;
    import ddt.view.MainToolBar;
    import com.pickgliss.utils.ObjectUtils;

    public class SingleMapInfoPanel extends Sprite implements Disposeable 
    {

        private var _info:RoomInfo;
        private var _matchingPic:Bitmap;
        private var _timeTxt:FilterFrameText;
        private var _timer:Timer;

        public function SingleMapInfoPanel()
        {
            this.initView();
        }

        protected function initView():void
        {
            this._matchingPic = ComponentFactory.Instance.creatBitmap("asset.room.view.SinglePlayer.Matching");
            this._matchingPic.visible = false;
            addChild(this._matchingPic);
            this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("room.singleView.timeText");
            addChild(this._timeTxt);
            this._timer = new Timer(1000);
            this._timer.addEventListener(TimerEvent.TIMER, this.__timer);
        }

        public function set info(_arg_1:RoomInfo):void
        {
            if (this._info)
            {
                this._info.removeEventListener(RoomEvent.STARTED_CHANGED, this.__startedHandler);
                this._info.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED, this.__update);
                this._info = null;
            };
            this._info = _arg_1;
            if (this._info)
            {
                this._info.addEventListener(RoomEvent.STARTED_CHANGED, this.__startedHandler);
                this._info.addEventListener(RoomEvent.PLAYER_STATE_CHANGED, this.__update);
            };
            this.updateView();
        }

        private function __update(_arg_1:Event):void
        {
            this.updateView();
        }

        private function __startedHandler(_arg_1:RoomEvent):void
        {
            if (this._info.started)
            {
                if ((!(this._timer.running)))
                {
                    this._timeTxt.text = "09";
                    this._timer.start();
                };
            }
            else
            {
                this._timer.stop();
                this._timer.reset();
                if (((this._info.gameMode == RoomInfo.BOTH_MODE) && (this._info.selfRoomPlayer.isHost)))
                {
                    SocketManager.Instance.out.sendGameStyle(RoomInfo.GUILD_MODE);
                };
            };
            this.updateView();
        }

        private function __timer(_arg_1:TimerEvent):void
        {
            var _local_2:uint = uint((this._timer.currentCount / 60));
            var _local_3:uint = (9 - (this._timer.currentCount % 10));
            this._timeTxt.text = ((_local_3 > 9) ? _local_3.toString() : ("0" + _local_3));
            if (this._timer.currentCount == 20)
            {
                if ((!(this._info.selfRoomPlayer.isHost)))
                {
                    MainToolBar.Instance.setReturnEnable(true);
                    dispatchEvent(new RoomEvent(RoomEvent.TWEENTY_SEC));
                };
            };
        }

        private function updateView():void
        {
            if (this._info)
            {
                this._matchingPic.visible = (this._timeTxt.visible = this._info.started);
            }
            else
            {
                this._matchingPic.visible = (this._timeTxt.visible = false);
            };
        }

        private function removeEvents():void
        {
            if (this._info)
            {
                this._info.removeEventListener(RoomEvent.STARTED_CHANGED, this.__startedHandler);
                this._info.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED, this.__update);
            };
            this._timer.removeEventListener(TimerEvent.TIMER, this.__timer);
        }

        public function dispose():void
        {
            this.removeEvents();
            this._info = null;
            ObjectUtils.disposeObject(this._matchingPic);
            this._matchingPic = null;
            ObjectUtils.disposeObject(this._timeTxt);
            this._timeTxt = null;
            ObjectUtils.disposeObject(this._timer);
            this._timer = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package room.view.singleView

