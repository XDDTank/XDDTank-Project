// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//invite.view.InviteListCell

package invite.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.cell.IListCell;
    import ddt.view.common.LevelIcon;
    import ddt.view.common.SexIcon;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.text.GradientText;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import room.model.RoomInfo;
    import ddt.manager.SoundManager;
    import room.RoomManager;
    import ddt.manager.MessageTipManager;
    import game.GameManager;
    import ddt.data.player.ConsortiaPlayerInfo;
    import ddt.manager.GameInSocketOut;
    import com.pickgliss.ui.controls.list.List;
    import vip.VipController;
    import com.pickgliss.utils.DisplayUtils;
    import ddt.utils.PositionUtils;
    import ddt.data.player.BasePlayer;
    import ddt.manager.PlayerManager;
    import flash.display.DisplayObject;

    public class InviteListCell extends Sprite implements Disposeable, IListCell 
    {

        private static const LevelLimit:int = 13;
        private static const RoomTypeLimit:int = 2;

        public var roomType:int;
        private var _data:Object;
        private var _levelIcon:LevelIcon;
        private var _sexIcon:SexIcon;
        private var _name:FilterFrameText;
        private var _vipName:GradientText;
        private var _BG:Bitmap;
        private var _BGII:Bitmap;
        private var _isSelected:Boolean;
        private var _inviteButton:TextButton;

        public function InviteListCell()
        {
            this.configUi();
            this.addEvent();
            mouseEnabled = false;
        }

        public function dispose():void
        {
            this.removeEvent();
            if (this._inviteButton)
            {
                ObjectUtils.disposeObject(this._inviteButton);
                this._inviteButton = null;
            };
            if (this._sexIcon)
            {
                ObjectUtils.disposeObject(this._sexIcon);
                this._sexIcon = null;
            };
            if (this._levelIcon)
            {
                ObjectUtils.disposeObject(this._levelIcon);
                this._levelIcon = null;
            };
            if (this._name)
            {
                ObjectUtils.disposeObject(this._name);
                this._name = null;
            };
            if (this._vipName)
            {
                ObjectUtils.disposeObject(this._vipName);
            };
            this._vipName = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        private function configUi():void
        {
            this._name = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.cell.playerItemName");
            this._levelIcon = ComponentFactory.Instance.creatCustomObject("asset.ddtinvite.cell.LevelIcon");
            this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
            addChild(this._levelIcon);
            this._sexIcon = ComponentFactory.Instance.creatCustomObject("asset.ddtinvite.cell.SexIcon");
            addChild(this._sexIcon);
            this._inviteButton = ComponentFactory.Instance.creatComponentByStylename("asset.ddtinvite.cell.inviteBtn");
            this._inviteButton.text = LanguageMgr.GetTranslation("im.InviteDialogFrame.Title");
            addChild(this._inviteButton);
        }

        private function addEvent():void
        {
            this._inviteButton.addEventListener(MouseEvent.CLICK, this.__onInviteClick);
        }

        private function removeEvent():void
        {
            this._inviteButton.removeEventListener(MouseEvent.CLICK, this.__onInviteClick);
        }

        private function __onInviteClick(_arg_1:MouseEvent):void
        {
            var _local_2:RoomInfo;
            SoundManager.instance.play("008");
            _local_2 = RoomManager.Instance.current;
            if (_local_2.placeCount < 1)
            {
                if (_local_2.players.length > 1)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.roomlist.RoomListIIBGView.room"));
                }
                else
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.room.RoomIIView2.noplacetoinvite"));
                };
                return;
            };
            this._inviteButton.enable = false;
            this._inviteButton.filters = [ComponentFactory.Instance.model.getSet("asset.ddtinvite.GF4")];
            this._data.invited = true;
            if (_local_2.type == RoomInfo.MATCH_ROOM)
            {
                if (this.inviteLvTip(LevelLimit))
                {
                    return;
                };
            }
            else
            {
                if (_local_2.type == RoomInfo.CHALLENGE_ROOM)
                {
                    if (this.inviteLvTip(LevelLimit))
                    {
                        return;
                    };
                };
            };
            if ((((_local_2.type == RoomInfo.DUNGEON_ROOM) || (_local_2.type == RoomInfo.MULTI_DUNGEON)) && (this._data.Grade < GameManager.MinLevelDuplicate)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.PlayerManager.gradeLow", GameManager.MinLevelDuplicate));
                return;
            };
            if ((this._data is ConsortiaPlayerInfo))
            {
                if (this.checkLevel(this._data.info.Grade))
                {
                    GameInSocketOut.sendInviteGame(this._data.info.ID);
                };
            }
            else
            {
                if (this.checkLevel(this._data.Grade))
                {
                    GameInSocketOut.sendInviteGame(this._data.ID);
                };
            };
        }

        private function inviteLvTip(_arg_1:int):Boolean
        {
            if ((this._data is ConsortiaPlayerInfo))
            {
                if (this._data.info.Grade < _arg_1)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.invite.InvitePlayerItem.cannot", _arg_1));
                    return (true);
                };
            }
            else
            {
                if (this._data.Grade < _arg_1)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.invite.InvitePlayerItem.cannot", _arg_1));
                    return (true);
                };
            };
            return (false);
        }

        private function checkLevel(_arg_1:int):Boolean
        {
            var _local_2:RoomInfo = RoomManager.Instance.current;
            if (_local_2.type > RoomTypeLimit)
            {
                if (_arg_1 < GameManager.MinLevelDuplicate)
                {
                    return (false);
                };
            }
            else
            {
                if (_local_2.type == RoomTypeLimit)
                {
                    if (((_local_2.levelLimits - 1) * 10) > _arg_1)
                    {
                        return (false);
                    };
                };
            };
            return (true);
        }

        public function setListCellStatus(_arg_1:List, _arg_2:Boolean, _arg_3:int):void
        {
        }

        public function getCellValue():*
        {
            return (this._data);
        }

        public function setCellValue(_arg_1:*):void
        {
            this._data = _arg_1;
            this.update();
        }

        private function update():void
        {
            if ((!(this._data.invited)))
            {
                this._inviteButton.enable = true;
                this._inviteButton.filters = null;
            };
            this._name.text = this._data.NickName;
            if (this._data.IsVIP)
            {
                ObjectUtils.disposeObject(this._vipName);
                this._vipName = VipController.instance.getVipNameTxt(121, this._data.VIPtype);
                this._vipName.x = this._name.x;
                this._vipName.y = this._name.y;
                this._vipName.text = this._name.text;
                addChild(this._vipName);
                DisplayUtils.removeDisplay(this._name);
            };
            addChild(this._name);
            PositionUtils.adaptNameStyle(BasePlayer(this._data), this._name, this._vipName);
            this._sexIcon.setSex(this._data.Sex);
            this._levelIcon.setInfo(this._data.Grade, this._data.Repute, this._data.WinCount, this._data.TotalCount, this._data.FightPower, this._data.Offer, true, false);
            this._sexIcon.visible = (!((PlayerManager.Instance.Self.isMyApprent(this._data.ID)) || (PlayerManager.Instance.Self.isMyMaster(this._data.ID))));
            if (PlayerManager.Instance.Self.isMyMaster(this._data.ID))
            {
                if (this._data.Sex)
                {
                };
            }
            else
            {
                if (this._data.Sex)
                {
                };
            };
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }


    }
}//package invite.view

