// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.utils.StaticFormula

package ddt.utils
{
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.player.PlayerInfo;
    import ddt.manager.PlayerManager;
    import ddt.manager.StateManager;
    import totem.TotemManager;
    import game.model.Living;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.BagInfo;
    import ddt.manager.ItemManager;

    public class StaticFormula 
    {


        public static function getHertAddition(_arg_1:int, _arg_2:int):Number
        {
            var _local_3:Number = ((_arg_1 * Math.pow(1.1, _arg_2)) - _arg_1);
            return (Math.round(_local_3));
        }

        public static function getDefenseAddition(_arg_1:int, _arg_2:int):Number
        {
            var _local_3:Number = ((_arg_1 * Math.pow(1.1, _arg_2)) - _arg_1);
            return (Math.round(_local_3));
        }

        public static function getRecoverHPAddition(_arg_1:int, _arg_2:int):Number
        {
            var _local_3:Number = ((_arg_1 * Math.pow(1.1, _arg_2)) - _arg_1);
            return (Math.floor(_local_3));
        }

        public static function getImmuneHertAddition(_arg_1:int):Number
        {
            var _local_2:Number = ((0.95 * _arg_1) / (_arg_1 + 500));
            _local_2 = (_local_2 * 100);
            return (Number(_local_2.toFixed(1)));
        }

        public static function isDeputyWeapon(_arg_1:ItemTemplateInfo):Boolean
        {
            if (((_arg_1.TemplateID >= 17000) && (_arg_1.TemplateID <= 17010)))
            {
                return (true);
            };
            return (false);
        }

        public static function getActionValue(_arg_1:PlayerInfo):int
        {
            var _local_2:int;
            return ((((((((_arg_1.Attack + _arg_1.Agility) + _arg_1.Luck) + _arg_1.Defence) + 1000) * (Math.pow(getDamage(_arg_1), 3) + (Math.pow(getRecovery(_arg_1), 3) * 3.5))) / 100000000) + (getMaxHp(_arg_1) * 0.95)) - 950);
        }

        public static function isShield(_arg_1:PlayerInfo):Boolean
        {
            return (false);
        }

        public static function getDamage(_arg_1:PlayerInfo):int
        {
            var _local_2:int;
            if ((((!(_arg_1.ZoneID == 0)) && (StateManager.isInFight)) && (!(_arg_1.ZoneID == PlayerManager.Instance.Self.ZoneID))))
            {
                return (-1);
            };
            _local_2 = _arg_1.Damage;
            _local_2 = (_local_2 + TotemManager.instance.getAddInfo(TotemManager.instance.getTotemPointLevel(_arg_1.totemId)).Damage);
            if (((_arg_1.propertyAddition) && (_arg_1.propertyAddition["Damage"])))
            {
                _local_2 = (_local_2 + ((_arg_1.propertyAddition["Damage"]["Bead"]) ? _arg_1.propertyAddition["Damage"]["Bead"] : 0));
            };
            return (_local_2);
        }

        public static function getRecovery(_arg_1:PlayerInfo):int
        {
            var _local_2:int;
            if (((!(_arg_1.ZoneID == 0)) && (!(StateManager.isInFight == PlayerManager.Instance.Self.ZoneID))))
            {
                return (-1);
            };
            _local_2 = _arg_1.Guard;
            _local_2 = (_local_2 + TotemManager.instance.getAddInfo(TotemManager.instance.getTotemPointLevel(_arg_1.totemId)).Guard);
            if (((_arg_1.propertyAddition) && (_arg_1.propertyAddition["Armor"])))
            {
                _local_2 = (_local_2 + ((_arg_1.propertyAddition["Armor"]["Bead"]) ? _arg_1.propertyAddition["Armor"]["Bead"] : 0));
            };
            return (_local_2);
        }

        public static function getMaxHp(_arg_1:PlayerInfo):int
        {
            var _local_3:Living;
            return (_arg_1.hp);
        }

        public static function getEnergy(_arg_1:PlayerInfo):int
        {
            if ((((!(_arg_1.ZoneID == 0)) && (StateManager.isInFight)) && (!(_arg_1.ZoneID == PlayerManager.Instance.Self.ZoneID))))
            {
                return (-1);
            };
            var _local_2:int;
            return (int((240 + (_arg_1.Agility / 30))));
        }

        private static function isDamageJewel(_arg_1:ItemTemplateInfo):Boolean
        {
            if ((((_arg_1.CategoryID == 11) && (_arg_1.Property1 == "31")) && (_arg_1.Property2 == "3")))
            {
                return (true);
            };
            return (false);
        }

        public static function getBeadDamage(_arg_1:PlayerInfo):int
        {
            var _local_5:InventoryItemInfo;
            var _local_2:int;
            var _local_3:BagInfo = _arg_1.BeadBag;
            var _local_4:int = 3;
            while (_local_4 < 12)
            {
                _local_5 = _local_3.items[_local_4];
                if (((_local_5) && (isDamageJewel(_local_5))))
                {
                    _local_2 = (_local_2 + int(_local_5.Property7));
                };
                _local_4++;
            };
            return (_local_2);
        }

        public static function getBeadRecovery(_arg_1:PlayerInfo):int
        {
            var _local_5:InventoryItemInfo;
            var _local_2:int;
            var _local_3:BagInfo = _arg_1.BeadBag;
            var _local_4:int = 3;
            while (_local_4 < 12)
            {
                _local_5 = _local_3.items[_local_4];
                if (_local_5)
                {
                    _local_2 = (_local_2 + int(_local_5.Property8));
                };
                _local_4++;
            };
            return (_local_2);
        }

        public static function getJewelDamage(_arg_1:InventoryItemInfo):int
        {
            var _local_2:int;
            if ((!(_arg_1)))
            {
                return (0);
            };
            if ((((!(_arg_1.Hole1 == -1)) && (!(_arg_1.Hole1 == 0))) && (int((_arg_1.StrengthenLevel / 3)) >= 1)))
            {
                if (isDamageJewel(ItemManager.Instance.getTemplateById(_arg_1.Hole1)))
                {
                    _local_2 = (_local_2 + int(ItemManager.Instance.getTemplateById(_arg_1.Hole1).Property7));
                };
            };
            if ((((!(_arg_1.Hole2 == -1)) && (!(_arg_1.Hole2 == 0))) && (int((_arg_1.StrengthenLevel / 3)) >= 2)))
            {
                if (isDamageJewel(ItemManager.Instance.getTemplateById(_arg_1.Hole2)))
                {
                    _local_2 = (_local_2 + int(ItemManager.Instance.getTemplateById(_arg_1.Hole2).Property7));
                };
            };
            if ((((!(_arg_1.Hole3 == -1)) && (!(_arg_1.Hole3 == 0))) && (int((_arg_1.StrengthenLevel / 3)) >= 3)))
            {
                if (isDamageJewel(ItemManager.Instance.getTemplateById(_arg_1.Hole3)))
                {
                    _local_2 = (_local_2 + int(ItemManager.Instance.getTemplateById(_arg_1.Hole3).Property7));
                };
            };
            if ((((!(_arg_1.Hole4 == -1)) && (!(_arg_1.Hole4 == 0))) && (int((_arg_1.StrengthenLevel / 3)) >= 4)))
            {
                if (isDamageJewel(ItemManager.Instance.getTemplateById(_arg_1.Hole4)))
                {
                    _local_2 = (_local_2 + int(ItemManager.Instance.getTemplateById(_arg_1.Hole4).Property7));
                };
            };
            if ((((!(_arg_1.Hole5 == -1)) && (!(_arg_1.Hole5 == 0))) && (_arg_1.Hole5Level > 0)))
            {
                if (isDamageJewel(ItemManager.Instance.getTemplateById(_arg_1.Hole5)))
                {
                    _local_2 = (_local_2 + int(ItemManager.Instance.getTemplateById(_arg_1.Hole5).Property7));
                };
            };
            if ((((!(_arg_1.Hole6 == -1)) && (!(_arg_1.Hole6 == 0))) && (_arg_1.Hole6Level > 0)))
            {
                if (isDamageJewel(ItemManager.Instance.getTemplateById(_arg_1.Hole6)))
                {
                    _local_2 = (_local_2 + int(ItemManager.Instance.getTemplateById(_arg_1.Hole6).Property7));
                };
            };
            return (_local_2);
        }

        public static function getJewelRecovery(_arg_1:InventoryItemInfo):int
        {
            var _local_2:int;
            if ((!(_arg_1)))
            {
                return (0);
            };
            if ((((!(_arg_1.Hole1 == -1)) && (!(_arg_1.Hole1 == 0))) && (int((_arg_1.StrengthenLevel / 3)) >= 1)))
            {
                _local_2 = (_local_2 + int(ItemManager.Instance.getTemplateById(_arg_1.Hole1).Property8));
            };
            if ((((!(_arg_1.Hole2 == -1)) && (!(_arg_1.Hole2 == 0))) && (int((_arg_1.StrengthenLevel / 3)) >= 2)))
            {
                _local_2 = (_local_2 + int(ItemManager.Instance.getTemplateById(_arg_1.Hole2).Property8));
            };
            if ((((!(_arg_1.Hole3 == -1)) && (!(_arg_1.Hole3 == 0))) && (int((_arg_1.StrengthenLevel / 3)) >= 3)))
            {
                _local_2 = (_local_2 + int(ItemManager.Instance.getTemplateById(_arg_1.Hole3).Property8));
            };
            if ((((!(_arg_1.Hole4 == -1)) && (!(_arg_1.Hole4 == 0))) && (int((_arg_1.StrengthenLevel / 3)) >= 4)))
            {
                _local_2 = (_local_2 + int(ItemManager.Instance.getTemplateById(_arg_1.Hole4).Property8));
            };
            if ((((!(_arg_1.Hole5 == -1)) && (!(_arg_1.Hole5 == 0))) && (_arg_1.Hole5Level > 0)))
            {
                _local_2 = (_local_2 + int(ItemManager.Instance.getTemplateById(_arg_1.Hole5).Property8));
            };
            if ((((!(_arg_1.Hole6 == -1)) && (!(_arg_1.Hole6 == 0))) && (_arg_1.Hole6Level > 0)))
            {
                _local_2 = (_local_2 + int(ItemManager.Instance.getTemplateById(_arg_1.Hole6).Property8));
            };
            return (_local_2);
        }


    }
}//package ddt.utils

