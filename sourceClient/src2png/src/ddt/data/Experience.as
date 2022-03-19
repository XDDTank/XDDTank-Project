// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.Experience

package ddt.data
{
    import ddt.manager.PlayerManager;
    import ddt.data.analyze.ExpericenceAnalyze;

    public class Experience 
    {

        public static var expericence:Array;
        public static var HP:Array;
        public static var MAX_LEVEL:int;


        public static function getExpPercent(_arg_1:int, _arg_2:int):Number
        {
            if (_arg_1 == MAX_LEVEL)
            {
                return (0);
            };
            if (_arg_1 == 1)
            {
                _arg_2--;
            };
            return ((_arg_2 - expericence[(_arg_1 - 1)]) / (expericence[_arg_1] - expericence[(_arg_1 - 1)]));
        }

        public static function getGrade(_arg_1:Number):int
        {
            var _local_2:int = PlayerManager.Instance.Self.Grade;
            var _local_3:int;
            while (_local_3 < expericence.length)
            {
                if (_arg_1 >= expericence[(MAX_LEVEL - 1)])
                {
                    _local_2 = MAX_LEVEL;
                    break;
                };
                if (_arg_1 < expericence[_local_3])
                {
                    _local_2 = _local_3;
                    break;
                };
                if (_arg_1 <= 0)
                {
                    _local_2 = 0;
                    break;
                };
                _local_3++;
            };
            return (_local_2);
        }

        public static function getBasicHP(_arg_1:int):int
        {
            _arg_1 = ((_arg_1 >= MAX_LEVEL) ? MAX_LEVEL : ((_arg_1 <= 1) ? 1 : _arg_1));
            return (HP[(_arg_1 - 1)]);
        }

        public static function setup(_arg_1:ExpericenceAnalyze):void
        {
            expericence = _arg_1.expericence;
            HP = _arg_1.HP;
            MAX_LEVEL = _arg_1.expericence.length;
        }


    }
}//package ddt.data

