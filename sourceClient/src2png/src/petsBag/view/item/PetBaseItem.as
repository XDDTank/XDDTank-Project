// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.item.PetBaseItem

package petsBag.view.item
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.core.ITipedDisplay;
    import ddt.interfaces.IDragable;
    import pet.date.PetInfo;
    import com.pickgliss.utils.DoubleClickManager;
    import com.pickgliss.events.InteractiveEvent;
    import petsBag.event.PetItemEvent;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.ShowTipManager;
    import ddt.manager.SoundManager;
    import bagAndInfo.cell.DragEffect;
    import ddt.manager.DragManager;
    import com.pickgliss.toplevel.StageReferance;

    public class PetBaseItem extends Sprite implements Disposeable, ITipedDisplay, IDragable 
    {

        protected var _info:PetInfo;
        protected var _lastInfo:PetInfo;
        public var id:int;
        private var _locked:Boolean;
        private var _isSelected:Boolean;
        protected var _canDrag:Boolean = true;
        protected var _showState:Boolean;
        protected var _showTip:Boolean;
        protected var _tipData:Object;
        protected var _tipDirction:String;
        protected var _tipGapV:int;
        protected var _tipGapH:int;
        protected var _tipStyle:String;

        public function PetBaseItem()
        {
            this.initView();
            this.initEvent();
            DoubleClickManager.Instance.enableDoubleClick(this);
        }

        protected function initView():void
        {
        }

        public function get canDrag():Boolean
        {
            return (this._canDrag);
        }

        public function set canDrag(_arg_1:Boolean):void
        {
            this._canDrag = _arg_1;
        }

        protected function initEvent():void
        {
            addEventListener(InteractiveEvent.MOUSE_DOWN, this.__onMouseDown);
            addEventListener(InteractiveEvent.CLICK, this.__onClick);
            addEventListener(InteractiveEvent.DOUBLE_CLICK, this.__onDoubleClick);
        }

        protected function removeEvent():void
        {
            removeEventListener(InteractiveEvent.MOUSE_DOWN, this.__onMouseDown);
            removeEventListener(InteractiveEvent.CLICK, this.__onClick);
            removeEventListener(InteractiveEvent.DOUBLE_CLICK, this.__onDoubleClick);
        }

        protected function __onMouseDown(_arg_1:InteractiveEvent):void
        {
            dispatchEvent(new PetItemEvent(PetItemEvent.MOUSE_DOWN, this, true, false, true));
        }

        protected function __onClick(_arg_1:InteractiveEvent):void
        {
            dispatchEvent(new PetItemEvent(PetItemEvent.ITEM_CLICK, this, true, false, true));
        }

        protected function __onDoubleClick(_arg_1:InteractiveEvent):void
        {
            dispatchEvent(new PetItemEvent(PetItemEvent.DOUBLE_CLICK, this, true, false, true));
        }

        protected function createDragImg():DisplayObject
        {
            return (null);
        }

        public function dispose():void
        {
            DoubleClickManager.Instance.disableDoubleClick(this);
            this.removeEvent();
            this._tipData = null;
            this._info = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function get tipData():Object
        {
            return (this._tipData);
        }

        public function set tipData(_arg_1:Object):void
        {
            if (this._tipData == _arg_1)
            {
                return;
            };
            this._tipData = _arg_1;
        }

        public function get tipDirctions():String
        {
            return (this._tipDirction);
        }

        public function set tipDirctions(_arg_1:String):void
        {
            if (this._tipDirction == _arg_1)
            {
                return;
            };
            this._tipDirction = _arg_1;
        }

        public function get tipGapV():int
        {
            return (this._tipGapV);
        }

        public function set tipGapV(_arg_1:int):void
        {
            if (this._tipGapV == _arg_1)
            {
                return;
            };
            this._tipGapV = _arg_1;
        }

        public function get tipGapH():int
        {
            return (this._tipGapH);
        }

        public function set tipGapH(_arg_1:int):void
        {
            if (this._tipGapH == _arg_1)
            {
                return;
            };
            this._tipGapH = _arg_1;
        }

        public function get tipStyle():String
        {
            return (this._tipStyle);
        }

        public function set tipStyle(_arg_1:String):void
        {
            if (this._tipStyle == _arg_1)
            {
                return;
            };
            this._tipStyle = _arg_1;
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function get info():PetInfo
        {
            return (this._info);
        }

        public function set info(_arg_1:PetInfo):void
        {
            this._lastInfo = this._info;
            this._info = _arg_1;
            ShowTipManager.Instance.removeTip(this);
            if (this._info)
            {
                if (this.showTip)
                {
                    ShowTipManager.Instance.addTip(this);
                };
            };
        }

        public function get locked():Boolean
        {
            return (this._locked);
        }

        public function set locked(_arg_1:Boolean):void
        {
            this._locked = _arg_1;
        }

        public function get isSelected():Boolean
        {
            return (this._isSelected);
        }

        public function set isSelected(_arg_1:Boolean):void
        {
            this._isSelected = ((_arg_1) && (this._info));
        }

        public function get showState():Boolean
        {
            return (this._showState);
        }

        public function set showState(_arg_1:Boolean):void
        {
            this._showState = _arg_1;
        }

        public function dragStop(_arg_1:DragEffect):void
        {
            SoundManager.instance.play("008");
            this.locked = false;
            dispatchEvent(new PetItemEvent(PetItemEvent.DRAGSTOP, this, true));
        }

        public function getSource():IDragable
        {
            return (this);
        }

        public function dragStart():void
        {
            if ((!(this.canDrag)))
            {
                return;
            };
            if (DragManager.startDrag(this, this._info, this.createDragImg(), StageReferance.stage.mouseX, StageReferance.stage.mouseY, "move", true, true, false, false, true))
            {
                this.locked = true;
            };
        }

        public function get showTip():Boolean
        {
            return (this._showTip);
        }

        public function set showTip(_arg_1:Boolean):void
        {
            this._showTip = _arg_1;
            ShowTipManager.Instance.removeTip(this);
            if (this.showTip)
            {
                ShowTipManager.Instance.addTip(this);
            };
        }


    }
}//package petsBag.view.item

