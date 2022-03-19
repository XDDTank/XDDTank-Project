// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.core.SpriteLayer

package com.pickgliss.ui.core
{
    import flash.display.Sprite;
    import __AS3__.vec.Vector;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.LayerManager;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.display.InteractiveObject;
    import com.pickgliss.utils.DisplayUtils;
    import com.pickgliss.toplevel.StageReferance;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.ComponentSetting;
    import __AS3__.vec.*;

    public class SpriteLayer extends Sprite 
    {

        private var _blackGoundList:Vector.<DisplayObject>;
        private var _alphaGoundList:Vector.<DisplayObject>;
        private var _blackGound:Sprite;
        private var _alphaGound:Sprite;
        private var _autoClickTotop:Boolean;

        public function SpriteLayer(_arg_1:Boolean=false)
        {
            this.init();
            super();
            mouseEnabled = _arg_1;
        }

        private function init():void
        {
            this._blackGoundList = new Vector.<DisplayObject>();
            this._alphaGoundList = new Vector.<DisplayObject>();
        }

        public function addTolayer(_arg_1:DisplayObject, _arg_2:int, _arg_3:Boolean):void
        {
            if (_arg_2 == LayerManager.BLCAK_BLOCKGOUND)
            {
                if (this._blackGoundList.indexOf(_arg_1) != -1)
                {
                    this._blackGoundList.splice(this._blackGoundList.indexOf(_arg_1), 1);
                };
                this._blackGoundList.push(_arg_1);
            }
            else
            {
                if (_arg_2 == LayerManager.ALPHA_BLOCKGOUND)
                {
                    if (this._alphaGoundList.indexOf(_arg_1) != -1)
                    {
                        this._alphaGoundList.splice(this._alphaGoundList.indexOf(_arg_1), 1);
                    };
                    this._alphaGoundList.push(_arg_1);
                };
            };
            _arg_1.addEventListener(Event.REMOVED_FROM_STAGE, this.__onChildRemoveFromStage);
            if (_arg_3)
            {
                _arg_1.addEventListener(Event.REMOVED_FROM_STAGE, this.__onFocusChange);
            };
            if (this._autoClickTotop)
            {
                _arg_1.addEventListener(MouseEvent.MOUSE_DOWN, this.__onClickToTop);
            };
            addChild(_arg_1);
            this.arrangeBlockGound();
            if (_arg_3)
            {
                this.focusTopLayerDisplay();
            };
        }

        private function __onClickToTop(_arg_1:MouseEvent):void
        {
            var _local_2:DisplayObject = (_arg_1.currentTarget as DisplayObject);
            addChild(_local_2);
            this.focusTopLayerDisplay();
        }

        private function __onFocusChange(_arg_1:Event):void
        {
            var _local_2:DisplayObject = (_arg_1.currentTarget as DisplayObject);
            _local_2.removeEventListener(Event.REMOVED_FROM_STAGE, this.__onFocusChange);
            this.focusTopLayerDisplay(_local_2);
        }

        private function __onChildRemoveFromStage(_arg_1:Event):void
        {
            var _local_2:DisplayObject = (_arg_1.currentTarget as DisplayObject);
            _local_2.removeEventListener(Event.REMOVED_FROM_STAGE, this.__onChildRemoveFromStage);
            _local_2.removeEventListener(MouseEvent.MOUSE_DOWN, this.__onClickToTop);
            if (this._blackGoundList.indexOf(_local_2) != -1)
            {
                this._blackGoundList.splice(this._blackGoundList.indexOf(_local_2), 1);
            };
            if (this._alphaGoundList.indexOf(_local_2) != -1)
            {
                this._alphaGoundList.splice(this._alphaGoundList.indexOf(_local_2), 1);
            };
            this.arrangeBlockGound();
        }

        private function arrangeBlockGound():void
        {
            var _local_1:DisplayObject;
            var _local_2:int;
            if (this.blackGound.parent)
            {
                this.blackGound.parent.removeChild(this.blackGound);
            };
            if (this.alphaGound.parent)
            {
                this.alphaGound.parent.removeChild(this.alphaGound);
            };
            if (this._blackGoundList.length > 0)
            {
                _local_1 = this._blackGoundList[(this._blackGoundList.length - 1)];
                _local_2 = getChildIndex(_local_1);
                addChildAt(this.blackGound, _local_2);
            };
            if (this._alphaGoundList.length > 0)
            {
                _local_1 = this._alphaGoundList[(this._alphaGoundList.length - 1)];
                _local_2 = getChildIndex(_local_1);
                addChildAt(this.alphaGound, _local_2);
            };
        }

        private function focusTopLayerDisplay(_arg_1:DisplayObject=null):void
        {
            var _local_2:InteractiveObject;
            var _local_4:DisplayObject;
            var _local_3:int;
            while (_local_3 < numChildren)
            {
                _local_4 = getChildAt(_local_3);
                if (_local_4 != _arg_1)
                {
                    _local_2 = (_local_4 as InteractiveObject);
                };
                _local_3++;
            };
            if ((!(DisplayUtils.isTargetOrContain(StageReferance.stage.focus, _local_2))))
            {
                StageReferance.stage.focus = _local_2;
            };
        }

        public function get backGroundInParent():Boolean
        {
            if (((this._blackGoundList.length > 0) || (this._alphaGoundList.length > 0)))
            {
                return (true);
            };
            return (false);
        }

        private function get blackGound():Sprite
        {
            if (this._blackGound == null)
            {
                this._blackGound = new Sprite();
                this._blackGound.graphics.beginFill(0, 0.4);
                this._blackGound.graphics.drawRect(-500, -200, 2000, 1000);
                this._blackGound.graphics.endFill();
                this._blackGound.addEventListener(MouseEvent.MOUSE_DOWN, this.__onBlackGoundMouseDown);
            };
            return (this._blackGound);
        }

        private function __onBlackGoundMouseDown(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            StageReferance.stage.focus = (this._blackGoundList[(this._blackGoundList.length - 1)] as InteractiveObject);
        }

        private function get alphaGound():Sprite
        {
            if (this._alphaGound == null)
            {
                this._alphaGound = new Sprite();
                this._alphaGound.graphics.beginFill(0, 0.001);
                this._alphaGound.graphics.drawRect(-500, -200, 2000, 1000);
                this._alphaGound.graphics.endFill();
                this._alphaGound.addEventListener(MouseEvent.MOUSE_DOWN, this.__onAlphaGoundDownClicked);
                this._alphaGound.addEventListener(MouseEvent.MOUSE_UP, this.__onAlphaGoundUpClicked);
            };
            return (this._alphaGound);
        }

        private function __onAlphaGoundDownClicked(_arg_1:MouseEvent):void
        {
            var _local_2:DisplayObject;
            _local_2 = this._alphaGoundList[(this._alphaGoundList.length - 1)];
            _local_2.filters = ComponentFactory.Instance.creatFilters(ComponentSetting.ALPHA_LAYER_FILTER);
            StageReferance.stage.focus = (_local_2 as InteractiveObject);
        }

        private function __onAlphaGoundUpClicked(_arg_1:MouseEvent):void
        {
            var _local_2:DisplayObject = this._alphaGoundList[(this._alphaGoundList.length - 1)];
            _local_2.filters = null;
        }

        public function set autoClickTotop(_arg_1:Boolean):void
        {
            if (this._autoClickTotop == _arg_1)
            {
                return;
            };
            this._autoClickTotop = _arg_1;
        }


    }
}//package com.pickgliss.ui.core

