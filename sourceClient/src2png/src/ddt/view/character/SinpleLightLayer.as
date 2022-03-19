// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.SinpleLightLayer

package ddt.view.character
{
    import flash.display.Sprite;
    import flash.display.MovieClip;
    import com.pickgliss.loader.ModuleLoader;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.LoaderEvent;
    import ddt.manager.PathManager;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.display.DisplayObject;

    public class SinpleLightLayer extends Sprite implements ILayer 
    {

        private var _light:MovieClip;
        private var _type:int;
        private var _callBack:Function;
        private var _loader:ModuleLoader;
        private var _nimbus:int;
        private var _isComplete:Boolean;

        public function SinpleLightLayer(_arg_1:int, _arg_2:int=0)
        {
            this._nimbus = _arg_1;
            this._type = _arg_2;
        }

        public function load(_arg_1:Function):void
        {
            this._callBack = _arg_1;
            this.initLoader();
        }

        protected function initLoader():void
        {
            if (this._nimbus < 100)
            {
                return;
            };
            if ((!(ClassUtils.uiSourceDomain.hasDefinition(("game.crazyTank.view.light.SinpleLightAsset_" + this.getId())))))
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

        private function getId():String
        {
            var _local_1:int = int(int((this._nimbus / 100)));
            return (_local_1.toString());
        }

        protected function __sourceComplete(_arg_1:LoaderEvent=null):void
        {
            var _local_2:Object;
            if (this._loader)
            {
                this._loader.removeEventListener(LoaderEvent.COMPLETE, this.__sourceComplete);
            };
            if (((!(_arg_1 == null)) && (!(_arg_1.loader.isSuccess))))
            {
                this._light = null;
            }
            else
            {
                _local_2 = (ClassUtils.uiSourceDomain.getDefinition(("game.crazyTank.view.light.SinpleLightAsset_" + this.getId())) as Class);
                this._light = (new (_local_2)() as MovieClip);
            };
            this._isComplete = true;
            if (this._callBack != null)
            {
                this._callBack(this);
            };
        }

        protected function getUrl():String
        {
            return (PathManager.soloveSinpleLightPath(this.getId()));
        }

        public function getshowTypeString():String
        {
            if (this._type == 0)
            {
                return ("show");
            };
            return ("game");
        }

        public function get info():ItemTemplateInfo
        {
            return (null);
        }

        public function set info(_arg_1:ItemTemplateInfo):void
        {
        }

        public function getContent():DisplayObject
        {
            return (this._light);
        }

        public function dispose():void
        {
            if (((this._light) && (this._light.parent)))
            {
                this._light.parent.removeChild(this._light);
            };
            this._light = null;
            this._callBack = null;
            if (this._loader)
            {
                this._loader.removeEventListener(LoaderEvent.COMPLETE, this.__sourceComplete);
            };
            this._loader = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }

        public function set currentEdit(_arg_1:int):void
        {
        }

        public function get currentEdit():int
        {
            return (0);
        }

        public function setColor(_arg_1:*):Boolean
        {
            return (false);
        }

        public function get isComplete():Boolean
        {
            return (this._isComplete);
        }


    }
}//package ddt.view.character

