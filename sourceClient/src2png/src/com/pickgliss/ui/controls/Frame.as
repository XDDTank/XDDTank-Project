﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.Frame

package com.pickgliss.ui.controls
{
    import com.pickgliss.ui.core.Component;
    import flash.display.DisplayObject;
    import com.pickgliss.geom.InnerRectangle;
    import flash.display.Sprite;
    import flash.text.TextField;
    import com.pickgliss.geom.OuterRectPos;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import com.pickgliss.toplevel.StageReferance;
    import flash.display.InteractiveObject;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.utils.ClassUtils;
    import flash.events.KeyboardEvent;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.DisplayUtils;
    import flash.ui.Keyboard;
    import flash.text.TextFieldType;
    import flash.geom.Rectangle;
    import flash.geom.Point;

    [Event(name="response", type="com.pickgliss.events.FrameEvent")]
    public class Frame extends Component 
    {

        public static const P_backgound:String = "backgound";
        public static const P_closeButton:String = "closeButton";
        public static const P_closeInnerRect:String = "closeInnerRect";
        public static const P_containerX:String = "containerX";
        public static const P_containerY:String = "containerY";
        public static const P_disposeChildren:String = "disposeChildren";
        public static const P_moveEnable:String = "moveEnable";
        public static const P_moveInnerRect:String = "moveInnerRect";
        public static const P_title:String = "title";
        public static const P_titleText:String = "titleText";
        public static const P_helpButton:String = "helpButton";
        public static const P_helpInnerRect:String = "helpInnerRect";
        public static const P_titleOuterRectPos:String = "titleOuterRectPos";
        public static const P_escEnable:String = "escEnable";
        public static const P_enterEnable:String = "enterEnable";

        protected var _backStyle:String;
        protected var _backgound:DisplayObject;
        protected var _closeButton:BaseButton;
        protected var _helpButton:BaseButton;
        protected var _closeInnerRect:InnerRectangle;
        protected var _helpInnerRect:InnerRectangle;
        protected var _closeInnerRectString:String;
        protected var _helpInnerRectString:String;
        protected var _closestyle:String;
        protected var _helpStyle:String;
        protected var _container:Sprite;
        protected var _containerPosString:String;
        protected var _containerX:Number;
        protected var _containerY:Number;
        protected var _moveEnable:Boolean;
        protected var _moveInnerRect:InnerRectangle;
        protected var _moveInnerRectString:String = "";
        protected var _moveRect:Sprite;
        protected var _title:TextField;
        protected var _titleStyle:String;
        protected var _titleText:String = "";
        protected var _disposeChildren:Boolean = true;
        protected var _titleOuterRectPosString:String;
        protected var _titleOuterRectPos:OuterRectPos;
        protected var _escEnable:Boolean;
        protected var _enterEnable:Boolean;

        public function Frame()
        {
            addEventListener(Event.ADDED_TO_STAGE, this.__onAddToStage);
            addEventListener(MouseEvent.MOUSE_DOWN, this.__onMouseClickSetFocus);
        }

        protected function __onMouseClickSetFocus(_arg_1:MouseEvent):void
        {
            StageReferance.stage.focus = (_arg_1.target as InteractiveObject);
        }

        public function addToContent(_arg_1:DisplayObject):void
        {
            if (this._container)
            {
                this._container.addChild(_arg_1);
            };
        }

        public function set backStyle(_arg_1:String):void
        {
            if (this._backStyle == _arg_1)
            {
                return;
            };
            this._backStyle = _arg_1;
            this.backgound = ComponentFactory.Instance.creat(this._backStyle);
        }

        public function set backgound(_arg_1:DisplayObject):void
        {
            if (this._backgound == _arg_1)
            {
                return;
            };
            ObjectUtils.disposeObject(this._backgound);
            this._backgound = _arg_1;
            if ((this._backgound is InteractiveObject))
            {
                InteractiveObject(this._backgound).mouseEnabled = true;
            };
            onPropertiesChanged(P_backgound);
        }

        public function get closeButton():BaseButton
        {
            return (this._closeButton);
        }

        public function set closeButton(_arg_1:BaseButton):void
        {
            if (this._closeButton == _arg_1)
            {
                return;
            };
            if (this._closeButton)
            {
                this._closeButton.removeEventListener(MouseEvent.CLICK, this.__onCloseClick);
                ObjectUtils.disposeObject(this._closeButton);
            };
            this._closeButton = _arg_1;
            onPropertiesChanged(P_closeButton);
        }

        public function get helpButton():BaseButton
        {
            return (this._helpButton);
        }

        public function set helpButton(_arg_1:BaseButton):void
        {
            if (this._helpButton == _arg_1)
            {
                return;
            };
            if (this._helpButton)
            {
                this._helpButton.removeEventListener(MouseEvent.CLICK, this.__onHelpClick);
                ObjectUtils.disposeObject(this._helpButton);
            };
            this._helpButton = _arg_1;
            onPropertiesChanged(P_helpButton);
        }

        public function set closeInnerRectString(_arg_1:String):void
        {
            if (this._closeInnerRectString == _arg_1)
            {
                return;
            };
            this._closeInnerRectString = _arg_1;
            this._closeInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, ComponentFactory.parasArgs(this._closeInnerRectString));
            onPropertiesChanged(P_closeInnerRect);
        }

        public function set helpInnerRectString(_arg_1:String):void
        {
            if (this._helpInnerRectString == _arg_1)
            {
                return;
            };
            this._helpInnerRectString = _arg_1;
            this._helpInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, ComponentFactory.parasArgs(this._helpInnerRectString));
            onPropertiesChanged(P_helpInnerRect);
        }

        public function set closestyle(_arg_1:String):void
        {
            if (this._closestyle == _arg_1)
            {
                return;
            };
            this._closestyle = _arg_1;
            this.closeButton = ComponentFactory.Instance.creat(this._closestyle);
        }

        public function set helpstyle(_arg_1:String):void
        {
            if (this._helpStyle == _arg_1)
            {
                return;
            };
            this._helpStyle = _arg_1;
            this.helpButton = ComponentFactory.Instance.creat(this._helpStyle);
        }

        public function set containerX(_arg_1:Number):void
        {
            if (this._containerX == _arg_1)
            {
                return;
            };
            this._containerX = _arg_1;
            onPropertiesChanged(P_containerX);
        }

        public function set containerY(_arg_1:Number):void
        {
            if (this._containerY == _arg_1)
            {
                return;
            };
            this._containerY = _arg_1;
            onPropertiesChanged(P_containerY);
        }

        public function set titleOuterRectPosString(_arg_1:String):void
        {
            if (this._titleOuterRectPosString == _arg_1)
            {
                return;
            };
            this._titleOuterRectPosString = _arg_1;
            this._titleOuterRectPos = ClassUtils.CreatInstance(ClassUtils.OUTTERRECPOS, ComponentFactory.parasArgs(this._titleOuterRectPosString));
            onPropertiesChanged(P_titleOuterRectPos);
        }

        override public function dispose():void
        {
            var _local_1:DisplayObject = (StageReferance.stage.focus as DisplayObject);
            if (((_local_1) && (contains(_local_1))))
            {
                StageReferance.stage.focus = null;
            };
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP, this.__onFrameMoveStop);
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.__onMoveWindow);
            StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.__onKeyDown);
            removeEventListener(MouseEvent.MOUSE_DOWN, this.__onMouseClickSetFocus);
            removeEventListener(Event.ADDED_TO_STAGE, this.__onAddToStage);
            if (this._backgound)
            {
                ObjectUtils.disposeObject(this._backgound);
            };
            this._backgound = null;
            if (this._closeButton)
            {
                this._closeButton.removeEventListener(MouseEvent.CLICK, this.__onCloseClick);
                ObjectUtils.disposeObject(this._closeButton);
            };
            this._closeButton = null;
            if (this._helpButton)
            {
                this._helpButton.removeEventListener(MouseEvent.CLICK, this.__onHelpClick);
            };
            this._helpButton = null;
            if (this._title)
            {
                ObjectUtils.disposeObject(this._title);
            };
            this._title = null;
            if (this._disposeChildren)
            {
                ObjectUtils.disposeAllChildren(this._container);
            };
            if (this._container)
            {
                ObjectUtils.disposeObject(this._container);
            };
            this._container = null;
            if (this._moveRect)
            {
                this._moveRect.removeEventListener(MouseEvent.MOUSE_DOWN, this.__onFrameMoveStart);
            };
            ObjectUtils.disposeObject(this._moveRect);
            this._moveRect = null;
            super.dispose();
        }

        public function get disposeChildren():Boolean
        {
            return (this._disposeChildren);
        }

        public function set disposeChildren(_arg_1:Boolean):void
        {
            if (this._disposeChildren == _arg_1)
            {
                return;
            };
            this._disposeChildren = _arg_1;
            onPropertiesChanged(P_disposeChildren);
        }

        public function set moveEnable(_arg_1:Boolean):void
        {
            if (this._moveEnable == _arg_1)
            {
                return;
            };
            this._moveEnable = _arg_1;
            onPropertiesChanged(P_moveEnable);
        }

        public function set moveInnerRectString(_arg_1:String):void
        {
            if (this._moveInnerRectString == _arg_1)
            {
                return;
            };
            this._moveInnerRectString = _arg_1;
            this._moveInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE, ComponentFactory.parasArgs(this._moveInnerRectString));
            onPropertiesChanged(P_moveInnerRect);
        }

        public function set title(_arg_1:TextField):void
        {
            if (this._title == _arg_1)
            {
                return;
            };
            this._title = _arg_1;
            onPropertiesChanged(P_title);
        }

        public function set titleStyle(_arg_1:String):void
        {
            if (this._titleStyle == _arg_1)
            {
                return;
            };
            this._titleStyle = _arg_1;
            this.title = ComponentFactory.Instance.creat(this._titleStyle);
        }

        public function set titleText(_arg_1:String):void
        {
            if (this._titleText == _arg_1)
            {
                return;
            };
            this._titleText = _arg_1;
            onPropertiesChanged(P_titleText);
        }

        protected function __onAddToStage(_arg_1:Event):void
        {
            stage.focus = this;
        }

        protected function __onCloseClick(_arg_1:MouseEvent):void
        {
            this.onResponse(FrameEvent.CLOSE_CLICK);
        }

        private function __onHelpClick(_arg_1:MouseEvent):void
        {
            this.onResponse(FrameEvent.HELP_CLICK);
        }

        protected function __onKeyDown(_arg_1:KeyboardEvent):void
        {
            var _local_2:DisplayObject = (StageReferance.stage.focus as DisplayObject);
            if (DisplayUtils.isTargetOrContain(_local_2, this))
            {
                if (((_arg_1.keyCode == Keyboard.ENTER) && (this.enterEnable)))
                {
                    if (((_local_2 is TextField) && (TextField(_local_2).type == TextFieldType.INPUT)))
                    {
                        return;
                    };
                    this.onResponse(FrameEvent.ENTER_CLICK);
                    _arg_1.stopImmediatePropagation();
                }
                else
                {
                    if (((_arg_1.keyCode == Keyboard.ESCAPE) && (this.escEnable)))
                    {
                        this.onResponse(FrameEvent.ESC_CLICK);
                        _arg_1.stopImmediatePropagation();
                    };
                };
            };
        }

        public function set escEnable(_arg_1:Boolean):void
        {
            if (this._escEnable == _arg_1)
            {
                return;
            };
            this._escEnable = _arg_1;
            onPropertiesChanged(P_escEnable);
        }

        public function get escEnable():Boolean
        {
            return (this._escEnable);
        }

        public function set enterEnable(_arg_1:Boolean):void
        {
            if (this._enterEnable == _arg_1)
            {
                return;
            };
            this._enterEnable = _arg_1;
            onPropertiesChanged(P_enterEnable);
        }

        public function get enterEnable():Boolean
        {
            return (this._enterEnable);
        }

        protected function onResponse(_arg_1:int):void
        {
            dispatchEvent(new FrameEvent(_arg_1));
        }

        protected function __onFrameMoveStart(_arg_1:MouseEvent):void
        {
            StageReferance.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.__onMoveWindow);
            StageReferance.stage.addEventListener(MouseEvent.MOUSE_UP, this.__onFrameMoveStop);
            startDrag();
        }

        protected function __onFrameMoveStop(_arg_1:MouseEvent):void
        {
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_UP, this.__onFrameMoveStop);
            StageReferance.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.__onMoveWindow);
            stopDrag();
        }

        override protected function addChildren():void
        {
            if (this._backgound)
            {
                addChild(this._backgound);
            };
            if (this._title)
            {
                addChild(this._title);
            };
            addChild(this._moveRect);
            addChild(this._container);
            if (this._closeButton)
            {
                addChild(this._closeButton);
            };
            if (this._helpButton)
            {
                addChild(this._helpButton);
            };
        }

        override protected function init():void
        {
            this._container = new Sprite();
            this._moveRect = new Sprite();
            super.init();
        }

        override protected function onProppertiesUpdate():void
        {
            super.onProppertiesUpdate();
            if ((((_changedPropeties[Component.P_height]) || (_changedPropeties[Component.P_width])) && (!(this._backgound == null))))
            {
                this._backgound.width = _width;
                this._backgound.height = _height;
                this.updateClosePos();
                this.updateHelpPos();
            };
            if ((((_changedPropeties[Component.P_height]) || (_changedPropeties[Component.P_width])) || (_changedPropeties[P_moveInnerRect])))
            {
                this.updateMoveRect();
            };
            if (_changedPropeties[P_closeButton])
            {
                this._closeButton.addEventListener(MouseEvent.CLICK, this.__onCloseClick);
            };
            if (_changedPropeties[P_helpButton])
            {
                this._helpButton.addEventListener(MouseEvent.CLICK, this.__onHelpClick);
            };
            if (((_changedPropeties[P_closeButton]) || (_changedPropeties[P_closeInnerRect])))
            {
                this.updateClosePos();
            };
            if (((_changedPropeties[P_helpButton]) || (_changedPropeties[P_helpInnerRect])))
            {
                this.updateHelpPos();
            };
            if (((_changedPropeties[P_containerX]) || (_changedPropeties[P_containerY])))
            {
                this.updateContainerPos();
            };
            if (((((_changedPropeties[P_titleOuterRectPos]) || (_changedPropeties[P_titleText])) || (_changedPropeties[Component.P_height])) || (_changedPropeties[Component.P_width])))
            {
                if (this._title != null)
                {
                    this._title.text = this._titleText;
                };
                this.updateTitlePos();
            };
            if (_changedPropeties[P_moveEnable])
            {
                if (this._moveEnable)
                {
                    this._moveRect.addEventListener(MouseEvent.MOUSE_DOWN, this.__onFrameMoveStart);
                }
                else
                {
                    this._moveRect.removeEventListener(MouseEvent.MOUSE_DOWN, this.__onFrameMoveStart);
                };
            };
            if (((this._escEnable) || (this._enterEnable)))
            {
                StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.__onKeyDown);
            }
            else
            {
                StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.__onKeyDown);
            };
        }

        protected function updateClosePos():void
        {
            if (((this._closeButton) && (this._closeInnerRect)))
            {
                DisplayUtils.layoutDisplayWithInnerRect(this._closeButton, this._closeInnerRect, _width, _height);
            };
        }

        protected function updateHelpPos():void
        {
            if (((this._helpButton) && (this._helpInnerRect)))
            {
                DisplayUtils.layoutDisplayWithInnerRect(this._helpButton, this._helpInnerRect, _width, _height);
            };
        }

        protected function updateContainerPos():void
        {
            this._container.x = this._containerX;
            this._container.y = this._containerY;
        }

        protected function updateMoveRect():void
        {
            if (this._moveInnerRect == null)
            {
                return;
            };
            var _local_1:Rectangle = this._moveInnerRect.getInnerRect(_width, _height);
            this._moveRect.graphics.clear();
            this._moveRect.graphics.beginFill(0, 0);
            this._moveRect.graphics.drawRect(_local_1.x, _local_1.y, _local_1.width, _local_1.height);
            this._moveRect.graphics.endFill();
        }

        protected function updateTitlePos():void
        {
            var _local_1:Point;
            if (this._title == null)
            {
                return;
            };
            if (this._titleOuterRectPos == null)
            {
                return;
            };
            _local_1 = this._titleOuterRectPos.getPos(this._title.width, this._title.height, _width, _height);
            this._title.x = _local_1.x;
            this._title.y = _local_1.y;
        }

        protected function __onMoveWindow(_arg_1:MouseEvent):void
        {
            if (DisplayUtils.isInTheStage(new Point(_arg_1.localX, _arg_1.localY), this))
            {
                _arg_1.updateAfterEvent();
            }
            else
            {
                this.__onFrameMoveStop(null);
            };
        }


    }
}//package com.pickgliss.ui.controls

