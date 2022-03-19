// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.BaseLayer

package ddt.view.character
{
    import flash.display.Sprite;
    import com.pickgliss.loader.LoaderQueue;
    import ddt.data.goods.ItemTemplateInfo;
    import __AS3__.vec.Vector;
    import flash.display.Bitmap;
    import com.pickgliss.loader.BitmapLoader;
    import com.pickgliss.loader.LoadResourceManager;
    import com.pickgliss.loader.BaseLoader;
    import flash.geom.ColorTransform;
    import road7th.utils.StringHelper;
    import ddt.utils.BitmapUtils;
    import flash.display.BlendMode;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.Event;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.LoaderEvent;
    import __AS3__.vec.*;

    public class BaseLayer extends Sprite implements ILayer 
    {

        public static const ICON:String = "icon";
        public static const SHOW:String = "show";
        public static const GAME:String = "game";
        public static const CONSORTIA:String = "consortia";
        public static const STATE:String = "state";

        protected var _queueLoader:LoaderQueue;
        protected var _info:ItemTemplateInfo;
        protected var _colors:Array;
        protected var _gunBack:Boolean;
        protected var _hairType:String;
        protected var _currentEdit:uint;
        private var _callBack:Function;
        protected var _color:String;
        protected var _defaultLayer:uint;
        protected var _bitmaps:Vector.<Bitmap>;
        private var _isAllLoadSucceed:Boolean = true;
        protected var _pic:String;
        private var _isComplete:Boolean;

        public function BaseLayer(_arg_1:ItemTemplateInfo, _arg_2:String="", _arg_3:Boolean=false, _arg_4:int=1, _arg_5:String=null)
        {
            this._info = _arg_1;
            this._color = ((_arg_2 == null) ? "" : _arg_2);
            this._gunBack = _arg_3;
            this._hairType = ((_arg_4 == 1) ? "B" : "A");
            this._pic = (((_arg_5 == null) || (String(_arg_5) == "undefined")) ? this._info.Pic : _arg_5);
            super();
            this.init();
        }

        private function init():void
        {
            this._queueLoader = new LoaderQueue();
            this._bitmaps = new Vector.<Bitmap>();
            this._colors = [];
            this.initLoaders();
        }

        protected function initLoaders():void
        {
            var _local_1:int;
            var _local_2:String;
            var _local_3:BitmapLoader;
            if (this._info != null)
            {
                _local_1 = 0;
                while (_local_1 < this._info.Property8.length)
                {
                    _local_2 = this.getUrl(int(this._info.Property8.charAt(_local_1)));
                    _local_3 = LoadResourceManager.instance.createLoader(_local_2, BaseLoader.BITMAP_LOADER);
                    this._queueLoader.addLoader(_local_3);
                    _local_1++;
                };
                this._defaultLayer = 0;
                this._currentEdit = this._queueLoader.length;
            };
        }

        protected function initColors(_arg_1:String):void
        {
            var _local_3:int;
            var _local_4:ColorTransform;
            var _local_5:Bitmap;
            this._colors = _arg_1.split("|");
            if (this._bitmaps.length == 0)
            {
                return;
            };
            while (numChildren > 0)
            {
                removeChildAt(0);
            };
            var _local_2:int;
            while (_local_2 < this._bitmaps.length)
            {
                if (this._bitmaps[_local_2])
                {
                    addChild(this._bitmaps[_local_2]);
                    this._bitmaps[_local_2].visible = false;
                };
                _local_2++;
            };
            if (this._bitmaps[this._defaultLayer])
            {
                this._bitmaps[this._defaultLayer].visible = true;
            };
            if (this._colors.length == this._bitmaps.length)
            {
                _local_3 = 0;
                for (;_local_3 < this._colors.length;_local_3++)
                {
                    if ((((!(StringHelper.isNullOrEmpty(this._colors[_local_3]))) && (!(this._colors[_local_3].toString() == "undefined"))) && (!(this._colors[_local_3].toString() == "null"))))
                    {
                        if (this._bitmaps[_local_3] == null) continue;
                        this._bitmaps[_local_3].visible = true;
                        this._bitmaps[_local_3].transform.colorTransform = BitmapUtils.getColorTransfromByColor(this._colors[_local_3]);
                        _local_4 = BitmapUtils.getHightlightColorTransfrom(this._colors[_local_3]);
                        _local_5 = new Bitmap(this._bitmaps[_local_3].bitmapData, "auto", true);
                        if (_local_4)
                        {
                            _local_5.transform.colorTransform = _local_4;
                        };
                        _local_5.blendMode = BlendMode.HARDLIGHT;
                        addChild(_local_5);
                    }
                    else
                    {
                        if (this._bitmaps[_local_3] != null)
                        {
                            this._bitmaps[_local_3].transform.colorTransform = new ColorTransform();
                        };
                    };
                };
            };
        }

        public function getContent():DisplayObject
        {
            return (this);
        }

        public function setColor(_arg_1:*):Boolean
        {
            if (((this._info == null) || (_arg_1 == null)))
            {
                return (false);
            };
            this._color = String(_arg_1);
            this.initColors(_arg_1);
            return (true);
        }

        public function get info():ItemTemplateInfo
        {
            return (this._info);
        }

        public function set info(_arg_1:ItemTemplateInfo):void
        {
            if (this.info == _arg_1)
            {
                return;
            };
            this.clear();
            this._info = _arg_1;
            if (this._info)
            {
                this.initLoaders();
                this.load(this._callBack);
            };
        }

        public function set currentEdit(_arg_1:int):void
        {
            this._currentEdit = _arg_1;
            if (this._currentEdit > this._bitmaps.length)
            {
                this._currentEdit = this._bitmaps.length;
            }
            else
            {
                if (this._currentEdit < 1)
                {
                    this._currentEdit = 1;
                };
            };
        }

        public function get currentEdit():int
        {
            return (this._currentEdit);
        }

        public function dispose():void
        {
            this.clear();
            this._info = null;
            this._callBack = null;
            this._bitmaps = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        protected function clearBitmap():void
        {
            ObjectUtils.disposeAllChildren(this);
            this._bitmaps = new Vector.<Bitmap>();
        }

        protected function clear():void
        {
            if (this._queueLoader)
            {
                this._queueLoader.removeEventListener(Event.COMPLETE, this.__loadComplete);
                this._queueLoader.dispose();
                this._queueLoader = null;
            };
            this.clearBitmap();
            this._colors = [];
        }

        final public function load(_arg_1:Function):void
        {
            this._callBack = _arg_1;
            if (this._info == null)
            {
                this.loadCompleteCallBack();
                return;
            };
            this._queueLoader.addEventListener(Event.COMPLETE, this.__loadComplete);
            this._queueLoader.start();
        }

        protected function getUrl(_arg_1:int):String
        {
            return (PathManager.solveGoodsPath(this._info, this._pic, (this._info.NeedSex == 1), SHOW, this._hairType, String(_arg_1), this._info.Level, this._gunBack, int(this._info.Property1)));
        }

        protected function __loadComplete(_arg_1:Event):void
        {
            this.reSetBitmap();
            this._queueLoader.removeEventListener(Event.COMPLETE, this.__loadComplete);
            this._queueLoader.removeEvent();
            this.initColors(this._color);
            this.loadCompleteCallBack();
        }

        public function reSetBitmap():void
        {
            this.clearBitmap();
            var _local_1:int;
            while (_local_1 < this._queueLoader.loaders.length)
            {
                this._bitmaps.push(this._queueLoader.loaders[_local_1].content);
                if (this._bitmaps[_local_1])
                {
                    this._bitmaps[_local_1].smoothing = true;
                    this._bitmaps[_local_1].visible = false;
                    addChild(this._bitmaps[_local_1]);
                };
                _local_1++;
            };
        }

        protected function loadCompleteCallBack():void
        {
            this._isComplete = true;
            if (this._callBack != null)
            {
                this._callBack(this);
            };
            dispatchEvent(new Event(Event.COMPLETE));
        }

        private function __onBitmapError(_arg_1:LoaderEvent):void
        {
            this._isAllLoadSucceed = false;
        }

        public function get isAllLoadSucceed():Boolean
        {
            return (this._isAllLoadSucceed);
        }

        public function get isComplete():Boolean
        {
            return (this._isComplete);
        }


    }
}//package ddt.view.character

