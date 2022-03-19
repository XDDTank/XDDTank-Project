// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.shortcutBuy.ShortcutBuyFrame

package store.view.shortcutBuy
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import ddt.command.NumberSelecter;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.SoundManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.LeavePageManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.ui.LayerManager;

    public class ShortcutBuyFrame extends Frame 
    {

        public static const ADDFrameHeight:int = 60;
        public static const ADD_OKBTN_Y:int = 53;

        private var _view:ShortCutBuyView;
        private var _panelIndex:int;
        private var _showRadioBtn:Boolean;
        private var okBtn:TextButton;


        public function show(_arg_1:Array, _arg_2:Boolean, _arg_3:String, _arg_4:int, _arg_5:int=-1, _arg_6:Number=30, _arg_7:Number=40):void
        {
            this.titleText = _arg_3;
            this._showRadioBtn = _arg_2;
            this._panelIndex = _arg_4;
            this._view = ComponentFactory.Instance.creatCustomObject("ddtstore.ShortcutBuyFrame.ShortcutBuyView", [_arg_1, _arg_2]);
            escEnable = true;
            enterEnable = true;
            this.initII();
            this.initEvents();
            this.showToLayer();
            this.relocationView(_arg_5, _arg_6, _arg_7);
        }

        private function relocationView(_arg_1:int, _arg_2:Number, _arg_3:Number):void
        {
            if (_arg_1 != -1)
            {
                this._view.List.selectedIndex = _arg_1;
            };
            this._view.List.list.hSpace = _arg_2;
            this._view.List.list.vSpace = _arg_3;
        }

        private function initII():void
        {
            this._view.addEventListener(Event.CHANGE, this.changeHandler);
            this._view.addEventListener(NumberSelecter.NUMBER_CLOSE, this._numberClose);
            addToContent(this._view);
            if ((!(this._showRadioBtn)))
            {
                this._view.x = (this._view.x + 5);
            };
            this.okBtn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.ShortBuyFrameEnter");
            this.okBtn.text = LanguageMgr.GetTranslation("store.view.shortcutBuy.buyBtn");
            height = ((this._view.height + this._containerY) + ADDFrameHeight);
            this.okBtn.y = (height - ADD_OKBTN_Y);
            addChild(this.okBtn);
        }

        private function initEvents():void
        {
            addEventListener(FrameEvent.RESPONSE, this._response);
            this.okBtn.addEventListener(MouseEvent.CLICK, this.okFun);
            addEventListener(NumberSelecter.NUMBER_ENTER, this._numberEnter);
        }

        private function removeEvents():void
        {
            removeEventListener(FrameEvent.RESPONSE, this._response);
            this.okBtn.removeEventListener(MouseEvent.CLICK, this.okFun);
            removeEventListener(NumberSelecter.NUMBER_ENTER, this._numberEnter);
        }

        private function _numberClose(_arg_1:Event):void
        {
            ObjectUtils.disposeObject(this);
        }

        private function _numberEnter(_arg_1:Event):void
        {
            _arg_1.stopImmediatePropagation();
            this.okFun(null);
        }

        private function changeHandler(_arg_1:Event):void
        {
            this.okBtn.enable = ((!(this._view.totalDDTMoney == 0)) || (!(this._view.totalMoney == 0)));
        }

        private function _response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                ObjectUtils.disposeObject(this);
            }
            else
            {
                if (_arg_1.responseCode == FrameEvent.ENTER_CLICK)
                {
                    this.okFun(null);
                };
            };
        }

        private function okFun(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (this._view.currentShopItem == null)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionSellView.Choose"));
                this._view.List.shine();
                return;
            };
            if (this._view.totalMoney > PlayerManager.Instance.Self.Money)
            {
                LeavePageManager.showFillFrame();
                ObjectUtils.disposeObject(this);
            }
            else
            {
                if (this._view.totalDDTMoney > PlayerManager.Instance.Self.DDTMoney)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.ddtMoneyLack"));
                }
                else
                {
                    this.buyGoods();
                    this._view.save();
                    this.dispose();
                };
            };
        }

        private function buyGoods():void
        {
            var _local_1:Array = [];
            var _local_2:Array = [];
            var _local_3:Array = [];
            var _local_4:Array = [];
            var _local_5:Array = [];
            var _local_6:Array = [];
            var _local_7:int = this._view.currentShopItem.GoodsID;
            var _local_8:int = this._view.totalNum;
            var _local_9:int;
            while (_local_9 < _local_8)
            {
                _local_1.push(_local_7);
                _local_2.push(1);
                _local_3.push("");
                _local_4.push(false);
                _local_5.push("");
                _local_6.push(-1);
                _local_9++;
            };
            SocketManager.Instance.out.sendBuyGoods(_local_1, _local_2, _local_3, _local_4, _local_5, _local_6, this._panelIndex);
        }

        private function showToLayer():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        override public function dispose():void
        {
            this.removeEvents();
            this._view.removeEventListener(Event.CHANGE, this.changeHandler);
            this._view.dispose();
            super.dispose();
            this._view = null;
            if (this.okBtn)
            {
                ObjectUtils.disposeObject(this.okBtn);
            };
            this.okBtn = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package store.view.shortcutBuy

