// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.EquipType

package ddt.data
{
    import ddt.manager.LanguageMgr;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.ItemManager;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.PlayerManager;

    public class EquipType 
    {

        public static const T_SBUGLE:int = 11101;
        public static const T_BBUGLE:int = 11102;
        public static const T_CBUGLE:int = 11100;
        public static const DUNGEON_BUGLE:int = 11114;
        public static const MONEY:int = -200;
        public static const BIND_MONEY:int = -300;
        public static const GOLD:int = -100;
        public static const MAGICSOUL:int = -400;
        public static const OFFER:int = 0;
        public static const T_ALL_PROP:int = 10200;
        public static const COLORCARD:int = 11999;
        public static const REWORK_NAME:int = 11994;
        public static const CONSORTIA_REWORK_NAME:int = 11993;
        public static const CHANGE_SEX:int = 11569;
        public static const VIPCARD:int = 11992;
        public static const VIPCARD_TEST:int = 11991;
        public static const VIPCARD_TEST3:int = 11914;
        public static const TRANSFER_PROP:int = 34101;
        public static const CHANGE_COLOR_SHELL:int = 11999;
        public static const MEDAL:int = -400;
        public static const GIFT:int = -300;
        public static const EXP:int = 11107;
        public static const SUPER_EXP:int = 11906;
        public static const GOLD_BOX:int = 11233;
        public static const ROULETTE_BOX:int = 112019;
        public static const VIP_COIN:int = 112109;
        public static const BOGU_COIN:int = 11606;
        public static const ROULETTE_KEY:int = 11444;
        public static const BOMB_KING_BLESS:int = 112222;
        public static const SILVER_BLESS:int = 112223;
        public static const GOLD_BLESS:int = 112224;
        public static const Silver_Caddy:int = 112100;
        public static const Qiang_SHI:int = 11025;
        public static const Qiang_SHI_TEN:int = 11026;
        public static const Gold_Caddy:int = 112101;
        public static const CADDY:int = 112047;
        public static const GOLD_CADDY:int = 112101;
        public static const SILVER_CADDY:int = 112100;
        public static const CADDY_KEY:int = 11456;
        public static const CADDY_BAGI:int = 112054;
        public static const CADDY_BAGII:int = 112055;
        public static const CADDY_BAGIII:int = 112056;
        public static const BEAD_ATTRIBUTE:int = 313500;
        public static const BEAD_ATTACK:int = 311500;
        public static const BEAD_DEFENSE:int = 312500;
        public static const OFFER_PACK_I:int = 11252;
        public static const OFFER_PACK_II:int = 11257;
        public static const OFFER_PACK_III:int = 11258;
        public static const OFFER_PACK_IV:int = 11259;
        public static const OFFER_PACK_V:int = 11260;
        public static const ONE_LEVEL_TIMEBOX:int = 112171;
        public static const TWO_LEVEL_TIMEBOX:int = 112172;
        public static const THREE_LEVEL_TIMEBOX:int = 112173;
        public static const Caddy_Good:int = 11907;
        public static const Save_Life:int = 11908;
        public static const Agility_Get:int = 11909;
        public static const ReHealth:int = 11910;
        public static const Level_Try:int = 11912;
        public static const Card_Get:int = 11913;
        public static const FREE_PROP_CARD:int = 11995;
        public static const DOUBLE_EXP_CARD:int = 11998;
        public static const DOUBLE_GESTE_CARD:int = 11997;
        public static const PREVENT_KICK:int = 11996;
        public static const CHANGE_NAME_CARD:int = 11994;
        public static const CONSORTIA_CHANGE_NAME_CARD:int = 11993;
        public static const Pay_Buff:int = -1;
        public static const STRENGTH_GIFT_BAG:int = 112051100;
        public static const VIP_GIFT_BAG:int = 112164;
        public static const SYMBLE:int = 11020;
        public static const LUCKY:int = 11018;
        public static const STRENGTH_STONE4:int = 11023;
        public static const STRENGTH_STONE_NEW:int = 11025;
        public static const STRENGTH_STONE1:int = 11026;
        public static const REFINING_STONE:int = 11028;
        public static const WEDDING_RING:int = 9022;
        public static const PIAN_OPENHOLE_STONE:int = 11034;
        public static const SKY_OPENHOLE_STONE:int = 11036;
        public static const GND_OPENHOLE_STONE:int = 11035;
        public static const BADLUCK_STONE:int = 11550;
        public static const TEXP_LV_I:int = 40001;
        public static const TEXP_LV_II:int = 40002;
        public static const VITALITY_WATER:int = 11400;
        public static const HEAD:uint = 1;
        public static const GLASS:uint = 2;
        public static const HAIR:uint = 3;
        public static const EFF:uint = 4;
        public static const CLOTH:uint = 5;
        public static const FACE:uint = 6;
        public static const ARM:uint = 7;
        public static const ARMLET:uint = 8;
        public static const RING:uint = 9;
        public static const FRIGHTPROP:uint = 10;
        public static const UNFRIGHTPROP:uint = 11;
        public static const TASK:uint = 12;
        public static const SUITS:uint = 13;
        public static const NECKLACE:uint = 14;
        public static const WING:uint = 15;
        public static const CHATBALL:uint = 16;
        public static const HOLYGRAIL:int = 11;
        public static const SPECIAL:int = 31;
        public static const SPACE_UPDATE:int = 36;
        public static const HEALSTONE:int = 19;
        public static const TEXP:int = 20;
        public static const EQUIP:int = 40;
        public static const EMBED_TYPE:int = 12;
        public static const BEAD:int = 11;
        public static const QEWELRY:int = 400;
        public static const COMPOSE_MATERIAL:int = 42;
        public static const COMPOSE_SKILL:int = 41;
        public static const TEXP_TASK:int = 23;
        public static const ACTIVE_TASK:int = 30;
        public static const TEMPWEAPON:int = 27;
        public static const TEMPARMLET:uint = 28;
        public static const TEMPRING:uint = 29;
        public static const TEMP_OFFHAND:uint = 31;
        public static const CATHARINE:int = 21;
        public static const EFFECT:int = 30;
        public static const SEED:int = 32;
        public static const MANURE:int = 33;
        public static const FOOD:int = 34;
        public static const PET_EGG:int = 35;
        public static const PET_EXP:int = 11923;
        public static const PET_ADVANCE:int = 11401;
        public static const VEGETABLE:int = 36;
        public static const ATACCKT:int = 37;
        public static const DEFENT:int = 38;
        public static const ATTRIBUTE:int = 39;
        public static const GIVING:int = 100;
        public static const DIAMOND_DRIL:int = 11088;
        public static const HEROBOX:int = 112065;
        public static const VIP_WEAPON_0:int = 408000;
        public static const VIP_WEAPON_1:int = 408001;
        public static const VIP_WEAPON_2:int = 408002;
        public static const TYPES:Array = ["", "head", "glass", "hair", "eff", "cloth", "face", "arm", "armlet", "ring", "", "", "", "suits", "necklace", "wing", "chatBall", "", "", "", "", "", "", "", "", "", "", "", "armlet", "ring"];
        public static const PARTNAME:Array = ["", ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.head"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.glass"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.hair"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.face"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.clothing"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.eye"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.weapon"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.bangle"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.finger"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.tool"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.normal"), "", ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.suit"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.necklace"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.decorate"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.paopao"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.offhand"), "", ddt.manager.LanguageMgr.GetTranslation("tank.manager.ItemManager.aid"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.normal"), ddt.manager.LanguageMgr.GetTranslation("tank.manager.ItemManager.cigaretteAsh"), "", ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.normal"), "", ddt.manager.LanguageMgr.GetTranslation("tank.manager.ItemManager.gift"), "", ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.tempweapon"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.TEMPARMLET"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.tempTEMPRING"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.prop"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.offhand"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.seed"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.manure"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.food"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.petEgg"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.petSpaceGoods"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.atacckt"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.defent"), ddt.manager.LanguageMgr.GetTranslation("tank.data.EquipType.attribute"), ""];
        private static const dressAbleIDs:Array = [1, 2, 3, 4, 5, 6, 13, 15];
        private static const DrillCategoryID:int = 11;
        private static const DrillCategotyProperty:String = "16";
        public static const HoleMaxExp:int = 100;
        public static const HoleMaxLevel:int = 4;
        private static const AttributeBeadLv1:int = 313199;
        private static const AttributeBeadLv2:int = 313299;
        private static const AttributeBeadLv3:int = 313399;
        private static const AttributeBeadLv4:int = 313499;
        private static const AttackBeadLv1:int = 311199;
        private static const AttackBeadLv2:int = 311299;
        private static const AttackBeadLv3:int = 311399;
        private static const AttackBeadLv4:int = 311499;
        private static const DefenceBeadLv1:int = 312199;
        private static const DefenceBeadLv2:int = 312299;
        private static const DefenceBeadLv3:int = 312399;
        private static const DefenceBeadLv4:int = 312499;
        public static const LaserBomdID:int = 87;
        public static const FLY_CD:int = 2;
        public static const FLY_ENERGY:int = 150;
        public static const ADD_TWO_ATTACK:int = 10001;
        public static const ADD_ONE_ATTACK:int = 10002;
        public static const THREEKILL:int = 10003;
        public static const FLY:int = 10006;
        public static const Angle:int = 17001;
        public static const TrueAngle:int = 17002;
        public static const ExllenceAngle:int = 17005;
        public static const FlyAngle:int = 17000;
        public static const FlyAngleOne:int = 17100;
        public static const TrueShield:int = 17003;
        public static const ExcellentShield:int = 17004;
        public static const WishKingBlessing:int = 17200;
        public static const PYX1:int = 17200;
        public static const GuildBomb:int = 10017;
        public static const Hiding:int = 10010;
        public static const HidingGroup:int = 10011;
        public static const HealthGroup:int = 10009;
        public static const Health:int = 10012;
        public static const Freeze:int = 10015;


        public static function getPropNameByType(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case 1:
                    return ("composestone");
                case 2:
                    return ("StrengthStoneCell");
                case 3:
                    return ("symbol");
                case 4:
                    return ("sbugle");
                case 5:
                    return ("bbugle");
                case 6:
                    return ("packages");
                case 7:
                    return ("symbol");
                case 8:
                    return ("other");
                default:
                    return ("");
            };
        }

        public static function dressAble(_arg_1:ItemTemplateInfo):Boolean
        {
            if (dressAbleIDs.indexOf(_arg_1.CategoryID) != -1)
            {
                return (true);
            };
            return (false);
        }

        public static function isJewelryOrRing(_arg_1:ItemTemplateInfo):Boolean
        {
            return ((_arg_1.CategoryID == 8) || (_arg_1.CategoryID == 9));
        }

        public static function isWeddingRing(_arg_1:ItemTemplateInfo):Boolean
        {
            switch (_arg_1.TemplateID)
            {
                case 9022:
                case 9122:
                case 9222:
                case 9322:
                case 9422:
                case 9522:
                    return (true);
                default:
                    return (false);
            };
        }

        public static function isEditable(_arg_1:ItemTemplateInfo):Boolean
        {
            if (((_arg_1.CategoryID <= 6) && (_arg_1.CategoryID >= 1)))
            {
                if (_arg_1.Property6 == "0")
                {
                    return (true);
                };
            };
            return (false);
        }

        public static function canBeUsed(_arg_1:ItemTemplateInfo):Boolean
        {
            if ((((_arg_1.CategoryID == 11) && (_arg_1.Property1 == "5")) && (!(_arg_1.Property2 == "0"))))
            {
                return (true);
            };
            if (((_arg_1.CategoryID == 11) && (_arg_1.Property1 == "21")))
            {
                return (true);
            };
            if (((_arg_1.CategoryID == 11) && (_arg_1.Property1 == "22")))
            {
                return (true);
            };
            if (((_arg_1.CategoryID == 11) && (_arg_1.Property1 == "25")))
            {
                return (true);
            };
            if (((_arg_1.CategoryID == 11) && (_arg_1.Property1 == "26")))
            {
                return (true);
            };
            if (((_arg_1.CategoryID == 11) && (_arg_1.Property1 == "27")))
            {
                return (true);
            };
            if (((_arg_1.CategoryID == 11) && (_arg_1.Property1 == "29")))
            {
                return (true);
            };
            if (((_arg_1.CategoryID == 11) && (_arg_1.Property1 == "28")))
            {
                return (true);
            };
            if (((_arg_1.CategoryID == 11) && (_arg_1.Property1 == "32")))
            {
                return (true);
            };
            if (((_arg_1.CategoryID == 11) && (_arg_1.Property1 == "33")))
            {
                return (true);
            };
            if (((_arg_1.CategoryID == 11) && (_arg_1.Property1 == "34")))
            {
                return (true);
            };
            if (((_arg_1.CategoryID == 11) && (_arg_1.Property1 == "37")))
            {
                return (true);
            };
            if (((_arg_1.CategoryID == 11) && (_arg_1.Property1 == "100")))
            {
                return (true);
            };
            if (_arg_1.CategoryID == EquipType.TEXP_TASK)
            {
                return (true);
            };
            if (_arg_1.CategoryID == EquipType.PET_EGG)
            {
                return (true);
            };
            if (_arg_1.CategoryID == EquipType.CHANGE_SEX)
            {
                return (true);
            };
            if (_arg_1.CategoryID == EquipType.COMPOSE_SKILL)
            {
                return (true);
            };
            switch (_arg_1.TemplateID)
            {
                case EquipType.TRANSFER_PROP:
                case EquipType.COLORCARD:
                case EquipType.FREE_PROP_CARD:
                case EquipType.DOUBLE_EXP_CARD:
                case EquipType.DOUBLE_GESTE_CARD:
                case EquipType.PREVENT_KICK:
                case EquipType.Caddy_Good:
                case EquipType.Save_Life:
                case EquipType.Agility_Get:
                case EquipType.ReHealth:
                case EquipType.Level_Try:
                case EquipType.Card_Get:
                case EquipType.CHANGE_NAME_CARD:
                case EquipType.CONSORTIA_CHANGE_NAME_CARD:
                case EquipType.VIPCARD:
                case EquipType.VIPCARD_TEST:
                case EquipType.VIPCARD_TEST3:
                case EquipType.CHANGE_SEX:
                case EquipType.VITALITY_WATER:
                    return (true);
                default:
                    return (false);
            };
        }

        public static function canOpenAll(_arg_1:ItemTemplateInfo):Boolean
        {
            if (((_arg_1.CategoryID == 11) && (_arg_1.Property1 == "6")))
            {
                return (true);
            };
            if (isCard(_arg_1))
            {
                return (true);
            };
            return (false);
        }

        public static function isCard(_arg_1:ItemTemplateInfo):Boolean
        {
            var _local_3:uint;
            var _local_2:Array = [21, 25, 26, 27, 28, 29];
            if (((_arg_1.CategoryID == 11) && (_arg_1.Property6 == "1")))
            {
                _local_3 = 0;
                while (_local_3 < _local_2.length)
                {
                    if (_arg_1.Property1 == String(_local_2[_local_3]))
                    {
                        return (true);
                    };
                    _local_3++;
                };
            };
            return (false);
        }

        public static function isEquipBoolean(_arg_1:ItemTemplateInfo):Boolean
        {
            switch (_arg_1.CategoryID)
            {
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                case 6:
                case 7:
                case 8:
                case 9:
                case 13:
                case 14:
                case 15:
                case 16:
                case 17:
                case 18:
                case HEALSTONE:
                    return (true);
                default:
                    return (false);
            };
        }

        public static function isHealStone(_arg_1:ItemTemplateInfo):Boolean
        {
            return (_arg_1.CategoryID == HEALSTONE);
        }

        public static function isStrengthStone(_arg_1:ItemTemplateInfo):Boolean
        {
            if (_arg_1.CategoryID != UNFRIGHTPROP)
            {
                return (false);
            };
            if (((_arg_1.Property1 == "2") || (_arg_1.Property1 == "35")))
            {
                return (true);
            };
            return (false);
        }

        public static function isSymbol(_arg_1:ItemTemplateInfo):Boolean
        {
            if (_arg_1.CategoryID != UNFRIGHTPROP)
            {
                return (false);
            };
            if (_arg_1.Property1 == "3")
            {
                return (true);
            };
            return (false);
        }

        public static function isBugle(_arg_1:ItemTemplateInfo):Boolean
        {
            return ((_arg_1.TemplateID == 11101) || (_arg_1.TemplateID == 11102));
        }

        public static function isEquip(_arg_1:ItemTemplateInfo):Boolean
        {
            if ((((_arg_1.CategoryID >= 1) && (_arg_1.CategoryID < 10)) && (!(_arg_1.CategoryID == 7))))
            {
                return (true);
            };
            return (false);
        }

        public static function isHead(_arg_1:ItemTemplateInfo):Boolean
        {
            return (_arg_1.CategoryID == HEAD);
        }

        public static function isCloth(_arg_1:ItemTemplateInfo):Boolean
        {
            return (_arg_1.CategoryID == CLOTH);
        }

        public static function isAvatar(_arg_1:int):Boolean
        {
            return (!([HEAD, GLASS, HAIR, EFF, CLOTH, FACE, SUITS, WING].indexOf(_arg_1) == -1));
        }

        public static function isArm(_arg_1:ItemTemplateInfo):Boolean
        {
            return ((_arg_1.CategoryID == 7) || (_arg_1.CategoryID == 27));
        }

        public static function canEquip(_arg_1:ItemTemplateInfo):Boolean
        {
            if ((((((((((((_arg_1.CategoryID >= 1) && (_arg_1.CategoryID < 20)) && (!(_arg_1.CategoryID == 18))) && (!(_arg_1.CategoryID == 11))) && (!(_arg_1.CategoryID == 12))) && (!(_arg_1.CategoryID == 10))) || (_arg_1.CategoryID == 27)) || (_arg_1.CategoryID == EquipType.TEMPARMLET)) || (_arg_1.CategoryID == EquipType.TEMPRING)) || (_arg_1.CategoryID == EquipType.TEMP_OFFHAND)) || (_arg_1.CategoryID == 40)))
            {
                return (true);
            };
            return (false);
        }

        public static function isChest(_arg_1:ItemTemplateInfo):Boolean
        {
            return (_arg_1.Property1 == "6");
        }

        public static function isMissionGoods(_arg_1:ItemTemplateInfo):Boolean
        {
            return (_arg_1.Property1 == "10");
        }

        public static function isProp(_arg_1:ItemTemplateInfo):Boolean
        {
            return ((_arg_1.CategoryID == FRIGHTPROP) || (_arg_1.CategoryID == UNFRIGHTPROP));
        }

        public static function isBelongToPropBag(_arg_1:ItemTemplateInfo):Boolean
        {
            if (_arg_1 == null)
            {
                return (false);
            };
            switch (_arg_1.CategoryID)
            {
                case EquipType.FRIGHTPROP:
                case EquipType.UNFRIGHTPROP:
                case EquipType.TASK:
                case EquipType.TEXP:
                case EquipType.TEXP_TASK:
                case EquipType.ACTIVE_TASK:
                case EquipType.FOOD:
                case EquipType.PET_EGG:
                    return (true);
                default:
                    return (false);
            };
        }

        public static function isFashionViewGoods(_arg_1:ItemTemplateInfo):Boolean
        {
            if (_arg_1 == null)
            {
                return (false);
            };
            switch (_arg_1.CategoryID)
            {
                case EquipType.CLOTH:
                case EquipType.FACE:
                case EquipType.HEAD:
                case EquipType.EFF:
                case EquipType.HAIR:
                case EquipType.SUITS:
                case EquipType.WING:
                case EquipType.GLASS:
                case EquipType.CHATBALL:
                    return (true);
                default:
                    return (false);
            };
        }

        public static function isEquipViewGoods(_arg_1:ItemTemplateInfo):Boolean
        {
            if (_arg_1 == null)
            {
                return (false);
            };
            if (isWeddingRing(_arg_1))
            {
                return (true);
            };
            var _local_2:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(_arg_1.TemplateID);
            if (_local_2 == null)
            {
                return (false);
            };
            switch (_local_2.TemplateType)
            {
                case 1:
                case 2:
                case 3:
                case 4:
                case 6:
                case 5:
                case 11:
                case 12:
                case 14:
                case 13:
                case 10:
                case 9:
                case 7:
                case 8:
                    return (true);
                default:
                    return (false);
            };
        }

        public static function isTask(_arg_1:ItemTemplateInfo):Boolean
        {
            return (_arg_1.CategoryID == TASK);
        }

        public static function isPackage(_arg_1:ItemTemplateInfo):Boolean
        {
            return ((_arg_1.CategoryID == UNFRIGHTPROP) && (_arg_1.Property1 == "6"));
        }

        public static function isPetEgg(_arg_1:ItemTemplateInfo):Boolean
        {
            return (_arg_1.CategoryID == EquipType.PET_EGG);
        }

        public static function isRingEquipment(_arg_1:ItemTemplateInfo):Boolean
        {
            if (_arg_1 == null)
            {
                return (false);
            };
            var _local_2:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(_arg_1.TemplateID);
            return ((_local_2) && (_local_2.TemplateType == 13));
        }

        public static function isPetSpeciallFood(_arg_1:ItemTemplateInfo):Boolean
        {
            return (_arg_1.TemplateID == 334100);
        }

        public static function isSpecilPackage(_arg_1:ItemTemplateInfo):Boolean
        {
            return (_arg_1.Property2 == "6");
        }

        public static function placeToCategeryId(_arg_1:int):int
        {
            switch (_arg_1)
            {
                case 7:
                case 8:
                    return (8);
                case 9:
                case 10:
                    return (9);
                default:
                    return (_arg_1 + 1);
            };
        }

        public static function CategeryIdToPlace(_arg_1:int):Array
        {
            switch (_arg_1)
            {
                case 13:
                    return ([5]);
                case 15:
                    return ([7]);
                case 16:
                    return ([9]);
                case 1:
                    return ([2]);
                case 2:
                    return ([8]);
                case 3:
                    return ([4]);
                case 4:
                    return ([3]);
                case 5:
                    return ([0]);
                case 6:
                    return ([1]);
                default:
                    return ([(_arg_1 - 1)]);
            };
        }

        public static function CategeryIdToCharacterload(_arg_1:int):Array
        {
            switch (_arg_1)
            {
                case 1:
                    return ([4]);
                case 5:
                    return ([0]);
                default:
                    return ([(_arg_1 - 1)]);
            };
        }

        public static function getTemplateTypeToPlace(_arg_1:int):Array
        {
            switch (_arg_1)
            {
                case 1:
                    return ([10]);
                case 2:
                    return ([11]);
                case 3:
                    return ([12]);
                case 4:
                    return ([13]);
                case 6:
                    return ([15]);
                case 5:
                    return ([14]);
                case 11:
                    return ([20]);
                case 12:
                    return ([23]);
                case 14:
                    return ([21]);
                case 13:
                    return ([6]);
                case 10:
                    return ([19]);
                case 9:
                    return ([18]);
                case 7:
                    return ([16]);
                case 8:
                    return ([17]);
                default:
                    return ([(_arg_1 - 1)]);
            };
        }

        public static function hasSkin(_arg_1:int):Boolean
        {
            return ((_arg_1 == FACE) || (_arg_1 == CLOTH));
        }

        public static function isCaddy(_arg_1:ItemTemplateInfo):Boolean
        {
            if ((((_arg_1.TemplateID == CADDY) || (_arg_1.TemplateID == Silver_Caddy)) || (_arg_1.TemplateID == Gold_Caddy)))
            {
                return (true);
            };
            return (false);
        }

        public static function isBless(_arg_1:ItemTemplateInfo):Boolean
        {
            if ((((_arg_1.TemplateID == BOMB_KING_BLESS) || (_arg_1.TemplateID == GOLD_BLESS)) || (_arg_1.TemplateID == SILVER_BLESS)))
            {
                return (true);
            };
            return (false);
        }

        public static function isValuableEquip(_arg_1:ItemTemplateInfo):Boolean
        {
            var _local_3:EquipmentTemplateInfo;
            var _local_2:InventoryItemInfo = (_arg_1 as InventoryItemInfo);
            if (_local_2)
            {
                if (((((_local_2.CategoryID == 27) || (_local_2.CategoryID == EquipType.TEMPARMLET)) || (_local_2.CategoryID == EquipType.TEMPRING)) || (_local_2.CategoryID == EquipType.SPECIAL)))
                {
                    return (true);
                };
                if (_local_2.CategoryID == EquipType.EQUIP)
                {
                    _local_3 = ItemManager.Instance.getEquipTemplateById(_local_2.TemplateID);
                    if ((((_local_3.TemplateType <= 6) && (_local_2.StrengthenLevel >= 30)) || ((_local_3.TemplateType > 6) && (_local_3.QualityID >= 4))))
                    {
                        return (true);
                    };
                };
            }
            else
            {
                return (false);
            };
            return (false);
        }

        public static function isEmbed(_arg_1:ItemTemplateInfo):Boolean
        {
            var _local_3:int;
            var _local_2:InventoryItemInfo = (_arg_1 as InventoryItemInfo);
            if (_local_2)
            {
                if (_local_2.CategoryID == EquipType.EQUIP)
                {
                    _local_3 = 1;
                    while (_local_3 <= 4)
                    {
                        if (_local_2[("Hole" + _local_3)] > 1)
                        {
                            return (true);
                        };
                        _local_3++;
                    };
                };
            };
            return (false);
        }

        public static function isDrill(_arg_1:InventoryItemInfo):Boolean
        {
            if (_arg_1 == null)
            {
                return (false);
            };
            return ((_arg_1.CategoryID == DrillCategoryID) && (_arg_1.Property1 == DrillCategotyProperty));
        }

        public static function isBead(_arg_1:int):Boolean
        {
            return (_arg_1 == 31);
        }

        public static function isAttackBead(_arg_1:ItemTemplateInfo):Boolean
        {
            return (_arg_1.Property2 == "1");
        }

        public static function isDefenceBead(_arg_1:ItemTemplateInfo):Boolean
        {
            return (_arg_1.Property2 == "2");
        }

        public static function isAttributeBead(_arg_1:ItemTemplateInfo):Boolean
        {
            return (_arg_1.Property2 == "3");
        }

        public static function isBeadFromSmelt(_arg_1:ItemTemplateInfo):Boolean
        {
            return (isBeadFromSmeltByID(_arg_1.TemplateID));
        }

        public static function isBeadFromSmeltByID(_arg_1:int):Boolean
        {
            return (BeadModel.getInstance().isBeadFromSmelt(_arg_1));
        }

        public static function isAttackBeadFromSmeltByID(_arg_1:int):Boolean
        {
            var _local_2:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_arg_1);
            if (_local_2)
            {
                return (BeadModel.getInstance().isAttackBead(_local_2));
            };
            return (false);
        }

        public static function isDefenceBeadFromSmeltByID(_arg_1:int):Boolean
        {
            var _local_2:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_arg_1);
            if (_local_2)
            {
                return (BeadModel.getInstance().isDefenceBead(_local_2));
            };
            return (false);
        }

        public static function isAttributeBeadFromSmeltByID(_arg_1:int):Boolean
        {
            var _local_2:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_arg_1);
            if (_local_2)
            {
                return (BeadModel.getInstance().isAttributeBead(_local_2));
            };
            return (false);
        }

        public static function isOfferPackage(_arg_1:ItemTemplateInfo):Boolean
        {
            switch (_arg_1.TemplateID)
            {
                case OFFER_PACK_I:
                case OFFER_PACK_II:
                case OFFER_PACK_III:
                case OFFER_PACK_IV:
                case OFFER_PACK_V:
                    return (true);
                default:
                    return (false);
            };
        }

        public static function isBeadNeedOpen(_arg_1:ItemTemplateInfo):Boolean
        {
            if (isBeadFromSmelt(_arg_1))
            {
                return (true);
            };
            switch (_arg_1.TemplateID)
            {
                case BEAD_ATTACK:
                case BEAD_ATTRIBUTE:
                case BEAD_DEFENSE:
                    return (true);
                default:
                    return (false);
            };
            return (false); //dead code
        }

        public static function isCaddyCanBay(_arg_1:ItemTemplateInfo):Boolean
        {
            return (_arg_1.TemplateID == CADDY);
        }

        public static function isTimeBox(_arg_1:ItemTemplateInfo):Boolean
        {
            return (((_arg_1.CategoryID == 11) && (_arg_1.Property1 == "6")) && (_arg_1.Property2 == "4"));
        }

        public static function isAngel(_arg_1:ItemTemplateInfo):Boolean
        {
            return (((((_arg_1.TemplateID == Angle) || (_arg_1.TemplateID == TrueAngle)) || (_arg_1.TemplateID == ExllenceAngle)) || (_arg_1.TemplateID == FlyAngle)) || (_arg_1.TemplateID == FlyAngleOne));
        }

        public static function isShield(_arg_1:ItemTemplateInfo):Boolean
        {
            return ((_arg_1.TemplateID == TrueShield) || (_arg_1.TemplateID == ExcellentShield));
        }

        public static function isWishKingBlessing(_arg_1:ItemTemplateInfo):Boolean
        {
            return (_arg_1.TemplateID == WishKingBlessing);
        }

        public static function hasPropAnimation(_arg_1:ItemTemplateInfo):String
        {
            switch (_arg_1.TemplateID)
            {
                case Hiding:
                case HidingGroup:
                    return ("hiding");
                case Health:
                case HealthGroup:
                    return ("health");
                case Freeze:
                    return ("freeze");
                default:
                    return (null);
            };
        }

        public static function isWeapon(_arg_1:int):Boolean
        {
            var _local_2:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(_arg_1);
            if (_local_2)
            {
                return (_local_2.TemplateType == 5);
            };
            return (false);
        }

        public static function isOffHand(_arg_1:int):Boolean
        {
            var _local_2:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(_arg_1);
            if (_local_2)
            {
                return (_local_2.TemplateType == 6);
            };
            return (false);
        }

        public static function filterEquiqItemId(_arg_1:int):int
        {
            switch (_arg_1)
            {
                case -1:
                    _arg_1 = EquipType.MONEY;
                    break;
                case -2:
                    _arg_1 = EquipType.BIND_MONEY;
                    break;
                case -3:
                    _arg_1 = EquipType.GOLD;
                    break;
                case -4:
                    _arg_1 = EquipType.MAGICSOUL;
                    break;
            };
            return (_arg_1);
        }

        public static function ContrastGoods(_arg_1:InventoryItemInfo):Boolean
        {
            var _local_2:Boolean;
            var _local_3:InventoryItemInfo;
            var _local_4:EquipmentTemplateInfo;
            var _local_5:int;
            if (_arg_1)
            {
                _local_3 = _arg_1;
                _local_4 = ItemManager.Instance.getEquipTemplateById(_local_3.TemplateID);
                if (_local_4 == null)
                {
                    return (false);
                };
                _local_5 = int(getCellIndex(_local_4));
                if (PlayerManager.Instance.Self.Bag.getItemAt(_local_5) == null)
                {
                    return (false);
                };
                if (_local_3.TemplateID == PlayerManager.Instance.Self.Bag.getItemAt(_local_5).TemplateID)
                {
                    _local_2 = true;
                }
                else
                {
                    _local_2 = false;
                };
            };
            return (_local_2);
        }

        public static function NoStrengLimitGood(_arg_1:ItemTemplateInfo):Boolean
        {
            switch (_arg_1.TemplateID)
            {
                case 400100:
                case 400101:
                case 400102:
                case 400103:
                case 400104:
                    return (true);
                default:
                    return (false);
            };
        }

        public static function isPetsEgg(_arg_1:ItemTemplateInfo):Boolean
        {
            switch (_arg_1.TemplateID)
            {
                case 112004:
                case 112005:
                case 112006:
                case 112007:
                case 112008:
                case 112009:
                case 112010:
                case 112011:
                    return (true);
                default:
                    return (false);
            };
        }

        private static function getCellIndex(_arg_1:EquipmentTemplateInfo):String
        {
            switch (_arg_1.TemplateType)
            {
                case 1:
                    return ("10");
                case 2:
                    return ("11");
                case 3:
                    return ("12");
                case 4:
                    return ("13");
                case 6:
                    return ("15");
                case 5:
                    return ("14");
                case 7:
                    return ("16");
                case 8:
                    return ("17");
                case 9:
                    return ("18");
                case 10:
                    return ("19");
                case 11:
                    return ("20");
                case 12:
                    return ("23");
                case 13:
                    return ("22");
                case 14:
                    return ("21");
                default:
                    return ("-1");
            };
        }

        public static function isHolyGrail(_arg_1:ItemTemplateInfo):Boolean
        {
            var _local_2:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(_arg_1.TemplateID);
            return ((_local_2) && (_local_2.TemplateType == HOLYGRAIL));
        }

        public static function getEmbedHoleCount(_arg_1:ItemTemplateInfo):int
        {
            var _local_4:String;
            var _local_2:int;
            var _local_3:Array = _arg_1.Hole.split("|");
            for each (_local_4 in _local_3)
            {
                if (_local_4.split(",")[0] != "0")
                {
                    _local_2++;
                };
            };
            return (_local_2);
        }

        public static function getEmbedHoleInfo(_arg_1:ItemTemplateInfo, _arg_2:int):Array
        {
            var _local_3:Array = _arg_1.Hole.split("|");
            return (_local_3[_arg_2].split(","));
        }


    }
}//package ddt.data

