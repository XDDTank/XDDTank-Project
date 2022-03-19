// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.prop.CustomPropCell

package game.view.prop
{
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.ShowTipManager;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
    import ddt.events.FightPropEevnt;
    import com.pickgliss.toplevel.StageReferance;
    import ddt.data.PropInfo;
    import com.pickgliss.utils.ObjectUtils;
    import game.view.control.FightControlBar;

    public class CustomPropCell extends PropCell 
    {

        private var _deleteBtn:SimpleBitmapButton;
        private var _type:int;

        public function CustomPropCell(_arg_1:String, _arg_2:int, _arg_3:int)
        {
            super(_arg_1, _arg_2);
            this._type = _arg_3;
            mouseChildren = false;
            if (this._type)
            {
                _tipInfo.valueType = null;
            };
        }

        override protected function configUI():void
        {
            super.configUI();
            this._deleteBtn = ComponentFactory.Instance.creatComponentByStylename("asset.game.deletePropBtn");
        }

        override protected function drawLayer():void
        {
        }

        override protected function __mouseOut(_arg_1:MouseEvent):void
        {
            if (this._deleteBtn.parent)
            {
                removeChild(this._deleteBtn);
            };
            x = _x;
            y = _y;
            scaleX = (scaleY = 1);
            _shortcutKeyShape.scaleX = (_shortcutKeyShape.scaleY = 1);
            if (_tweenMax)
            {
                _tweenMax.pause();
            };
            filters = null;
            ShowTipManager.Instance.hideTip(this);
        }

        override protected function __mouseOver(_arg_1:MouseEvent):void
        {
            if (_info)
            {
                addChild(this._deleteBtn);
            };
            super.__mouseOver(_arg_1);
        }

        override protected function addEvent():void
        {
            super.addEvent();
            addEventListener(MouseEvent.CLICK, this.__clicked);
        }

        private function __deleteClick(_arg_1:MouseEvent):void
        {
        }

        private function deleteContainMouse():Boolean
        {
            var _local_1:Rectangle = this._deleteBtn.getBounds(this);
            return (_local_1.contains(mouseX, mouseY));
        }

        private function deleteProp():void
        {
            dispatchEvent(new FightPropEevnt(FightPropEevnt.DELETEPROP));
        }

        private function __clicked(_arg_1:MouseEvent):void
        {
            StageReferance.stage.focus = null;
            if (((this._deleteBtn.parent) && (this.deleteContainMouse())))
            {
                this.deleteProp();
            }
            else
            {
                this.useProp();
            };
        }

        override public function set enabled(_arg_1:Boolean):void
        {
            if (_enabled != _arg_1)
            {
                _enabled = _arg_1;
                if ((!(_enabled)))
                {
                    if (_asset)
                    {
                        _asset.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                    };
                }
                else
                {
                    if (_asset)
                    {
                        _asset.filters = null;
                    };
                };
            };
        }

        override public function useProp():void
        {
            if (((!(_info == null)) && (!(isUsed))))
            {
                isUsed = true;
                dispatchEvent(new FightPropEevnt(FightPropEevnt.USEPROP));
            };
        }

        override protected function removeEvent():void
        {
            super.removeEvent();
            removeEventListener(MouseEvent.CLICK, this.__clicked);
        }

        override public function set info(_arg_1:PropInfo):void
        {
            super.info = _arg_1;
            isUsed = false;
            if (_info == null)
            {
                this.__mouseOut(null);
            };
        }

        override public function setPossiton(_arg_1:int, _arg_2:int):void
        {
            super.setPossiton(_arg_1, _arg_2);
            this.x = _x;
            this.y = _y;
        }

        override public function dispose():void
        {
            if (this._deleteBtn)
            {
                ObjectUtils.disposeObject(this._deleteBtn);
                this._deleteBtn = null;
            };
            super.dispose();
        }

        override public function get tipDirctions():String
        {
            if (this._type != FightControlBar.LIVE)
            {
                return ("4,5,7,1,6,2");
            };
            return (super.tipDirctions);
        }


    }
}//package game.view.prop

