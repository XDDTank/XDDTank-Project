// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.view.AuctionSellLeftAler

package auctionHouse.view
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.LayerManager;
    import flash.events.Event;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import auctionHouse.event.AuctionSellEvent;

    public class AuctionSellLeftAler extends BaseAlerFrame 
    {

        private var _alertInfo:AlertInfo;
        private var _btn1:BaseButton;
        private var _btn2:BaseButton;
        private var _inputText:FilterFrameText;
        private var _SellText1:FilterFrameText;
        private var _maxNum:int = 0;
        private var _minNum:int = 1;
        private var _nowNum:int = 1;
        private var _sellInputBg:Scale9CornerImage;

        public function AuctionSellLeftAler()
        {
            this.initialize();
        }

        protected function initialize():void
        {
            this.setView();
            this.setEvent();
        }

        private function setView():void
        {
            this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.view.bagII.BreakGoodsView.number"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"));
            this._alertInfo.moveEnable = false;
            info = this._alertInfo;
            this.escEnable = true;
            this._SellText1 = ComponentFactory.Instance.creatComponentByStylename("ddtauctionHouse.SellLeftAlerText1");
            this._SellText1.text = LanguageMgr.GetTranslation("tank.view.bagII.BreakGoodsView.input");
            this._sellInputBg = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.SellLeftAlerInputBg");
            this._btn1 = ComponentFactory.Instance.creat("auctionHouse.SellLeftAlerBt1");
            this._btn2 = ComponentFactory.Instance.creat("auctionHouse.SellLeftAlerBt2");
            this._inputText = ComponentFactory.Instance.creat("auctionHouse.SellLeftAlerInputText");
            this._inputText.restrict = "0-9";
            addToContent(this._SellText1);
            addToContent(this._sellInputBg);
            addToContent(this._btn1);
            addToContent(this._btn2);
            addToContent(this._inputText);
            this.upSee();
        }

        public function show(_arg_1:int=5, _arg_2:int=1):void
        {
            this._maxNum = _arg_1;
            this._minNum = _arg_2;
            this._nowNum = this._maxNum;
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            this.upSee();
        }

        public function upSee():void
        {
            this._inputText.text = this._nowNum.toString();
            this._upbtView();
        }

        private function removeView():void
        {
        }

        private function setEvent():void
        {
            this._inputText.addEventListener(Event.CHANGE, this._changeInput);
            addEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
            this._btn1.addEventListener(MouseEvent.CLICK, this.click_btn1);
            this._btn2.addEventListener(MouseEvent.CLICK, this.click_btn2);
        }

        private function removeEvent():void
        {
            this._inputText.removeEventListener(Event.CHANGE, this._changeInput);
            removeEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
            this._btn1.removeEventListener(MouseEvent.CLICK, this.click_btn1);
            this._btn2.removeEventListener(MouseEvent.CLICK, this.click_btn2);
        }

        private function _changeInput(_arg_1:Event):void
        {
            if (int(this._inputText.text) == 0)
            {
                this._nowNum = 1;
            }
            else
            {
                if (int(this._inputText.text) > this._maxNum)
                {
                    this._nowNum = this._maxNum;
                }
                else
                {
                    this._nowNum = int(this._inputText.text);
                };
            };
            this.upSee();
        }

        private function click_btn1(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._nowNum = (this._nowNum + 1);
            this.upSee();
        }

        private function click_btn2(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._nowNum = (this._nowNum - 1);
            this.upSee();
        }

        private function _upbtView():void
        {
            this._btn1.enable = true;
            this._btn2.enable = true;
            if (this._nowNum == this._minNum)
            {
                this._btn2.enable = false;
            }
            else
            {
                if (this._nowNum == this._maxNum)
                {
                    this._btn1.enable = false;
                };
            };
        }

        private function onFrameResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.dispose();
                    dispatchEvent(new AuctionSellEvent(AuctionSellEvent.NOTSELL, this._nowNum));
                    return;
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    if (int(this._inputText.text) >= this._maxNum)
                    {
                        this._nowNum = this._maxNum;
                    }
                    else
                    {
                        if (int(this._inputText.text) == 0)
                        {
                            this._nowNum = 1;
                        };
                    };
                    dispatchEvent(new AuctionSellEvent(AuctionSellEvent.SELL, this._nowNum));
                    return;
            };
        }

        override public function dispose():void
        {
            super.dispose();
            this.removeEvent();
            this.removeView();
        }


    }
}//package auctionHouse.view

