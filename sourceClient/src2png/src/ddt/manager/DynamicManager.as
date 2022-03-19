// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.DynamicManager

package ddt.manager
{
    import flash.external.ExternalInterface;
    import flash.system.Security;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.view.SNSFrame;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.manager.CacheSysManager;
    import ddt.constants.CacheConsts;
    import ddt.action.FrameShowAction;

    public class DynamicManager 
    {

        private static var _ins:DynamicManager;


        public static function get Instance():DynamicManager
        {
            if (_ins == null)
            {
                _ins = new (DynamicManager)();
            };
            return (_ins);
        }


        public function initialize():void
        {
            if ((((ExternalInterface.available) && (PathManager.CommnuntyMicroBlog())) && (PathManager.CommnuntySinaSecondMicroBlog())))
            {
                Security.allowInsecureDomain("*");
                ExternalInterface.addCallback("sinaCallBack", this.sinaCallBack);
            };
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_DYNAMIC, this.__getDynamic);
        }

        private function __getDynamic(_arg_1:CrazyTankSocketEvent):void
        {
            if (((PathManager.CommnuntyMicroBlog()) && (PathManager.CommnuntySinaSecondMicroBlog())))
            {
                this.__semdWeiBo(_arg_1);
            }
            else
            {
                this.__sendDynamic(_arg_1);
            };
        }

        public function __sendDynamic(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:SNSFrame;
            if (SharedManager.Instance.isCommunity)
            {
                _local_2 = ComponentFactory.Instance.creatComponentByStylename("core.SNSFrameView");
                _local_2.typeId = _arg_1.pkg.readInt();
                _local_2.backgroundServerTxt = _arg_1.pkg.readUTF();
                _local_2.receptionistTxt = _arg_1.pkg.readUTF();
                if (CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
                {
                    CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT, new FrameShowAction(_local_2));
                }
                else
                {
                    if (CacheSysManager.isLock(CacheConsts.ALERT_IN_MOVIE))
                    {
                        CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_MOVIE, new FrameShowAction(_local_2));
                    }
                    else
                    {
                        _local_2.show();
                    };
                };
            };
        }

        public function __semdWeiBo(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_4:String;
            if (((SharedManager.Instance.allowSnsSend) || (!(PathManager.CommunityExist()))))
            {
                return;
            };
            var _local_2:Object = new Object();
            var _local_3:int = _arg_1.pkg.readInt();
            _local_4 = (("flash/CMFriendIcon/sinaweibo/weibo" + _local_3) + ".jpg");
            _local_4 = PathManager.CommunitySinaWeibo(_local_4);
            _local_2.title = _arg_1.pkg.readUTF();
            _local_2.content = _arg_1.pkg.readUTF();
            if (ExternalInterface.available)
            {
                ExternalInterface.call("sendWeiboFeed", _local_2.title, _local_2.content, _local_4);
                SocketManager.Instance.out.sendSnsMsg(_local_3);
            };
        }

        public function sinaCallBack():void
        {
            ChatManager.Instance.sysChatYellow("微博发送成功!");
            SocketManager.Instance.out.sendSnsMsg(0);
        }


    }
}//package ddt.manager

