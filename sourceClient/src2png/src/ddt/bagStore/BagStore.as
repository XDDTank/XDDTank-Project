// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.bagStore.BagStore

package ddt.bagStore
{
    import flash.events.EventDispatcher;
    import store.StoreController;
    import flash.events.IEventDispatcher;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import com.pickgliss.ui.ComponentFactory;
    import store.StoreMainView;
    import bagAndInfo.BagAndInfoManager;
    import com.pickgliss.utils.ObjectUtils;

    public class BagStore extends EventDispatcher 
    {

        public static var OPEN_BAGSTORE:String = "openBagStore";
        public static var CLOSE_BAGSTORE:String = "closeBagStore";
        public static const GENERAL:String = "general";
        public static const CONSORTIA:String = "consortia";
        public static const BAG_STORE:String = "bag_store";
        private static var _instance:BagStore;

        private var _tipPanelNumber:int = 0;
        private var _passwordOpen:Boolean = true;
        private var _controllerInstance:StoreController;
        private var _storeOpenAble:Boolean = false;
        private var _isFromBagFrame:Boolean = false;
        private var _isFromShop:Boolean = false;

        public function BagStore(_arg_1:IEventDispatcher=null)
        {
            this._controllerInstance = StoreController.instance;
        }

        public static function get instance():BagStore
        {
            if (_instance == null)
            {
                _instance = new (BagStore)();
            };
            return (_instance);
        }


        public function show(type:int=0):void
        {
            try
            {
                this.createStoreFrame(type);
            }
            catch(e:Error)
            {
                UIModuleSmallLoading.Instance.progress = 0;
                UIModuleSmallLoading.Instance.show();
                UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, __onClose);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, _UIComplete);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, __progressShow);
                UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTSTORE);
            };
        }

        private function __onClose(_arg_1:Event):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this._UIComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__progressShow);
        }

        private function createStoreFrame(_arg_1:int):void
        {
            var _local_2:BagStoreFrame = ComponentFactory.Instance.creatComponentByStylename("ddtstore.BagStoreFrame");
            this._controllerInstance.Model.loadBagData();
            _local_2.controller = this._controllerInstance;
            _local_2.show(_arg_1);
            this.storeOpenAble = true;
            dispatchEvent(new Event(OPEN_BAGSTORE));
        }

        private function __progressShow(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.DDTSTORE)
            {
                UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
            };
        }

        private function _UIComplete(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.DDTSTORE)
            {
                UIModuleSmallLoading.Instance.hide();
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this._UIComplete);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__progressShow);
                this.createStoreFrame(StoreMainView.STRENGTH);
            };
        }

        public function closed():void
        {
            if (this._isFromBagFrame)
            {
                BagAndInfoManager.Instance.showBagAndInfo();
                dispatchEvent(new Event(CLOSE_BAGSTORE));
                this._isFromBagFrame = false;
            };
        }

        public function get tipPanelNumber():int
        {
            return (this._tipPanelNumber);
        }

        public function set tipPanelNumber(_arg_1:int):void
        {
            this._tipPanelNumber = _arg_1;
        }

        public function reduceTipPanelNumber():void
        {
            this._tipPanelNumber--;
        }

        public function get passwordOpen():Boolean
        {
            return (this._passwordOpen);
        }

        public function set passwordOpen(_arg_1:Boolean):void
        {
            this._passwordOpen = _arg_1;
        }

        public function set storeOpenAble(_arg_1:Boolean):void
        {
            this._storeOpenAble = _arg_1;
        }

        public function get storeOpenAble():Boolean
        {
            return (this._storeOpenAble);
        }

        public function set isFromBagFrame(_arg_1:Boolean):void
        {
            this._isFromBagFrame = _arg_1;
            if (this._isFromBagFrame)
            {
                BagAndInfoManager.Instance.hideBagAndInfo();
            };
        }

        public function get isFromBagFrame():Boolean
        {
            return (this._isFromBagFrame);
        }

        public function set isFromShop(_arg_1:Boolean):void
        {
            this._isFromShop = _arg_1;
        }

        public function get isFromShop():Boolean
        {
            return (this._isFromShop);
        }

        public function get controllerInstance():StoreController
        {
            return (this._controllerInstance);
        }

        public function dispose():void
        {
            if (this._controllerInstance)
            {
                ObjectUtils.disposeObject(this._controllerInstance);
            };
            this._controllerInstance = null;
        }


    }
}//package ddt.bagStore

