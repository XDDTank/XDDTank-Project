// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.view.BagAuctionFrame

package auctionHouse.view
{
    import bagAndInfo.bag.BagFrame;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import flash.events.MouseEvent;
    import email.manager.MailManager;
    import email.view.EmailEvent;
    import ddt.manager.SoundManager;
    import ddt.events.CellEvent;
    import com.pickgliss.events.FrameEvent;

    public class BagAuctionFrame extends BagFrame 
    {

        public function BagAuctionFrame()
        {
            escEnable = true;
        }

        override protected function initView():void
        {
            _bagView = new AuctionBagView();
            _bagView.info = PlayerManager.Instance.Self;
            _bagView.breakBtnEnable = false;
            _bagView.breakBtnFilter = ComponentFactory.Instance.creatFilters("grayFilter");
            _bagView.sellBtnFilter = ComponentFactory.Instance.creatFilters("grayFilter");
            _bagView.switchButtomVisible(true);
            _bagView.switchLockBtnVisible(false);
            _bagView.setClassBtnVisible = false;
            addToContent(_bagView);
            PositionUtils.setPos(_bagView, "AutionBagView.Pos");
        }

        override protected function __onCloseClick(_arg_1:MouseEvent):void
        {
            super.__onCloseClick(null);
        }

        override protected function initEvent():void
        {
            super.initEvent();
            MailManager.Instance.Model.addEventListener(EmailEvent.BAG_UPDATA, this._updata);
        }

        private function _updata(_arg_1:EmailEvent):void
        {
            _bagView.info = PlayerManager.Instance.Self;
        }

        override protected function onResponse(_arg_1:int):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1)
            {
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    dispatchEvent(new CellEvent(CellEvent.BAG_CLOSE));
                    return;
            };
        }

        override public function dispose():void
        {
            super.dispose();
            MailManager.Instance.Model.removeEventListener(EmailEvent.BAG_UPDATA, this._updata);
        }


    }
}//package auctionHouse.view

