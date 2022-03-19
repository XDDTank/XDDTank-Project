// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.info.PlayerInfoView

package bagAndInfo.info
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.data.player.PlayerInfo;
    import ddt.data.BagInfo;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.container.VBox;
    import ddt.view.common.LevelIcon;
    import ddt.view.common.VipLevelIcon;
    import militaryrank.view.MilitaryIcon;
    import ddt.view.common.MarriedIcon;
    import platformapi.tencent.view.DiamondIcon;
    import ddt.view.common.SuidIcon;
    import ddt.view.common.TotemIcon;
    import ddt.view.common.RuneIcon;
    import consortion.view.selfConsortia.Badge;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import com.pickgliss.ui.controls.BaseButton;
    import ddt.view.character.RoomCharacter;
    import flash.geom.Point;
    import com.pickgliss.ui.text.GradientText;
    import bagAndInfo.bag.PlayerPersonView;
    import pet.date.PetInfo;
    import road.game.resource.ActionMovie;
    import com.pickgliss.loader.BaseLoader;
    import ddt.display.BitmapLoaderProxy;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.SavePointManager;
    import ddt.utils.PositionUtils;
    import ddt.manager.StateManager;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import ddt.manager.TimeManager;
    import ddt.events.TimeEvents;
    import totem.TotemManager;
    import totem.data.TotemEvent;
    import ddt.events.BagEvent;
    import ddt.states.StateType;
    import ddt.events.PlayerPropertyEvent;
    import flash.events.Event;
    import flash.utils.Dictionary;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.MessageTipManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import baglocked.BaglockedManager;
    import ddt.manager.SocketManager;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.utils.ObjectUtils;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import ddt.bagStore.BagStore;
    import im.IMController;
    import shop.manager.ShopBuyManager;
    import ddt.data.EquipType;
    import ddt.view.character.CharactoryFactory;
    import com.pickgliss.loader.ModuleLoader;
    import road.game.resource.ActionMovieEvent;
    import ddt.utils.Helpers;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.LoaderEvent;
    import flash.utils.getTimer;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.geom.Rectangle;
    import ddt.manager.ItemManager;
    import ddt.view.character.BaseLayer;
    import game.GameManager;
    import platformapi.tencent.DiamondManager;
    import hall.FightPowerAndFatigue;
    import com.pickgliss.utils.DisplayUtils;
    import vip.VipController;
    import flash.text.TextFieldAutoSize;
    import ddt.data.Experience;
    import ddt.data.player.SelfInfo;

    public class PlayerInfoView extends Sprite implements Disposeable 
    {

        private var _info:PlayerInfo;
        private var _bagInfo:BagInfo;
        private var _showSelfOperation:Boolean;
        private var _cellPos:Array;
        private var _theCostOfFatigue:int;
        private var _nickNameTxt:FilterFrameText;
        private var _consortiaTxt:FilterFrameText;
        private var _dutyField:FilterFrameText;
        private var _iconContainer:VBox;
        private var _levelIcon:LevelIcon;
        private var _vipIcon:VipLevelIcon;
        private var _militaryIcon:MilitaryIcon;
        private var _marriedIcon:MarriedIcon;
        private var _diamon:DiamondIcon;
        private var _bunIcon:DiamondIcon;
        private var _suidIcon:SuidIcon;
        private var _totemIcon:TotemIcon;
        private var _runeIcon:RuneIcon;
        private var _badge:Badge;
        private var _hiddenControlsBg:Bitmap;
        private var _hideHatBtn:SelectedCheckButton;
        private var _hideGlassBtn:SelectedCheckButton;
        private var _hideSuitBtn:SelectedCheckButton;
        private var _hideWingBtn:SelectedCheckButton;
        private var _hideBg:Bitmap;
        private var _achvEnable:Boolean = true;
        private var _addFriendBtn:BaseButton;
        private var _buyAvatar:BaseButton;
        private var _textLevelPrpgress:FilterFrameText;
        private var _progressLevel:LevelProgress;
        private var _character:RoomCharacter;
        private var _dragDropArea:PersonalInfoDragInArea;
        private var _offerSourcePosition:Point;
        private var _vipName:GradientText;
        private var _showEquip:Sprite;
        private var _isVisible:Boolean = true;
        private var _FashionBtn:BaseButton;
        private var _EquiepBtn:BaseButton;
        private var _fashionView:PlayerFashionView;
        private var _equipView:PlayerEquipView;
        private var _fightPowerArr:Array;
        private var _figthPower:FightPowerView;
        private var _personView:PlayerPersonView;
        private var _fatigueTxt:FilterFrameText;
        private var _buyFatigueBtn:BaseButton;
        private var _petInfo:PetInfo;
        private var _petMovie:ActionMovie;
        private var ACTIONS:Array = ["standA", "walkA", "walkB"];
        private var _loader:BaseLoader;
        private var _weapon:BitmapLoaderProxy;
        private var _storeBtn:BaseButton;
        private var _switchShowII:Boolean = true;

        public function PlayerInfoView()
        {
            PlayerManager.Instance.changeState(PlayerViewState.EQUIP);
            this.initView();
            this.initProperties();
            this.initEvents();
        }

        private function initView():void
        {
            this._theCostOfFatigue = PlayerManager.Instance.Self.getBuyFatigueMoney();
            this._dragDropArea = new PersonalInfoDragInArea();
            addChild(this._dragDropArea);
            this._showEquip = new Sprite();
            addChild(this._showEquip);
            this._personView = ComponentFactory.Instance.creat("bagAndInfo.PlayerPersonView");
            addChild(this._personView);
            this._equipView = ComponentFactory.Instance.creat("bagAndInfo.PlayerEquipView");
            this._showEquip.addChildAt(this._equipView, 0);
            this._fashionView = ComponentFactory.Instance.creat("bagAndInfo.PlayerFashionView");
            this._showEquip.addChildAt(this._fashionView, 0);
            this._equipView.visible = true;
            this._fashionView.visible = false;
            this._FashionBtn = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.btnFashion");
            if (((PlayerManager.Instance.Self.Bag.getItemAt(14)) && (!(SavePointManager.Instance.savePoints[33]))))
            {
                SavePointManager.Instance.setSavePoint(33);
            };
            if (((PlayerManager.Instance.Self.Bag.getItemAt(0)) && (!(SavePointManager.Instance.savePoints[64]))))
            {
                SavePointManager.Instance.setSavePoint(64);
            };
            if (SavePointManager.Instance.savePoints[33])
            {
                addChild(this._FashionBtn);
            };
            this._FashionBtn.visible = true;
            this._EquiepBtn = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.btnEquipment");
            addChild(this._EquiepBtn);
            this._EquiepBtn.visible = false;
            this._nickNameTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewNickNameText");
            this._consortiaTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewConsortiaText");
            addChild(this._consortiaTxt);
            this._addFriendBtn = ComponentFactory.Instance.creatComponentByStylename("addFriendBtn1");
            PositionUtils.setPos(this._addFriendBtn, "bagAndInfo.FritendBtn.Pos");
            addChild(this._addFriendBtn);
            this._buyAvatar = ComponentFactory.Instance.creatComponentByStylename("addFriendBtn2");
            this._buyAvatar.x = 236;
            this._buyAvatar.y = 50;
            if ((!(StateManager.isInFight)))
            {
                addChild(this._buyAvatar);
                this._buyAvatar.visible = false;
            };
            this._dutyField = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.info.DutyField");
            addChild(this._dutyField);
            this._iconContainer = ComponentFactory.Instance.creatComponentByStylename("asset.bagAndInfo.iconContainer");
            this._showEquip.addChild(this._iconContainer);
            this._iconContainer.visible = true;
            this._progressLevel = ComponentFactory.Instance.creatComponentByStylename("LevelProgress");
            this._showEquip.addChild(this._progressLevel);
            this._progressLevel.tipStyle = "ddt.view.tips.OneLineTip";
            this._progressLevel.tipDirctions = "3,7,6";
            this._progressLevel.tipGapV = 20;
            this._hideBg = ComponentFactory.Instance.creatBitmap("ddtbagAndInfo.hideBg");
            this._showEquip.addChild(this._hideBg);
            this._hideBg.visible = false;
            this._hideGlassBtn = ComponentFactory.Instance.creatComponentByStylename("personanHideHatCheckBox");
            this._showEquip.addChild(this._hideGlassBtn);
            this._hideHatBtn = ComponentFactory.Instance.creatComponentByStylename("personanHideGlassCheckBox");
            this._showEquip.addChild(this._hideHatBtn);
            this._hideSuitBtn = ComponentFactory.Instance.creatComponentByStylename("personanHideSuitCheckBox");
            this._showEquip.addChild(this._hideSuitBtn);
            this._hideWingBtn = ComponentFactory.Instance.creatComponentByStylename("personanHideWingCheckBox");
            this._showEquip.addChild(this._hideWingBtn);
            this._hideGlassBtn.visible = false;
            this._hideHatBtn.visible = false;
            this._hideSuitBtn.visible = false;
            this._hideWingBtn.visible = false;
            this._figthPower = ComponentFactory.Instance.creatCustomObject("bagAndInfo.FightPowerView");
            addChild(this._figthPower);
            this._figthPower.visible = true;
            this._fatigueTxt = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.fatigue.text");
            this._showEquip.addChild(this._fatigueTxt);
            this._buyFatigueBtn = ComponentFactory.Instance.creatComponentByStylename("buyFatigueBtn");
            this._buyFatigueBtn.tipData = LanguageMgr.GetTranslation("ddt.buyFatigue.tipData");
            this._showEquip.addChild(this._buyFatigueBtn);
            this._storeBtn = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.storeBtn");
            this._storeBtn.tipData = "快捷铁匠铺";
            this._showEquip.addChild(this._storeBtn);
            if (SavePointManager.Instance.savePoints[67])
            {
                this._storeBtn.enable = true;
                this._storeBtn.filters = null;
            }
            else
            {
                this._storeBtn.enable = false;
                this._storeBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            };
        }

        public function switchShow(_arg_1:Boolean):void
        {
            this._showEquip.visible = (!(_arg_1));
            this._nickNameTxt.visible = (!(_arg_1));
            this._consortiaTxt.visible = (!(_arg_1));
            this._dutyField.visible = (!(_arg_1));
            if (this._vipName != null)
            {
                this._vipName.visible = (!(_arg_1));
                this._isVisible = (!(_arg_1));
            };
        }

        public function switchShowII(_arg_1:Boolean):void
        {
            this._switchShowII = (!(_arg_1));
            this.switchShow(_arg_1);
            this._addFriendBtn.visible = (!(_arg_1));
            if (this._info.ID == PlayerManager.Instance.Self.ID)
            {
                this._addFriendBtn.visible = false;
            };
        }

        private function initProperties():void
        {
            this._hideHatBtn.text = LanguageMgr.GetTranslation("shop.ShopIITryDressView.hideHat");
            this._hideGlassBtn.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.glass");
            this._hideSuitBtn.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.suit");
            this._hideWingBtn.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.wing");
        }

        private function initEvents():void
        {
            this._addFriendBtn.addEventListener(MouseEvent.CLICK, this.__addFriendClickHandler);
            this._buyAvatar.addEventListener(MouseEvent.CLICK, this.__buyAvatarClickHandler);
            this._hideGlassBtn.addEventListener(MouseEvent.CLICK, this.__hideGlassClickHandler);
            this._hideHatBtn.addEventListener(MouseEvent.CLICK, this.__hideHatClickHandler);
            this._hideSuitBtn.addEventListener(MouseEvent.CLICK, this.__hideSuitClickHandler);
            this._hideWingBtn.addEventListener(MouseEvent.CLICK, this.__hideWingClickHandler);
            this._FashionBtn.addEventListener(MouseEvent.CLICK, this.__FashionBtnClick);
            this._EquiepBtn.addEventListener(MouseEvent.CLICK, this.__EquipBtnClick);
            PlayerManager.Instance.addEventListener(PlayerManager.CHAGE_STATE, this.__changeState);
            TimeManager.addEventListener(TimeEvents.MINUTES, this.__updateatigue);
            this._buyFatigueBtn.addEventListener(MouseEvent.CLICK, this.__onBuyFatigueClick);
            TotemManager.instance.addEventListener(TotemEvent.TOTEM_UPDATE, this.__onTotemUpdate);
            this._equipView.addEventListener(BagEvent.WEAPON_READY, this.__weaponReady);
            this._equipView.addEventListener(BagEvent.WEAPON_REMOVE, this.__weaponRemove);
            this._fashionView.addEventListener(BagEvent.FASHION_READY, this.__fashionReady);
            if ((((!(StateManager.currentStateType == StateType.MAIN)) && (!(StateManager.currentStateType == StateType.SINGLEDUNGEON))) && (!(StateManager.currentStateType == StateType.DUNGEON_LIST))))
            {
                PlayerManager.Instance.addEventListener(PlayerManager.BUY_FATIUE, this.__buyFatigueHandler);
            };
            this._fashionView.addEventListener(BagEvent.FASHION_REMOVE, this.__fashionRemove);
            this._storeBtn.addEventListener(MouseEvent.CLICK, this.__storeBtnClickHandler);
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__propertyChange);
        }

        private function __propertyChange(_arg_1:PlayerPropertyEvent):void
        {
            if (_arg_1.changedProperties["Pets"])
            {
                this._petInfo = PlayerManager.Instance.Self.pets[0];
                this.updatePets();
            };
        }

        private function __buyFatigueHandler(_arg_1:Event):void
        {
            this.updataFatigueTxt(PlayerManager.Instance.Self.Fatigue);
        }

        private function __weaponReady(_arg_1:BagEvent):void
        {
            if ((!(this._FashionBtn.parent)))
            {
                addChild(this._FashionBtn);
            };
            dispatchEvent(new BagEvent(BagEvent.WEAPON_READY, new Dictionary()));
        }

        private function __weaponRemove(_arg_1:BagEvent):void
        {
            if (SavePointManager.Instance.isInSavePoint(33))
            {
                if (this._FashionBtn.parent)
                {
                    removeChild(this._FashionBtn);
                };
            };
            dispatchEvent(new BagEvent(BagEvent.WEAPON_REMOVE, new Dictionary()));
        }

        private function __fashionReady(_arg_1:BagEvent):void
        {
            dispatchEvent(new BagEvent(BagEvent.FASHION_READY, new Dictionary()));
        }

        private function __fashionRemove(_arg_1:BagEvent):void
        {
            dispatchEvent(new BagEvent(BagEvent.FASHION_REMOVE, new Dictionary()));
        }

        private function __onTotemUpdate(_arg_1:TotemEvent):void
        {
            if (((this._totemIcon) && (this._info)))
            {
                this._totemIcon.setInfo(this._info);
            };
        }

        private function __onBuyFatigueClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.getRestBuyFatigueCount > 0)
            {
                AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("ddt.buyFatigue.tipInfo", PlayerManager.Instance.Self.getBuyFatigueMoney()), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.ALPHA_BLOCKGOUND).addEventListener(FrameEvent.RESPONSE, this.__frameEvent);
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.buyFatigue.tipInfo3"));
            };
        }

        private function __frameEvent(_arg_1:FrameEvent):void
        {
            var _local_4:BaseAlerFrame;
            var _local_5:BaseAlerFrame;
            var _local_2:int = PlayerManager.Instance.Self.getBuyFatigueMoney();
            var _local_3:BaseAlerFrame = (_arg_1.target as BaseAlerFrame);
            _local_3.removeEventListener(FrameEvent.RESPONSE, this.__frameEvent);
            _local_3.dispose();
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                if (PlayerManager.Instance.Self.bagLocked)
                {
                    BaglockedManager.Instance.show();
                    return;
                };
                if (((PlayerManager.Instance.Self.DDTMoney == 0) && (_local_2 > PlayerManager.Instance.Self.Money)))
                {
                    _local_4 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("poorNote"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.BLCAK_BLOCKGOUND);
                    _local_4.moveEnable = false;
                    _local_4.addEventListener(FrameEvent.RESPONSE, this.__poorManResponse);
                }
                else
                {
                    if ((PlayerManager.Instance.Self.DDTMoney + PlayerManager.Instance.Self.Money) < _local_2)
                    {
                        _local_5 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("poorNote"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.BLCAK_BLOCKGOUND);
                        _local_5.moveEnable = false;
                        _local_5.addEventListener(FrameEvent.RESPONSE, this.__poorManResponse);
                    }
                    else
                    {
                        SocketManager.Instance.out.sendBuyFatigue();
                    };
                };
            };
        }

        private function __poorManResponse(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__poorManResponse);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                LeavePageManager.leaveToFillPath();
            };
            ObjectUtils.disposeObject(_local_2);
        }

        private function __updateatigue(_arg_1:TimeEvents):void
        {
            if (this._info.ID == PlayerManager.Instance.Self.ID)
            {
                this.updataFatigueTxt(PlayerManager.Instance.Self.Fatigue);
            };
        }

        private function __EquipBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._EquiepBtn.visible = false;
            this._FashionBtn.visible = true;
            this._hideGlassBtn.visible = false;
            this._hideHatBtn.visible = false;
            this._hideSuitBtn.visible = false;
            this._hideWingBtn.visible = false;
            this._hideBg.visible = false;
            this._buyAvatar.visible = false;
            this._levelIcon.visible = true;
            this._suidIcon.visible = true;
            this._totemIcon.visible = true;
            this._runeIcon.visible = true;
            this._iconContainer.visible = true;
            PlayerManager.Instance.changeState(PlayerViewState.EQUIP);
        }

        private function __FashionBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._EquiepBtn.visible = true;
            this._FashionBtn.visible = false;
            this._levelIcon.visible = false;
            this._suidIcon.visible = false;
            this._totemIcon.visible = false;
            this._runeIcon.visible = true;
            this._iconContainer.visible = false;
            this._hideGlassBtn.visible = this._showSelfOperation;
            this._hideHatBtn.visible = this._showSelfOperation;
            this._hideSuitBtn.visible = this._showSelfOperation;
            this._hideWingBtn.visible = this._showSelfOperation;
            this._hideBg.visible = this._showSelfOperation;
            if (((this._info.ID == PlayerManager.Instance.Self.ID) || ((!(this._info.ZoneID == PlayerManager.Instance.Self.ZoneID)) && (!(this._info.ZoneID == 0)))))
            {
                this._buyAvatar.visible = false;
            }
            else
            {
                this._buyAvatar.visible = true;
            };
            PlayerManager.Instance.changeState(PlayerViewState.FASHION);
            NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_FASHION_BTN);
        }

        private function __changeState(_arg_1:Event):void
        {
            if (PlayerManager.Instance.playerstate == PlayerViewState.EQUIP)
            {
                if (this._equipView == null)
                {
                    this._equipView = ComponentFactory.Instance.creat("bagAndInfo.PlayerEquipView");
                };
                if (this._fashionView == null)
                {
                    this._fashionView = ComponentFactory.Instance.creat("bagAndInfo.PlayerFashionView");
                };
                this._equipView.visible = true;
                this._fashionView.visible = false;
                this._EquiepBtn.visible = false;
                this._FashionBtn.visible = true;
                this._hideGlassBtn.visible = false;
                this._hideHatBtn.visible = false;
                this._hideSuitBtn.visible = false;
                this._hideWingBtn.visible = false;
                this._hideBg.visible = false;
                this._levelIcon.visible = true;
                this._suidIcon.visible = true;
                this._totemIcon.visible = true;
                this._runeIcon.visible = true;
                this._iconContainer.visible = true;
            }
            else
            {
                if (this._equipView == null)
                {
                    this._equipView = ComponentFactory.Instance.creat("bagAndInfo.PlayerEquipView");
                    this._showEquip.addChild(this._equipView);
                };
                if (this._fashionView == null)
                {
                    this._fashionView = ComponentFactory.Instance.creat("bagAndInfo.PlayerFashionView");
                    this._showEquip.addChild(this._fashionView);
                };
                this._equipView.visible = false;
                this._fashionView.visible = true;
                this._EquiepBtn.visible = true;
                this._FashionBtn.visible = false;
                this._levelIcon.visible = false;
                this._suidIcon.visible = false;
                this._totemIcon.visible = false;
                this._runeIcon.visible = false;
                this._iconContainer.visible = false;
                this._hideGlassBtn.visible = this._showSelfOperation;
                this._hideHatBtn.visible = this._showSelfOperation;
                this._hideSuitBtn.visible = this._showSelfOperation;
                this._hideWingBtn.visible = this._showSelfOperation;
                this._hideBg.visible = this._showSelfOperation;
            };
        }

        private function removeEvent():void
        {
            this._addFriendBtn.removeEventListener(MouseEvent.CLICK, this.__addFriendClickHandler);
            this._buyAvatar.removeEventListener(MouseEvent.CLICK, this.__buyAvatarClickHandler);
            this._hideGlassBtn.removeEventListener(MouseEvent.CLICK, this.__hideGlassClickHandler);
            this._hideHatBtn.removeEventListener(MouseEvent.CLICK, this.__hideHatClickHandler);
            this._hideSuitBtn.removeEventListener(MouseEvent.CLICK, this.__hideSuitClickHandler);
            this._hideWingBtn.removeEventListener(MouseEvent.CLICK, this.__hideWingClickHandler);
            this._FashionBtn.removeEventListener(MouseEvent.CLICK, this.__FashionBtnClick);
            this._EquiepBtn.removeEventListener(MouseEvent.CLICK, this.__EquipBtnClick);
            if (this._info)
            {
                this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__changeHandler);
            };
            PlayerManager.Instance.removeEventListener(PlayerManager.VIP_STATE_CHANGE, this.__upVip);
            PlayerManager.Instance.removeEventListener(PlayerManager.UPDATE_FIGHT_VIP, this.__upFgihtToolBox);
            PlayerManager.Instance.removeEventListener(PlayerManager.CHAGE_STATE, this.__changeState);
            TimeManager.removeEventListener(TimeEvents.MINUTES, this.__updateatigue);
            TotemManager.instance.removeEventListener(TotemEvent.TOTEM_UPDATE, this.__onTotemUpdate);
            this._equipView.removeEventListener(BagEvent.WEAPON_READY, this.__weaponReady);
            this._equipView.removeEventListener(BagEvent.WEAPON_REMOVE, this.__weaponRemove);
            this._fashionView.removeEventListener(BagEvent.FASHION_READY, this.__fashionReady);
            if ((((!(StateManager.currentStateType == StateType.MAIN)) && (!(StateManager.currentStateType == StateType.SINGLEDUNGEON))) && (!(StateManager.currentStateType == StateType.DUNGEON_LIST))))
            {
                PlayerManager.Instance.removeEventListener(PlayerManager.BUY_FATIUE, this.__buyFatigueHandler);
            };
            this._fashionView.removeEventListener(BagEvent.FASHION_REMOVE, this.__fashionRemove);
            this._storeBtn.removeEventListener(MouseEvent.CLICK, this.__storeBtnClickHandler);
            this._buyFatigueBtn.removeEventListener(MouseEvent.CLICK, this.__onBuyFatigueClick);
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__propertyChange);
        }

        private function __storeBtnClickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            BagStore.instance.show();
            BagStore.instance.isFromBagFrame = true;
        }

        private function __addFriendClickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            IMController.Instance.addFriend(this._info.NickName);
        }

        private function __buyAvatarClickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            ShopBuyManager.Instance.buyAvatar(this._info);
        }

        private function __hideGlassClickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.sendHideLayer(EquipType.GLASS, this._hideGlassBtn.selected);
        }

        private function __hideHatClickHandler(_arg_1:Event):void
        {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.sendHideLayer(EquipType.HEAD, this._hideHatBtn.selected);
        }

        private function __hideSuitClickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.sendHideLayer(EquipType.SUITS, this._hideSuitBtn.selected);
        }

        private function __hideWingClickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.sendHideLayer(EquipType.WING, this._hideWingBtn.selected);
        }

        public function set info(_arg_1:PlayerInfo):void
        {
            if (this._info == _arg_1)
            {
                return;
            };
            if (this._info)
            {
                this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__changeHandler);
                PlayerManager.Instance.removeEventListener(PlayerManager.VIP_STATE_CHANGE, this.__upVip);
                PlayerManager.Instance.removeEventListener(PlayerManager.UPDATE_FIGHT_VIP, this.__upFgihtToolBox);
                this._info = null;
            };
            this._info = _arg_1;
            if (this._info)
            {
                this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__changeHandler);
                PlayerManager.Instance.addEventListener(PlayerManager.VIP_STATE_CHANGE, this.__upVip);
                PlayerManager.Instance.addEventListener(PlayerManager.UPDATE_FIGHT_VIP, this.__upFgihtToolBox);
                this._petInfo = this._info.pets[0];
                if (this._equipView)
                {
                    this._equipView.info = this._info;
                };
                if (this._fashionView)
                {
                    this._fashionView.info = this._info;
                };
                if (this._personView)
                {
                    this._personView.info = this._info;
                };
                this.addWeapon(this._info);
            };
            this.updateView();
        }

        public function set bagInfo(_arg_1:BagInfo):void
        {
            if (this._bagInfo == _arg_1)
            {
                return;
            };
            if (this._bagInfo)
            {
                this._bagInfo = null;
            };
            this._bagInfo = _arg_1;
            if (this._bagInfo)
            {
                if (this._equipView)
                {
                    this._equipView.bagInfo = this._bagInfo;
                };
                if (this._fashionView)
                {
                    this._fashionView.bagInfo = this._bagInfo;
                };
            };
        }

        private function __changeHandler(_arg_1:PlayerPropertyEvent):void
        {
            if (_arg_1)
            {
                if (((_arg_1.changedProperties["WeaponID"]) || (!(this._info.ID == PlayerManager.Instance.Self.ID))))
                {
                    this.addWeapon(this._info);
                };
                this.updatePersonInfo();
                this.updateHide();
                this.updateIcons();
            }
            else
            {
                this.addWeapon(this._info);
                this.updatePersonInfo();
                this.updateHide();
                this.updateIcons();
            };
        }

        private function __upVip(_arg_1:Event):void
        {
            this.__changeHandler(null);
        }

        private function __upFgihtToolBox(_arg_1:Event):void
        {
            this.__changeHandler(null);
        }

        private function updateView():void
        {
            this.updateCharacter();
            this.updatePets();
            this.updatePersonInfo();
            this.updateHide();
            this.updateIcons();
            this.updateShowOperation();
        }

        private function updateHide():void
        {
            if (this._info)
            {
                this._hideGlassBtn.selected = this._info.getGlassHide();
                this._hideHatBtn.selected = this._info.getHatHide();
                this._hideSuitBtn.selected = this._info.getSuitesHide();
                this._hideWingBtn.selected = this._info.wingHide;
            };
        }

        private function updateCharacter():void
        {
            if (this._info)
            {
                if (this._character)
                {
                    this._character.dispose();
                    this._character = null;
                };
                this._character = (CharactoryFactory.createCharacter(this._info, "room") as RoomCharacter);
                this._character.showGun = false;
                this._character.show(true, -1);
                this._character.x = 275;
                this._character.y = 114;
                this._showEquip.addChild(this._character);
            }
            else
            {
                this._character.dispose();
                this._character = null;
            };
        }

        private function updatePets():void
        {
            var _local_1:Class;
            if (this._petInfo)
            {
                if (ModuleLoader.hasDefinition(("pet.asset.game." + this._petInfo.GameAssetUrl)))
                {
                    _local_1 = (ModuleLoader.getDefinition(("pet.asset.game." + this._petInfo.GameAssetUrl)) as Class);
                    if (this._petMovie)
                    {
                        this._petMovie.removeEventListener(ActionMovieEvent.ACTION_END, this.doNextAction);
                        if (this._petMovie)
                        {
                            ObjectUtils.disposeObject(this._petMovie);
                        };
                        this._petMovie = null;
                    };
                    this._petMovie = new (_local_1)();
                    this._petMovie.doAction(Helpers.randomPick(this.ACTIONS));
                    this._petMovie.addEventListener(ActionMovieEvent.ACTION_END, this.doNextAction);
                    this._petMovie.visible = true;
                    PositionUtils.setPos(this._petMovie, "ddtbagAndInfo.petMovie.Pos");
                    addChild(this._petMovie);
                }
                else
                {
                    this._loader = LoadResourceManager.instance.createLoader(PathManager.solvePetGameAssetUrl(this._petInfo.GameAssetUrl), BaseLoader.MODULE_LOADER);
                    this._loader.addEventListener(LoaderEvent.COMPLETE, this.__onComplete);
                    LoadResourceManager.instance.startLoad(this._loader);
                };
            };
        }

        private function doNextAction(_arg_1:ActionMovieEvent):void
        {
            var _local_2:uint;
            if (this._petMovie)
            {
                if ((getTimer() - _local_2) > 40)
                {
                    this._petMovie.doAction(Helpers.randomPick(this.ACTIONS));
                };
                _local_2 = getTimer();
            };
        }

        private function __onComplete(_arg_1:LoaderEvent):void
        {
            var _local_2:Class;
            this._loader.removeEventListener(LoaderEvent.COMPLETE, this.__onComplete);
            if (this._petInfo)
            {
                if (ModuleLoader.hasDefinition(("pet.asset.game." + this._petInfo.GameAssetUrl)))
                {
                    _local_2 = (ModuleLoader.getDefinition(("pet.asset.game." + this._petInfo.GameAssetUrl)) as Class);
                    if (this._petMovie)
                    {
                        this._petMovie.removeEventListener(ActionMovieEvent.ACTION_END, this.doNextAction);
                        if (this._petMovie)
                        {
                            ObjectUtils.disposeObject(this._petMovie);
                        };
                        this._petMovie = null;
                    };
                    this._petMovie = new (_local_2)();
                    this._petMovie.doAction(Helpers.randomPick(this.ACTIONS));
                    this._petMovie.addEventListener(ActionMovieEvent.ACTION_END, this.doNextAction);
                    this._petMovie.visible = true;
                    PositionUtils.setPos(this._petMovie, "ddtbagAndInfo.petMovie.Pos");
                    addChild(this._petMovie);
                };
            };
        }

        private function addWeapon(_arg_1:PlayerInfo):void
        {
            var _local_2:ItemTemplateInfo;
            var _local_3:String;
            var _local_4:Rectangle;
            if (this._weapon)
            {
                ObjectUtils.disposeObject(this._weapon);
            };
            if (_arg_1.ID == PlayerManager.Instance.Self.ID)
            {
                _local_2 = ItemManager.Instance.getTemplateById(_arg_1.WeaponID);
            }
            else
            {
                if (((_arg_1.Bag.items.length > 0) && (!(_arg_1.Bag.items[14] == null))))
                {
                    _local_2 = ItemManager.Instance.getTemplateById(_arg_1.Bag.items[14].TemplateID);
                };
            };
            if (_local_2)
            {
                _local_3 = PathManager.solveGoodsPath(_local_2, _local_2.Pic, (this._info.Sex == 1), BaseLayer.SHOW, "A", "1", _local_2.Level);
                _local_4 = ComponentFactory.Instance.creatCustomObject("asset.ddtbagAndInfo.WeaponSize");
                this._weapon = new BitmapLoaderProxy(_local_3, _local_4);
                this._weapon.scaleX = -1;
                this._weapon.mouseEnabled = false;
                this._weapon.mouseChildren = false;
                PositionUtils.setPos(this._weapon, "ddtbagAndInfo.Weapon.Pos");
                addChild(this._weapon);
            };
        }

        public function allowLvIconClick():void
        {
            if (this._levelIcon)
            {
                this._levelIcon.allowClick();
            };
        }

        private function updateIcons():void
        {
            var _local_1:int;
            if (this._info)
            {
                if (this._levelIcon == null)
                {
                    this._levelIcon = ComponentFactory.Instance.creatCustomObject("asset.bagAndInfo.levelIcon");
                    if (this._info.IsVIP)
                    {
                        this._levelIcon.x = (this._levelIcon.x + 1);
                    };
                };
                this._levelIcon.setSize(LevelIcon.SIZE_BIG);
                if (this._suidIcon == null)
                {
                    this._suidIcon = ComponentFactory.Instance.creatCustomObject("asset.bagAndInfo.SuidIcon");
                };
                if (this._totemIcon == null)
                {
                    this._totemIcon = ComponentFactory.Instance.creatCustomObject("asset.bagAndInfo.TotemIcon");
                };
                if (this._runeIcon == null)
                {
                    this._runeIcon = ComponentFactory.Instance.creatCustomObject("bagAndInfo.RuneIcon");
                };
                _local_1 = 1;
                if (((((StateManager.isInFight) || (StateManager.currentStateType == StateType.TRAINER1)) || (StateManager.currentStateType == StateType.TRAINER2)) || (StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)))
                {
                    _local_1 = ((GameManager.Instance.Current.findLivingByPlayerID(this._info.ID, this._info.ZoneID) == null) ? -1 : GameManager.Instance.Current.findLivingByPlayerID(this._info.ID, this._info.ZoneID).team);
                };
                this._levelIcon.setInfo(this._info.Grade, this._info.Repute, this._info.WinCount, this._info.TotalCount, this._info.FightPower, this._info.Offer, true, false, _local_1);
                this._suidIcon.setInfo(this._info);
                this._totemIcon.setInfo(this._info);
                this._runeIcon.setInfo(this._info);
                this._showEquip.addChild(this._levelIcon);
                this._showEquip.addChild(this._suidIcon);
                this._showEquip.addChild(this._runeIcon);
                addChild(this._totemIcon);
                if (((this._info.ID == PlayerManager.Instance.Self.ID) || ((this._info.IsVIP) && ((this._info.ZoneID == PlayerManager.Instance.Self.ZoneID) || (this._info.ZoneID == 0)))))
                {
                    if (this._vipIcon == null)
                    {
                        this._vipIcon = ComponentFactory.Instance.creatCustomObject("asset.bagAndInfo.VipIcon");
                        this._iconContainer.addChild(this._vipIcon);
                    };
                    this._vipIcon.setInfo(this._info);
                    if ((!(this._info.IsVIP)))
                    {
                        this._vipIcon.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                    }
                    else
                    {
                        this._vipIcon.filters = null;
                    };
                }
                else
                {
                    if (this._vipIcon)
                    {
                        this._vipIcon.dispose();
                        this._vipIcon = null;
                    };
                };
                if ((!(this._militaryIcon)))
                {
                    this._militaryIcon = new MilitaryIcon(this._info);
                    this._militaryIcon.x = 19;
                    this._militaryIcon.setMilitary(this._info.MilitaryRankTotalScores);
                    this._iconContainer.addChild(this._militaryIcon);
                }
                else
                {
                    this._militaryIcon.setMilitary(this._info.MilitaryRankTotalScores);
                };
                if (this._info.SpouseID > 0)
                {
                    if (this._marriedIcon == null)
                    {
                        this._marriedIcon = ComponentFactory.Instance.creatCustomObject("asset.bagAndInfo.MarriedIcon");
                    };
                    this._marriedIcon.tipData = {
                        "nickName":this._info.SpouseName,
                        "gender":this._info.Sex
                    };
                    this._iconContainer.addChild(this._marriedIcon);
                }
                else
                {
                    if (this._marriedIcon)
                    {
                        this._marriedIcon.dispose();
                        this._marriedIcon = null;
                    };
                };
                if (DiamondManager.instance.model.pfdata.pfType > 0)
                {
                    if (this._info.isYellowVip)
                    {
                        if ((!(this._diamon)))
                        {
                            this._diamon = ComponentFactory.Instance.creat("asset.ddtbagAndInfo.diamondIcon", [0]);
                        };
                        this._diamon.level = this._info.MemberDiamondLevel;
                        this._iconContainer.addChild(this._diamon);
                    }
                    else
                    {
                        ObjectUtils.disposeObject(this._diamon);
                        this._diamon = null;
                    };
                    if (DiamondManager.instance.pfType == 2)
                    {
                        if ((!(this._bunIcon)))
                        {
                            this._bunIcon = ComponentFactory.Instance.creat("asset.ddtbagAndInfo.bunIcon", [1]);
                        };
                        this._bunIcon.level = this._info.Level3366;
                        this._iconContainer.addChild(this._bunIcon);
                    };
                }
                else
                {
                    ObjectUtils.disposeObject(this._diamon);
                    this._diamon = null;
                    ObjectUtils.disposeObject(this._bunIcon);
                    this._bunIcon = null;
                };
                if (((this._info.ConsortiaID > 0) && (this._info.badgeID > 0)))
                {
                    if (this._badge == null)
                    {
                        this._badge = new Badge();
                        this._badge.x = 21;
                        this._badge.badgeID = this._info.badgeID;
                        this._badge.showTip = true;
                        this._badge.tipData = this._info.ConsortiaName;
                        this._iconContainer.addChild(this._badge);
                    };
                }
                else
                {
                    if (this._badge)
                    {
                        this._badge.dispose();
                        this._badge = null;
                    };
                };
                this._iconContainer.arrange();
            }
            else
            {
                if (this._levelIcon)
                {
                    this._levelIcon.dispose();
                    this._levelIcon = null;
                };
                if (this._suidIcon)
                {
                    this._suidIcon.dispose();
                    this._suidIcon = null;
                };
                if (this._totemIcon)
                {
                    this._totemIcon.dispose();
                    this._totemIcon = null;
                };
                if (this._runeIcon)
                {
                    this._runeIcon.dispose();
                    this._runeIcon = null;
                };
                if (this._vipIcon)
                {
                    this._vipIcon.dispose();
                    this._vipIcon = null;
                };
                if (this._militaryIcon)
                {
                    ObjectUtils.disposeObject(this._militaryIcon);
                    this._militaryIcon = null;
                };
                if (this._marriedIcon)
                {
                    this._marriedIcon.dispose();
                    this._marriedIcon = null;
                };
                ObjectUtils.disposeObject(this._diamon);
                this._diamon = null;
                ObjectUtils.disposeObject(this._bunIcon);
                this._bunIcon = null;
                if (this._badge)
                {
                    this._badge.dispose();
                    this._badge = null;
                };
            };
        }

        private function updataFatigueTxt(_arg_1:int):void
        {
            if (_arg_1 > 100)
            {
                this._fatigueTxt.htmlText = LanguageMgr.GetTranslation("ddt.bagAndInfo.fatigue.red", _arg_1);
                this._buyFatigueBtn.enable = false;
            }
            else
            {
                this._fatigueTxt.htmlText = LanguageMgr.GetTranslation("ddt.bagAndInfo.fatigue.white", _arg_1);
                if (this._info.ID == PlayerManager.Instance.Self.ID)
                {
                    if (_arg_1 == 100)
                    {
                        this._buyFatigueBtn.enable = false;
                    }
                    else
                    {
                        this._buyFatigueBtn.enable = this._showSelfOperation;
                    };
                }
                else
                {
                    this._buyFatigueBtn.enable = false;
                };
            };
            FightPowerAndFatigue.Instance.reflashFatigue();
        }

        private function updatePersonInfo():void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            if (this._info == null)
            {
                return;
            };
            this.updataFatigueTxt(((this._info == null) ? 0 : this._info.Fatigue));
            this._dutyField.text = (((this._info.DutyName == null) || (this._info.DutyName == "")) ? "" : ((this._info.ConsortiaID > 0) ? (("< " + this._info.DutyName) + " >") : ""));
            if (((this._dutyField.text.length >= 8) && (!(this._dutyField.text == ""))))
            {
                this._dutyField.text = (this._dutyField.text.substr(0, 2) + "...>");
            };
            var _local_1:String = DisplayUtils.subStringByLength(this._nickNameTxt, ((this._info.NickName == null) ? "" : this._info.NickName), 130);
            this._nickNameTxt.text = _local_1;
            if (this._info.IsVIP)
            {
                ObjectUtils.disposeObject(this._vipName);
                this._vipName = VipController.instance.getVipNameTxt(130, this._info.VIPtype);
                this._vipName.x = this._nickNameTxt.x;
                this._vipName.y = this._nickNameTxt.y;
                this._vipName.text = this._nickNameTxt.text;
                this._vipName.visible = this._isVisible;
                addChild(this._vipName);
                DisplayUtils.removeDisplay(this._nickNameTxt);
            }
            else
            {
                addChild(this._nickNameTxt);
                DisplayUtils.removeDisplay(this._vipName);
            };
            this._consortiaTxt.text = ((this._info.ConsortiaName == null) ? "" : ((this._info.ConsortiaID > 0) ? this._info.ConsortiaName : ""));
            if (this._consortiaTxt.text.length >= 7)
            {
                this._consortiaTxt.text = (this._consortiaTxt.text.substr(0, 4) + "...");
            };
            this._dutyField.x = ((this._consortiaTxt.x + this._consortiaTxt.width) + 6);
            if ((this._dutyField.x + this._dutyField.width) > 267)
            {
                this._dutyField.autoSize = TextFieldAutoSize.NONE;
                this._dutyField.isAutoFitLength = true;
                _local_2 = (260 - this._dutyField.x);
                this._dutyField.width = _local_2;
            };
            if (this._info.ID == PlayerManager.Instance.Self.ID)
            {
                if (SavePointManager.Instance.savePoints[67])
                {
                    this._storeBtn.enable = this._showSelfOperation;
                    if (this._showSelfOperation)
                    {
                        this._storeBtn.filters = null;
                    }
                    else
                    {
                        this._storeBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                    };
                }
                else
                {
                    this._storeBtn.enable = false;
                    this._storeBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                };
                this._buyAvatar.visible = false;
            }
            else
            {
                this._storeBtn.enable = false;
                this._storeBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                if (PlayerManager.Instance.playerstate == PlayerViewState.EQUIP)
                {
                    this._buyAvatar.visible = false;
                }
                else
                {
                    this._buyAvatar.visible = true;
                };
            };
            this._figthPower.setInfo(this._info);
            if (this._info)
            {
                this._progressLevel.setProgress((Experience.getExpPercent(this._info.Grade, this._info.GP) * 100), 100);
                _local_3 = (Experience.expericence[this._info.Grade] - Experience.expericence[(this._info.Grade - 1)]);
                _local_4 = (this._info.GP - Experience.expericence[(this._info.Grade - 1)]);
                if (this._info.Grade < Experience.expericence.length)
                {
                    _local_4 = ((_local_4 > _local_3) ? _local_3 : _local_4);
                };
                if ((((StateManager.isInFight) && (!(this._info.ZoneID == 0))) && (!(this._info.ZoneID == PlayerManager.Instance.Self.ZoneID))))
                {
                    this._progressLevel.tipData = ("0/" + _local_3);
                }
                else
                {
                    if (((_local_4 > 0) && (this._info.Grade < Experience.expericence.length)))
                    {
                        this._progressLevel.tipData = ((_local_4 + "/") + _local_3);
                    }
                    else
                    {
                        if (this._info.Grade == Experience.expericence.length)
                        {
                            this._progressLevel.tipData = (_local_4 + "/0");
                        }
                        else
                        {
                            this._progressLevel.tipData = ("0/" + _local_3);
                        };
                    };
                };
            };
        }

        private function getHtmlTextByString(_arg_1:String, _arg_2:int):String
        {
            var _local_3:String;
            var _local_4:String;
            switch (_arg_2)
            {
                case 0:
                    _local_3 = "<TEXTFORMAT LEADING='-1'><P ALIGN='CENTER'><FONT FACE='宋体' SIZE='14' COLOR='#FFF6C9' ><B>";
                    _local_4 = "</B></FONT></P></TEXTFORMAT>";
                    break;
                case 1:
                    _local_3 = "<TEXTFORMAT LEADING='-1'><P ALIGN='CENTER'><FONT FACE='宋体' SIZE='14' COLOR='#FFF6C9' LETTERSPACING='0' KERNING='1'><B>";
                    _local_4 = "</B></FONT></P></TEXTFORMAT>";
                    break;
                case 2:
                    _local_3 = "<TEXTFORMAT LEADING='-1'><P ALIGN='CENTER'><FONT FACE='宋体' SIZE='14' COLOR='#FFF6C9' LETTERSPACING='0' KERNING='1'><B>";
                    _local_4 = "</B></FONT></P></TEXTFORMAT>";
                    break;
            };
            return ((_local_3 + _arg_1) + _local_4);
        }

        public function getPerCellByPlace(_arg_1:int):Point
        {
            return (this._equipView.getCellPos(_arg_1));
        }

        public function dispose():void
        {
            this.removeEvent();
            if (parent)
            {
                parent.removeChild(this);
            };
            ObjectUtils.disposeObject(this._badge);
            this._badge = null;
            ObjectUtils.disposeObject(this._iconContainer);
            this._iconContainer = null;
            ObjectUtils.disposeObject(this._vipName);
            this._vipName = null;
            ObjectUtils.disposeObject(this._showEquip);
            this._showEquip = null;
            ObjectUtils.disposeObject(this._nickNameTxt);
            this._nickNameTxt = null;
            ObjectUtils.disposeObject(this._consortiaTxt);
            this._consortiaTxt = null;
            ObjectUtils.disposeObject(this._character);
            this._character = null;
            ObjectUtils.disposeObject(this._progressLevel);
            this._progressLevel = null;
            ObjectUtils.disposeObject(this._dutyField);
            this._dutyField = null;
            ObjectUtils.disposeObject(this._levelIcon);
            this._levelIcon = null;
            ObjectUtils.disposeObject(this._suidIcon);
            this._suidIcon = null;
            ObjectUtils.disposeObject(this._totemIcon);
            this._totemIcon = null;
            ObjectUtils.disposeObject(this._runeIcon);
            this._runeIcon = null;
            ObjectUtils.disposeObject(this._vipIcon);
            this._vipIcon = null;
            ObjectUtils.disposeObject(this._militaryIcon);
            this._militaryIcon = null;
            ObjectUtils.disposeObject(this._marriedIcon);
            this._marriedIcon = null;
            ObjectUtils.disposeObject(this._diamon);
            this._diamon = null;
            ObjectUtils.disposeObject(this._bunIcon);
            this._bunIcon = null;
            ObjectUtils.disposeObject(this._hideGlassBtn);
            this._hideGlassBtn = null;
            ObjectUtils.disposeObject(this._hideHatBtn);
            this._hideHatBtn = null;
            ObjectUtils.disposeObject(this._hideSuitBtn);
            this._hideSuitBtn = null;
            ObjectUtils.disposeObject(this._hideWingBtn);
            this._hideWingBtn = null;
            ObjectUtils.disposeObject(this._hideBg);
            this._hideBg = null;
            ObjectUtils.disposeObject(this._addFriendBtn);
            this._addFriendBtn = null;
            ObjectUtils.disposeObject(this._buyAvatar);
            this._buyAvatar = null;
            ObjectUtils.disposeObject(this._buyFatigueBtn);
            this._buyFatigueBtn = null;
            ObjectUtils.disposeObject(this._dragDropArea);
            this._dragDropArea = null;
            ObjectUtils.disposeObject(this._EquiepBtn);
            this._EquiepBtn = null;
            ObjectUtils.disposeObject(this._FashionBtn);
            this._FashionBtn = null;
            this._fashionView.dispose();
            this._fashionView = null;
            this._equipView.dispose();
            this._equipView = null;
            this._figthPower.dispose();
            this._figthPower = null;
            ObjectUtils.disposeObject(this._personView);
            this._personView = null;
            ObjectUtils.disposeObject(this._fatigueTxt);
            this._fatigueTxt = null;
            if (this._weapon)
            {
                ObjectUtils.disposeObject(this._weapon);
                this._weapon = null;
            };
            ObjectUtils.disposeAllChildren(this);
            if (this._petMovie)
            {
                this._petMovie.removeEventListener(ActionMovieEvent.ACTION_END, this.doNextAction);
                if (this._petMovie)
                {
                    ObjectUtils.disposeObject(this._petMovie);
                };
                this._petMovie = null;
            };
            if (this._storeBtn)
            {
                ObjectUtils.disposeObject(this._storeBtn);
                this._storeBtn = null;
            };
            this._petInfo = null;
            this._info = null;
        }

        public function startShine(_arg_1:ItemTemplateInfo):void
        {
            if (((PlayerManager.Instance.playerstate == PlayerViewState.FASHION) && ((EquipType.isFashionViewGoods(_arg_1)) || (EquipType.isRingEquipment(_arg_1)))))
            {
                this._fashionView.startShine(_arg_1);
            }
            else
            {
                if ((((PlayerManager.Instance.playerstate == PlayerViewState.EQUIP) && (!(EquipType.isFashionViewGoods(_arg_1)))) && (!(EquipType.isRingEquipment(_arg_1)))))
                {
                    this._equipView.startShine(_arg_1);
                };
            };
        }

        public function stopShine():void
        {
            if (PlayerManager.Instance.playerstate == PlayerViewState.FASHION)
            {
                this._fashionView.stopShine();
            }
            else
            {
                this._equipView.stopShine();
            };
        }

        public function get showSelfOperation():Boolean
        {
            return (this._showSelfOperation);
        }

        public function set showSelfOperation(_arg_1:Boolean):void
        {
            this._showSelfOperation = _arg_1;
            if (this._equipView)
            {
                this._equipView.showSelfOperation = _arg_1;
            };
            if (this._fashionView)
            {
                this._fashionView.showSelfOperation = _arg_1;
            };
            this.updateShowOperation();
        }

        private function updateShowOperation():void
        {
            (((((((((((!(this._info == null)) && ((this._info.ZoneID == 0) || (this._info.ZoneID == PlayerManager.Instance.Self.ZoneID))) && (PlayerManager.Instance.Self.Grade > 2)) && (!(StateManager.isInFight))) && (!(StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW))) && (!(StateManager.currentStateType == StateType.TRAINER1))) && (!(StateManager.currentStateType == StateType.TRAINER2))) && (!(StateManager.currentStateType == StateType.HOT_SPRING_ROOM))) && (!(StateManager.currentStateType == StateType.CHURCH_ROOM))) && (!(StateManager.currentStateType == StateType.LITTLEGAME))) && (!(StateManager.currentStateType == StateType.ROOM_LOADING)));
            if ((this._info is SelfInfo))
            {
                this._buyAvatar.visible = false;
            };
            if (PlayerManager.Instance.playerstate == PlayerViewState.EQUIP)
            {
                this._hideGlassBtn.visible = (this._hideHatBtn.visible = (this._hideSuitBtn.visible = (this._hideWingBtn.visible = (this._hideBg.visible = false))));
            }
            else
            {
                this._hideGlassBtn.visible = (this._hideHatBtn.visible = (this._hideSuitBtn.visible = (this._hideWingBtn.visible = (this._hideBg.visible = this._showSelfOperation))));
            };
            this._addFriendBtn.visible = ((((!(this._showSelfOperation)) && (!(this._info == null))) && (!(this._info.ID == PlayerManager.Instance.Self.ID))) && ((this._info.ZoneID == 0) || (this._info.ZoneID == PlayerManager.Instance.Self.ZoneID)));
            this._figthPower.setFightPowerEnable(this._showSelfOperation);
        }


    }
}//package bagAndInfo.info

