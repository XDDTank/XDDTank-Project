// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.common.MarriedIcon

package ddt.view.common
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.ITipedDisplay;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.ShowTipManager;
    import flash.display.DisplayObject;

    public class MarriedIcon extends Sprite implements ITipedDisplay 
    {

        private var _icon:Bitmap;
        private var _tipStyle:String;
        private var _tipDirctions:String;
        private var _tipData:Object;
        private var _tipGapH:int;
        private var _tipGapV:int;
        private var _gender:Boolean;

        public function MarriedIcon()
        {
            this._icon = ComponentFactory.Instance.creatBitmap("asset.core.MarriedIcon");
            addChild(this._icon);
            ShowTipManager.Instance.addTip(this);
        }

        public function dispose():void
        {
            ShowTipManager.Instance.removeTip(this);
            removeChild(this._icon);
            this._icon.bitmapData.dispose();
            this._icon = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function get tipStyle():String
        {
            return (this._tipStyle);
        }

        public function get tipData():Object
        {
            return (this._tipData);
        }

        public function get tipDirctions():String
        {
            return (this._tipDirctions);
        }

        public function get tipGapV():int
        {
            return (this._tipGapV);
        }

        public function get tipGapH():int
        {
            return (this._tipGapH);
        }

        public function set tipStyle(_arg_1:String):void
        {
            this._tipStyle = _arg_1;
        }

        public function set tipData(_arg_1:Object):void
        {
            this._tipData = _arg_1;
        }

        public function set tipDirctions(_arg_1:String):void
        {
            this._tipDirctions = _arg_1;
        }

        public function set tipGapV(_arg_1:int):void
        {
            this._tipGapV = _arg_1;
        }

        public function set tipGapH(_arg_1:int):void
        {
            this._tipGapH = _arg_1;
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }


    }
}//package ddt.view.common

