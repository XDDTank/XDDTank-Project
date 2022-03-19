// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.objects.GhostBoxModel

package game.objects
{
    import com.pickgliss.ui.ComponentFactory;

    public class GhostBoxModel 
    {

        private static var _ins:GhostBoxModel;

        private var _psychicArr:Array;


        public static function getInstance():GhostBoxModel
        {
            if (_ins == null)
            {
                _ins = ComponentFactory.Instance.creatCustomObject("GhostBoxModel");
            };
            return (_ins);
        }


        public function set psychics(_arg_1:String):void
        {
            this._psychicArr = _arg_1.split(",");
        }

        public function getPsychicByType(_arg_1:int):int
        {
            if ((((this._psychicArr == null) || ((_arg_1 - 2) > this._psychicArr.length)) || ((_arg_1 - 2) < 0)))
            {
                return (0);
            };
            return (this._psychicArr[(_arg_1 - 2)]);
        }


    }
}//package game.objects

