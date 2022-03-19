// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.SelectStateButton

package ddt.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class SelectStateButton extends Sprite implements Disposeable 
    {

        private var _bg:DisplayObject;
        private var _overBg:DisplayObject;
        private var _gray:Boolean;
        private var _enable:Boolean;
        private var _selected:Boolean;

        public function SelectStateButton()
        {
            this.initEvents();
        }

        private function initEvents():void
        {
            addEventListener(MouseEvent.MOUSE_OVER, this.__overHandler);
            addEventListener(MouseEvent.MOUSE_OUT, this.__outHander);
            addEventListener(MouseEvent.CLICK, this.__clickHander);
        }

        private function removeEvents():void
        {
            removeEventListener(MouseEvent.MOUSE_OVER, this.__overHandler);
            removeEventListener(MouseEvent.MOUSE_OUT, this.__outHander);
            removeEventListener(MouseEvent.CLICK, this.__clickHander);
        }

        private function __outHander(_arg_1:MouseEvent):void
        {
            if (this.enable)
            {
                this._bg.visible = (!(this.selected));
                this._overBg.visible = this.selected;
            };
        }

        private function __overHandler(_arg_1:MouseEvent):void
        {
            if (this.enable)
            {
                this._bg.visible = false;
                this._overBg.visible = true;
            };
        }

        private function __clickHander(_arg_1:MouseEvent):void
        {
            if ((!(this._enable)))
            {
                _arg_1.stopImmediatePropagation();
            };
        }

        public function get selected():Boolean
        {
            return (this._selected);
        }

        public function set selected(_arg_1:Boolean):void
        {
            this._selected = _arg_1;
            this._bg.visible = (!(this._selected));
            this._overBg.visible = this._selected;
        }

        public function get enable():Boolean
        {
            return (this._enable);
        }

        public function set enable(_arg_1:Boolean):void
        {
            this._enable = _arg_1;
        }

        public function get gray():Boolean
        {
            return (this._gray);
        }

        public function set gray(_arg_1:Boolean):void
        {
            this._gray = _arg_1;
            if (this._gray)
            {
                filters = ComponentFactory.Instance.creatFilters("grayFilter");
            }
            else
            {
                filters = null;
            };
        }

        public function set backGround(_arg_1:DisplayObject):void
        {
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
                this._bg = null;
            };
            this._bg = _arg_1;
            if (this._bg)
            {
                addChild(this._bg);
            };
        }

        public function set overBackGround(_arg_1:DisplayObject):void
        {
            if (this._overBg)
            {
                ObjectUtils.disposeObject(this._overBg);
                this._overBg = null;
            };
            this._overBg = _arg_1;
            if (this._overBg)
            {
                addChild(this._overBg);
            };
        }

        public function dispose():void
        {
        }


    }
}//package ddt.view

