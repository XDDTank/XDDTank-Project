// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.StageFocusManager

package ddt.manager
{
    import flash.display.Stage;
    import flash.display.Sprite;
    import flash.display.InteractiveObject;
    import com.pickgliss.toplevel.StageReferance;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import com.pickgliss.ui.ShowTipManager;
    import flash.events.MouseEvent;

    public class StageFocusManager 
    {

        private static var instance:StageFocusManager;

        private var _count:int;
        private var _stage:Stage;
        private var _view:Sprite;
        private var _currentActiveObject:InteractiveObject;


        public static function getInstance():StageFocusManager
        {
            if (instance == null)
            {
                instance = new (StageFocusManager)();
            };
            return (instance);
        }


        public function setup(_arg_1:Stage):void
        {
            this._stage = _arg_1;
            this._view = new Sprite();
            this._view.graphics.beginFill(0, 0.75);
            this._view.graphics.drawRect(0, 0, StageReferance.stageWidth, StageReferance.stageHeight);
            this._view.graphics.endFill();
            this._view.buttonMode = true;
            this._view.addChild(ComponentFactory.Instance.creatCustomObject("tip.StageFocus"));
            this.addEvent();
        }

        public function removeEvent():void
        {
            this._stage.removeEventListener(Event.DEACTIVATE, this.__deactivateHandler);
            this._stage.removeEventListener(Event.ACTIVATE, this.__activateHandler);
        }

        public function addEvent():void
        {
            this._stage.addEventListener(Event.DEACTIVATE, this.__deactivateHandler);
            this._stage.addEventListener(Event.ACTIVATE, this.__activateHandler);
        }

        private function __deactivateHandler(_arg_1:Event):void
        {
            this._stage.addChild(this._view);
            this.fadein();
            ShowTipManager.Instance.removeAllTip();
        }

        private function __activateHandler(_arg_1:Event):void
        {
            this.stopFade();
            if (((this._view.stage) && (this._currentActiveObject)))
            {
                this._view.stage.focus = this._currentActiveObject;
            };
            if (this._view.parent)
            {
                this._view.parent.removeChild(this._view);
            };
        }

        private function __enterFrameHandler(_arg_1:Event):void
        {
            this._count++;
            if (this._count >= 2)
            {
                this._view.removeEventListener(Event.ENTER_FRAME, this.__enterFrameHandler);
                if (this._view.parent)
                {
                    this._view.parent.removeChild(this._view);
                };
                this._count = 0;
            };
        }

        private function __onClickHandler(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            _arg_1.stopPropagation();
        }

        public function setActiveFocus(_arg_1:InteractiveObject):void
        {
            this._currentActiveObject = _arg_1;
        }

        private function fadein():void
        {
            this._view.alpha = 0;
            this._view.addEventListener(Event.ENTER_FRAME, this.__onFadein);
        }

        private function stopFade():void
        {
            this._view.alpha = 1;
            this._view.removeEventListener(Event.ENTER_FRAME, this.__onFadein);
        }

        private function __onFadein(_arg_1:Event):void
        {
            if (this._view.alpha < 0.95)
            {
                this._view.alpha = (this._view.alpha + 0.05);
            }
            else
            {
                this._view.alpha = 1;
                this._view.removeEventListener(Event.ENTER_FRAME, this.__onFadein);
            };
        }


    }
}//package ddt.manager

