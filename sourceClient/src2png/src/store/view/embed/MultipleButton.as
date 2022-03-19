// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.embed.MultipleButton

package store.view.embed
{
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.core.ITransformableTipedDisplay;
    import com.pickgliss.ui.ShowTipManager;

    public class MultipleButton extends TextButton implements ITransformableTipedDisplay 
    {

        public var P_tipWidth:String = "tipWidth";
        public var P_tipHeight:String = "tipHeight";
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
            onPropertiesChanged(this.P_tipWidth);
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
            onPropertiesChanged(this.P_tipHeight);
        }

        override protected function onProppertiesUpdate():void
        {
            super.onProppertiesUpdate();
            if (((((((_changedPropeties[P_tipDirction]) || (_changedPropeties[P_tipGap])) || (_changedPropeties[P_tipStyle])) || (_changedPropeties[P_tipData])) || (_changedPropeties[this.P_tipWidth])) || (_changedPropeties[this.P_tipHeight])))
            {
                ShowTipManager.Instance.addTip(this);
            };
        }


    }
}//package store.view.embed

