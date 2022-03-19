// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.strength.StrengthSelectNumAlertFrame

package store.view.strength
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.vo.AlertInfo;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.Image;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import flash.ui.Keyboard;
    import ddt.manager.SoundManager;

    public class StrengthSelectNumAlertFrame extends BaseAlerFrame 
    {

        private var _alertInfo:AlertInfo;
        private var _txtExplain:Bitmap;
        private var _btn1:BaseButton;
        private var _btn2:BaseButton;
        private var _inputText:FilterFrameText;
        private var _inputBg:Image;
        private var _maxNum:int = 0;
        private var _minNum:int = 1;
        private var _nowNum:int = 1;
        private var _sellFunction:Function;
        private var _notSellFunction:Function;
        public var index:int;
        private var _goodsinfo:InventoryItemInfo;

        public function StrengthSelectNumAlertFrame()
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
            cancelButtonStyle = "core.simplebt";
            submitButtonStyle = "core.simplebt";
            this._alertInfo = new AlertInfo(LanguageMgr.GetTranslation("store.strength.autoSplit.inputNumber"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"));
            this._alertInfo.moveEnable = false;
            info = this._alertInfo;
            this.escEnable = true;
            this._btn1 = ComponentFactory.Instance.creat("ddtstore.SellLeftAlerBt1");
            this._btn2 = ComponentFactory.Instance.creat("ddtstore.SellLeftAlerBt2");
            this._txtExplain = ComponentFactory.Instance.creatBitmap("asset.ddtstore.strengthNumTxt");
            PositionUtils.setPos(this._txtExplain, "asset.ddtstore.strengthNumTxtPos");
            this._inputBg = ComponentFactory.Instance.creat("ddtstore.SellLeftAlerInputTextBG");
            this._inputText = ComponentFactory.Instance.creat("ddtstore.SellLeftAlerInputText");
            this._inputText.restrict = "0-9";
            addToContent(this._txtExplain);
            addToContent(this._inputBg);
            addToContent(this._btn1);
            addToContent(this._btn2);
            addToContent(this._inputText);
        }

        public function addExeFunction(_arg_1:Function, _arg_2:Function):void
        {
            this._sellFunction = _arg_1;
            this._notSellFunction = _arg_2;
        }

        public function show(_arg_1:int=5, _arg_2:int=1):void
        {
            this._maxNum = _arg_1;
            this._minNum = _arg_2;
            this._nowNum = this._maxNum;
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        public function upSee():void
        {
            this._inputText.text = this._nowNum.toString();
            this._upbtView();
        }

        private function removeView():void
        {
            if (this._alertInfo)
            {
                this._alertInfo = null;
            };
            if (this._txtExplain)
            {
                ObjectUtils.disposeObject(this._txtExplain);
            };
            this._txtExplain = null;
            if (this._inputBg)
            {
                ObjectUtils.disposeObject(this._inputBg);
            };
            this._inputBg = null;
            if (this._btn1)
            {
                ObjectUtils.disposeObject(this._btn1);
            };
            this._btn1 = null;
            if (this._btn2)
            {
                ObjectUtils.disposeObject(this._btn2);
            };
            this._btn2 = null;
            if (this._inputText)
            {
                ObjectUtils.disposeObject(this._inputText);
            };
            this._inputText = null;
        }

        private function setEvent():void
        {
            addEventListener(Event.ADDED_TO_STAGE, this.__addToStageHandler);
            this._inputText.addEventListener(Event.CHANGE, this._changeInput);
            this._inputText.addEventListener(KeyboardEvent.KEY_DOWN, this.__enterHanlder);
            addEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
            this._btn1.addEventListener(MouseEvent.CLICK, this.click_btn1);
            this._btn2.addEventListener(MouseEvent.CLICK, this.click_btn2);
        }

        private function removeEvent():void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.__addToStageHandler);
            if (this._inputText)
            {
                this._inputText.removeEventListener(Event.CHANGE, this._changeInput);
            };
            if (this._inputText)
            {
                this._inputText.removeEventListener(KeyboardEvent.KEY_DOWN, this.__enterHanlder);
            };
            removeEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
            if (this._btn1)
            {
                this._btn1.removeEventListener(MouseEvent.CLICK, this.click_btn1);
            };
            if (this._btn2)
            {
                this._btn2.removeEventListener(MouseEvent.CLICK, this.click_btn2);
            };
        }

        private function __addToStageHandler(_arg_1:Event):void
        {
            this._inputText.appendText(this._nowNum.toString());
            this._inputText.setFocus();
            this._upbtView();
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

        private function __enterHanlder(_arg_1:KeyboardEvent):void
        {
            _arg_1.stopImmediatePropagation();
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                this.__confirm();
            };
            if (_arg_1.keyCode == Keyboard.ESCAPE)
            {
                SoundManager.instance.play("008");
                this.dispose();
            };
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
                    if (this._notSellFunction != null)
                    {
                        this._notSellFunction.call(this);
                    };
                    this.dispose();
                    return;
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    this.__confirm();
                    return;
            };
        }

        private function __confirm():void
        {
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
            if (this._sellFunction != null)
            {
                this._sellFunction.call(this, this._nowNum, this.goodsinfo, this.index);
            };
        }

        public function get goodsinfo():InventoryItemInfo
        {
            return (this._goodsinfo);
        }

        public function set goodsinfo(_arg_1:InventoryItemInfo):void
        {
            this._goodsinfo = _arg_1;
        }

        override public function dispose():void
        {
            super.dispose();
            this.removeEvent();
            this.removeView();
            if (this._sellFunction != null)
            {
                this._sellFunction = null;
            };
            if (this._notSellFunction != null)
            {
                this._notSellFunction = null;
            };
            if (this.parent)
            {
                removeChild(this);
            };
        }


    }
}//package store.view.strength

