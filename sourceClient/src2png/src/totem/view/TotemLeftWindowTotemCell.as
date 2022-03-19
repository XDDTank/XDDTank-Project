// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//totem.view.TotemLeftWindowTotemCell

package totem.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.MovieClip;
    import com.pickgliss.utils.ClassUtils;
    import ddt.utils.PositionUtils;
    import com.pickgliss.utils.ObjectUtils;
    import totem.TotemManager;
    import flash.events.Event;

    public class TotemLeftWindowTotemCell extends Sprite implements Disposeable 
    {

        public static const OPEN_TOTEM_FAIL:String = "openTotemFail";

        public var level:int;
        public var index:int;
        private var _isCurCanClick:Boolean;
        private var _isHasLighted:Boolean;
        private var _totemBtn:MovieClip;
        private var _totemFailMC:MovieClip;

        public function TotemLeftWindowTotemCell(_arg_1:int=1)
        {
            this.mouseEnabled = false;
            this._totemBtn = ClassUtils.CreatInstance(("asset.totem.totemBtn" + _arg_1));
            addChild(this._totemBtn);
        }

        public function set isCurCanClick(_arg_1:Boolean):void
        {
            this._isCurCanClick = _arg_1;
            if (_arg_1)
            {
                this._totemBtn.gotoAndStop(1);
                this._totemBtn.canClickMC.canClickMC2.canClickMC21.buttonMode = true;
            }
            else
            {
                this._totemBtn.gotoAndStop(3);
            };
        }

        public function get isCurCanClick():Boolean
        {
            return (this._isCurCanClick);
        }

        public function set isHasLighted(_arg_1:Boolean):void
        {
            this._isHasLighted = _arg_1;
            if (_arg_1)
            {
                this._totemBtn.gotoAndStop(4);
            }
            else
            {
                if (this._isCurCanClick)
                {
                    this._totemBtn.gotoAndStop(1);
                }
                else
                {
                    this._totemBtn.gotoAndStop(3);
                };
            };
        }

        public function doLightTotem():void
        {
            this._totemBtn.gotoAndStop(2);
        }

        public function get isHasLighted():Boolean
        {
            return (this._isHasLighted);
        }

        public function showOpenFail():void
        {
            this._totemFailMC = ClassUtils.CreatInstance("asset.totem.failOpen.pointBomb");
            PositionUtils.setPos(this._totemFailMC, "totem.openFailMcPos");
            addChild(this._totemFailMC);
            this._totemFailMC.play();
            this._totemFailMC.addEventListener(OPEN_TOTEM_FAIL, this.__onOpenFail);
        }

        private function __onOpenFail(_arg_1:Event):void
        {
            this._totemFailMC.stop();
            ObjectUtils.disposeObject(this._totemFailMC);
            this._totemFailMC = null;
            TotemManager.instance.dispatchEvent(new Event(OPEN_TOTEM_FAIL));
        }

        public function dispose():void
        {
            if (this._totemFailMC)
            {
                this._totemFailMC.stop();
                this._totemFailMC.removeEventListener(OPEN_TOTEM_FAIL, this.__onOpenFail);
            };
            ObjectUtils.disposeAllChildren(this);
            this._totemBtn = null;
            this._totemFailMC = null;
        }


    }
}//package totem.view

