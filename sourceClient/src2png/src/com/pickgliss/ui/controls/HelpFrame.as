// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.HelpFrame

package com.pickgliss.ui.controls
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.LayerManager;
    import flash.events.MouseEvent;
    import com.pickgliss.events.FrameEvent;

    public class HelpFrame extends Frame 
    {

        private var _bg:DisplayObject;
        private var _view:Sprite;
        protected var _submitButton:TextButton;
        protected var _submitstyle:String;
        protected var _submitText:String;

        public function HelpFrame()
        {
            super.init();
            escEnable = true;
            this.addEvent();
            this._bg = ComponentFactory.Instance.creat("frame.helpFrame.FrameBg");
            addToContent(this._bg);
            this._view = new Sprite();
            addToContent(this._view);
        }

        public function setView(_arg_1:DisplayObject):void
        {
            var _local_2:Point = ComponentFactory.Instance.creatCustomObject("helpFrame.helpPos");
            ObjectUtils.disposeAllChildren(this._view);
            if (_local_2)
            {
                this._view.x = _local_2.x;
                this._view.y = _local_2.y;
            };
            this._view.addChild(_arg_1);
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        override protected function addChildren():void
        {
            var _local_1:Point;
            super.addChildren();
            if (this._submitButton)
            {
                _local_1 = ComponentFactory.Instance.creatCustomObject("helpFrame.submitBtnPos");
                this._submitButton.x = _local_1.x;
                this._submitButton.y = _local_1.y;
                this._submitButton.addEventListener(MouseEvent.CLICK, this.__onClick);
                addChild(this._submitButton);
            };
        }

        private function addEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.___response);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.___response);
            if (this._submitButton)
            {
                this._submitButton.removeEventListener(MouseEvent.CLICK, this.__onClick);
            };
        }

        private function __onClick(_arg_1:MouseEvent):void
        {
            onResponse(FrameEvent.HELP_CLOSE);
        }

        protected function ___response(_arg_1:FrameEvent):void
        {
            this.dispose();
        }

        override public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._submitButton);
            this._submitButton = null;
            ObjectUtils.disposeAllChildren(this._view);
            ObjectUtils.disposeObject(this._view);
            this._view = null;
            super.dispose();
        }

        public function get submitButton():TextButton
        {
            return (this._submitButton);
        }

        public function set submitButton(_arg_1:TextButton):void
        {
            if (this._submitButton == _arg_1)
            {
                return;
            };
            if (this._submitButton)
            {
                this._submitButton.removeEventListener(MouseEvent.CLICK, this.__onClick);
                ObjectUtils.disposeObject(this._submitButton);
            };
            this._submitButton = _arg_1;
        }

        public function get submitstyle():String
        {
            return (this._submitstyle);
        }

        public function set submitstyle(_arg_1:String):void
        {
            if (this._submitstyle == _arg_1)
            {
                return;
            };
            this._submitstyle = _arg_1;
            this.submitButton = ComponentFactory.Instance.creat(this._submitstyle);
        }

        public function get submitText():String
        {
            return (this._submitText);
        }

        public function set submitText(_arg_1:String):void
        {
            this._submitText = _arg_1;
            if (this._submitButton)
            {
                this._submitButton.text = this._submitText;
            };
        }


    }
}//package com.pickgliss.ui.controls

