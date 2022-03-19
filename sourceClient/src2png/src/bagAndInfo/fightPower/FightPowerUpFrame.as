// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.fightPower.FightPowerUpFrame

package bagAndInfo.fightPower
{
    import com.pickgliss.ui.controls.Frame;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.controls.container.HBox;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import ddt.manager.PlayerManager;
    import ddt.manager.SoundManager;
    import ddt.bagStore.BagStore;
    import store.StoreMainView;
    import bagAndInfo.BagAndInfoManager;
    import bagAndInfo.BagAndGiftFrame;
    import ddt.manager.PetBagManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class FightPowerUpFrame extends Frame 
    {

        private var _btnTypeList:Vector.<uint>;
        private var _btnList:Vector.<PowerUpSystemButton>;
        private var _buttonVBox:VBox;
        private var _hBoxList:Vector.<HBox>;

        public function FightPowerUpFrame()
        {
            escEnable = true;
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this.initView();
            this.initEvent();
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function initView():void
        {
            var _local_5:HBox;
            var _local_6:PowerUpSystemButton;
            var _local_7:uint;
            var _local_8:uint;
            titleText = LanguageMgr.GetTranslation("ddt.FightPowerUpFrame.titleTxt");
            this._buttonVBox = ComponentFactory.Instance.creatComponentByStylename("hall.fightPowerUpButtonVBox");
            this._hBoxList = new Vector.<HBox>();
            var _local_1:uint;
            while (_local_1 < 4)
            {
                _local_5 = ComponentFactory.Instance.creatComponentByStylename("hall.fightPowerUpButtonHBox");
                this._hBoxList.push(_local_5);
                _local_1++;
            };
            this._btnList = new Vector.<PowerUpSystemButton>();
            this._btnTypeList = new Vector.<uint>();
            this.addBtns();
            var _local_2:uint;
            while (_local_2 < this._btnTypeList.length)
            {
                _local_6 = new PowerUpSystemButton(this._btnTypeList[_local_2]);
                this._btnList.push(_local_6);
                _local_6.addEventListener(MouseEvent.CLICK, this.__clickButton);
                this._hBoxList[int((_local_2 / 2))].addChild(_local_6);
                _local_2++;
            };
            var _local_3:uint;
            while (_local_3 < 4)
            {
                this._buttonVBox.addChild(this._hBoxList[_local_3]);
                _local_3++;
            };
            this._btnList.sort(this.sortBtnByProgress);
            var _local_4:Vector.<PowerUpSystemButton> = this.getRecommendList();
            if (_local_4.length > 0)
            {
                _local_7 = ((_local_4.length > 2) ? 2 : _local_4.length);
                _local_8 = 0;
                while (_local_8 < _local_7)
                {
                    _local_4[_local_8].setRecommendVisible();
                    _local_8++;
                };
            };
            addToContent(this._buttonVBox);
        }

        private function getRecommendList():Vector.<PowerUpSystemButton>
        {
            var _local_1:Vector.<PowerUpSystemButton> = new Vector.<PowerUpSystemButton>();
            var _local_2:uint;
            while (_local_2 < this._btnList.length)
            {
                if (this._btnList[_local_2].progress <= 35)
                {
                    _local_1.push(this._btnList[_local_2]);
                };
                _local_2++;
            };
            if (_local_1.length > 1)
            {
                _local_1.sort(this.sortBtnByType);
            };
            return (_local_1);
        }

        private function addBtns():void
        {
            var _local_2:uint;
            var _local_3:uint;
            var _local_1:int = PlayerManager.Instance.Self.Grade;
            if (_local_1 >= FightPowerController.Instance.getMinLevelByType(FightPowerController.EQUIP_FIGHT_POWER))
            {
                this._btnTypeList.push(PowerUpSystemButton.EQUIP_SYSTEM);
            };
            if (_local_1 >= FightPowerController.Instance.getMinLevelByType(FightPowerController.STRENG_FIGHT_POWER))
            {
                this._btnTypeList.push(PowerUpSystemButton.STRENG_SYSTEM);
            };
            if (_local_1 >= FightPowerController.Instance.getMinLevelByType(FightPowerController.BEAD_FIGHT_POWER))
            {
                this._btnTypeList.push(PowerUpSystemButton.BEAD_SYSTEM);
            };
            if (_local_1 >= FightPowerController.Instance.getMinLevelByType(FightPowerController.PET_FIGHT_POWER))
            {
                this._btnTypeList.push(PowerUpSystemButton.PET_SYSTEM);
            };
            if (_local_1 >= FightPowerController.Instance.getMinLevelByType(FightPowerController.TOTEM_FIGHT_POWER))
            {
                this._btnTypeList.push(PowerUpSystemButton.TOTEM_SYSTEM);
            };
            if (_local_1 >= FightPowerController.Instance.getMinLevelByType(FightPowerController.RUNE_FIGHT_POWER))
            {
                this._btnTypeList.push(PowerUpSystemButton.RUNE_SYSTEM);
            };
            if (_local_1 >= FightPowerController.Instance.getMinLevelByType(FightPowerController.REFINING_FIGHT_POWER))
            {
                this._btnTypeList.push(PowerUpSystemButton.REFINING_SYSTEM);
            };
            if (_local_1 >= FightPowerController.Instance.getMinLevelByType(FightPowerController.PET_ADVANCE_FIGHT_POWER))
            {
                this._btnTypeList.push(PowerUpSystemButton.PETADVANCE_SYSTEM);
            };
            if (this._btnTypeList.length < 8)
            {
                _local_2 = this._btnTypeList.length;
                _local_3 = 0;
                while (_local_3 < (8 - _local_2))
                {
                    this._btnTypeList.push(PowerUpSystemButton.NOT_OPEN);
                    _local_3++;
                };
            };
        }

        private function initEvent():void
        {
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            var _local_1:uint;
            while (_local_1 < this._btnList.length)
            {
                this._btnList[_local_1].removeEventListener(MouseEvent.CLICK, this.__clickButton);
                _local_1++;
            };
        }

        private function sortBtnByProgress(_arg_1:PowerUpSystemButton, _arg_2:PowerUpSystemButton):int
        {
            if (_arg_1.progress >= _arg_2.progress)
            {
                return (1);
            };
            return (-1);
        }

        private function sortBtnByType(_arg_1:PowerUpSystemButton, _arg_2:PowerUpSystemButton):int
        {
            if (_arg_1.type >= _arg_2.type)
            {
                return (1);
            };
            return (-1);
        }

        private function __clickButton(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            switch ((_arg_1.target as PowerUpSystemButton).type)
            {
                case PowerUpSystemButton.EQUIP_SYSTEM:
                    BagStore.instance.show(StoreMainView.COMPOSE);
                    BagAndInfoManager.Instance.hideBagAndInfo();
                    break;
                case PowerUpSystemButton.STRENG_SYSTEM:
                    BagStore.instance.show(StoreMainView.STRENGTH);
                    BagAndInfoManager.Instance.hideBagAndInfo();
                    break;
                case PowerUpSystemButton.BEAD_SYSTEM:
                    BagAndInfoManager.Instance.showBagAndInfo(BagAndGiftFrame.BEADVIEW);
                    break;
                case PowerUpSystemButton.PET_SYSTEM:
                    PetBagManager.instance().openPetFrame(0);
                    break;
                case PowerUpSystemButton.TOTEM_SYSTEM:
                    BagAndInfoManager.Instance.showBagAndInfo(BagAndGiftFrame.TOTEMVIEW);
                    break;
                case PowerUpSystemButton.RUNE_SYSTEM:
                    BagStore.instance.show(StoreMainView.EMBED);
                    BagAndInfoManager.Instance.hideBagAndInfo();
                    break;
                case PowerUpSystemButton.PETADVANCE_SYSTEM:
                    PetBagManager.instance().openPetFrame(1);
                    break;
                case PowerUpSystemButton.REFINING_SYSTEM:
                    BagStore.instance.show(StoreMainView.REFINING);
                    BagAndInfoManager.Instance.hideBagAndInfo();
                    break;
            };
            this.dispose();
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                SoundManager.instance.play("008");
                this.dispose();
            };
        }

        override public function dispose():void
        {
            var _local_1:HBox;
            this.removeEvent();
            for each (_local_1 in this._hBoxList)
            {
                ObjectUtils.disposeObject(_local_1);
                _local_1 = null;
            };
            ObjectUtils.disposeObject(this._hBoxList);
            this._hBoxList = null;
            ObjectUtils.disposeObject(this._buttonVBox);
            this._buttonVBox = null;
            this._btnList = null;
            this._btnTypeList = null;
            super.dispose();
        }


    }
}//package bagAndInfo.fightPower

