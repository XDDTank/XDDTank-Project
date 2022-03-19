// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.DuowanInterfaceManage

package ddt.manager
{
    import flash.events.EventDispatcher;
    import ddt.events.DuowanInterfaceEvent;
    import com.pickgliss.utils.MD5;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.RequestLoader;
    import com.pickgliss.loader.LoaderEvent;

    public class DuowanInterfaceManage extends EventDispatcher 
    {

        private static var _instance:DuowanInterfaceManage;

        private var key:String;

        public function DuowanInterfaceManage()
        {
            this.key = "sdkxccjlqaoehtdwjkdycdrw";
            addEventListener(DuowanInterfaceEvent.ADD_ROLE, this.__userActionNotice);
            addEventListener(DuowanInterfaceEvent.UP_GRADE, this.__upGradeNotice);
            addEventListener(DuowanInterfaceEvent.ONLINE, this.__onLineNotice);
            addEventListener(DuowanInterfaceEvent.OUTLINE, this.__outLineNotice);
        }

        public static function get Instance():DuowanInterfaceManage
        {
            if (_instance == null)
            {
                _instance = new (DuowanInterfaceManage)();
            };
            return (_instance);
        }


        private function __userActionNotice(_arg_1:DuowanInterfaceEvent):void
        {
            var _local_2:String = "4";
            var _local_3:String = PlayerManager.Instance.Self.ID.toString();
            _local_3 = encodeURI(_local_3);
            var _local_4:String = MD5.hash(((_local_3 + _local_2) + this.key));
            this.send(_local_2, _local_3, _local_4);
        }

        private function __upGradeNotice(_arg_1:DuowanInterfaceEvent):void
        {
            var _local_2:String = "1";
            var _local_3:String = PlayerManager.Instance.Self.ID.toString();
            _local_3 = encodeURI(_local_3);
            var _local_4:String = MD5.hash(((_local_3 + _local_2) + this.key));
            this.send(_local_2, _local_3, _local_4);
        }

        private function __onLineNotice(_arg_1:DuowanInterfaceEvent):void
        {
            var _local_2:String = "2";
            var _local_3:String = PlayerManager.Instance.Self.ID.toString();
            _local_3 = encodeURI(_local_3);
            var _local_4:String = MD5.hash(((_local_3 + _local_2) + this.key));
            this.send(_local_2, _local_3, _local_4);
        }

        private function __outLineNotice(_arg_1:DuowanInterfaceEvent):void
        {
            var _local_2:String = "3";
            var _local_3:String = PlayerManager.Instance.Self.ID.toString();
            _local_3 = encodeURI(_local_3);
            var _local_4:String = MD5.hash(((_local_3 + _local_2) + this.key));
            this.send(_local_2, _local_3, _local_4);
        }

        private function send(_arg_1:String, _arg_2:String, _arg_3:String):void
        {
            var _local_4:String = PathManager.userActionNotice();
            if (_local_4 == "")
            {
                return;
            };
            _local_4 = _local_4.replace("{username}", _arg_2);
            _local_4 = _local_4.replace("{type}", _arg_1);
            _local_4 = _local_4.replace("{sign}", _arg_3);
            var _local_5:RequestLoader = LoadResourceManager.instance.createLoader(_local_4, BaseLoader.REQUEST_LOADER);
            _local_5.addEventListener(LoaderEvent.COMPLETE, this.__loaderComplete2);
            LoadResourceManager.instance.startLoad(_local_5);
        }

        private function __loaderComplete2(_arg_1:LoaderEvent):void
        {
        }


    }
}//package ddt.manager

