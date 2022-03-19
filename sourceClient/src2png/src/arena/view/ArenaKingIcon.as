// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//arena.view.ArenaKingIcon

package arena.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.ITipedDisplay;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.MovieClip;
    import ddt.data.player.PlayerInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.ShowTipManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ArenaKingIcon extends Sprite implements ITipedDisplay, Disposeable 
    {

        private var _tipDirctions:String;
        private var _tipGapH:int;
        private var _tipGapV:int;
        private var _tipStyle:String;
        private var _tipData:String;
        private var _size:int;
        private var _iconM:MovieClip;
        private var _iconF:MovieClip;
        private var _info:PlayerInfo;

        public function ArenaKingIcon(_arg_1:PlayerInfo)
        {
            this._info = _arg_1;
            this.initView();
        }

        private function initView():void
        {
            if (this._info.Sex)
            {
                this._iconM = (ComponentFactory.Instance.creat("movieclip.ddtarena.kingiocnM") as MovieClip);
                addChild(this._iconM);
            }
            else
            {
                this._iconF = (ComponentFactory.Instance.creat("movieclip.ddtarena.kingiocnF") as MovieClip);
                addChild(this._iconF);
            };
            this._tipStyle = "ddt.view.tips.OneLineTip";
            this._tipGapV = 10;
            this._tipGapH = 10;
            this._tipDirctions = "7,4,6,5";
            this.tipData = LanguageMgr.GetTranslation("ddt.arena.arena.kingiconTips");
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
            this._tipData = (_arg_1 as String);
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

        public function get tipWidth():int
        {
            return (0);
        }

        public function set tipWidth(_arg_1:int):void
        {
        }

        public function asDisplayObject():DisplayObject
        {
            return (null);
        }

        public function dispose():void
        {
            ShowTipManager.Instance.removeTip(this);
            ObjectUtils.disposeObject(this._iconM);
            this._iconM = null;
            ObjectUtils.disposeObject(this._iconF);
            this._iconF = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package arena.view

