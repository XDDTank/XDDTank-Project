// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.ConsortionSkillCell

package consortion.view.selfConsortia
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.core.ITipedDisplay;
    import consortion.data.ConsortionNewSkillInfo;
    import flash.display.Bitmap;
    import com.pickgliss.loader.DisplayLoader;
    import com.pickgliss.ui.ShowTipManager;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.LoaderEvent;
    import ddt.utils.PositionUtils;
    import ddt.manager.PathManager;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.DisplayObject;

    public class ConsortionSkillCell extends Sprite implements Disposeable, ITipedDisplay 
    {

        private var _info:ConsortionNewSkillInfo;
        private var _tipData:Object;
        private var _bg:Bitmap;
        private var _titleLoader:DisplayLoader;

        public function ConsortionSkillCell()
        {
            buttonMode = true;
            ShowTipManager.Instance.addTip(this);
        }

        public function dispose():void
        {
            ShowTipManager.Instance.removeTip(this);
            ObjectUtils.disposeAllChildren(this);
            this._bg = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }

        public function get tipData():Object
        {
            return (this._tipData);
        }

        public function set info(_arg_1:ConsortionNewSkillInfo):void
        {
            this._info = _arg_1;
            if (this._titleLoader)
            {
                this._titleLoader = null;
            };
            this._titleLoader = LoadResourceManager.instance.createLoader(this.path(), BaseLoader.BITMAP_LOADER);
            this._titleLoader.addEventListener(LoaderEvent.COMPLETE, this.__completeHandler);
            LoadResourceManager.instance.startLoad(this._titleLoader);
            this.tipData = this._info;
        }

        private function __completeHandler(_arg_1:LoaderEvent):void
        {
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (_arg_1.loader.isSuccess)
            {
                _arg_1.loader.removeEventListener(LoaderEvent.COMPLETE, this.__completeHandler);
                this._bg = (_arg_1.loader.content as Bitmap);
                PositionUtils.setPos(this._bg, "asset.consortion.skillIcon.pos");
                this.contentRect(54, 54);
                addChild(this._bg);
                this._bg.smoothing = true;
            };
        }

        private function path():String
        {
            return (((PathManager.SITE_MAIN + "/image/") + this._info.Pic) + "/icon.png");
        }

        public function get info():ConsortionNewSkillInfo
        {
            return (this._info);
        }

        public function set tipData(_arg_1:Object):void
        {
            this._tipData = _arg_1;
        }

        public function isLearn(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this.filters = null;
            }
            else
            {
                this.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            };
        }

        public function contentRect(_arg_1:int, _arg_2:int):void
        {
            this._bg.width = _arg_1;
            this._bg.height = _arg_2;
        }

        public function setGray(_arg_1:Boolean):void
        {
            if ((!(_arg_1)))
            {
                this.filters = null;
            };
        }

        public function get tipDirctions():String
        {
            return ("0,1,2");
        }

        public function set tipDirctions(_arg_1:String):void
        {
        }

        public function get tipGapH():int
        {
            return (0);
        }

        public function set tipGapH(_arg_1:int):void
        {
        }

        public function get tipGapV():int
        {
            return (0);
        }

        public function set tipGapV(_arg_1:int):void
        {
        }

        public function get tipStyle():String
        {
            return ("ddt.view.tips.SkillTipPanel");
        }

        public function set tipStyle(_arg_1:String):void
        {
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function get tipWidth():int
        {
            return (200);
        }

        public function set tipWidth(_arg_1:int):void
        {
        }

        public function get tipHeight():int
        {
            return (-1);
        }

        public function set tipHeight(_arg_1:int):void
        {
        }


    }
}//package consortion.view.selfConsortia

