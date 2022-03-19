// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.data.StoreEquipExperience

package store.data
{
    import store.analyze.StoreEquipExpericenceAnalyze;

    public class StoreEquipExperience 
    {

        public static var expericence:Array;
        public static var MAX_LEVEL:int = 0;


        public static function setup(_arg_1:StoreEquipExpericenceAnalyze):void
        {
            expericence = _arg_1.expericence;
            MAX_LEVEL = _arg_1.expericence.length;
        }

        public static function getExpPercent(_arg_1:int, _arg_2:int):Number
        {
            if (expericence.hasOwnProperty(_arg_1))
            {
                return (Math.floor(((_arg_2 / expericence[(_arg_1 + 1)]) * 10000)) / 100);
            };
            return (0);
        }

        public static function getExpMax(_arg_1:int):int
        {
            var _local_2:int;
            while (_local_2 < expericence.length)
            {
                if (expericence[_local_2] > _arg_1)
                {
                    return (expericence[_local_2]);
                };
                _local_2++;
            };
            return (expericence[_local_2]);
        }

        public static function getLevelByGP(_arg_1:int):int
        {
            var _local_2:int = (MAX_LEVEL - 1);
            while (_local_2 > -1)
            {
                if (expericence[_local_2] <= _arg_1)
                {
                    return (_local_2 + 1);
                };
                _local_2--;
            };
            return (1);
        }


    }
}//package store.data

