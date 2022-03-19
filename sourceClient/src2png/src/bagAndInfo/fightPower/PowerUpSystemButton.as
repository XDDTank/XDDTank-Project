// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.fightPower.PowerUpSystemButton

package bagAndInfo.fightPower
{
    import com.pickgliss.ui.controls.BaseButton;
    import flash.display.Shape;
    import flash.display.Bitmap;
    import __AS3__.vec.Vector;
    import ddt.manager.PlayerManager;
    import ddt.data.player.PlayerInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import com.pickgliss.ui.LayerManager;
    import pet.date.PetInfo;
    import road7th.data.DictionaryData;
    import ddt.manager.PetInfoManager;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.manager.ItemManager;
    import store.data.RefiningConfigInfo;
    import store.StoreController;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class PowerUpSystemButton extends BaseButton 
    {

        public static const EQUIP_SYSTEM:uint = 0;
        public static const STRENG_SYSTEM:uint = 1;
        public static const BEAD_SYSTEM:uint = 2;
        public static const PET_SYSTEM:uint = 3;
        public static const TOTEM_SYSTEM:uint = 4;
        public static const RUNE_SYSTEM:uint = 5;
        public static const REFINING_SYSTEM:uint = 6;
        public static const PETADVANCE_SYSTEM:uint = 7;
        public static const NOT_OPEN:uint = 8;

        private var _type:uint;
        private var _progress:Number;
        private var _progressMask:Shape;
        private var _bg:Bitmap;
        private var _recommend:Bitmap;
        private var _progressBmp:Bitmap;
        private var _tips:PowerUpSystemButtonTips;
        private var _tipsData:Vector.<String>;
        private var _damage:int = 0;
        private var _armor:int = 0;
        private var _energy:int = 0;
        private var _attack:int = 0;
        private var _defence:int = 0;
        private var _agility:int = 0;
        private var _luck:int = 0;
        private var _hp:int = 0;

        public function PowerUpSystemButton(_arg_1:uint)
        {
            this._type = _arg_1;
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            var _local_2:FightPowerDescInfo;
            var _local_1:PlayerInfo = PlayerManager.Instance.Self;
            this._energy = _local_1.Energy;
            this._tipsData = new Vector.<String>(3);
            this._tipsData[0] = LanguageMgr.GetTranslation("ddt.FightPowerUpTips.titleTxt");
            switch (this._type)
            {
                case EQUIP_SYSTEM:
                    this._bg = ComponentFactory.Instance.creatBitmap("asset.hall.EquipSystem");
                    this.calStrengPower();
                    this.calRefiningPower();
                    this._damage = (int(_local_1.getPropertyAdditionByType("Damage")["Equip"]) - this._damage);
                    this._armor = (int(_local_1.getPropertyAdditionByType("Armor")["Equip"]) - this._armor);
                    this._attack = (_local_1.getPropertyAdditionByType("Attack")["Equip"] - this._attack);
                    this._defence = (_local_1.getPropertyAdditionByType("Defence")["Equip"] - this._defence);
                    this._agility = (_local_1.getPropertyAdditionByType("Agility")["Equip"] - this._agility);
                    this._luck = (_local_1.getPropertyAdditionByType("Luck")["Equip"] - this._luck);
                    this._hp = (_local_1.getPropertyAdditionByType("HP")["Equip"] - this._hp);
                    _local_2 = FightPowerController.Instance.getCurrentLevelValueByType(FightPowerController.EQUIP_FIGHT_POWER);
                    this._tipsData[1] = _local_2.RecommendDesc;
                    this._progress = (this.calFightPower() / _local_2.StandFigting);
                    break;
                case STRENG_SYSTEM:
                    this._bg = ComponentFactory.Instance.creatBitmap("asset.hall.strengSystem");
                    this.calStrengPower();
                    _local_2 = FightPowerController.Instance.getCurrentLevelValueByType(FightPowerController.STRENG_FIGHT_POWER);
                    this._tipsData[1] = _local_2.RecommendDesc;
                    this._progress = (this.calFightPower() / _local_2.StandFigting);
                    break;
                case BEAD_SYSTEM:
                    this._bg = ComponentFactory.Instance.creatBitmap("asset.hall.beadSystem");
                    this._attack = _local_1.getPropertyAdditionByType("Attack")["Bead"];
                    this._defence = _local_1.getPropertyAdditionByType("Defence")["Bead"];
                    this._agility = _local_1.getPropertyAdditionByType("Agility")["Bead"];
                    this._luck = _local_1.getPropertyAdditionByType("Luck")["Bead"];
                    this._hp = _local_1.getPropertyAdditionByType("HP")["Bead"];
                    _local_2 = FightPowerController.Instance.getCurrentLevelValueByType(FightPowerController.BEAD_FIGHT_POWER);
                    this._tipsData[1] = _local_2.RecommendDesc;
                    this._progress = (this.calFightPower() / _local_2.StandFigting);
                    break;
                case PET_SYSTEM:
                    this._bg = ComponentFactory.Instance.creatBitmap("asset.hall.petSystem");
                    this.calPetAdvance();
                    this._attack = (int((_local_1.getPropertyAdditionByType("Attack")["Pet"] / 100)) - this._attack);
                    this._defence = (int((_local_1.getPropertyAdditionByType("Defence")["Pet"] / 100)) - this._defence);
                    this._agility = (int((_local_1.getPropertyAdditionByType("Agility")["Pet"] / 100)) - this._defence);
                    this._luck = (int((_local_1.getPropertyAdditionByType("Luck")["Pet"] / 100)) - this._luck);
                    this._hp = (int((_local_1.getPropertyAdditionByType("HP")["Pet"] / 100)) - this._hp);
                    _local_2 = FightPowerController.Instance.getCurrentLevelValueByType(FightPowerController.PET_FIGHT_POWER);
                    this._tipsData[1] = _local_2.RecommendDesc;
                    this._progress = (this.calFightPower() / _local_2.StandFigting);
                    break;
                case TOTEM_SYSTEM:
                    this._bg = ComponentFactory.Instance.creatBitmap("asset.hall.totemSystem");
                    this._damage = (this._damage + int(_local_1.getPropertyAdditionByType("Damage")["Totem"]));
                    this._armor = (this._armor + int(_local_1.getPropertyAdditionByType("Armor")["Totem"]));
                    this._attack = (this._attack + _local_1.getPropertyAdditionByType("Attack")["Totem"]);
                    this._defence = (this._defence + _local_1.getPropertyAdditionByType("Defence")["Totem"]);
                    this._agility = (this._agility + _local_1.getPropertyAdditionByType("Agility")["Totem"]);
                    this._luck = (this._luck + _local_1.getPropertyAdditionByType("Luck")["Totem"]);
                    this._hp = (this._hp + _local_1.getPropertyAdditionByType("HP")["Totem"]);
                    _local_2 = FightPowerController.Instance.getCurrentLevelValueByType(FightPowerController.TOTEM_FIGHT_POWER);
                    this._tipsData[1] = _local_2.RecommendDesc;
                    this._progress = (this.calFightPower() / _local_2.StandFigting);
                    break;
                case RUNE_SYSTEM:
                    this._bg = ComponentFactory.Instance.creatBitmap("asset.hall.runeSystem");
                    this._attack = (this._attack + _local_1.getPropertyAdditionByType("Attack")["Embed"]);
                    this._defence = (this._defence + _local_1.getPropertyAdditionByType("Defence")["Embed"]);
                    this._agility = (this._agility + _local_1.getPropertyAdditionByType("Agility")["Embed"]);
                    this._luck = (this._luck + _local_1.getPropertyAdditionByType("Luck")["Embed"]);
                    this._hp = (this._hp + _local_1.getPropertyAdditionByType("HP")["Embed"]);
                    _local_2 = FightPowerController.Instance.getCurrentLevelValueByType(FightPowerController.RUNE_FIGHT_POWER);
                    this._tipsData[1] = _local_2.RecommendDesc;
                    this._progress = (this.calFightPower() / _local_2.StandFigting);
                    break;
                case PETADVANCE_SYSTEM:
                    this._bg = ComponentFactory.Instance.creatBitmap("asset.hall.petAdvanceSystem");
                    this.calPetAdvance();
                    _local_2 = FightPowerController.Instance.getCurrentLevelValueByType(FightPowerController.PET_ADVANCE_FIGHT_POWER);
                    this._tipsData[1] = _local_2.RecommendDesc;
                    this._progress = (this.calFightPower() / _local_2.StandFigting);
                    break;
                case REFINING_SYSTEM:
                    this._bg = ComponentFactory.Instance.creatBitmap("asset.hall.refiningSystem");
                    this.calRefiningPower();
                    _local_2 = FightPowerController.Instance.getCurrentLevelValueByType(FightPowerController.REFINING_FIGHT_POWER);
                    this._tipsData[1] = _local_2.RecommendDesc;
                    this._progress = (this.calFightPower() / _local_2.StandFigting);
                    break;
                case NOT_OPEN:
                    this._bg = ComponentFactory.Instance.creatBitmap("asset.hall.notOpen");
                    this.enable = false;
                    this._progress = 1;
                    break;
            };
            this._progress = (this._progress * 100);
            this._progress = ((this._progress > 100) ? 100 : int(this._progress));
            this._tipsData[2] = LanguageMgr.GetTranslation("ddt.FightPowerUpTips.socreTxt", this._progress);
            if (this._progress <= 35)
            {
                this._progressBmp = ComponentFactory.Instance.creatBitmap("asset.hall.greenProgress");
            }
            else
            {
                if (this._progress < 75)
                {
                    this._progressBmp = ComponentFactory.Instance.creatBitmap("asset.hall.blueProgress");
                }
                else
                {
                    if (this._progress < 100)
                    {
                        this._progressBmp = ComponentFactory.Instance.creatBitmap("asset.hall.purpleProgress");
                    }
                    else
                    {
                        this._progressBmp = ComponentFactory.Instance.creatBitmap("asset.hall.orangeProgress");
                    };
                };
            };
            this._progressMask = new Shape();
            this._progressMask.graphics.beginFill(0, 0);
            this._progressMask.graphics.drawRect(0, 0, int(((this._progressBmp.width * this._progress) / 100)), this._progressBmp.height);
            this._progressMask.graphics.endFill();
            PositionUtils.setPos(this._progressBmp, "hall.powerUpSystemButtonProgress.Pos");
            PositionUtils.setPos(this._progressMask, "hall.powerUpSystemButtonProgress.Pos");
            this._recommend = ComponentFactory.Instance.creatBitmap("asset.hall.recommend");
            this._recommend.visible = false;
            this._tips = new PowerUpSystemButtonTips();
            this._tips.visible = false;
            this._tips.tipData = this._tipsData;
            addChild(this._bg);
            if (this._type != NOT_OPEN)
            {
                addChild(this._progressBmp);
                addChild(this._progressMask);
                this._progressBmp.mask = this._progressMask;
            };
            addChild(this._recommend);
        }

        private function initEvent():void
        {
            addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
        }

        override protected function removeEvent():void
        {
            removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            removeEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
        }

        private function __mouseOver(_arg_1:MouseEvent):void
        {
            var _local_2:Point;
            if (this._tips)
            {
                this._tips.visible = true;
                LayerManager.Instance.addToLayer(this._tips, LayerManager.GAME_TOP_LAYER);
                _local_2 = this.localToGlobal(new Point((this.width - 50), (this.height / 2)));
                this._tips.x = _local_2.x;
                this._tips.y = _local_2.y;
            };
        }

        private function __mouseOut(_arg_1:MouseEvent):void
        {
            if (this._tips)
            {
                this._tips.visible = false;
            };
        }

        public function setRecommendVisible():void
        {
            this._recommend.visible = true;
        }

        private function calFightPower():int
        {
            return ((((((this._attack + (this._damage * 2)) + (this._armor * 2)) + this._defence) + this._luck) + this._agility) + (this._hp / 2));
        }

        private function calPetAdvance():void
        {
            var _local_2:PetInfo;
            var _local_3:PetInfo;
            var _local_4:PetInfo;
            var _local_5:PetInfo;
            var _local_1:DictionaryData = PlayerManager.Instance.Self.pets;
            if (((_local_1.length > 0) && (_local_1[0])))
            {
                _local_2 = _local_1[0];
                if (((_local_2.MagicLevel == 0) || (_local_2.OrderNumber == 1)))
                {
                    return;
                };
                _local_3 = PetInfoManager.instance.getPetInfoByTemplateID(_local_2.TemplateID);
                _local_3.OrderNumber = 1;
                _local_4 = PetInfoManager.instance.getPetInfoByTemplateID(_local_2.TemplateID);
                _local_4.OrderNumber = _local_2.OrderNumber;
                _local_5 = PetInfoManager.instance.getTransformPet(_local_3, _local_4);
                this._attack = (this._attack + int((_local_5.Attack / 100)));
                this._defence = (this._defence + int((_local_5.Defence / 100)));
                this._agility = (this._agility + int((_local_5.Agility / 100)));
                this._luck = (this._luck + int((_local_5.Luck / 100)));
                this._hp = (this._hp + int((_local_5.Blood / 100)));
            };
        }

        private function calStrengPower():void
        {
            var _local_2:InventoryItemInfo;
            var _local_3:int;
            var _local_4:EquipmentTemplateInfo;
            var _local_1:uint = 10;
            while (_local_1 < 16)
            {
                _local_2 = PlayerManager.Instance.Self.Bag.getItemAt(_local_1);
                if (_local_2)
                {
                    _local_3 = ItemManager.Instance.getMinorProperty(_local_2, _local_2);
                    _local_4 = ItemManager.Instance.getEquipTemplateById(_local_2.TemplateID);
                    _local_4 = ItemManager.Instance.getEquipPropertyListById(_local_4.MainProperty1ID);
                    switch (_local_4.PropertyID)
                    {
                        case 1:
                            this._attack = (this._attack + _local_3);
                            break;
                        case 2:
                            this._defence = (this._defence + _local_3);
                            break;
                        case 3:
                            this._agility = (this._agility + _local_3);
                            break;
                        case 4:
                            this._luck = (this._luck + _local_3);
                            break;
                        case 5:
                            this._damage = (this._damage + _local_3);
                            break;
                        case 6:
                            this._armor = (this._armor + _local_3);
                            break;
                        case 7:
                            this._hp = (this._hp + _local_3);
                            break;
                    };
                };
                _local_1++;
            };
        }

        private function calRefiningPower():void
        {
            var _local_2:InventoryItemInfo;
            var _local_3:RefiningConfigInfo;
            var _local_1:uint = 16;
            while (_local_1 < 20)
            {
                _local_2 = PlayerManager.Instance.Self.Bag.getItemAt(_local_1);
                if (_local_2)
                {
                    _local_3 = StoreController.instance.Model.getRefiningConfigByLevel(_local_2.StrengthenLevel);
                    this._attack = (this._attack + _local_3.Attack);
                    this._defence = (this._defence + _local_3.Defence);
                    this._agility = (this._agility + _local_3.Agility);
                    this._luck = (this._luck + _local_3.Lucky);
                    this._hp = (this._hp + _local_3.Blood);
                };
                _local_1++;
            };
        }

        override public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._progressMask);
            this._progressMask = null;
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._recommend);
            this._recommend = null;
            ObjectUtils.disposeObject(this._progressBmp);
            this._progressBmp = null;
            ObjectUtils.disposeObject(this._tips);
            this._tips = null;
            ObjectUtils.disposeObject(this._tipsData);
            this._tipsData = null;
            super.dispose();
        }

        override public function get width():Number
        {
            return (this._bg.width);
        }

        override public function get height():Number
        {
            return (this._bg.height);
        }

        public function get progress():int
        {
            return (this._progress);
        }

        public function get type():uint
        {
            return (this._type);
        }


    }
}//package bagAndInfo.fightPower

