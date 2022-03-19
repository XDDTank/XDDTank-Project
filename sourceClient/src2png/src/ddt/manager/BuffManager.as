// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.BuffManager

package ddt.manager
{
    import flash.utils.Dictionary;
    import ddt.data.FightBuffInfo;
    import ddt.data.BuffType;
    import calendar.CalendarManager;
    import ddt.data.BuffInfo;
    import ddt.data.analyze.PetSkillEliementAnalyzer;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;

    public class BuffManager 
    {

        private static var _info:Dictionary;


        public static function creatBuff(_arg_1:int):FightBuffInfo
        {
            var _local_2:FightBuffInfo = new FightBuffInfo(_arg_1);
            if (BuffType.isCardBuff(_local_2))
            {
                _local_2.type = BuffType.CARD_BUFF;
                translateDisplayID(_local_2);
            }
            else
            {
                if (BuffType.isConsortiaBuff(_local_2))
                {
                    _local_2.type = BuffType.CONSORTIA;
                    translateDisplayID(_local_2);
                }
                else
                {
                    if (BuffType.isLocalBuffByID(_arg_1))
                    {
                        _local_2.type = BuffType.Local;
                        translateDisplayID(_local_2);
                        if (((BuffType.isLuckyBuff(_arg_1)) && (CalendarManager.getInstance().luckyNum >= 0)))
                        {
                            _local_2.displayid = (CalendarManager.getInstance().luckyNum + 40);
                        };
                    }
                    else
                    {
                        if (BuffType.isMilitaryBuff(_arg_1))
                        {
                            _local_2.type = BuffType.MILITARY_BUFF;
                            _local_2.displayid = _local_2.id;
                        }
                        else
                        {
                            if (BuffType.isArenaBufferByID(_arg_1))
                            {
                                _local_2.type = BuffType.ARENA_BUFF;
                                _local_2.displayid = _local_2.id;
                            }
                            else
                            {
                                _local_2.displayid = _local_2.id;
                            };
                        };
                    };
                };
            };
            return (_local_2);
        }

        private static function translateDisplayID(_arg_1:FightBuffInfo):void
        {
            switch (_arg_1.id)
            {
                case BuffType.AddPercentDamage:
                    _arg_1.displayid = BuffType.AddDamage;
                    return;
                case BuffType.SetDefaultDander:
                    _arg_1.displayid = BuffType.TurnAddDander;
                    return;
                case BuffType.AddDander:
                    _arg_1.displayid = BuffType.TurnAddDander;
                    return;
                case BuffInfo.ADD_INVADE_ATTACK:
                    _arg_1.displayid = BuffInfo.ADD_INVADE_ATTACK;
                    return;
                default:
                    _arg_1.displayid = _arg_1.id;
            };
        }

        public static function setPetTemplate(_arg_1:PetSkillEliementAnalyzer):void
        {
            _info = _arg_1.buffTemplateInfo;
        }

        public static function getResource(_arg_1:String):void
        {
            var _local_2:Array = _arg_1.split(",");
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                if (((_local_2[_local_3]) && (_info[_local_2[_local_3]].EffectPic)))
                {
                    LoadResourceManager.instance.creatAndStartLoad(PathManager.solvePetSkillEffect(_info[_local_2[_local_3]].EffectPic), BaseLoader.MODULE_LOADER);
                };
                _local_3++;
            };
        }


    }
}//package ddt.manager

