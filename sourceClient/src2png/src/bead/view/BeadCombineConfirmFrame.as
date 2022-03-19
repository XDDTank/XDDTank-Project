﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bead.view.BeadCombineConfirmFrame

package bead.view
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import flash.ui.Keyboard;
    import flash.events.KeyboardEvent;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import bead.BeadManager;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.LayerManager;

    public class BeadCombineConfirmFrame extends Frame 
    {

        private var _confirmBtn:TextButton;
        private var _cancelBtn:TextButton;
        private var _tip:FilterFrameText;
        private var _isYes:Boolean = false;
        private var _place:int = -1;

        public function BeadCombineConfirmFrame()
        {
            this.initView();
            this.initEvent();
        }

        public function get place():int
        {
            return (this._place);
        }

        public function get isYes():Boolean
        {
            return (this._isYes);
        }

        private function initView():void
        {
            titleText = LanguageMgr.GetTranslation("AlertDialog.Info");
            this._confirmBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.combineConfirm.confirmBtn");
            this._confirmBtn.text = LanguageMgr.GetTranslation("ok");
            this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.combineConfirm.cancelBtn");
            this._cancelBtn.text = LanguageMgr.GetTranslation("cancel");
            this._tip = ComponentFactory.Instance.creatComponentByStylename("beadSystem.combineConfirm.tipTxt");
            addToContent(this._confirmBtn);
            addToContent(this._cancelBtn);
            addToContent(this._tip);
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this._response);
            this._confirmBtn.addEventListener(MouseEvent.CLICK, this.confirmHandler, false, 0, true);
            this._cancelBtn.addEventListener(MouseEvent.CLICK, this.cancelHandler, false, 0, true);
        }

        private function keyDownHandler(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                this.confirmHandler(null);
            };
        }

        private function confirmHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._isYes = true;
            this.closeThis();
        }

        private function cancelHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.closeThis();
        }

        private function _response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                this.closeThis();
            };
        }

        private function closeThis():void
        {
            this.dispatchEvent(new Event(BeadManager.BEAD_COMBINE_CONFIRM_RETURN_EVENT));
            ObjectUtils.disposeObject(this);
        }

        public function show(_arg_1:String, _arg_2:int):void
        {
            this._place = _arg_2;
            this._tip.htmlText = _arg_1;
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this._response);
            this._confirmBtn.removeEventListener(MouseEvent.CLICK, this.confirmHandler);
            this._cancelBtn.removeEventListener(MouseEvent.CLICK, this.cancelHandler);
        }

        override public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._confirmBtn);
            this._confirmBtn = null;
            ObjectUtils.disposeObject(this._cancelBtn);
            this._cancelBtn = null;
            ObjectUtils.disposeObject(this._tip);
            this._tip = null;
            super.dispose();
        }


    }
}//package bead.view
