// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//packagePurchaseBox.PackagePurchaseBoxController

package packagePurchaseBox
{
    import flash.events.EventDispatcher;
    import packagePurchaseBox.view.PackagePurchaseBoxFrame;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import com.pickgliss.ui.ComponentFactory;
    import __AS3__.vec.Vector;
    import ddt.data.goods.ShopItemInfo;
    import __AS3__.vec.*;

    public class PackagePurchaseBoxController extends EventDispatcher 
    {

        private static var _instance:PackagePurchaseBoxController;

        private var _frame:PackagePurchaseBoxFrame;
        private var _model:PackagePurchaseBoxModel;
        private var _useFirst:Boolean = true;
        private var _loadComplete:Boolean = false;

        public function PackagePurchaseBoxController()
        {
            this._model = new PackagePurchaseBoxModel();
        }

        public static function get instance():PackagePurchaseBoxController
        {
            if ((!(_instance)))
            {
                _instance = new (PackagePurchaseBoxController)();
            };
            return (_instance);
        }


        public function show():void
        {
            if (this._loadComplete)
            {
                this.showFrame();
            }
            else
            {
                if (this._useFirst)
                {
                    UIModuleSmallLoading.Instance.progress = 0;
                    UIModuleSmallLoading.Instance.show();
                    UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
                    UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__progressShow);
                    UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__complainShow);
                    UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.DDTSHOP);
                };
            };
        }

        private function showFrame():void
        {
            this._frame = ComponentFactory.Instance.creatComponentByStylename("packagePurchaseBoxFrame");
            this._frame.show();
        }

        public function measureList(_arg_1:Vector.<ShopItemInfo>):Vector.<ShopItemInfo>
        {
            var _local_2:Vector.<ShopItemInfo>;
            _local_2 = new Vector.<ShopItemInfo>();
            if ((!(_arg_1)))
            {
                return (_local_2);
            };
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                if (_arg_1[_local_3].isValid)
                {
                    _local_2[_local_3] = _arg_1[_local_3];
                };
                _local_3++;
            };
            return (_local_2);
        }

        public function hide():void
        {
            if (this._frame != null)
            {
                this._frame.dispose();
            };
            this._frame = null;
        }

        private function __progressShow(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.DDTSHOP)
            {
                UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
            };
        }

        private function __onClose(_arg_1:Event):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__progressShow);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__complainShow);
        }

        private function __complainShow(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.DDTSHOP)
            {
                UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__progressShow);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__complainShow);
                UIModuleSmallLoading.Instance.hide();
                this._loadComplete = true;
                this._useFirst = false;
                this.show();
            };
        }


    }
}//package packagePurchaseBox

