// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.core.TransformableComponent

package com.pickgliss.ui.core
{
    import com.pickgliss.ui.ShowTipManager;

    public class TransformableComponent extends Component implements ITransformableTipedDisplay 
    {

        public static const P_tipWidth:String = "tipWidth";
        public static const P_tipHeight:String = "tipHeight";

        protected var _tipWidth:int;
        protected var _tipHeight:int;


        public function get tipWidth():int
        {
            return (this._tipWidth);
        }

        public function set tipWidth(_arg_1:int):void
        {
            if (this._tipWidth == _arg_1)
            {
                return;
            };
            this._tipWidth = _arg_1;
            onPropertiesChanged(P_tipWidth);
        }

        public function get tipHeight():int
        {
            return (this._tipHeight);
        }

        public function set tipHeight(_arg_1:int):void
        {
            if (this._tipHeight == _arg_1)
            {
                return;
            };
            this._tipHeight = _arg_1;
            onPropertiesChanged(P_tipHeight);
        }

        override protected function onProppertiesUpdate():void
        {
            if (((((((_changedPropeties[P_tipWidth]) || (_changedPropeties[P_tipHeight])) || (_changedPropeties[P_tipDirction])) || (_changedPropeties[P_tipGap])) || (_changedPropeties[P_tipStyle])) || (_changedPropeties[P_tipData])))
            {
                ShowTipManager.Instance.addTip(this);
            };
        }


    }
}//package com.pickgliss.ui.core

