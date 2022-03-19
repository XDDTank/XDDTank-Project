// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.fightPower.FightPowerController

package bagAndInfo.fightPower
{
    import __AS3__.vec.Vector;
    import ddt.manager.PlayerManager;
    import __AS3__.vec.*;

    public class FightPowerController 
    {

        public static const TOTAL_FIGHT_POWER:uint = 1;
        public static const EQUIP_FIGHT_POWER:uint = 2;
        public static const STRENG_FIGHT_POWER:uint = 3;
        public static const BEAD_FIGHT_POWER:uint = 4;
        public static const PET_FIGHT_POWER:uint = 5;
        public static const TOTEM_FIGHT_POWER:uint = 6;
        public static const RUNE_FIGHT_POWER:uint = 7;
        public static const PET_ADVANCE_FIGHT_POWER:uint = 8;
        public static const REFINING_FIGHT_POWER:uint = 9;
        private static var _instance:FightPowerController;

        private var _fightPowerDescList:Vector.<FightPowerDescInfo>;


        public static function get Instance():FightPowerController
        {
            if ((!(_instance)))
            {
                _instance = new (FightPowerController)();
            };
            return (_instance);
        }


        public function setFightPowerDesc(_arg_1:FightPowerDescAnalyzer):void
        {
            this._fightPowerDescList = _arg_1.list;
        }

        public function getFightPowerByType(_arg_1:int, _arg_2:Boolean=false):Vector.<FightPowerDescInfo>
        {
            var _local_4:FightPowerDescInfo;
            var _local_3:Vector.<FightPowerDescInfo> = new Vector.<FightPowerDescInfo>();
            for each (_local_4 in this._fightPowerDescList)
            {
                if (_local_4.Type == _arg_1)
                {
                    _local_3.push(_local_4);
                };
            };
            if (_arg_2)
            {
                _local_3.sort(this.sortList);
            };
            return (_local_3);
        }

        public function getCurrentLevelValueByType(_arg_1:int):FightPowerDescInfo
        {
            var _local_3:FightPowerDescInfo;
            var _local_2:Vector.<FightPowerDescInfo> = this.getFightPowerByType(_arg_1);
            for each (_local_3 in _local_2)
            {
                if (_local_3.Level == PlayerManager.Instance.Self.Grade)
                {
                    return (_local_3);
                };
            };
            return (null);
        }

        public function getMinLevelByType(_arg_1:int):int
        {
            var _local_2:Vector.<FightPowerDescInfo> = this.getFightPowerByType(_arg_1, true);
            if (_local_2.length == 0)
            {
                return (999);
            };
            return (_local_2[0].Level);
        }

        private function sortList(_arg_1:FightPowerDescInfo, _arg_2:FightPowerDescInfo):int
        {
            if (_arg_1.Level > _arg_2.Level)
            {
                return (1);
            };
            return (-1);
        }

        public function get fightPowerDescList():Vector.<FightPowerDescInfo>
        {
            return (this._fightPowerDescList);
        }


    }
}//package bagAndInfo.fightPower

