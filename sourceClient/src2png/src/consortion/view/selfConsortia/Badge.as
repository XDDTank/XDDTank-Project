// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.Badge

package consortion.view.selfConsortia
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.core.ITipedDisplay;
    import flash.display.Bitmap;
    import com.pickgliss.loader.BitmapLoader;
    import com.pickgliss.ui.ShowTipManager;
    import flash.events.MouseEvent;
    import ddt.manager.BadgeInfoManager;
    import consortion.data.BadgeInfo;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.LoaderEvent;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;

    public class Badge extends Sprite implements Disposeable, ITipedDisplay 
    {

        public static const LARGE:String = "large";
        public static const NORMAL:String = "normal";
        public static const SMALL:String = "small";
        private static const LARGE_SIZE:int = 78;
        private static const NORMAL_SIZE:int = 48;
        private static const SMALL_SIZE:int = 28;

        private var _size:String = "large";
        private var _badgeID:int = -1;
        private var _buyDate:Date;
        private var _badge:Bitmap;
        private var _loader:BitmapLoader;
        private var _clickEnale:Boolean = false;
        private var _tipInfo:Object;
        private var _tipDirctions:String;
        private var _tipGapH:int;
        private var _tipGapV:int;
        private var _tipStyle:String = "consortion.view.selfConsortia.BadgeTip";
        private var _showTip:Boolean;

        public function Badge(_arg_1:String="small")
        {
            this._size = _arg_1;
            graphics.beginFill(0xFFFFFF, 0);
            var _local_2:int;
            if (this._size == LARGE)
            {
                _local_2 = LARGE_SIZE;
            }
            else
            {
                if (this._size == NORMAL)
                {
                    _local_2 = NORMAL_SIZE;
                }
                else
                {
                    if (this._size == SMALL)
                    {
                        _local_2 = SMALL_SIZE;
                    };
                };
            };
            graphics.drawRect(0, 0, _local_2, _local_2);
            graphics.endFill();
            this._tipGapV = 5;
            this._tipGapH = 5;
            this._tipDirctions = "7,6,5";
            if (this._size == SMALL)
            {
                this._tipStyle = "ddt.view.tips.OneLineTip";
            }
            else
            {
                this._tipStyle = "consortion.view.selfConsortia.BadgeTip";
            };
        }

        public function get showTip():Boolean
        {
            return (this._showTip);
        }

        public function set showTip(_arg_1:Boolean):void
        {
            this._showTip = _arg_1;
            if (this._showTip)
            {
                ShowTipManager.Instance.addTip(this);
            }
            else
            {
                ShowTipManager.Instance.removeTip(this);
            };
        }

        public function get clickEnale():Boolean
        {
            return (this._clickEnale);
        }

        public function set clickEnale(_arg_1:Boolean):void
        {
            if (_arg_1 == this._clickEnale)
            {
                return;
            };
            this._clickEnale = _arg_1;
            if (this._clickEnale)
            {
                addEventListener(MouseEvent.CLICK, this.onClick);
            }
            else
            {
                removeEventListener(MouseEvent.CLICK, this.onClick);
            };
        }

        private function onClick(_arg_1:MouseEvent):void
        {
        }

        public function get buyDate():Date
        {
            return (this._buyDate);
        }

        public function set buyDate(_arg_1:Date):void
        {
            this._buyDate = _arg_1;
        }

        public function get badgeID():int
        {
            return (this._badgeID);
        }

        public function set badgeID(_arg_1:int):void
        {
            if (_arg_1 == this._badgeID)
            {
                return;
            };
            this._badgeID = _arg_1;
            this.getTipInfo();
            this.updateView();
        }

        private function getTipInfo():void
        {
            this._tipInfo = {};
            var _local_1:BadgeInfo = BadgeInfoManager.instance.getBadgeInfoByID(this._badgeID);
            if (_local_1)
            {
                this._tipInfo.name = _local_1.BadgeName;
                this._tipInfo.LimitLevel = _local_1.LimitLevel;
                this._tipInfo.ValidDate = _local_1.ValidDate;
                if (this._buyDate)
                {
                    this._tipInfo.buyDate = this._buyDate;
                };
            };
        }

        private function updateView():void
        {
            this.removeBadge();
            this._loader = LoadResourceManager.instance.createLoader(PathManager.solveBadgePath(this._badgeID), BaseLoader.BITMAP_LOADER);
            this._loader.addEventListener(LoaderEvent.COMPLETE, this.onComplete);
            this._loader.addEventListener(LoaderEvent.LOAD_ERROR, this.onError);
            LoadResourceManager.instance.startLoad(this._loader);
        }

        private function removeBadge():void
        {
            if (this._badge)
            {
                if (this._badge.parent)
                {
                    this._badge.parent.removeChild(this._badge);
                };
                this._badge.bitmapData.dispose();
                this._badge = null;
            };
        }

        private function onComplete(_arg_1:LoaderEvent):void
        {
            this._loader.removeEventListener(LoaderEvent.COMPLETE, this.onComplete);
            this._loader.removeEventListener(LoaderEvent.LOAD_ERROR, this.onError);
            if (this._loader.isSuccess)
            {
                this._badge = (this._loader.content as Bitmap);
                this._badge.smoothing = true;
                if (this._size == LARGE)
                {
                    this._badge.width = (this._badge.height = LARGE_SIZE);
                }
                else
                {
                    if (this._size == NORMAL)
                    {
                        this._badge.width = (this._badge.height = NORMAL_SIZE);
                    }
                    else
                    {
                        this._badge.width = (this._badge.height = SMALL_SIZE);
                    };
                };
                addChild(this._badge);
            };
        }

        private function onError(_arg_1:LoaderEvent):void
        {
            this._loader.removeEventListener(LoaderEvent.COMPLETE, this.onComplete);
            this._loader.removeEventListener(LoaderEvent.LOAD_ERROR, this.onError);
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function get tipData():Object
        {
            return (this._tipInfo);
        }

        public function set tipData(_arg_1:Object):void
        {
            this._tipInfo = _arg_1;
        }

        public function get tipDirctions():String
        {
            return (this._tipDirctions);
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

        public function dispose():void
        {
            ShowTipManager.Instance.removeTip(this);
            ObjectUtils.disposeObject(this._badge);
            this._badge = null;
            if (this._loader)
            {
                this._loader.removeEventListener(LoaderEvent.COMPLETE, this.onComplete);
                this._loader.removeEventListener(LoaderEvent.LOAD_ERROR, this.onError);
            };
            this._loader = null;
            this._tipInfo = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia

