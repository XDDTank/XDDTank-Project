// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//platformapi.tencent.DiamondManager

package platformapi.tencent
{
    import flash.events.EventDispatcher;
    import platformapi.tencent.model.DiamondModel;
    import ddt.manager.PlayerManager;
    import com.pickgliss.loader.UIModuleLoader;
    import com.pickgliss.events.UIModuleEvent;
    import ddt.data.UIModuleTypes;
    import flash.events.Event;
    import ddt.view.UIModuleSmallLoading;
    import ddt.manager.SocketManager;
    import platformapi.tencent.view.MemberDiamondFrame;
    import com.pickgliss.ui.ComponentFactory;
    import platformapi.tencent.view.BlueDiamondGiftView;
    import platformapi.tencent.view.BunAwardFrame;
    import com.pickgliss.ui.LayerManager;
    import platformapi.tencent.view.BlueDiamondNewHandGiftView;
    import platformapi.tencent.view.MemberDiamondRepaymentFrame;

    public class DiamondManager extends EventDispatcher 
    {

        private static var _instance:DiamondManager;

        private var _model:DiamondModel;
        private var _hasUI:Boolean;
        private var _isFirst:Boolean = true;

        public function DiamondManager(_arg_1:SingleTon)
        {
            if ((!(_arg_1)))
            {
                throw ("单例无法实例化");
            };
        }

        public static function get instance():DiamondManager
        {
            return (_instance = ((_instance) || (new DiamondManager(new SingleTon()))));
        }


        public function get model():DiamondModel
        {
            return (this._model = ((this._model) || (new DiamondModel())));
        }

        public function get isInTencent():Boolean
        {
            return (this.model.pfdata.pfType > 0);
        }

        public function get pfType():int
        {
            return (this.model.pfdata.pfType);
        }

        public function get hasUI():Boolean
        {
            return (this._hasUI);
        }

        public function get isFirst():Boolean
        {
            if (PlayerManager.Instance.Self.Grade <= 3)
            {
                return (false);
            };
            if (this._isFirst)
            {
                this._isFirst = false;
                return (true);
            };
            return (this._isFirst);
        }

        public function loadUIModule():void
        {
            if ((!(this._hasUI)))
            {
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIModuleComplete);
                UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onProgress);
                UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.MEMBER_DIAMOND_GIFT);
            }
            else
            {
                dispatchEvent(new Event(Event.COMPLETE));
            };
        }

        protected function __onProgress(_arg_1:UIModuleEvent):void
        {
            UIModuleSmallLoading.Instance.progress = (_arg_1.loader.progress * 100);
        }

        protected function __onUIModuleComplete(_arg_1:UIModuleEvent):void
        {
            if (_arg_1.module == UIModuleTypes.MEMBER_DIAMOND_GIFT)
            {
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIModuleComplete);
                UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onProgress);
                this._hasUI = true;
                dispatchEvent(new Event(Event.COMPLETE));
            };
        }

        protected function __onClose(_arg_1:Event):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE, this.__onUIModuleComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS, this.__onProgress);
        }

        public function dailyAward(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                SocketManager.Instance.out.sendDiamondAward(8);
            }
            else
            {
                SocketManager.Instance.out.sendDiamondAward(7);
            };
        }

        public function firstEnterOpen():void
        {
            if (PlayerManager.Instance.Self.Grade < 9)
            {
                return;
            };
            if (this.isFirst)
            {
                if (PlayerManager.Instance.Self.isGetNewHandPack)
                {
                    switch (DiamondManager.instance.model.pfdata.pfType)
                    {
                        case DiamondType.YELLOW_DIAMOND:
                            this.openDiamondFrame(1);
                            break;
                        case DiamondType.BLUE_DIAMOND:
                            this.openBlueFrame(1);
                            break;
                        case DiamondType.MEMBER_DIAMOND:
                            this.openBlueFrame(1);
                            break;
                    };
                }
                else
                {
                    switch (DiamondManager.instance.model.pfdata.pfType)
                    {
                        case DiamondType.YELLOW_DIAMOND:
                            this.openDiamondFrame(0);
                            return;
                        case DiamondType.BLUE_DIAMOND:
                            this.openBlueNewHandFrame(0);
                            return;
                        case DiamondType.MEMBER_DIAMOND:
                            this.openBlueNewHandFrame(0);
                            return;
                    };
                };
            };
        }

        public function openNewHand():void
        {
            switch (this.pfType)
            {
                case DiamondType.YELLOW_DIAMOND:
                    this.openDiamondFrame(0);
                    return;
                case DiamondType.BLUE_DIAMOND:
                    this.openBlueNewHandFrame();
                    return;
                case DiamondType.MEMBER_DIAMOND:
                    this.openDiamondFrame(0);
                    return;
            };
        }

        public function openDiamond():void
        {
            switch (this.pfType)
            {
                case DiamondType.YELLOW_DIAMOND:
                    this.openDiamondFrame(1);
                    return;
                case DiamondType.BLUE_DIAMOND:
                    this.openBlueFrame();
                    return;
                case DiamondType.MEMBER_DIAMOND:
                    this.openDiamondFrame(1);
                    return;
            };
        }

        public function openDiamondFrame(_arg_1:int):void
        {
            var _local_2:MemberDiamondFrame;
            if (this._hasUI)
            {
                _local_2 = ComponentFactory.Instance.creatComponentByStylename("memberDiamondFrame");
                _local_2.show(_arg_1);
            }
            else
            {
                addEventListener(Event.COMPLETE, this.callBackFunc(this.openDiamondFrame, _arg_1));
                this.loadUIModule();
            };
        }

        private function callBackFunc(func:Function, index:int):Function
        {
            (func(index));
            return (function (_arg_1:Event):void
            {
            });
        }

        public function openBlueFrame(_arg_1:int=0):void
        {
            var _local_2:BlueDiamondGiftView;
            if (this._hasUI)
            {
                _local_2 = ComponentFactory.Instance.creatComponentByStylename("memberDiamondGift.view.memberDiamondGiftView");
                _local_2.show();
            }
            else
            {
                addEventListener(Event.COMPLETE, this.callBackFunc(this.openBlueFrame, _arg_1));
                this.loadUIModule();
            };
        }

        public function openBunFrame(_arg_1:int=0):void
        {
            var _local_2:BunAwardFrame;
            if (this._hasUI)
            {
                _local_2 = ComponentFactory.Instance.creatComponentByStylename("memberDiamondGift.view.bunAwardFrame");
                LayerManager.Instance.addToLayer(_local_2, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            }
            else
            {
                addEventListener(Event.COMPLETE, this.callBackFunc(this.openBunFrame, _arg_1));
                this.loadUIModule();
            };
        }

        public function openBlueNewHandFrame(_arg_1:int=0):void
        {
            var _local_2:BlueDiamondNewHandGiftView;
            if (this._hasUI)
            {
                _local_2 = ComponentFactory.Instance.creatComponentByStylename("memberDiamondGift.view.memberDiamondNewHandGiftView");
                _local_2.show();
            }
            else
            {
                addEventListener(Event.COMPLETE, this.callBackFunc(this.openBlueNewHandFrame, _arg_1));
                this.loadUIModule();
            };
        }

        public function openMemberDiamondRepaymentFrame(_arg_1:int=0):void
        {
            var _local_2:MemberDiamondRepaymentFrame;
            if (this._hasUI)
            {
                _local_2 = ComponentFactory.Instance.creatComponentByStylename("memberDiamondGift.view.memberDiamondRepaymentFrame");
                _local_2.show();
            }
            else
            {
                addEventListener(Event.COMPLETE, this.callBackFunc(this.openMemberDiamondRepaymentFrame, _arg_1));
                this.loadUIModule();
            };
        }

        public function openMemberDiamond():void
        {
            TencentExternalInterfaceManager.openDiamond();
        }

        public function openYearMemberDiamond():void
        {
            TencentExternalInterfaceManager.openDiamond(true);
        }


    }
}//package platformapi.tencent

class SingleTon 
{


}


