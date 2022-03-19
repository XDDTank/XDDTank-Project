// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bead.view.BeadInfoView

package bead.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import ddt.view.character.RoomCharacter;
    import flash.utils.Dictionary;
    import ddt.data.player.PlayerInfo;
    import bagAndInfo.bag.PlayerPersonView;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import bead.BeadManager;
    import ddt.data.BagInfo;
    import ddt.data.goods.InventoryItemInfo;
    import road7th.data.DictionaryData;
    import ddt.manager.LanguageMgr;
    import ddt.events.PlayerPropertyEvent;
    import ddt.view.character.CharactoryFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class BeadInfoView extends Sprite implements Disposeable 
    {

        private var _bg:Bitmap;
        private var _beadPower:Bitmap;
        private var _beadPowerTxt:BeadPowerText;
        private var _beadSprite:Sprite;
        private var _character:RoomCharacter;
        private var _beadList:Dictionary;
        private var _levelLimitData:Array;
        private var _info:PlayerInfo;
        private var _personView:PlayerPersonView;

        public function BeadInfoView()
        {
            this.initView();
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.beadSystem.beadinfo.bg");
            PositionUtils.setPos(this._bg, "beadInfoViewbg.pos");
            this._beadPower = ComponentFactory.Instance.creatBitmap("asset.beadSystem.beadInset.beadPower");
            PositionUtils.setPos(this._beadPower, "beadInfoView.beadPowerBg.pos");
            this._beadSprite = new Sprite();
            PositionUtils.setPos(this._beadSprite, "beadInfoView.beadSprite.pos");
            this._beadPowerTxt = ComponentFactory.Instance.creatCustomObject("beadInsetView.beadPower.txt");
            PositionUtils.setPos(this._beadPowerTxt, "beadInsetView.beadPower.txt.pos");
            this._personView = ComponentFactory.Instance.creat("bagAndInfo.PlayerPersonView");
            PositionUtils.setPos(this._personView, "beadInfoView.PlayerPersonView.pos");
            this._personView.setHpVisble(false);
            this.createCell();
            addChild(this._bg);
            addChild(this._beadPower);
            addChild(this._beadSprite);
            addChild(this._beadPowerTxt);
            addChild(this._personView);
        }

        private function createCell():void
        {
            var _local_3:BeadCell;
            this._beadList = new Dictionary();
            var _local_1:String = BeadManager.instance.beadConfig.GemHoleNeedLevel;
            this._levelLimitData = _local_1.split("|");
            var _local_2:int;
            while (_local_2 <= 4)
            {
                _local_3 = ComponentFactory.Instance.creatCustomObject(("otherBeadCell_" + _local_2), [_local_2, null]);
                this._beadSprite.addChild(_local_3);
                this._beadList[_local_2] = _local_3;
                _local_3.info = null;
                _local_3.setBGVisible(false);
                _local_2++;
            };
        }

        private function updateCell():void
        {
            var _local_3:String;
            var _local_4:String;
            var _local_5:int;
            if ((!(this._info)))
            {
                for (_local_4 in this._beadList)
                {
                    this._beadList[_local_4].info = null;
                };
                return;
            };
            var _local_1:BagInfo = this._info.BeadBag;
            var _local_2:int = this._info.Grade;
            for (_local_3 in this._beadList)
            {
                this._beadList[_local_3].info = _local_1.items[_local_3];
                _local_5 = int(this._levelLimitData[_local_3]);
                if (((_local_2 < _local_5) || (_local_5 == -1)))
                {
                    this._beadList[_local_3].lockCell(_local_5);
                };
            };
        }

        private function updateBeadPower():void
        {
            var _local_9:InventoryItemInfo;
            if ((!(this._info)))
            {
                this._beadPowerTxt.text = "";
                return;
            };
            var _local_1:Object = BeadManager.instance.list;
            var _local_2:DictionaryData = this._info.BeadBag.items;
            var _local_3:int;
            var _local_4:String = "";
            var _local_5:String = "    ";
            var _local_6:String = "   ";
            var _local_7:String = "  ";
            var _local_8:int;
            while (_local_8 <= 4)
            {
                if (_local_2[_local_8])
                {
                    _local_9 = (_local_2[_local_8] as InventoryItemInfo);
                    if (_local_9.beadLevel == 20)
                    {
                        _local_3 = (_local_3 + int(_local_1[_local_9.Property2][20].Exp));
                    }
                    else
                    {
                        _local_3 = (_local_3 + _local_9.beadExp);
                    };
                    _local_4 = (_local_4 + LanguageMgr.GetTranslation("beadSystem.bead.name.color.html", BeadManager.instance.getBeadNameColor(_local_9), LanguageMgr.GetTranslation("beadSystem.bead.nameLevel", _local_9.Name, _local_9.beadLevel, "")));
                    if (((_local_9.Name.substr(0, 1) == "S") || (_local_9.Name.substr(0, 1) == "s")))
                    {
                        if (_local_9.beadLevel >= 10)
                        {
                            _local_4 = (_local_4 + _local_7);
                        }
                        else
                        {
                            _local_4 = (_local_4 + _local_6);
                        };
                    }
                    else
                    {
                        if (_local_9.beadLevel >= 10)
                        {
                            _local_4 = (_local_4 + _local_6);
                        }
                        else
                        {
                            _local_4 = (_local_4 + _local_5);
                        };
                    };
                    _local_4 = (_local_4 + (BeadManager.instance.getDescriptionStr(_local_9) + "\n"));
                };
                _local_8++;
            };
            this._beadPowerTxt.text = int((_local_3 / 10)).toString();
            this._beadPowerTxt.tipData = [LanguageMgr.GetTranslation("beadSystem.bead.beadPower.titleTip", this._beadPowerTxt.text), _local_4];
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
                this._info = null;
            };
            this._info = _arg_1;
            if (this._info)
            {
                this._info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__changeHandler);
            };
            this.updateView();
            if (this._personView)
            {
                this._personView.info = this._info;
            };
        }

        private function updateView():void
        {
            this.updateBeadPower();
            this.updateCharacter();
            this.updateCell();
        }

        private function __changeHandler(_arg_1:PlayerPropertyEvent):void
        {
            this.updateView();
        }

        private function updateCharacter():void
        {
            if (this._character)
            {
                this._character.dispose();
                this._character = null;
            };
            if (this._info)
            {
                this._character = (CharactoryFactory.createCharacter(this._info, "room") as RoomCharacter);
                this._character.showGun = false;
                this._character.showWing = false;
                this._character.LightVible = false;
                this._character.show(false, -1);
                PositionUtils.setPos(this._character, "beadInfoView.character.pos");
                this._character.LightVible = false;
                addChildAt(this._character, this.getChildIndex(this._beadSprite));
            };
        }

        private function removeEvent():void
        {
            if (this._info)
            {
                this._info.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__changeHandler);
                this._info = null;
            };
        }

        public function dispose():void
        {
            var _local_1:BeadCell;
            this.removeEvent();
            for each (_local_1 in this._beadList)
            {
                if (_local_1)
                {
                    ObjectUtils.disposeObject(_local_1);
                };
            };
            this._beadList = null;
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._beadPower)
            {
                ObjectUtils.disposeObject(this._beadPower);
            };
            this._beadPower = null;
            if (this._beadPowerTxt)
            {
                ObjectUtils.disposeObject(this._beadPowerTxt);
            };
            this._beadPowerTxt = null;
            if (this._beadSprite)
            {
                ObjectUtils.disposeObject(this._beadSprite);
            };
            this._beadSprite = null;
            if (this._character)
            {
                ObjectUtils.disposeObject(this._character);
            };
            this._character = null;
            ObjectUtils.disposeObject(this._personView);
            this._personView = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package bead.view

