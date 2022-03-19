// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//worldboss.view.ExchangeGoodsFrame

package worldboss.view
{
    import com.pickgliss.ui.controls.Frame;
    import ddt.data.goods.ShopItemInfo;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import ddt.command.NumberSelecter;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.Event;
    import ddt.manager.PlayerManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.SocketManager;
    import ddt.manager.SoundManager;

    public class ExchangeGoodsFrame extends Frame 
    {

        public var canDispose:Boolean;
        private var _view:ExchangeGoodsFrameView;
        private var _shopItemInfo:ShopItemInfo;
        private var _submitButton:TextButton;
        private var _unitPrice:Number;
        private var _buyFrom:int;

        public function ExchangeGoodsFrame()
        {
            this.canDispose = true;
            this.initView();
            this.initEvents();
        }

        private function initView():void
        {
            this._view = new ExchangeGoodsFrameView();
            addToContent(this._view);
            this._submitButton = ComponentFactory.Instance.creatComponentByStylename("ddtcore.quickEnter");
            this._submitButton.text = LanguageMgr.GetTranslation("tank.littlegame.exchange");
            this._view.addChild(this._submitButton);
            escEnable = true;
            enterEnable = true;
        }

        private function initEvents():void
        {
            addEventListener(FrameEvent.RESPONSE, this._response);
            this._submitButton.addEventListener(MouseEvent.CLICK, this.doPay);
            this._view.addEventListener(NumberSelecter.NUMBER_CLOSE, this._numberClose);
            addEventListener(NumberSelecter.NUMBER_ENTER, this._numberEnter);
        }

        private function removeEvnets():void
        {
            removeEventListener(FrameEvent.RESPONSE, this._response);
            if (this._submitButton)
            {
                this._submitButton.removeEventListener(MouseEvent.CLICK, this.doPay);
            };
            if (this._view)
            {
                this._view.removeEventListener(NumberSelecter.NUMBER_CLOSE, this._numberClose);
            };
            removeEventListener(NumberSelecter.NUMBER_ENTER, this._numberEnter);
        }

        private function _numberClose(_arg_1:Event):void
        {
            ObjectUtils.disposeObject(this);
        }

        private function _numberEnter(_arg_1:Event):void
        {
            _arg_1.stopImmediatePropagation();
            this.doPay(null);
        }

        public function set stoneNumber(_arg_1:int):void
        {
            this._view.stoneNumber = _arg_1;
        }

        public function set maxLimit(_arg_1:int):void
        {
            this._view.maxLimit = _arg_1;
        }

        public function set ItemInfo(_arg_1:ShopItemInfo):void
        {
            this._view.shopInfo = _arg_1;
            this._shopItemInfo = _arg_1;
            this.perPrice();
        }

        private function perPrice():void
        {
            this._unitPrice = this._shopItemInfo.AValue1;
        }

        private function doPay(_arg_1:MouseEvent):void
        {
            var _local_2:Array;
            var _local_3:Array;
            var _local_4:Array;
            var _local_5:Array;
            var _local_6:Array;
            var _local_7:int;
            if (PlayerManager.Instance.Self.damageScores < (this._view.stoneNumber * this._unitPrice))
            {
                return (MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.littlegame.scorelack")));
            };
            _local_2 = new Array();
            _local_3 = new Array();
            _local_4 = new Array();
            _local_5 = new Array();
            _local_6 = new Array();
            _local_7 = 0;
            while (_local_7 < this._view.stoneNumber)
            {
                _local_2.push(this._shopItemInfo.GoodsID);
                _local_3.push(1);
                _local_4.push("");
                _local_5.push("");
                _local_6.push("");
                _local_7++;
            };
            SocketManager.Instance.out.sendBuyGoods(_local_2, _local_3, _local_4, _local_5, _local_6);
            this.dispose();
        }

        private function _response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (_arg_1.responseCode == FrameEvent.ENTER_CLICK)
            {
                this.doPay(null);
            }
            else
            {
                this.dispose();
            };
        }

        public function setTitleText(_arg_1:String):void
        {
            titleText = _arg_1;
        }

        override public function dispose():void
        {
            this.removeEvnets();
            this.canDispose = false;
            super.dispose();
            this._view = null;
            this._shopItemInfo = null;
            if (this._submitButton)
            {
                ObjectUtils.disposeObject(this._submitButton);
            };
            this._submitButton = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package worldboss.view

