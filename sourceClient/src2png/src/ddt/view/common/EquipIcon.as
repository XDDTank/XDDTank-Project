// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.common.EquipIcon

package ddt.view.common
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.ITipedDisplay;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.ShowTipManager;
    import ddt.data.player.PlayerInfo;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;

    public class EquipIcon extends Sprite implements ITipedDisplay, Disposeable 
    {

        public static const TIPGAPH:int = 10;
        public static const TIPGAPV:int = 10;

        private var _seniorIcon:ScaleFrameImage;
        private var _tipDirctions:String;
        private var _tipGapH:int;
        private var _tipGapV:int;
        private var _tipStyle:String;
        private var _tipData:Object;

        public function EquipIcon()
        {
            this._tipStyle = "";
            this._tipGapV = TIPGAPV;
            this._tipGapH = TIPGAPH;
            ShowTipManager.Instance.addTip(this);
        }

        public function setInfo(_arg_1:PlayerInfo, _arg_2:Boolean=true):void
        {
            if (this._tipData == _arg_1)
            {
                return;
            };
            this._tipData = _arg_1;
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
            return (0);
        }

        public function get tipGapH():int
        {
            return (0);
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
        }

        public function set tipGapV(_arg_1:int):void
        {
        }

        public function set tipGapH(_arg_1:int):void
        {
        }

        public function asDisplayObject():DisplayObject
        {
            return (null);
        }

        public function dispose():void
        {
            ShowTipManager.Instance.removeTip(this);
            ObjectUtils.disposeObject(this._seniorIcon);
            this._seniorIcon = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view.common

