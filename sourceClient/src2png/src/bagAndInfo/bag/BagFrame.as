// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.bag.BagFrame

package bagAndInfo.bag
{
    import com.pickgliss.ui.controls.Frame;
    import email.view.EmailBagView;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PlayerManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.ui.LayerManager;

    public class BagFrame extends Frame 
    {

        protected var _bagView:BagView;
        protected var _emailBagView:EmailBagView;
        protected var _isShow:Boolean;

        public function BagFrame()
        {
            this.initView();
            this.initEvent();
        }

        protected function initView():void
        {
            this._bagView = ComponentFactory.Instance.creatCustomObject("bagFrameBagView");
            this._bagView.info = PlayerManager.Instance.Self;
        }

        public function graySortBtn():void
        {
            this._bagView.sortBagEnable = false;
        }

        protected function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.dispose();
                    return;
            };
        }

        public function get bagView():BagView
        {
            return (this._bagView);
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, false);
            this._isShow = true;
        }

        public function hide():void
        {
            if (parent)
            {
                parent.removeChild(this);
                this._isShow = false;
            };
        }

        public function get isShow():Boolean
        {
            return (this._isShow);
        }

        override public function dispose():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            if (this._bagView)
            {
                this._bagView.dispose();
            };
            super.dispose();
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package bagAndInfo.bag

