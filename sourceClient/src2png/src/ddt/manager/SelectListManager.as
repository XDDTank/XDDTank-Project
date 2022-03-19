// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.SelectListManager

package ddt.manager
{
    import __AS3__.vec.Vector;
    import ddt.data.Role;
    import ddt.data.analyze.LoginSelectListAnalyzer;

    public class SelectListManager 
    {

        private static var _instance:SelectListManager;

        private var _isNewBie:Boolean;
        private var _list:Vector.<Role>;
        private var _currentLoginRole:Role;


        public static function get Instance():SelectListManager
        {
            if (_instance == null)
            {
                _instance = new (SelectListManager)();
            };
            return (_instance);
        }


        public function setup(_arg_1:LoginSelectListAnalyzer):void
        {
            this._list = _arg_1.list;
            if (this._list.length == 0)
            {
                this._isNewBie = true;
            };
            if (this._list.length == 1)
            {
                this.currentLoginRole = this._list[0];
            };
        }

        public function get list():Vector.<Role>
        {
            return (this._list);
        }

        public function set currentLoginRole(_arg_1:Role):void
        {
            this._currentLoginRole = _arg_1;
        }

        public function get currentLoginRole():Role
        {
            return (this._currentLoginRole);
        }

        public function get mustShowSelectWindow():Boolean
        {
            if ((((this._list.length == 1) && (this._list[0].Rename == false)) && (this._list[0].ConsortiaRename == false)))
            {
                return (false);
            };
            return (true);
        }

        public function get isNewbie():Boolean
        {
            return (this._isNewBie);
        }


    }
}//package ddt.manager

