// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.PetExperienceManager

package ddt.data
{
    import __AS3__.vec.Vector;
    import ddt.manager.ServerConfigManager;
    import ddt.data.analyze.PetExpericenceAnalyze;

    public class PetExperienceManager 
    {

        public static var expericence:Vector.<PetExperience>;
        public static var MAX_LEVEL:int = 0;


        public static function setup(analyzer:PetExpericenceAnalyze):void
        {
            expericence = analyzer.expericence;
            expericence = expericence.sort(function (_arg_1:PetExperience, _arg_2:PetExperience):int
            {
                return ((_arg_1.Level > _arg_2.Level) ? 1 : -1);
            });
            MAX_LEVEL = int(ServerConfigManager.instance.findInfoByName(ServerConfigManager.PET_MAX_LEVEL).Value);
        }

        public static function getCurrentExp(_arg_1:int, _arg_2:int):int
        {
            return (_arg_1 - expericence[(_arg_2 - 1)].GP);
        }

        public static function getUpgradeExp(_arg_1:int, _arg_2:int):int
        {
            var _local_3:int = (expericence[_arg_2].GP - _arg_1);
            return ((_local_3 > 0) ? _local_3 : 0);
        }

        public static function getNextPetExp(_arg_1:int):int
        {
            if (_arg_1 == 1)
            {
                return (expericence[_arg_1].GP);
            };
            if (_arg_1 < MAX_LEVEL)
            {
                return (expericence[_arg_1].GP - expericence[(_arg_1 - 1)].GP);
            };
            return (0);
        }

        public static function getCurrentSpaceExp(_arg_1:int, _arg_2:int):int
        {
            if (_arg_2 < MAX_LEVEL)
            {
                return (_arg_1 - expericence[(_arg_2 - 1)].ZoneExp);
            };
            return (0);
        }

        public static function getNextSpaceExp(_arg_1:int):int
        {
            if (_arg_1 == 1)
            {
                return (expericence[_arg_1].ZoneExp);
            };
            if (_arg_1 < MAX_LEVEL)
            {
                return (expericence[_arg_1].ZoneExp - expericence[(_arg_1 - 1)].ZoneExp);
            };
            return (0);
        }

        public static function getUpgradeSpaceExp(_arg_1:int, _arg_2:int):int
        {
            if (_arg_2 < MAX_LEVEL)
            {
                return (expericence[_arg_2].ZoneExp - _arg_1);
            };
            return (0);
        }

        public static function getLevelByGP(_arg_1:int):PetExperience
        {
            var _local_2:PetExperience;
            for each (_local_2 in expericence)
            {
                if (_local_2.GP >= _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }


    }
}//package ddt.data

