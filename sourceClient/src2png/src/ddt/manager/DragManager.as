// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.DragManager

package ddt.manager
{
    import flash.events.EventDispatcher;
    import flash.display.Sprite;
    import bagAndInfo.cell.DragEffect;
    import ddt.interfaces.IDragable;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.LayerManager;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.display.Stage;
    import ddt.interfaces.IAcceptDrag;
    import flash.geom.Point;
    import com.pickgliss.utils.ObjectUtils;

    public class DragManager extends EventDispatcher 
    {

        public static const DRAG_IN_RANGE_TOP:String = "dragInRangeTop";
        public static const DRAG_IN_RANGE_BUTTOM:String = "dragOutRangeButtom";
        public static const DRAG_IN_HOT:String = "dragInHot";
        private static var _isDraging:Boolean;
        private static var _proxy:Sprite;
        private static var _dragEffect:DragEffect;
        private static var _source:IDragable;
        private static var _throughAll:Boolean;
        private static var _wheelFun:Function;
        private static var _passSelf:Boolean;
        private static var _isUpDrag:Boolean;
        private static var _changCardStateFun:Function;
        private static var _responseRectangle:DisplayObject;
        private static var _responseRange:int;
        private static var _isContinue:Boolean;


        public static function get proxy():Sprite
        {
            return (_proxy);
        }

        public static function get isDraging():Boolean
        {
            return (_isDraging);
        }

        public static function startDrag(_arg_1:IDragable, _arg_2:Object, _arg_3:DisplayObject, _arg_4:int, _arg_5:int, _arg_6:String="none", _arg_7:Boolean=true, _arg_8:Boolean=false, _arg_9:Boolean=false, _arg_10:Boolean=false, _arg_11:Boolean=false, _arg_12:DisplayObject=null, _arg_13:int=0, _arg_14:Boolean=false):Boolean
        {
            if (((!(_isDraging)) && (_arg_3)))
            {
                _responseRectangle = _arg_12;
                _responseRange = _arg_13;
                _isContinue = _arg_14;
                _passSelf = _arg_10;
                _isUpDrag = _arg_11;
                _isDraging = true;
                _proxy = new Sprite();
                _arg_3.x = (-(_arg_3.width) / 2);
                _arg_3.y = (-(_arg_3.height) / 2);
                _proxy.addChild(_arg_3);
                InGameCursor.hide();
                _proxy.x = _arg_4;
                _proxy.y = _arg_5;
                _proxy.mouseEnabled = _arg_7;
                _proxy.mouseChildren = false;
                _proxy.startDrag();
                _throughAll = _arg_9;
                _dragEffect = new DragEffect(_arg_1.getSource(), _arg_2, _arg_6);
                _source = _arg_1;
                LayerManager.Instance.addToLayer(_proxy, LayerManager.STAGE_DYANMIC_LAYER);
                if (_arg_7)
                {
                    _proxy.addEventListener(MouseEvent.CLICK, __stopDrag);
                    _proxy.addEventListener(MouseEvent.MOUSE_UP, __upDrag);
                    _proxy.addEventListener(MouseEvent.MOUSE_WHEEL, __dispatchWheel);
                }
                else
                {
                    if ((!(_arg_8)))
                    {
                        _proxy.stage.addEventListener(MouseEvent.MOUSE_DOWN, __stageMouseDown, true);
                    };
                    _proxy.stage.addEventListener(MouseEvent.CLICK, __stopDrag, true);
                    _proxy.stage.addEventListener(MouseEvent.MOUSE_UP, __upDrag, true);
                    _proxy.parent.mouseEnabled = false;
                };
                if (((!(_responseRectangle == null)) && (!(_responseRange == 0))))
                {
                    _proxy.addEventListener(Event.ENTER_FRAME, __checkResponse);
                };
                _proxy.addEventListener(Event.REMOVED_FROM_STAGE, __removeFromStage);
                return (true);
            };
            return (false);
        }

        protected static function __checkResponse(_arg_1:Event):void
        {
            var _local_2:Boolean = ((_proxy.stage.mouseY > _responseRectangle.y) && (_proxy.stage.mouseY < (_responseRectangle.y + _responseRange)));
            var _local_3:Boolean = ((_proxy.stage.mouseY > ((_responseRectangle.y + _responseRectangle.height) - _responseRange)) && (_proxy.stage.mouseY < (_responseRectangle.y + _responseRectangle.height)));
            var _local_4:Boolean = ((_proxy.stage.mouseX > _responseRectangle.x) && (_proxy.stage.mouseX < (_responseRectangle.x + _responseRectangle.width)));
            if (((_local_2) && (_local_4)))
            {
                _responseRectangle.dispatchEvent(new Event(DRAG_IN_RANGE_TOP));
            }
            else
            {
                if (((_local_3) && (_local_4)))
                {
                    _responseRectangle.dispatchEvent(new Event(DRAG_IN_RANGE_BUTTOM));
                };
            };
        }

        public static function ListenWheelEvent(_arg_1:Function):void
        {
            _wheelFun = _arg_1;
        }

        public static function removeListenWheelEvent():void
        {
            _wheelFun = null;
            _changCardStateFun = null;
        }

        private static function __dispatchWheel(_arg_1:MouseEvent):void
        {
            if (((_passSelf) && (!(_wheelFun == null))))
            {
                _wheelFun(_arg_1);
            };
        }

        public static function changeCardState(_arg_1:Function):void
        {
            _changCardStateFun = _arg_1;
        }

        private static function __stageMouseDown(_arg_1:Event):void
        {
            _arg_1.stopImmediatePropagation();
            _proxy.stage.removeEventListener(MouseEvent.MOUSE_DOWN, __stageMouseDown, true);
        }

        private static function __removeFromStage(_arg_1:Event):void
        {
            _proxy.removeEventListener(MouseEvent.CLICK, __stopDrag);
            _proxy.removeEventListener(MouseEvent.MOUSE_UP, __upDrag);
            _proxy.removeEventListener(Event.REMOVED_FROM_STAGE, __removeFromStage);
            _proxy.stage.removeEventListener(MouseEvent.MOUSE_DOWN, __stageMouseDown, true);
            _proxy.removeEventListener(MouseEvent.MOUSE_WHEEL, __dispatchWheel);
            if (((!(_responseRectangle == null)) && (!(_responseRange == 0))))
            {
                _proxy.removeEventListener(Event.ENTER_FRAME, __checkResponse);
            };
            InGameCursor.show();
            acceptDrag(null);
        }

        public static function __upDrag(_arg_1:MouseEvent):void
        {
            if (_isUpDrag)
            {
                __stopDrag(_arg_1);
            };
        }

        private static function __stopDrag(_arg_1:MouseEvent):void
        {
            var _local_2:Array;
            var _local_3:Stage;
            var _local_4:Boolean;
            var _local_5:Boolean;
            var _local_6:DisplayObject;
            var _local_7:DisplayObject;
            var _local_8:Boolean;
            var _local_9:IAcceptDrag;
            try
            {
                if (((_passSelf) && (!(_changCardStateFun == null))))
                {
                    _changCardStateFun();
                };
                _local_2 = _proxy.stage.getObjectsUnderPoint(new Point(_arg_1.stageX, _arg_1.stageY));
                _local_3 = _proxy.stage;
                _local_4 = true;
                InGameCursor.show();
                if (_local_3)
                {
                    _local_3.removeEventListener(MouseEvent.CLICK, __stopDrag);
                    _local_3.removeEventListener(MouseEvent.MOUSE_UP, __upDrag);
                };
                _proxy.removeEventListener(MouseEvent.CLICK, __stopDrag);
                _proxy.removeEventListener(MouseEvent.MOUSE_UP, __upDrag);
                _proxy.removeEventListener(MouseEvent.MOUSE_WHEEL, __dispatchWheel);
                _proxy.removeEventListener(Event.REMOVED_FROM_STAGE, __removeFromStage);
                if (((!(_responseRectangle == null)) && (!(_responseRange == 0))))
                {
                    _proxy.removeEventListener(Event.ENTER_FRAME, __checkResponse);
                };
                _arg_1.stopImmediatePropagation();
                if (_proxy.parent)
                {
                    _proxy.parent.removeChild(_proxy);
                };
                _local_2 = _local_2.reverse();
                _local_5 = false;
                for each (_local_6 in _local_2)
                {
                    if (!_proxy.contains(_local_6))
                    {
                        _local_7 = _local_6;
                        _local_8 = false;
                        while (((_local_7) && (!(_local_7 == _local_3))))
                        {
                            if (((!(_passSelf)) && (_local_7 == _source)))
                            {
                                _dragEffect.action = DragEffect.NONE;
                                _local_8 = true;
                                break;
                            };
                            _local_9 = (_local_7 as IAcceptDrag);
                            if (_local_9)
                            {
                                if (_local_4)
                                {
                                    _local_9.dragDrop(_dragEffect);
                                    _local_5 = true;
                                    if (_throughAll == false)
                                    {
                                        _local_4 = false;
                                    };
                                };
                                if ((!(_isDraging)))
                                {
                                    _local_8 = true;
                                    break;
                                };
                            };
                            _local_7 = _local_7.parent;
                        };
                        if (_local_8) break;
                    };
                };
                if (((!(_isContinue)) || (!(_local_5))))
                {
                    ObjectUtils.disposeAllChildren(_proxy);
                    _proxy = null;
                };
            }
            catch(e:Error)
            {
            };
            if (_source)
            {
                acceptDrag(null);
            };
        }

        public static function acceptDrag(_arg_1:IAcceptDrag, _arg_2:String=null):void
        {
            _isDraging = false;
            var _local_3:IDragable = _source;
            var _local_4:DragEffect = _dragEffect;
            try
            {
                _local_4.target = _arg_1;
                if (_arg_2)
                {
                    _local_4.action = _arg_2;
                };
                _local_3.dragStop(_local_4);
            }
            catch(e:Error)
            {
            };
            if ((!(_isContinue)))
            {
                _source = null;
                _dragEffect = null;
            };
        }


    }
}//package ddt.manager

