// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.item.PetBigItem

package petsBag.view.item
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import road.game.resource.ActionMovie;
    import ddt.display.BitmapLoaderProxy;
    import com.pickgliss.loader.BaseLoader;
    import flash.display.MovieClip;
    import flash.display.Bitmap;
    import com.pickgliss.loader.LoaderEvent;
    import road.game.resource.ActionMovieEvent;
    import com.pickgliss.loader.ModuleLoader;
    import ddt.utils.Helpers;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.PetBagManager;
    import ddt.manager.PetInfoManager;
    import pet.date.PetInfo;
    import com.pickgliss.ui.ShowTipManager;
    import flash.utils.getTimer;
    import flash.display.BitmapData;

    public class PetBigItem extends PetBaseItem 
    {

        protected var _bg:DisplayObject;
        protected var _movieContainer:Sprite;
        protected var _petMovie:ActionMovie;
        protected var ACTIONS:Array = ["standA", "walkA", "walkB"];
        protected var _petIcon:BitmapLoaderProxy;
        protected var _locked:Boolean;
        protected var _loader:BaseLoader;
        protected var _effectLoader:BaseLoader;
        protected var _advanceEffect:MovieClip;
        private var _dragImg:Bitmap;
        protected var _lastTime:uint = 0;

        public function PetBigItem(_arg_1:DisplayObject=null)
        {
            this._bg = ((_arg_1) ? _arg_1 : this.getDefaultBg());
            super();
            this.initTips();
        }

        override public function set info(_arg_1:PetInfo):void
        {
            var _local_2:Class;
            var _local_3:String;
            var _local_4:Class;
            super.info = _arg_1;
            tipData = _arg_1;
            if (_info)
            {
                if ((((!(_info)) || (!(_lastInfo))) || (!(_info.TemplateID == _lastInfo.TemplateID))))
                {
                    if (this._loader)
                    {
                        this._loader.removeEventListener(LoaderEvent.COMPLETE, this.__onComplete);
                    };
                    if (this._petMovie)
                    {
                        this._petMovie.removeEventListener(ActionMovieEvent.ACTION_END, this.doNextAction);
                        this._petMovie.dispose();
                        this._petMovie = null;
                    };
                    if (ModuleLoader.hasDefinition(("pet.asset.game." + _arg_1.GameAssetUrl)))
                    {
                        _local_2 = (ModuleLoader.getDefinition(("pet.asset.game." + _arg_1.GameAssetUrl)) as Class);
                        this._petMovie = new (_local_2)();
                        this._petMovie.doAction(Helpers.randomPick(this.ACTIONS));
                        this._petMovie.addEventListener(ActionMovieEvent.ACTION_END, this.doNextAction);
                        this._petMovie.visible = (!(this._locked));
                        this._movieContainer.addChild(this._petMovie);
                    }
                    else
                    {
                        this._loader = LoadResourceManager.instance.createLoader(PathManager.solvePetGameAssetUrl(_arg_1.GameAssetUrl), BaseLoader.MODULE_LOADER);
                        this._loader.addEventListener(LoaderEvent.COMPLETE, this.__onComplete);
                        LoadResourceManager.instance.startLoad(this._loader);
                    };
                    ObjectUtils.disposeObject(this._petIcon);
                    this._petIcon = new BitmapLoaderProxy(PathManager.solvePetIconUrl(PetBagManager.instance().getPicStr(_info)), null, true);
                };
                if ((((!(_info)) || (!(_lastInfo))) || (!(int((_info.OrderNumber / 10)) == int((_lastInfo.OrderNumber / 10))))))
                {
                    _local_3 = PetInfoManager.instance.getAdvanceEffectUrl(_arg_1);
                    if (this._advanceEffect)
                    {
                        ObjectUtils.disposeObject(this._advanceEffect);
                    };
                    if (_info.OrderNumber >= 10)
                    {
                        if (ModuleLoader.hasDefinition(("asset.game.pet." + _local_3)))
                        {
                            _local_4 = (ModuleLoader.getDefinition(("asset.game.pet." + _local_3)) as Class);
                            this._advanceEffect = new (_local_4)();
                            addChild(this._advanceEffect);
                        }
                        else
                        {
                            if (this._effectLoader)
                            {
                                this._effectLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onEffectComplete);
                            };
                            this._effectLoader = LoadResourceManager.instance.createLoader(PathManager.solvePetAdvanceEffect(_local_3), BaseLoader.MODULE_LOADER);
                            this._effectLoader.addEventListener(LoaderEvent.COMPLETE, this.__onEffectComplete);
                            LoadResourceManager.instance.startLoad(this._effectLoader);
                        };
                    };
                };
            }
            else
            {
                ObjectUtils.disposeObject(this._petIcon);
                this._petIcon = null;
                if (this._petMovie)
                {
                    this._petMovie.removeEventListener(ActionMovieEvent.ACTION_END, this.doNextAction);
                    this._petMovie.dispose();
                    this._petMovie = null;
                };
                if (this._loader)
                {
                    this._loader.removeEventListener(LoaderEvent.COMPLETE, this.__onComplete);
                    this._loader = null;
                };
                if (this._advanceEffect)
                {
                    ObjectUtils.disposeObject(this._advanceEffect);
                    this._advanceEffect = null;
                };
                if (this._effectLoader)
                {
                    this._effectLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onEffectComplete);
                    this._effectLoader = null;
                };
                ObjectUtils.disposeObject(this._petIcon);
                this._petIcon = null;
            };
        }

        protected function initTips():void
        {
            tipStyle = "ddt.view.tips.PetInfoTip";
            tipDirctions = "5,2,7,1,6,4";
            ShowTipManager.Instance.addTip(this);
        }

        override public function get height():Number
        {
            return (this._bg.height);
        }

        override public function get width():Number
        {
            return (this._bg.width);
        }

        override protected function initView():void
        {
            addChild(this._bg);
            this._movieContainer = new Sprite();
            addChild(this._movieContainer);
        }

        private function getDefaultBg():Sprite
        {
            var _local_1:Sprite = new Sprite();
            _local_1.graphics.beginFill(0, 0);
            _local_1.graphics.drawRect(-30, -50, 60, 60);
            return (_local_1);
        }

        private function __onComplete(_arg_1:LoaderEvent):void
        {
            var _local_2:Class;
            this._loader.removeEventListener(LoaderEvent.COMPLETE, this.__onComplete);
            if (ModuleLoader.hasDefinition(("pet.asset.game." + _info.GameAssetUrl)))
            {
                _local_2 = (ModuleLoader.getDefinition(("pet.asset.game." + _info.GameAssetUrl)) as Class);
                this._petMovie = new (_local_2)();
                this._petMovie.doAction(Helpers.randomPick(this.ACTIONS));
                this._petMovie.addEventListener(ActionMovieEvent.ACTION_END, this.doNextAction);
                this._petMovie.visible = (!(this._locked));
                this._movieContainer.addChild(this._petMovie);
            };
        }

        private function __onEffectComplete(_arg_1:LoaderEvent):void
        {
            var _local_3:Class;
            this._effectLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onEffectComplete);
            if ((!(_info)))
            {
                return;
            };
            var _local_2:String = PetInfoManager.instance.getAdvanceEffectUrl(_info);
            if (ModuleLoader.hasDefinition(("asset.game.pet." + _local_2)))
            {
                _local_3 = (ModuleLoader.getDefinition(("asset.game.pet." + _local_2)) as Class);
                this._advanceEffect = new (_local_3)();
                addChild(this._advanceEffect);
            };
        }

        private function doNextAction(_arg_1:ActionMovieEvent):void
        {
            if (this._petMovie)
            {
                if ((getTimer() - this._lastTime) > 40)
                {
                    this._petMovie.doAction(Helpers.randomPick(this.ACTIONS));
                };
                this._lastTime = getTimer();
            };
        }

        override public function dispose():void
        {
            ShowTipManager.Instance.removeTip(this);
            super.dispose();
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            if (this._petMovie)
            {
                this._petMovie.removeEventListener(ActionMovieEvent.ACTION_END, this.doNextAction);
            };
            ObjectUtils.disposeObject(this._petMovie);
            this._petMovie = null;
            ObjectUtils.disposeObject(this._movieContainer);
            this._movieContainer = null;
            _info = null;
            if (this._loader)
            {
                this._loader.removeEventListener(LoaderEvent.COMPLETE, this.__onComplete);
            };
            this._loader = null;
            if (this._effectLoader)
            {
                this._effectLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onEffectComplete);
            };
            this._effectLoader = null;
            ObjectUtils.disposeObject(this._advanceEffect);
            this._advanceEffect = null;
            ObjectUtils.disposeObject(this._petIcon);
            this._petIcon = null;
            ObjectUtils.disposeObject(this._dragImg);
            this._dragImg = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        override public function set locked(_arg_1:Boolean):void
        {
            super.locked = _arg_1;
        }

        override protected function createDragImg():DisplayObject
        {
            ObjectUtils.disposeObject(this._dragImg);
            this._dragImg = null;
            if ((((this._petIcon) && (this._petIcon.width > 0)) && (this._petIcon.height > 0)))
            {
                this._dragImg = new Bitmap(new BitmapData((this._petIcon.width / this._petIcon.scaleX), (this._petIcon.height / this._petIcon.scaleY), true, 0));
                this._dragImg.bitmapData.draw(this._petIcon);
            };
            return (this._dragImg);
        }


    }
}//package petsBag.view.item

