// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.common.TotemIcon

package ddt.view.common
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.ITipedDisplay;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.data.player.PlayerInfo;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.ShowTipManager;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;
    import totem.TotemManager;

    public class TotemIcon extends Sprite implements ITipedDisplay, Disposeable 
    {

        private var _iconBitmap:Bitmap;
        private var _levelTxt:FilterFrameText;
        private var _tipDictions:String;
        private var _tipGapH:int;
        private var _tipGapV:int;
        private var _tipStyle:String;
        private var _playerInfo:PlayerInfo;
        private var _tipData:Object;
        private var _Level:int;

        public function TotemIcon()
        {
            this._iconBitmap = ComponentFactory.Instance.creatBitmap("asset.ddtbagAndInfo.TotemIcon");
            addChild(this._iconBitmap);
            this._levelTxt = ComponentFactory.Instance.creatComponentByStylename("ddtbagAndInfo.TotemIcon.text");
            addChild(this._levelTxt);
            this._tipStyle = "core.TotemIconTips";
            this._tipGapH = 5;
            this._tipGapV = 5;
            this._tipDictions = "2,1,0";
            mouseChildren = true;
            mouseEnabled = true;
            ShowTipManager.Instance.addTip(this);
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function dispose():void
        {
            ShowTipManager.Instance.removeTip(this);
            if (this._iconBitmap)
            {
                ObjectUtils.disposeObject(this._iconBitmap);
                this._iconBitmap = null;
            };
            if (this._levelTxt)
            {
                ObjectUtils.disposeObject(this._levelTxt);
                this._levelTxt = null;
            };
            this._playerInfo = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function setInfo(_arg_1:PlayerInfo):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            this._playerInfo = _arg_1;
            var _local_2:int = TotemManager.instance.getTotemPointLevel(this._playerInfo.totemId);
            this._Level = TotemManager.instance.getCurrentLv(_local_2);
            this._levelTxt.text = this._Level.toString();
            if (this._Level == 0)
            {
                this.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                this.tipData = "当前没有全部激活整页图腾";
                this._levelTxt.visible = false;
            }
            else
            {
                this.filters = null;
                this.tipData = this._playerInfo;
                this._levelTxt.visible = true;
            };
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
            return (this._tipDictions);
        }

        public function set tipDirctions(_arg_1:String):void
        {
            this._tipDictions = _arg_1;
        }

        public function get tipGapH():int
        {
            return (this._tipGapH);
        }

        public function set tipGapH(_arg_1:int):void
        {
            this._tipGapH = _arg_1;
        }

        public function set tipGapV(_arg_1:int):void
        {
            this._tipGapV = _arg_1;
        }

        public function get tipGapV():int
        {
            return (this._tipGapV);
        }

        public function get tipStyle():String
        {
            return (this._tipStyle);
        }

        public function set tipStyle(_arg_1:String):void
        {
            this._tipStyle = _arg_1;
        }


    }
}//package ddt.view.common

