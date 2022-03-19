// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.action.AlertAction

package com.pickgliss.action
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.ComponentSetting;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.toplevel.StageReferance;

    public class AlertAction extends BaseAction 
    {

        private var _alert:BaseAlerFrame;
        private var _layerType:int;
        private var _blockBackgound:int;
        private var _soundStr:String;
        private var _center:Boolean;

        public function AlertAction(_arg_1:BaseAlerFrame, _arg_2:int, _arg_3:int, _arg_4:String=null, _arg_5:Boolean=true)
        {
            this._alert = _arg_1;
            this._layerType = _arg_2;
            this._blockBackgound = _arg_3;
            this._soundStr = _arg_4;
            this._center = _arg_5;
        }

        override public function act():void
        {
            if (((this._soundStr) && (ComponentSetting.PLAY_SOUND_FUNC is Function)))
            {
                ComponentSetting.PLAY_SOUND_FUNC(this._soundStr);
            };
            if (((this._alert) && (this._alert.info)))
            {
                LayerManager.Instance.addToLayer(this._alert, this._layerType, this._alert.info.frameCenter, this._blockBackgound);
                StageReferance.stage.focus = this._alert;
            };
        }


    }
}//package com.pickgliss.action

