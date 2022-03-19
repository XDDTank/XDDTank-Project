// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//room.view.chooseMap.DungeonChooseMapFrame

package room.view.chooseMap
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.ui.LayerManager;
    import ddt.data.map.DungeonInfo;
    import ddt.manager.SoundManager;
    import ddt.manager.MapManager;
    import ddt.manager.GameInSocketOut;
    import room.model.RoomInfo;
    import room.RoomManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.manager.LeavePageManager;

    public class DungeonChooseMapFrame extends Sprite implements Disposeable 
    {

        private var _frame:BaseAlerFrame;
        private var _view:DungeonChooseMapView;
        private var _alert:BaseAlerFrame;
        private var _voucherAlert:BaseAlerFrame;

        public function DungeonChooseMapFrame()
        {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("asset.ddtdungeonRoom.ChooseMap.Frame");
            addChild(this._frame);
            var _local_1:AlertInfo = new AlertInfo();
            _local_1.title = LanguageMgr.GetTranslation("tank.room.RoomIIMapSetPanel.room");
            _local_1.submitLabel = LanguageMgr.GetTranslation("ok");
            _local_1.showCancel = false;
            _local_1.moveEnable = false;
            this._frame.info = _local_1;
            this._view = ComponentFactory.Instance.creatCustomObject("asset.ddtroom.dungeonChooseMapView");
            this._frame.addToContent(this._view);
            this._frame.addEventListener(FrameEvent.RESPONSE, this.__responeHandler);
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function __responeHandler(_arg_1:FrameEvent):void
        {
            var _local_2:DungeonInfo;
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                SoundManager.instance.play("008");
                this.dispose();
            }
            else
            {
                if (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)
                {
                    SoundManager.instance.play("008");
                    if (this._view.checkState())
                    {
                        _local_2 = MapManager.getDungeonInfo(this._view.selectedMapID);
                        if (this._view.select)
                        {
                            this.showAlert();
                        }
                        else
                        {
                            if (_local_2.Type == MapManager.PVE_CHANGE_MAP)
                            {
                                GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID, RoomInfo.CHANGE_DUNGEON, false, this._view.roomPass, this._view.roomName, 1, this._view.selectedLevel, 0, false, this._view.selectedMapID);
                            }
                            else
                            {
                                if (_local_2.Type == MapManager.PVE_MULTISHOOT)
                                {
                                    GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID, RoomInfo.MULTI_DUNGEON, false, this._view.roomPass, this._view.roomName, 4, this._view.selectedLevel, 0, false, this._view.selectedMapID);
                                }
                                else
                                {
                                    GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID, RoomInfo.DUNGEON_ROOM, false, this._view.roomPass, this._view.roomName, 1, this._view.selectedLevel, 0, false, this._view.selectedMapID);
                                };
                            };
                            RoomManager.Instance.current.roomName = this._view.roomName;
                            RoomManager.Instance.current.roomPass = this._view.roomPass;
                            RoomManager.Instance.current.dungeonType = this._view.selectedDungeonType;
                            this.dispose();
                        };
                    };
                };
            };
        }

        private function getPrice():String
        {
            var _local_1:Array = [];
            var _local_2:String = "";
            var _local_3:String = MapManager.getDungeonInfo(this._view.selectedMapID).BossFightNeedMoney;
            if (_local_3)
            {
                _local_1 = _local_3.split("|");
            };
            if (((_local_1) && (_local_1.length > 0)))
            {
                switch (this._view.selectedLevel)
                {
                    case RoomInfo.EASY:
                        _local_2 = _local_1[0];
                        break;
                    case RoomInfo.NORMAL:
                        _local_2 = _local_1[1];
                        break;
                    case RoomInfo.HARD:
                        _local_2 = _local_1[2];
                        break;
                    case RoomInfo.HERO:
                        _local_2 = _local_1[3];
                        break;
                };
            };
            return (_local_2);
        }

        private function showAlert():void
        {
            if (this._alert == null)
            {
                this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.room.openBossTip.text", this.getPrice()), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.BLCAK_BLOCKGOUND);
                this._alert.moveEnable = false;
                this._alert.addEventListener(FrameEvent.RESPONSE, this.__alertResponse);
            };
        }

        private function disposeAlert():void
        {
            if (this._alert)
            {
                this._alert.removeEventListener(FrameEvent.RESPONSE, this.__alertResponse);
                ObjectUtils.disposeObject(this._alert);
                this._alert.dispose();
            };
            this._alert = null;
        }

        private function __alertResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    if (PlayerManager.Instance.Self.bagLocked)
                    {
                        BaglockedManager.Instance.show();
                        return;
                    };
                    if (PlayerManager.Instance.Self.totalMoney < Number(this.getPrice()))
                    {
                        this.showVoucherAlert();
                    }
                    else
                    {
                        GameInSocketOut.sendGameRoomSetUp(this._view.selectedMapID, RoomInfo.DUNGEON_ROOM, true, this._view.roomPass, this._view.roomName, 1, this._view.selectedLevel, 0, false, this._view.selectedMapID);
                        RoomManager.Instance.current.roomName = this._view.roomName;
                        RoomManager.Instance.current.roomPass = this._view.roomPass;
                        RoomManager.Instance.current.dungeonType = this._view.selectedDungeonType;
                        this.dispose();
                    };
                    return;
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    this.disposeAlert();
                    return;
            };
        }

        private function showVoucherAlert():void
        {
            if (this._voucherAlert == null)
            {
                this._voucherAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("poorNote"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"));
                this._voucherAlert.addEventListener(FrameEvent.RESPONSE, this.__onNoMoneyResponse);
            };
        }

        private function disposeVoucherAlert():void
        {
            this.disposeAlert();
            if (this._voucherAlert)
            {
                this._voucherAlert.removeEventListener(FrameEvent.RESPONSE, this.__onNoMoneyResponse);
                this._voucherAlert.disposeChildren = true;
                this._voucherAlert.dispose();
                this._voucherAlert = null;
            };
        }

        private function __onNoMoneyResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this.disposeVoucherAlert();
            if (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)
            {
                LeavePageManager.leaveToFillPath();
            };
        }

        public function dispose():void
        {
            this.disposeAlert();
            this.disposeVoucherAlert();
            this._frame.removeEventListener(FrameEvent.RESPONSE, this.__responeHandler);
            if (this._frame)
            {
                this._frame.dispose();
                this._frame = null;
            };
            if (this._view)
            {
                this._view.dispose();
                this._view = null;
            };
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package room.view.chooseMap

