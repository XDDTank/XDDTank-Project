// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.info.PlayerInfoViewControl

package bagAndInfo.info
{
    import ddt.data.player.PlayerInfo;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import ddt.events.PlayerPropertyEvent;
    import ddt.manager.SocketManager;
    import ddt.manager.SoundManager;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;

    public class PlayerInfoViewControl 
    {

        private static var _view:PlayerInfoFrame;
        private static var _tempInfo:PlayerInfo;
        private static var _loadComplete:Boolean;
        private static var _info:PlayerInfo;
        private static var _achivEnable:Boolean;
        public static var isOpenFromBag:Boolean;


        public static function get info():PlayerInfo
        {
            return (_info);
        }

        public static function view(_arg_1:PlayerInfo, _arg_2:Boolean=true):void
        {
            _info = _arg_1;
            _achivEnable = _arg_2;
            if (_loadComplete)
            {
                showView();
            }
            else
            {
                loadUI();
            };
        }

        private static function showView():void
        {
            if (info)
            {
                if (((info.ZoneID > 0) && (!(info.ZoneID == PlayerManager.Instance.Self.ZoneID))))
                {
                    if (_view == null)
                    {
                        _view = ComponentFactory.Instance.creatComponentByStylename("bag.personelInfoViewFrame");
                    };
                    _view.info = info;
                    _view.show();
                    _view.addEventListener(FrameEvent.RESPONSE, __responseHandler);
                    return;
                };
                if (info.Style != null)
                {
                    if (_view == null)
                    {
                        _view = ComponentFactory.Instance.creatComponentByStylename("bag.personelInfoViewFrame");
                    };
                    _view.info = info;
                    _view.show();
                    _view.addEventListener(FrameEvent.RESPONSE, __responseHandler);
                }
                else
                {
                    info.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, __infoChange);
                };
                SocketManager.Instance.out.sendItemEquip(info.ID);
            };
        }

        private static function __infoChange(_arg_1:PlayerPropertyEvent):void
        {
            if (PlayerInfo(_arg_1.currentTarget).Style)
            {
                PlayerInfo(_arg_1.target).removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, __infoChange);
                if (_view == null)
                {
                    _view = ComponentFactory.Instance.creatComponentByStylename("bag.personelInfoViewFrame");
                };
                _view.info = PlayerInfo(_arg_1.target);
                _view.show();
                _view.addEventListener(FrameEvent.RESPONSE, __responseHandler);
            };
        }

        public static function viewByID(_arg_1:int, _arg_2:int=-1, _arg_3:Boolean=true):void
        {
            var _local_4:PlayerInfo = PlayerManager.Instance.findPlayer(_arg_1, _arg_2);
            view(_local_4, _arg_3);
        }

        public static function viewByNickName(_arg_1:String, _arg_2:int=-1, _arg_3:Boolean=true):void
        {
            _tempInfo = new PlayerInfo();
            _tempInfo = PlayerManager.Instance.findPlayerByNickName(_tempInfo, _arg_1);
            if (_tempInfo.ID)
            {
                view(_tempInfo, _arg_3);
            }
            else
            {
                SocketManager.Instance.out.sendItemEquip(_tempInfo.NickName, true);
                _tempInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, __IDChange);
            };
        }

        private static function __IDChange(_arg_1:PlayerPropertyEvent):void
        {
            _tempInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, __IDChange);
            view(_tempInfo);
        }

        private static function __responseHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    _view.dispose();
                    clearView();
                    isOpenFromBag = false;
                    return;
            };
        }

        public static function closeView():void
        {
            if (((_view) && (_view.parent)))
            {
                _view.removeEventListener(FrameEvent.RESPONSE, __responseHandler);
                _view.dispose();
            };
            _view = null;
        }

        private static function loadUI():void
        {
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, __loadingClose);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, __moduleComplete);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, __onProgress);
            UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_ERROR, __moduleIOError);
            UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.NEWBAGANDINFO);
        }

        private static function __onProgress(_arg_1:UIModuleEvent):void
        {
            UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
        }

        private static function __moduleIOError(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.NEWBAGANDINFO)
            {
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, __moduleComplete);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, __onProgress);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR, __moduleIOError);
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, __loadingClose);
                UIModuleSmallLoading.Instance.hide();
            };
        }

        private static function __moduleComplete(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.NEWBAGANDINFO)
            {
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, __moduleComplete);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, __onProgress);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR, __moduleIOError);
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, __loadingClose);
                UIModuleSmallLoading.Instance.hide();
                _loadComplete = true;
                showView();
            };
        }

        private static function __loadingClose(_arg_1:Event):void
        {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, __moduleComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, __onProgress);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_ERROR, __moduleIOError);
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, __loadingClose);
            UIModuleSmallLoading.Instance.hide();
        }

        public static function clearView():void
        {
            if (_view)
            {
                _view.removeEventListener(FrameEvent.RESPONSE, __responseHandler);
            };
            _view = null;
        }


    }
}//package bagAndInfo.info

