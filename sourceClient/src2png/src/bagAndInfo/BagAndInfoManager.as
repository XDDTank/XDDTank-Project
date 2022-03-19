// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.BagAndInfoManager

package bagAndInfo
{
    import flash.events.EventDispatcher;
    import ddt.data.BagInfo;
    import bagAndInfo.bag.BagEquipListView;
    import ddt.data.UIModuleTypes;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import flash.utils.getTimer;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.ComponentFactory;

    public class BagAndInfoManager extends EventDispatcher 
    {

        public static var _firstShowBag:Boolean = true;
        private static var _instance:BagAndInfoManager;

        private var _bagAndGiftFrame:BagAndGiftFrame;
        private var _type:int = 0;
        private var _bagInfo:BagInfo;
        private var _isClose:Boolean = true;
        private var _bagListView:BagEquipListView;
        private var _bagListViewTwo:BagEquipListView;
        private var _bagListViewThree:BagEquipListView;

        public function BagAndInfoManager(_arg_1:SingletonForce)
        {
        }

        public static function get Instance():BagAndInfoManager
        {
            if (_instance == null)
            {
                _instance = new BagAndInfoManager(new SingletonForce());
            };
            return (_instance);
        }


        public function get isShown():Boolean
        {
            if ((!(this._bagAndGiftFrame)))
            {
                return (false);
            };
            return (true);
        }

        public function setup():void
        {
            this._bagListView = new BagEquipListView(0);
            this._bagListViewTwo = new BagEquipListView(0, 79, 127);
            this._bagListViewThree = new BagEquipListView(0, 127, 175);
        }

        private function __createBag(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.NEWBAGANDINFO)
            {
                UIModuleSmallLoading.Instance.hide();
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onSmallLoadingClose);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__createBag);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onUIProgress);
                _firstShowBag = false;
                this.showBagAndInfo(this._type);
            };
        }

        public function set bagInfo(_arg_1:BagInfo):void
        {
            this._bagInfo = _arg_1;
        }

        public function get bagInfo():BagInfo
        {
            return (this._bagInfo);
        }

        public function showBagAndInfo(_arg_1:int=0, _arg_2:String=""):void
        {
            var _local_3:uint = getTimer();
            this._type = _arg_1;
            if (this._bagAndGiftFrame == null)
            {
                if (_firstShowBag)
                {
                    UIModuleSmallLoading.Instance.progress = 0;
                    UIModuleSmallLoading.Instance.show();
                    UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onSmallLoadingClose);
                    UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__createBag);
                    UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onUIProgress);
                    UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.NEWBAGANDINFO);
                }
                else
                {
                    this.bagInfo = PlayerManager.Instance.Self.Bag;
                    this._bagAndGiftFrame = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame");
                    this._bagAndGiftFrame.show(_arg_1, _arg_2);
                    dispatchEvent(new Event(Event.OPEN));
                    this.IsClose = false;
                };
            }
            else
            {
                this._bagAndGiftFrame.show(_arg_1);
                dispatchEvent(new Event(Event.OPEN));
                this.IsClose = false;
            };
        }

        private function __onUIProgress(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.NEWBAGANDINFO)
            {
                UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
            };
        }

        private function __onSmallLoadingClose(_arg_1:Event):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onSmallLoadingClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__createBag);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onUIProgress);
        }

        public function hideBagAndInfo():void
        {
            if (this._bagAndGiftFrame)
            {
                this._bagAndGiftFrame.dispose();
                this._bagAndGiftFrame = null;
                dispatchEvent(new Event(Event.CLOSE));
            };
        }

        public function clearReference():void
        {
            this._bagAndGiftFrame = null;
            dispatchEvent(new Event(Event.CLOSE));
        }

        public function set IsClose(_arg_1:Boolean):void
        {
            this._isClose = _arg_1;
        }

        public function get IsClose():Boolean
        {
            return (this._isClose);
        }

        public function get bagListView():BagEquipListView
        {
            return (this._bagListView);
        }

        public function get bagListViewTwo():BagEquipListView
        {
            return (this._bagListViewTwo);
        }

        public function get bagListViewThree():BagEquipListView
        {
            return (this._bagListViewThree);
        }


    }
}//package bagAndInfo

class SingletonForce 
{


}


