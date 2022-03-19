// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.bigMapInfoPanel.MatchRoomBigMapInfoPanel

package room.view.bigMapInfoPanel
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.MutipleImage;
    import room.model.RoomInfo;
    import ddt.view.SelectStateButton;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.utils.Timer;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.TimerEvent;
    import ddt.events.RoomEvent;
    import ddt.manager.SocketManager;
    import ddt.view.MainToolBar;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;

    public class MatchRoomBigMapInfoPanel extends Sprite implements Disposeable 
    {

        private var _bg:MutipleImage;
        private var _info:RoomInfo;
        private var _guildModeBtn:SelectStateButton;
        private var _freeModeBtn:SelectStateButton;
        private var _smallBg:Bitmap;
        private var _gameModeIcon:ScaleFrameImage;
        private var _matchingPic:Bitmap;
        private var _timeTxt:FilterFrameText;
        private var _timer:Timer;

        public function MatchRoomBigMapInfoPanel()
        {
            this.initView();
            this._freeModeBtn.addEventListener(MouseEvent.CLICK, this.__freeClickHandler);
            this._guildModeBtn.addEventListener(MouseEvent.CLICK, this.__guildClickHandler);
        }

        protected function initView():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.bigMapinfo.bg");
            this._freeModeBtn = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.bigMapInfoPanel.freeModeButton");
            this._freeModeBtn.backGround = ComponentFactory.Instance.creatBitmap("asset.ddtroom.bigMapInfo.freeModeBtn");
            this._freeModeBtn.overBackGround = ComponentFactory.Instance.creatBitmap("asset.ddtroom.bigMapInfo.freeModeBtnOver");
            this._guildModeBtn = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.bigMapInfoPanel.guildModeButton");
            this._guildModeBtn.backGround = ComponentFactory.Instance.creatBitmap("asset.ddtroom.bigMapInfo.guildModeBtn");
            this._guildModeBtn.overBackGround = ComponentFactory.Instance.creatBitmap("asset.ddtroom.bigMapInfo.guildModeBtnOver");
            this._freeModeBtn.selected = (this._freeModeBtn.enable = (this._guildModeBtn.selected = (this._guildModeBtn.enable = false)));
            this._freeModeBtn.gray = (this._freeModeBtn.gray = true);
            this._guildModeBtn.gray = true;
            this._smallBg = ComponentFactory.Instance.creatBitmap("asset.ddtroom.bigMapInfo.smallBg");
            addChild(this._smallBg);
            this._gameModeIcon = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.bigMapinfo.gameModeIcon");
            this._gameModeIcon.setFrame(1);
            this._matchingPic = ComponentFactory.Instance.creatBitmap("asset.ddtroom.bigMapInfo.matchingTxt");
            addChild(this._matchingPic);
            this._timeTxt = ComponentFactory.Instance.creatComponentByStylename("asset.ddtroom.bigMapinfo.timeTxt");
            addChild(this._timeTxt);
            this._timer = new Timer(1000);
            this._timer.addEventListener(TimerEvent.TIMER, this.__timer);
        }

        public function set info(_arg_1:RoomInfo):void
        {
            if (this._info)
            {
                this._info.removeEventListener(RoomEvent.GAME_MODE_CHANGE, this.__update);
                this._info.removeEventListener(RoomEvent.STARTED_CHANGED, this.__startedHandler);
                this._info.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED, this.__update);
                this._info.removeEventListener(RoomEvent.ADD_PLAYER, this.__update);
                this._info.removeEventListener(RoomEvent.REMOVE_PLAYER, this.__update);
                this._info.removeEventListener(RoomEvent.ROOMPLACE_CHANGED, this.__update);
                this._info = null;
            };
            this._info = _arg_1;
            if (this._info)
            {
                this._info.addEventListener(RoomEvent.GAME_MODE_CHANGE, this.__update);
                this._info.addEventListener(RoomEvent.STARTED_CHANGED, this.__startedHandler);
                this._info.addEventListener(RoomEvent.PLAYER_STATE_CHANGED, this.__update);
                this._info.addEventListener(RoomEvent.ADD_PLAYER, this.__update);
                this._info.addEventListener(RoomEvent.REMOVE_PLAYER, this.__update);
                this._info.addEventListener(RoomEvent.ROOMPLACE_CHANGED, this.__update);
            };
            this.updateView();
            this.updateBtns();
        }

        private function __update(_arg_1:RoomEvent):void
        {
            this.updateView();
            this.updateBtns();
        }

        private function __startedHandler(_arg_1:RoomEvent):void
        {
            if (this._info.started)
            {
                if ((!(this._timer.running)))
                {
                    this._timeTxt.text = "00";
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
            this.updateBtns();
        }

        private function __timer(_arg_1:TimerEvent):void
        {
            var _local_2:uint = uint((this._timer.currentCount / 60));
            var _local_3:uint = (this._timer.currentCount % 60);
            this._timeTxt.text = ((_local_3 > 9) ? _local_3.toString() : ("0" + _local_3));
            if (this._timer.currentCount == 20)
            {
                if (((!(this._info.selfRoomPlayer.isHost)) && (!(this._info.selfRoomPlayer.isViewer))))
                {
                    MainToolBar.Instance.setReturnEnable(true);
                    dispatchEvent(new RoomEvent(RoomEvent.TWEENTY_SEC));
                };
            };
        }

        private function updateView():void
        {
            if (((((this._freeModeBtn) && (this._gameModeIcon)) && (this._matchingPic)) && (this._smallBg)))
            {
                if (this._info)
                {
                    this._freeModeBtn.visible = (this._guildModeBtn.visible = (!(this._info.started)));
                    this._gameModeIcon.visible = (this._matchingPic.visible = (this._timeTxt.visible = (this._smallBg.visible = this._info.started)));
                    if (this._info.gameMode != RoomInfo.BOTH_MODE)
                    {
                        this._gameModeIcon.setFrame((this._info.gameMode + 1));
                    };
                }
                else
                {
                    this._freeModeBtn.visible = (this._guildModeBtn.visible = (this._gameModeIcon.visible = (this._matchingPic.visible = (this._timeTxt.visible = (this._smallBg.visible = false)))));
                };
            };
        }

        private function updateBtns():void
        {
            var _local_1:Boolean = this._info.canPlayGuidMode();
            if (((this._freeModeBtn) && (this._gameModeIcon)))
            {
                this._freeModeBtn.selected = ((this._info) && (this._info.gameMode == RoomInfo.FREE_MODE));
                this._freeModeBtn.enable = (this._freeModeBtn.buttonMode = ((this._info) && (this._info.selfRoomPlayer.isHost)));
                this._freeModeBtn.gray = false;
                this._freeModeBtn.buttonMode = (((this._info) && (_local_1)) && (this._info.selfRoomPlayer.isHost));
            };
        }

        private function __freeClickHandler(_arg_1:MouseEvent):void
        {
            if (((this._info) && (this._info.canPlayGuidMode())))
            {
                SoundManager.instance.play("008");
            };
            SocketManager.Instance.out.sendGameStyle(RoomInfo.FREE_MODE);
        }

        private function __guildClickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.sendGameStyle(RoomInfo.GUILD_MODE);
        }

        private function removeEvents():void
        {
            if (this._info)
            {
                this._info.removeEventListener(RoomEvent.GAME_MODE_CHANGE, this.__update);
                this._info.removeEventListener(RoomEvent.STARTED_CHANGED, this.__startedHandler);
                this._info.removeEventListener(RoomEvent.PLAYER_STATE_CHANGED, this.__update);
                this._info.removeEventListener(RoomEvent.ADD_PLAYER, this.__update);
                this._info.removeEventListener(RoomEvent.REMOVE_PLAYER, this.__update);
            };
            this._timer.removeEventListener(TimerEvent.TIMER, this.__timer);
            this._freeModeBtn.removeEventListener(MouseEvent.CLICK, this.__freeClickHandler);
        }

        public function dispose():void
        {
            this.removeEvents();
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            ObjectUtils.disposeObject(this._guildModeBtn);
            this._guildModeBtn = null;
            ObjectUtils.disposeObject(this._freeModeBtn);
            this._freeModeBtn = null;
            ObjectUtils.disposeObject(this._gameModeIcon);
            this._gameModeIcon = null;
            ObjectUtils.disposeObject(this._smallBg);
            this._smallBg = null;
            ObjectUtils.disposeObject(this._matchingPic);
            this._matchingPic = null;
            ObjectUtils.disposeObject(this._timeTxt);
            this._timeTxt = null;
            this._timer.stop();
            this._timer = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package room.view.bigMapInfoPanel

