// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.ui.text.FilterFrameTextWithTips

package com.pickgliss.ui.text
{
    import com.pickgliss.ui.core.ITipedDisplay;
    import com.pickgliss.ui.ShowTipManager;
    import flash.display.DisplayObject;

    public class FilterFrameTextWithTips extends FilterFrameText implements ITipedDisplay 
    {

        private var _tipStyle:String;
        private var _tipGapV:int;
        private var _tipGapH:int;
        private var _tipDirctions:String;
        private var _tipData:Object;

        public function FilterFrameTextWithTips()
        {
            mouseEnabled = true;
            selectable = false;
            ShowTipManager.Instance.addTip(this);
        }

        public function get tipData():Object
        {
            return (this._tipData);
        }

        public function set tipData(_arg_1:Object):void
        {
            this._tipData = _arg_1;
        }

        public function get tipDirctions():String
        {
            return ("5,2,7,1,6,4");
        }

        public function set tipDirctions(_arg_1:String):void
        {
            this._tipDirctions = _arg_1;
        }

        public function get tipGapH():int
        {
            return (this._tipGapH);
        }

        public function set tipGapH(_arg_1:int):void
        {
            this._tipGapH = _arg_1;
        }

        public function get tipGapV():int
        {
            return (this._tipGapV);
        }

        public function set tipGapV(_arg_1:int):void
        {
            this._tipGapV = _arg_1;
        }

        public function get tipStyle():String
        {
            return (this._tipStyle);
        }

        public function set tipStyle(_arg_1:String):void
        {
            this._tipStyle = _arg_1;
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        override public function dispose():void
        {
            super.dispose();
            ShowTipManager.Instance.removeTip(this);
        }


    }
}//package com.pickgliss.ui.text

