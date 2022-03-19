// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//CapabilityNoctice.CapabilityNocticeManager

package CapabilityNoctice
{
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.data.player.PlayerInfo;
    import ddt.events.PlayerPropertyEvent;
    import ddt.manager.SharedManager;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.StateManager;
    import ddt.states.StateType;

    public class CapabilityNocticeManager 
    {

        public static const ARENA_LEVEL:int = 20;
        public static var ARENA_NAME:String;
        private static var _instance:CapabilityNocticeManager;

        private var _viewDic:Array;
        private var _noticeDic:Array;

        public function CapabilityNocticeManager()
        {
            this._noticeDic = new Array();
            this._viewDic = new Array();
            ARENA_NAME = LanguageMgr.GetTranslation("ddt.capabilitynotice.arena");
            this.initEvent();
        }

        public static function get instance():CapabilityNocticeManager
        {
            if ((!(_instance)))
            {
                _instance = new (CapabilityNocticeManager)();
            };
            return (_instance);
        }


        public function hide():void
        {
            var _local_1:CapabilityNocticeView;
            for each (_local_1 in this._viewDic)
            {
                ObjectUtils.disposeObject(_local_1);
                _local_1 = null;
            };
            this._viewDic = new Array();
        }

        public function addNotice(_arg_1:int, _arg_2:String, _arg_3:String):void
        {
            var _local_4:CapabilityNoticeInfo;
            var _local_5:CapabilityNoticeInfo;
            for each (_local_4 in this._noticeDic)
            {
                if (((_local_4.level == _arg_1) && (_local_4.name == _arg_3)))
                {
                    return;
                };
            };
            _local_5 = new CapabilityNoticeInfo();
            _local_5.level = _arg_1;
            _local_5.pic = _arg_2;
            _local_5.name = _arg_3;
            this._noticeDic.push(_local_5);
        }

        public function check():void
        {
            this.showNotice();
        }

        private function __update(_arg_1:PlayerPropertyEvent):void
        {
            if (((_arg_1.changedProperties[PlayerInfo.GRADE]) && (this.checkState())))
            {
                this.showNotice();
            };
        }

        private function showNotice():void
        {
            var _local_2:CapabilityNoticeInfo;
            var _local_3:CapabilityNocticeView;
            var _local_1:Object = SharedManager.Instance.capabilityNotice;
            for each (_local_2 in this._noticeDic)
            {
                if (((_local_2.level == PlayerManager.Instance.Self.Grade) && (!(_local_1[_local_2.name]))))
                {
                    _local_3 = ComponentFactory.Instance.creatComponentByStylename("ddt.capabilityNoctice.CapabilityNocticeView");
                    _local_3.info = _local_2;
                    _local_3.show();
                    this._viewDic.push(_local_3);
                    _local_1[_local_2.name] = true;
                    SharedManager.Instance.capabilityNotice = _local_1;
                    SharedManager.Instance.save();
                };
            };
        }

        private function checkState():Boolean
        {
            if (StateManager.currentStateType == StateType.MAIN)
            {
                return (true);
            };
            return (false);
        }

        private function initEvent():void
        {
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__update);
        }


    }
}//package CapabilityNoctice

