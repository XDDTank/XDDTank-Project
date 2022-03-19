// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.BuffType

package ddt.data
{
    public class BuffType 
    {

        public static const ARENA_BUFF:int = 7;
        public static const MILITARY_BUFF:int = 6;
        public static const PET_BUFF:int = 5;
        public static const FREE_CONTINUE:int = 72;
        public static const CARD_BUFF:int = 4;
        public static const CONSORTIA:int = 3;
        public static const Pay:int = 2;
        public static const Local:int = 1;
        public static const Turn:int = 0;
        public static const LockState:int = 1000;
        public static const DieFight:int = 1001;
        public static const Tired:int = 1;
        public static const Firing:int = 2;
        public static const LockAngel:int = 3;
        public static const Weakness:int = 4;
        public static const NoHole:int = 5;
        public static const Defend:int = 6;
        public static const Targeting:int = 7;
        public static const DisenableFly:int = 8;
        public static const LimitMaxForce:int = 9;
        public static const ResolveHurt:int = 10;
        public static const CustomAddGuard:int = 11;
        public static const AddDamage:int = 12;
        public static const TurnAddDander:int = 13;
        public static const AddCritical:int = 14;
        public static const ExemptEnergy:int = 15;
        public static const AddDander:int = 16;
        public static const AddProperty:int = 17;
        public static const AddMaxBlood:int = 18;
        public static const ReduceDamage:int = 19;
        public static const AddPercentDamage:int = 20;
        public static const SetDefaultDander:int = 21;
        public static const ReduceContinueDamage:int = 22;
        public static const DoNotMove:int = 23;
        public static const AddPercentDefance:int = 24;
        public static const ReducePoisoning:int = 25;
        public static const AddBloodGunCount:int = 26;
        public static const ResistAttack:int = 27;
        public static const SACRED_BLESSING:int = 31;
        public static const SACRED_SHIELD:int = 32;
        public static const NIUTOU:int = 33;
        public static const INDIAN:int = 34;
        public static const ConsortionAddBloodGunCount:int = 101;
        public static const ConsortionAddDamage:int = 102;
        public static const ConsortionAddCritical:int = 103;
        public static const ConsortionAddMaxBlood:int = 104;
        public static const ConsortionAddProperty:int = 105;
        public static const ConsortionReduceEnergyUse:int = 106;
        public static const ConsortionAddEnergy:int = 107;
        public static const ConsortionAddEffectTurn:int = 108;
        public static const ConsortionAddOfferRate:int = 109;
        public static const ConsortionAddPercentGoldOrGP:int = 110;
        public static const ConsortionAddSpellCount:int = 111;
        public static const ConsortionReduceDander:int = 112;
        public static const ARENA_MARS:int = 300;
        public static const WorldBossHP:int = 400;
        public static const WorldBossHP_MoneyBuff:int = 402;
        public static const WorldBossAttrack:int = 401;
        public static const WorldBossAttrack_MoneyBuff:int = 403;
        public static const WorldBossAncientBlessings:int = 404;
        public static const WorldBossAddDamage:int = 405;


        public static function isContainerBuff(_arg_1:FightBuffInfo):Boolean
        {
            return (((_arg_1.type == Pay) || (_arg_1.type == CONSORTIA)) || (_arg_1.type == CARD_BUFF));
        }

        public static function isPayBuff(_arg_1:FightBuffInfo):Boolean
        {
            return (((_arg_1.id >= 50) && (_arg_1.id <= 79)) && (!(_arg_1.id == 72)));
        }

        public static function isConsortiaBuff(_arg_1:FightBuffInfo):Boolean
        {
            switch (_arg_1.id)
            {
                case BuffInfo.ADD_BOMB_MINE_COUNT:
                case BuffInfo.ADD_TRUCK_SPEED:
                case BuffInfo.ADD_CONVOY_COUNT:
                case BuffInfo.ADD_HIJACK_COUNT:
                case BuffInfo.ADD_SIRIKE_COPY_COUNT:
                case BuffInfo.ADD_INVADE_ATTACK:
                case BuffInfo.ADD_QUEST_RICHESOFFER:
                case BuffInfo.ADD_SLAY_DAMAGE:
                case BuffInfo.REDUCE_PVP_MOVE_ENERY:
                case BuffInfo.GET_ONLINE_REWARS:
                case BuffInfo.GET_INVADE_HONOR:
                case BuffInfo.GET_PET_GP_PLUS:
                    return (true);
                default:
                    return (false);
            };
        }

        public static function isCardBuff(_arg_1:FightBuffInfo):Boolean
        {
            return ((_arg_1.id >= 211) && (_arg_1.id <= 290));
        }

        public static function isLuckyBuff(_arg_1:int):Boolean
        {
            return ((_arg_1 >= 40) && (_arg_1 <= 49));
        }

        public static function isArenaBufferByID(_arg_1:int):Boolean
        {
            switch (_arg_1)
            {
                case ARENA_MARS:
                    return (true);
            };
            return (false);
        }

        public static function isLocalBuffByID(_arg_1:int):Boolean
        {
            if (isLuckyBuff(_arg_1))
            {
                return (true);
            };
            switch (_arg_1)
            {
                case CustomAddGuard:
                case AddDamage:
                case TurnAddDander:
                case AddCritical:
                case ExemptEnergy:
                case AddDander:
                case AddProperty:
                case AddMaxBlood:
                case ReduceDamage:
                case AddPercentDamage:
                case SetDefaultDander:
                case ReduceContinueDamage:
                case DoNotMove:
                case AddPercentDefance:
                case ReducePoisoning:
                case AddBloodGunCount:
                case SACRED_BLESSING:
                case SACRED_SHIELD:
                case ResistAttack:
                case WorldBossHP:
                case WorldBossHP_MoneyBuff:
                case WorldBossAttrack:
                case WorldBossAttrack_MoneyBuff:
                case WorldBossAncientBlessings:
                case WorldBossAddDamage:
                    return (true);
                default:
                    return (false);
            };
        }

        public static function isMilitaryBuff(_arg_1:int):Boolean
        {
            switch (_arg_1)
            {
                case BuffInfo.MILITARY_BLOOD_BUFF1:
                case BuffInfo.MILITARY_BLOOD_BUFF2:
                case BuffInfo.MILITARY_BLOOD_BUFF3:
                    return (true);
                default:
                    return (false);
            };
        }


    }
}//package ddt.data

