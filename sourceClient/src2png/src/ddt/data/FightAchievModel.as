// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.FightAchievModel

package ddt.data
{
    import com.pickgliss.ui.ComponentFactory;

    public class FightAchievModel 
    {

        public static const Achiev1:int = 1;
        public static const Achiev2:int = 2;
        public static const Achiev3:int = 3;
        public static const Achiev4:int = 4;
        public static const Achiev5:int = 5;
        public static const Achiev6:int = 6;
        public static const Achiev7:int = 7;
        private static var _ins:FightAchievModel;

        private var _colors:Array;


        public static function getInstance():FightAchievModel
        {
            if (_ins == null)
            {
                _ins = ComponentFactory.Instance.creatCustomObject("FightAchievModel");
            };
            return (_ins);
        }


        public function isNumAchiev(_arg_1:int):Boolean
        {
            switch (_arg_1)
            {
                case Achiev1:
                case Achiev5:
                    return (true);
                default:
                    return (false);
            };
        }

        public function getAchievColor(_arg_1:int):int
        {
            if (((this._colors) && (_arg_1 <= this._colors.length)))
            {
                return (this._colors[(_arg_1 - 1)]);
            };
            return (0xFF0000);
        }

        public function set colors(_arg_1:String):void
        {
            this._colors = _arg_1.split(",");
        }


    }
}//package ddt.data

