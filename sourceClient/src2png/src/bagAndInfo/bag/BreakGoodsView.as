// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.bag.BreakGoodsView

package bagAndInfo.bag
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import bagAndInfo.cell.LockBagCell;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.ComponentEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.MessageTipManager;
    import com.pickgliss.utils.ObjectUtils;

    public class BreakGoodsView extends BaseAlerFrame 
    {

        private static const EnterKeyCode:int = 13;
        private static const ESCkeyCode:int = 27;

        private var _input:FilterFrameText;
        private var _NumString:FilterFrameText;
        private var _tipString:FilterFrameText;
        private var _inputBG:Scale9CornerImage;
        private var _cell:LockBagCell;
        private var _upBtn:SimpleBitmapButton;
        private var _downBtn:SimpleBitmapButton;

        public function BreakGoodsView()
        {
            submitButtonStyle = "core.simplebt";
            var _local_1:AlertInfo = new AlertInfo();
            _local_1.title = LanguageMgr.GetTranslation("tank.view.bagII.BreakGoodsView.split");
            info = _local_1;
            this._input = ComponentFactory.Instance.creatComponentByStylename("breakGoodsInput");
            this._input.text = "1";
            this._inputBG = ComponentFactory.Instance.creatComponentByStylename("breakInputbg");
            addToContent(this._inputBG);
            addToContent(this._input);
            this._NumString = ComponentFactory.Instance.creatComponentByStylename("breakGoodsNumText");
            this._NumString.text = LanguageMgr.GetTranslation("tank.view.bagII.BreakGoodsView.num");
            addToContent(this._NumString);
            this._tipString = ComponentFactory.Instance.creatComponentByStylename("breakGoodsPleasEnterText");
            this._tipString.text = LanguageMgr.GetTranslation("tank.view.bagII.BreakGoodsView.input");
            addToContent(this._tipString);
            submitButtonEnable = false;
            this._upBtn = ComponentFactory.Instance.creatComponentByStylename("breakUpButton");
            addToContent(this._upBtn);
            this._downBtn = ComponentFactory.Instance.creatComponentByStylename("breakDownButton");
            addToContent(this._downBtn);
            this.addEvent();
        }

        private function addEvent():void
        {
            this._input.addEventListener(Event.CHANGE, this.__input);
            this._input.addEventListener(KeyboardEvent.KEY_UP, this.__onInputKeyUp);
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            addEventListener(Event.ADDED_TO_STAGE, this.__onToStage);
            this._upBtn.addEventListener(MouseEvent.CLICK, this.__onUpBtn);
            this._downBtn.addEventListener(MouseEvent.CLICK, this.__onDownBtn);
        }

        private function __onUpBtn(_arg_1:Event):void
        {
            var _local_2:int = int(this._input.text);
            _local_2++;
            this._input.text = String(_local_2);
            this.downBtnEnable();
        }

        private function __onDownBtn(_arg_1:Event):void
        {
            var _local_2:int = int(this._input.text);
            if (_local_2 == 0)
            {
                return;
            };
            _local_2--;
            this._input.text = String(_local_2);
            this.downBtnEnable();
        }

        private function __onToStage(_arg_1:Event):void
        {
        }

        private function __onInputKeyUp(_arg_1:KeyboardEvent):void
        {
            switch (_arg_1.keyCode)
            {
                case EnterKeyCode:
                    this.okFun();
                    return;
                case ESCkeyCode:
                    this.dispose();
                    return;
            };
        }

        private function __getFocus(_arg_1:Event):void
        {
            this._input.setFocus();
        }

        private function removeEvent():void
        {
            if (this._input)
            {
                this._input.removeEventListener(Event.CHANGE, this.__input);
                this._input.removeEventListener(KeyboardEvent.KEY_UP, this.__onInputKeyUp);
            };
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            removeEventListener(Event.ADDED_TO_STAGE, this.__onToStage);
            removeEventListener(MouseEvent.CLICK, this.__onUpBtn);
            removeEventListener(MouseEvent.CLICK, this.__onDownBtn);
        }

        private function __input(_arg_1:Event):void
        {
            submitButtonEnable = (!(this._input.text == ""));
            this.downBtnEnable();
        }

        private function downBtnEnable():void
        {
            if ((((!(this._input.text)) || (this._input.text == "")) || (int(this._input.text) < 1)))
            {
                this._downBtn.enable = false;
            }
            else
            {
                this._downBtn.enable = true;
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function __okClickCall(_arg_1:ComponentEvent):void
        {
            this.okFun();
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.dispose();
                    return;
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    this.okFun();
                    return;
            };
        }

        private function getFocus():void
        {
            if (stage)
            {
                stage.focus = this._input;
            };
        }

        private function okFun():void
        {
            SoundManager.instance.play("008");
            var _local_1:int = int(this._input.text);
            if (((_local_1 > 0) && (_local_1 < this._cell.itemInfo.Count)))
            {
                this._cell.dragCountStart(_local_1);
                this.dispose();
            }
            else
            {
                if (_local_1 == 0)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.BreakGoodsView.wrong2"));
                    this._input.text = "";
                }
                else
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.BreakGoodsView.right"));
                    this._input.text = "";
                };
            };
        }

        override public function dispose():void
        {
            SoundManager.instance.play("008");
            this.removeEvent();
            ObjectUtils.disposeObject(this._inputBG);
            this._inputBG = null;
            ObjectUtils.disposeObject(this._input);
            this._input = null;
            ObjectUtils.disposeObject(this._NumString);
            this._NumString = null;
            ObjectUtils.disposeObject(this._tipString);
            this._tipString = null;
            this._cell = null;
            if (this._upBtn)
            {
                ObjectUtils.disposeObject(this._upBtn);
            };
            this._upBtn = null;
            if (this._downBtn)
            {
                ObjectUtils.disposeObject(this._downBtn);
            };
            this._downBtn = null;
            if (parent)
            {
                parent.removeChild(this);
            };
            super.dispose();
        }

        public function get cell():LockBagCell
        {
            return (this._cell);
        }

        public function set cell(_arg_1:LockBagCell):void
        {
            this._cell = _arg_1;
        }


    }
}//package bagAndInfo.bag

