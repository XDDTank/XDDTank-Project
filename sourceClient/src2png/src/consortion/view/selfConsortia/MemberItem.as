// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.MemberItem

package consortion.view.selfConsortia
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.cell.IListCell;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.image.ScaleLeftRightImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.text.GradientText;
    import ddt.view.common.LevelIcon;
    import ddt.data.player.ConsortiaPlayerInfo;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import ddt.manager.PlayerManager;
    import ddt.events.PlayerPropertyEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerTipManager;
    import com.pickgliss.toplevel.StageReferance;
    import com.pickgliss.ui.controls.list.List;
    import ddt.data.player.PlayerState;
    import ddt.manager.LanguageMgr;
    import ddt.data.player.BasePlayer;
    import flash.text.TextFormat;
    import com.pickgliss.utils.ObjectUtils;
    import vip.VipController;
    import ddt.utils.PositionUtils;
    import flash.display.DisplayObject;

    public class MemberItem extends Sprite implements Disposeable, IListCell 
    {

        public static const MAX_OFFLINE_HOURS:int = 720;

        private var _itemBG:ScaleFrameImage;
        private var _light:ScaleLeftRightImage;
        private var _name:FilterFrameText;
        private var _nameForVip:GradientText;
        private var _job:FilterFrameText;
        private var _offer:FilterFrameText;
        private var _fightPower:FilterFrameText;
        private var _offLine:FilterFrameText;
        private var _levelIcon:LevelIcon;
        private var _playerInfo:ConsortiaPlayerInfo;
        private var _isSelected:Boolean;

        public function MemberItem()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            buttonMode = true;
            this._itemBG = ComponentFactory.Instance.creatComponentByStylename("memberItem.BG");
            this._name = ComponentFactory.Instance.creatComponentByStylename("memberItem.commonName");
            this._job = ComponentFactory.Instance.creatComponentByStylename("memberItem.job");
            this._offer = ComponentFactory.Instance.creatComponentByStylename("memberItem.offer");
            this._fightPower = ComponentFactory.Instance.creatComponentByStylename("memberItem.fightPower");
            this._offLine = ComponentFactory.Instance.creatComponentByStylename("memberItem.offline");
            this._levelIcon = ComponentFactory.Instance.creatCustomObject("memberItem.level");
            this._levelIcon.setSize(LevelIcon.SIZE_SMALL);
            this._light = ComponentFactory.Instance.creatComponentByStylename("consortion.memberItem.light");
            addChild(this._itemBG);
            addChild(this._light);
            addChild(this._job);
            addChild(this._levelIcon);
            addChild(this._offer);
            addChild(this._fightPower);
            addChild(this._offLine);
            this._light.mouseChildren = (this._light.mouseEnabled = (this._light.visible = false));
        }

        private function initEvent():void
        {
            addEventListener(MouseEvent.CLICK, this.__onItmeClickHandler);
            addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOverHandler);
            addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOutHandler);
        }

        private function removeEvent():void
        {
            removeEventListener(MouseEvent.CLICK, this.__onItmeClickHandler);
            removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOverHandler);
            removeEventListener(MouseEvent.MOUSE_OUT, this.__mouseOutHandler);
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__selfPropertyHanlder);
        }

        private function __onItmeClickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            PlayerTipManager.show(this._playerInfo, StageReferance.stage.mouseY);
        }

        private function __mouseOverHandler(_arg_1:MouseEvent):void
        {
            this._light.visible = true;
        }

        private function __mouseOutHandler(_arg_1:MouseEvent):void
        {
            this._light.visible = this._isSelected;
        }

        public function isSelelct(_arg_1:Boolean):void
        {
            this._light.visible = (this._isSelected = _arg_1);
        }

        public function setListCellStatus(_arg_1:List, _arg_2:Boolean, _arg_3:int):void
        {
            if (((this._playerInfo == null) || (!(this._playerInfo.ID == PlayerManager.Instance.Self.ID))))
            {
                if ((_arg_3 % 2) != 0)
                {
                    this._itemBG.setFrame(2);
                }
                else
                {
                    this._itemBG.setFrame(1);
                };
            };
            if (this._playerInfo)
            {
                this.isSelelct(_arg_2);
            };
        }

        public function getCellValue():*
        {
            return (this._playerInfo);
        }

        public function setCellValue(_arg_1:*):void
        {
            this._playerInfo = _arg_1;
            if (this._playerInfo == null)
            {
                this.isSelelct(false);
                mouseEnabled = false;
                mouseChildren = false;
                this.setVisible(false);
            }
            else
            {
                mouseEnabled = true;
                mouseChildren = true;
                this.setVisible(true);
                this.setName();
                if (this._playerInfo.ID == PlayerManager.Instance.Self.ID)
                {
                    this._itemBG.setFrame(3);
                    PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__selfPropertyHanlder);
                    this._offer.text = String(PlayerManager.Instance.Self.beforeOffer);
                    this._fightPower.text = String(PlayerManager.Instance.Self.UseOffer);
                }
                else
                {
                    PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__selfPropertyHanlder);
                    this._offer.text = String(this._playerInfo.beforeOffer);
                    this._fightPower.text = String(this._playerInfo.UseOffer);
                };
                this._job.text = this._playerInfo.DutyName;
                this._levelIcon.setInfo(this._playerInfo.Grade, this._playerInfo.Repute, this._playerInfo.WinCount, this._playerInfo.TotalCount, this._playerInfo.FightPower, this._playerInfo.Offer);
                if (this._playerInfo.playerState.StateID != PlayerState.OFFLINE)
                {
                    this._offLine.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberInfoItem.offlineTxt");
                }
                else
                {
                    if (this._playerInfo.playerState.StateID == PlayerState.OFFLINE)
                    {
                        if (this._playerInfo.OffLineHour == -1)
                        {
                            this._offLine.text = (this._playerInfo.minute + LanguageMgr.GetTranslation("tank.hotSpring.room.time.minute"));
                        }
                        else
                        {
                            if (((this._playerInfo.OffLineHour >= 1) && (this._playerInfo.OffLineHour < 24)))
                            {
                                this._offLine.text = (this._playerInfo.OffLineHour + LanguageMgr.GetTranslation("hours"));
                            }
                            else
                            {
                                if (((this._playerInfo.OffLineHour >= 24) && (this._playerInfo.OffLineHour < 720)))
                                {
                                    this._offLine.text = (this._playerInfo.day + LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.day"));
                                }
                                else
                                {
                                    if (((this._playerInfo.OffLineHour >= 720) && (this._playerInfo.OffLineHour < 999)))
                                    {
                                        this._offLine.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberInfoItem.month");
                                    }
                                    else
                                    {
                                        this._offLine.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.MyConsortiaMemberInfoItem.long");
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

        private function __selfPropertyHanlder(_arg_1:PlayerPropertyEvent):void
        {
            if ((((_arg_1.changedProperties["RichesOffer"]) || (_arg_1.changedProperties["UseOffer"])) || (_arg_1.changedProperties["BeforeOffer"])))
            {
                this._fightPower.text = String(PlayerManager.Instance.Self.UseOffer);
                this._offer.text = String(PlayerManager.Instance.Self.beforeOffer);
            };
            if (_arg_1.changedProperties["isVip"])
            {
                this.setName();
            };
        }

        private function setVisible(_arg_1:Boolean):void
        {
            if (this._nameForVip)
            {
                this._nameForVip.visible = _arg_1;
            };
            this._name.visible = _arg_1;
            this._job.visible = _arg_1;
            this._levelIcon.visible = _arg_1;
            this._offer.visible = _arg_1;
            this._fightPower.visible = _arg_1;
            this._offLine.visible = _arg_1;
        }

        private function setName():void
        {
            var _local_1:BasePlayer;
            var _local_2:TextFormat;
            if (this._playerInfo.ID == PlayerManager.Instance.Self.ID)
            {
                _local_1 = PlayerManager.Instance.Self;
            }
            else
            {
                _local_1 = this._playerInfo;
            };
            ObjectUtils.disposeObject(this._name);
            this._name = ComponentFactory.Instance.creatComponentByStylename("memberItem.commonName");
            this._name.text = _local_1.NickName;
            if (this._name.text.length > 12)
            {
                this._name.text = (this._name.text.substr(0, 12) + ".");
            };
            addChild(this._name);
            if (_local_1.IsVIP)
            {
                ObjectUtils.disposeObject(this._nameForVip);
                this._nameForVip = VipController.instance.getVipNameTxt(149, _local_1.VIPtype);
                _local_2 = new TextFormat();
                _local_2.align = "center";
                _local_2.bold = true;
                this._nameForVip.textField.defaultTextFormat = _local_2;
                this._nameForVip.textSize = 16;
                this._nameForVip.x = this._name.x;
                this._nameForVip.y = this._name.y;
                this._nameForVip.text = _local_1.NickName;
                addChild(this._nameForVip);
            };
            PositionUtils.adaptNameStyle(_local_1, this._name, this._nameForVip);
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeAllChildren(this);
            this._itemBG = null;
            this._light.dispose();
            this._light = null;
            this._name = null;
            this._nameForVip = null;
            this._job = null;
            this._offer = null;
            this._fightPower = null;
            this._offLine = null;
            this._levelIcon = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia

