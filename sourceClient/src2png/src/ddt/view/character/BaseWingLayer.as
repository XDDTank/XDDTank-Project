// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.BaseWingLayer

package ddt.view.character
{
    import flash.display.Sprite;
    import ddt.data.goods.ItemTemplateInfo;
    import com.pickgliss.loader.ModuleLoader;
    import flash.display.MovieClip;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.LoaderEvent;
    import flash.display.DisplayObject;
    import ddt.manager.PathManager;

    public class BaseWingLayer extends Sprite implements ILayer 
    {

        public static const SHOW_WING:int = 0;
        public static const GAME_WING:int = 1;

        protected var _info:ItemTemplateInfo;
        protected var _callBack:Function;
        protected var _loader:ModuleLoader;
        protected var _showType:int = 0;
        protected var _wing:MovieClip;
        private var _isComplete:Boolean;

        public function BaseWingLayer(_arg_1:ItemTemplateInfo, _arg_2:int=0)
        {
            this._info = _arg_1;
            this._showType = _arg_2;
            super();
        }

        protected function initLoader():void
        {
            if ((!(ClassUtils.uiSourceDomain.hasDefinition(((("wing_" + this.getshowTypeString()) + "_") + this.info.TemplateID)))))
            {
                this._loader = LoadResourceManager.instance.createLoader(this.getUrl(), BaseLoader.MODULE_LOADER);
                this._loader.addEventListener(LoaderEvent.COMPLETE, this.__sourceComplete);
                LoadResourceManager.instance.startLoad(this._loader);
            }
            else
            {
                this.__sourceComplete();
            };
        }

        protected function __sourceComplete(_arg_1:LoaderEvent=null):void
        {
            var _local_2:Object;
            if (this.info == null)
            {
                return;
            };
            if (this._loader)
            {
                this._loader.removeEventListener(LoaderEvent.COMPLETE, this.__sourceComplete);
            };
            if (((!(_arg_1 == null)) && (!(_arg_1.loader.isSuccess))))
            {
                this._wing = null;
            }
            else
            {
                _local_2 = (ClassUtils.uiSourceDomain.getDefinition(((("wing_" + this.getshowTypeString()) + "_") + this.info.TemplateID)) as Class);
                this._wing = new (_local_2)();
            };
            this._isComplete = true;
            if (this._callBack != null)
            {
                this._callBack(this);
            };
        }

        public function setColor(_arg_1:*):Boolean
        {
            return (false);
        }

        public function get info():ItemTemplateInfo
        {
            return (this._info);
        }

        public function set info(_arg_1:ItemTemplateInfo):void
        {
            this._info = _arg_1;
        }

        public function getContent():DisplayObject
        {
            return (this._wing);
        }

        public function dispose():void
        {
            if (this._loader)
            {
                this._loader.removeEventListener(LoaderEvent.COMPLETE, this.__sourceComplete);
                this._loader = null;
            };
            this._wing = null;
            this._callBack = null;
            this._info = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function load(_arg_1:Function):void
        {
            this._callBack = _arg_1;
            this.initLoader();
        }

        private function loadLayerComplete():void
        {
        }

        public function set currentEdit(_arg_1:int):void
        {
        }

        public function get currentEdit():int
        {
            return (0);
        }

        override public function get width():Number
        {
            return (0);
        }

        override public function get height():Number
        {
            return (0);
        }

        protected function getUrl():String
        {
            return (PathManager.soloveWingPath(this.info.Pic));
        }

        public function getshowTypeString():String
        {
            if (this._showType == 0)
            {
                return ("show");
            };
            return ("game");
        }

        public function get isComplete():Boolean
        {
            return (this._isComplete);
        }


    }
}//package ddt.view.character

