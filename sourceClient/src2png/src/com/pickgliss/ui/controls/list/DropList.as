// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.controls.list.DropList

package com.pickgliss.ui.controls.list
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.controls.container.BoxContainer;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.cell.IDropListCell;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.KeyboardEvent;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.ComponentSetting;
    import flash.ui.Keyboard;
    import com.pickgliss.toplevel.StageReferance;
    import flash.display.InteractiveObject;
    import __AS3__.vec.*;

    public class DropList extends Component implements Disposeable 
    {

        public static const SELECTED:String = "selected";
        public static const P_backgound:String = "backgound";
        public static const P_container:String = "container";

        private var _backStyle:String;
        private var _backGround:DisplayObject;
        private var _cellStyle:String;
        private var _containerStyle:String;
        private var _container:BoxContainer;
        private var _targetDisplay:IDropListTarget;
        private var _showLength:int;
        private var _dataList:Array;
        private var _items:Vector.<IDropListCell>;
        private var _currentSelectedIndex:int;
        private var _pageIndex:int;
        private var _preItemIdx:int;
        private var _cellHeight:int;
        private var _cellWidth:int;
        private var _isListening:Boolean;
        private var _canUseEnter:Boolean = true;


        override protected function init():void
        {
            this._items = new Vector.<IDropListCell>();
        }

        public function set container(_arg_1:BoxContainer):void
        {
            if (this._container)
            {
                ObjectUtils.disposeObject(this._container);
                this._container = null;
            };
            this._container = _arg_1;
            onPropertiesChanged(P_container);
        }

        public function set containerStyle(_arg_1:String):void
        {
            if (this._containerStyle == _arg_1)
            {
                return;
            };
            this._containerStyle = _arg_1;
            if (this._container)
            {
                ObjectUtils.disposeObject(this._container);
                this._container = null;
            };
            this.container = ComponentFactory.Instance.creat(this._containerStyle);
        }

        public function set cellStyle(_arg_1:String):void
        {
            if (this._cellStyle == _arg_1)
            {
                return;
            };
            this._cellStyle = _arg_1;
        }

        public function set dataList(_arg_1:Array):void
        {
            if ((!(_arg_1)))
            {
                if (parent)
                {
                    parent.removeChild(this);
                };
                return;
            };
            if (this._targetDisplay.parent)
            {
                this._targetDisplay.parent.addChild(this);
            };
            this._dataList = _arg_1;
            var _local_2:int = Math.min(this._dataList.length, this._showLength);
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                this._items[_local_3].setCellValue(this._dataList[_local_3]);
                if ((!(this._container.contains(this._items[_local_3].asDisplayObject()))))
                {
                    this._container.addChild(this._items[_local_3].asDisplayObject());
                };
                _local_3++;
            };
            if (_local_2 == 0)
            {
                this._items[0].setCellValue(null);
                if ((!(this._container.contains(this._items[_local_3].asDisplayObject()))))
                {
                    this._container.addChild(this._items[_local_3].asDisplayObject());
                };
                _local_2 = 1;
            };
            _local_3 = _local_2;
            while (_local_3 < this._showLength)
            {
                if (this._container.contains(this._items[_local_3].asDisplayObject()))
                {
                    this._container.removeChild(this._items[_local_3].asDisplayObject());
                };
                _local_3++;
            };
            this.updateBg();
            this.unSelectedAllItems();
            this._currentSelectedIndex = 0;
            this._pageIndex = 0;
            this._items[this._currentSelectedIndex].selected = true;
        }

        private function updateBg():void
        {
            if (this._container.numChildren == 0)
            {
                if (contains(this._backGround))
                {
                    removeChild(this._backGround);
                };
            }
            else
            {
                this._backGround.width = (this._cellWidth + (2 * this._container.x));
                this._backGround.height = (((this._container.numChildren * (this._cellHeight + this._container.spacing)) - this._container.spacing) + (2 * this._container.y));
                addChildAt(this._backGround, 0);
            };
        }

        private function getHightLightItemIdx():int
        {
            var _local_1:int;
            while (_local_1 < this._showLength)
            {
                if (this._items[_local_1].selected)
                {
                    return (_local_1);
                };
                _local_1++;
            };
            return (0);
        }

        private function unSelectedAllItems():int
        {
            var _local_1:int;
            var _local_2:int;
            while (_local_2 < this._showLength)
            {
                if (this._items[_local_2].selected)
                {
                    _local_1 = _local_2;
                };
                this._items[_local_2].selected = false;
                _local_2++;
            };
            return (_local_1);
        }

        private function updateItemValue(_arg_1:Boolean=false):void
        {
            var _local_2:int;
            while (_local_2 < this._showLength)
            {
                this._items[_local_2].setCellValue(this._dataList[((this._currentSelectedIndex - this.getHightLightItemIdx()) + _local_2)]);
                _local_2++;
            };
        }

        private function updateWheelItemValue(_arg_1:Boolean=false):void
        {
            var _local_2:Number = (this._dataList.length / 5);
            var _local_3:int;
            while (_local_3 < this._showLength)
            {
                if ((!(_arg_1)))
                {
                    if (this.PageIndex == (this._dataList.length - this._showLength))
                    {
                        return;
                    };
                    this._items[_local_3].setCellValue(this._dataList[((this.PageIndex + 1) + _local_3)]);
                }
                else
                {
                    if (this.PageIndex == 0)
                    {
                        return;
                    };
                    this._items[_local_3].setCellValue(this._dataList[((this.PageIndex - 1) + _local_3)]);
                };
                _local_3++;
            };
            if ((!(_arg_1)))
            {
                this.PageIndex = (this.PageIndex + 1);
            }
            else
            {
                this.PageIndex = (this.PageIndex - 1);
            };
        }

        public function set PageIndex(_arg_1:int):void
        {
            this._pageIndex = _arg_1;
        }

        public function get PageIndex():int
        {
            return (this._pageIndex);
        }

        private function setWheelHightLightItem(_arg_1:Boolean=false):void
        {
            var _local_2:int;
            if (this._dataList.length > this._showLength)
            {
                _local_2 = (this._showLength - 1);
                if (_local_2 >= (this._showLength - 1))
                {
                    if ((!(_arg_1)))
                    {
                        this.updateWheelItemValue();
                    }
                    else
                    {
                        this.updateWheelItemValue(true);
                    };
                };
            };
        }

        private function setHightLightItem(_arg_1:Boolean=false):void
        {
            var _local_2:int;
            if (this._dataList.length > 0)
            {
                _local_2 = this.getHightLightItemIdx();
                if ((!(_arg_1)))
                {
                    if (_local_2 < (this._showLength - 1))
                    {
                        this.unSelectedAllItems();
                        _local_2++;
                    }
                    else
                    {
                        if (_local_2 >= (this._showLength - 1))
                        {
                            this.updateItemValue();
                        };
                    };
                };
                if (_arg_1)
                {
                    if (_local_2 > 0)
                    {
                        this.unSelectedAllItems();
                        _local_2--;
                    }
                    else
                    {
                        if (_local_2 == 0)
                        {
                            this.updateItemValue(true);
                        };
                    };
                };
                this._items[_local_2].selected = true;
            }
            else
            {
                this._currentSelectedIndex = 0;
            };
            this.setTargetValue();
        }

        override protected function addChildren():void
        {
            super.addChildren();
            if (this._backGround)
            {
                addChild(this._backGround);
            };
            if (this._container)
            {
                addChild(this._container);
            };
        }

        public function set targetDisplay(_arg_1:IDropListTarget):void
        {
            if (_arg_1 == this._targetDisplay)
            {
                return;
            };
            this._targetDisplay = _arg_1;
            this._targetDisplay.addEventListener(KeyboardEvent.KEY_DOWN, this.__onKeyDown);
            this._targetDisplay.addEventListener(Event.REMOVED_FROM_STAGE, this.__onRemoveFromStage);
            this._targetDisplay.addEventListener(MouseEvent.MOUSE_WHEEL, this.__mouseWheel);
        }

        private function __onRemoveFromStage(_arg_1:Event):void
        {
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function set showLength(_arg_1:int):void
        {
            var _local_2:*;
            if (this._showLength == _arg_1)
            {
                return;
            };
            this._showLength = _arg_1;
            while (this._container.numChildren > this._showLength)
            {
                this._container.removeChild(this._items.pop());
            };
            while (this._container.numChildren < this._showLength)
            {
                if (this._items.length > this._container.numChildren)
                {
                    this._container.addChild(this._items[this._container.numChildren].asDisplayObject());
                }
                else
                {
                    _local_2 = ComponentFactory.Instance.creat(this._cellStyle);
                    _local_2.addEventListener(MouseEvent.MOUSE_OVER, this.__onCellMouseOver);
                    _local_2.addEventListener(MouseEvent.CLICK, this.__onCellMouseClick);
                    this._items.push(_local_2);
                    this._container.addChild(_local_2);
                };
            };
            this._cellHeight = _local_2.height;
            this._cellWidth = _local_2.width;
            this.updateBg();
        }

        private function __onCellMouseClick(_arg_1:MouseEvent):void
        {
            ComponentSetting.PLAY_SOUND_FUNC("008");
            this.setTargetValue();
            if (parent)
            {
                parent.removeChild(this);
            };
            dispatchEvent(new Event(SELECTED));
        }

        private function __onCellMouseOver(_arg_1:MouseEvent):void
        {
            var _local_2:int = this.unSelectedAllItems();
            var _local_3:int = this._items.indexOf(_arg_1.currentTarget);
            this._currentSelectedIndex = (this._currentSelectedIndex + (_local_3 - _local_2));
            _arg_1.currentTarget.selected = true;
        }

        override protected function onProppertiesUpdate():void
        {
            super.onProppertiesUpdate();
            if (((_changedPropeties[P_backgound]) || (_changedPropeties[P_container])))
            {
                this.addChildren();
            };
        }

        private function __mouseWheel(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            _arg_1.stopPropagation();
            if (this._dataList == null)
            {
                return;
            };
            if (this._dataList.length <= this._showLength)
            {
                return;
            };
            if (_arg_1.delta > 0)
            {
                this.setWheelHightLightItem(true);
            }
            else
            {
                this.setWheelHightLightItem();
            };
        }

        private function __onKeyDown(_arg_1:KeyboardEvent):void
        {
            if (this._dataList == null)
            {
                return;
            };
            _arg_1.stopImmediatePropagation();
            _arg_1.stopPropagation();
            if (((!(this._isListening)) && (_arg_1.keyCode == Keyboard.ENTER)))
            {
                this._isListening = true;
                StageReferance.stage.addEventListener(Event.ENTER_FRAME, this.__setSelection);
            };
            switch (_arg_1.keyCode)
            {
                case Keyboard.UP:
                    ComponentSetting.PLAY_SOUND_FUNC("008");
                    if (this._currentSelectedIndex == 0)
                    {
                        return;
                    };
                    this._currentSelectedIndex--;
                    this.setHightLightItem(true);
                    return;
                case Keyboard.DOWN:
                    ComponentSetting.PLAY_SOUND_FUNC("008");
                    if (this._currentSelectedIndex == (this._dataList.length - 1))
                    {
                        return;
                    };
                    this._currentSelectedIndex++;
                    this.setHightLightItem();
                    return;
                case Keyboard.ENTER:
                    if (this._canUseEnter == false)
                    {
                        return;
                    };
                    ComponentSetting.PLAY_SOUND_FUNC("008");
                    if (parent)
                    {
                        parent.removeChild(this);
                    };
                    this._targetDisplay.setValue(this._dataList[this._currentSelectedIndex]);
                    dispatchEvent(new Event(SELECTED));
                    return;
            };
        }

        public function set canUseEnter(_arg_1:Boolean):void
        {
            this._canUseEnter = _arg_1;
        }

        public function get canUseEnter():Boolean
        {
            return (this._canUseEnter);
        }

        public function set currentSelectedIndex(_arg_1:int):void
        {
            if (this._dataList == null)
            {
                return;
            };
            ComponentSetting.PLAY_SOUND_FUNC("008");
            if (((this._currentSelectedIndex == (this._dataList.length - 1)) || (this._currentSelectedIndex == 0)))
            {
                return;
            };
            this._currentSelectedIndex = (this._currentSelectedIndex + _arg_1);
            this.setHightLightItem();
        }

        private function setTargetValue():void
        {
            if ((!(this._targetDisplay.parent)))
            {
                this._targetDisplay.parent.addChild(this);
            };
            if (this._dataList)
            {
                this._targetDisplay.setValue(this._dataList[this._currentSelectedIndex]);
            };
        }

        private function __setSelection(_arg_1:Event):void
        {
            if (this._targetDisplay.caretIndex == this._targetDisplay.getValueLength())
            {
                this._isListening = false;
                StageReferance.stage.removeEventListener(Event.ENTER_FRAME, this.__setSelection);
            }
            else
            {
                this._targetDisplay.setCursor(this._targetDisplay.getValueLength());
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
            if (this._backGround == _arg_1)
            {
                return;
            };
            ObjectUtils.disposeObject(this._backGround);
            this._backGround = _arg_1;
            if ((this._backGround is InteractiveObject))
            {
                InteractiveObject(this._backGround).mouseEnabled = true;
            };
            onPropertiesChanged(P_backgound);
        }

        override public function dispose():void
        {
            if (parent)
            {
                parent.removeChild(this);
            };
            StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.__onKeyDown);
            StageReferance.stage.removeEventListener(Event.ENTER_FRAME, this.__setSelection);
            this._targetDisplay.removeEventListener(KeyboardEvent.KEY_DOWN, this.__onKeyDown);
            if (this._backGround)
            {
                ObjectUtils.disposeObject(this._backGround);
            };
            this._backGround = null;
            if (this._container)
            {
                ObjectUtils.disposeObject(this._container);
            };
            this._container = null;
            if (this._targetDisplay)
            {
                ObjectUtils.disposeObject(this._targetDisplay);
            };
            this._targetDisplay = null;
            var _local_1:int;
            while (_local_1 < this._items.length)
            {
                if (this._items[_local_1])
                {
                    ObjectUtils.disposeObject(this._items[_local_1]);
                };
                this._items[_local_1] = null;
                _local_1++;
            };
            this._dataList = null;
            super.dispose();
        }


    }
}//package com.pickgliss.ui.controls.list

