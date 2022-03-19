// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.AlertManager

package com.pickgliss.ui
{
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.ComponentEvent;
    import flash.events.Event;
    import com.pickgliss.manager.CacheSysManager;
    import com.pickgliss.action.AlertAction;
    import com.pickgliss.toplevel.StageReferance;
    import com.pickgliss.utils.StringUtils;
    import com.pickgliss.utils.ObjectUtils;

    public final class AlertManager 
    {

        private static var _instance:AlertManager;
        public static var DEFAULT_CONFIRM_LABEL:String = "确 定";

        private var _layerType:int;
        private var _simpleAlertInfo:AlertInfo;


        public static function get Instance():AlertManager
        {
            if (_instance == null)
            {
                _instance = new (AlertManager)();
            };
            return (_instance);
        }


        public function alert(_arg_1:String, _arg_2:AlertInfo, _arg_3:int=0, _arg_4:String=null):BaseAlerFrame
        {
            var _local_5:BaseAlerFrame = ComponentFactory.Instance.creat(_arg_1);
            _local_5.addEventListener(ComponentEvent.PROPERTIES_CHANGED, this.__onAlertSizeChanged);
            _local_5.addEventListener(Event.REMOVED_FROM_STAGE, this.__onAlertRemoved);
            _local_5.info = _arg_2;
            if (((_arg_4) && (CacheSysManager.isLock(_arg_4))))
            {
                CacheSysManager.getInstance().cache(_arg_4, new AlertAction(_local_5, this._layerType, _arg_3));
            }
            else
            {
                LayerManager.Instance.addToLayer(_local_5, this._layerType, _local_5.info.frameCenter, _arg_3);
                StageReferance.stage.focus = _local_5;
            };
            return (_local_5);
        }

        private function __onAlertRemoved(_arg_1:Event):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(ComponentEvent.PROPERTIES_CHANGED, this.__onAlertSizeChanged);
            _local_2.removeEventListener(Event.REMOVED_FROM_STAGE, this.__onAlertRemoved);
        }

        private function __onAlertSizeChanged(_arg_1:ComponentEvent):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            if (_local_2.info.frameCenter)
            {
                _local_2.x = ((StageReferance.stageWidth - _local_2.width) / 2);
                _local_2.y = ((StageReferance.stageHeight - _local_2.height) / 2);
            };
        }

        public function setup(_arg_1:int, _arg_2:AlertInfo):void
        {
            this._simpleAlertInfo = _arg_2;
            this._layerType = _arg_1;
        }

        public function simpleAlert(_arg_1:String, _arg_2:String, _arg_3:String="", _arg_4:String="", _arg_5:Boolean=false, _arg_6:Boolean=false, _arg_7:Boolean=false, _arg_8:int=0, _arg_9:String=null, _arg_10:String="SimpleAlert", _arg_11:int=30, _arg_12:Boolean=true):BaseAlerFrame
        {
            if (StringUtils.isEmpty(_arg_3))
            {
                _arg_3 = DEFAULT_CONFIRM_LABEL;
            };
            var _local_13:AlertInfo = new AlertInfo();
            ObjectUtils.copyProperties(_local_13, this._simpleAlertInfo);
            _local_13.sound = this._simpleAlertInfo.sound;
            _local_13.data = _arg_2;
            _local_13.autoDispose = _arg_5;
            _local_13.title = _arg_1;
            _local_13.submitLabel = _arg_3;
            _local_13.cancelLabel = _arg_4;
            _local_13.enableHtml = _arg_6;
            _local_13.mutiline = _arg_7;
            _local_13.buttonGape = _arg_11;
            _local_13.autoButtonGape = _arg_12;
            if (StringUtils.isEmpty(_arg_4))
            {
                _local_13.showCancel = false;
            };
            return (this.alert(_arg_10, _local_13, _arg_8, _arg_9));
        }


    }
}//package com.pickgliss.ui

