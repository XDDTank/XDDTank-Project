// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.common.SuidIcon

package ddt.view.common
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.ITipedDisplay;
    import com.pickgliss.ui.core.Disposeable;
    import flash.utils.Dictionary;
    import ddt.data.player.PlayerInfo;
    import com.pickgliss.ui.ShowTipManager;
    import flash.display.DisplayObject;
    import flash.display.Bitmap;
    import ddt.data.goods.InventoryItemInfo;
    import com.pickgliss.ui.ComponentFactory;

    public class SuidIcon extends Sprite implements ITipedDisplay, Disposeable 
    {

        public static const MAX_EQUIP:int = 6;
        private static const SUID_ICON_BITMAP:String = "asset.SuitIcon.Level_";

        private var _SuidLevelBitmaps:Dictionary;
        private var _tipDictions:String;
        private var _tipGapH:int;
        private var _tipGapV:int;
        private var _tipStyle:String;
        private var _bmContainer:Sprite;
        private var _playerInfo:PlayerInfo;
        private var _tipData:Object;
        private var _suidLevel:int;

        public function SuidIcon()
        {
            this._SuidLevelBitmaps = new Dictionary();
            this._tipStyle = "core.SuidTips";
            this._tipGapH = 5;
            this._tipGapV = 5;
            this._tipDictions = "2";
            mouseChildren = true;
            mouseEnabled = false;
            this._bmContainer = new Sprite();
            this._bmContainer.buttonMode = false;
            addChild(this._bmContainer);
            ShowTipManager.Instance.addTip(this);
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function dispose():void
        {
            var _local_1:String;
            var _local_2:Bitmap;
            ShowTipManager.Instance.removeTip(this);
            this.clearnDisplay();
            for (_local_1 in this._SuidLevelBitmaps)
            {
                _local_2 = this._SuidLevelBitmaps[_local_1];
                _local_2.bitmapData.dispose();
                delete this._SuidLevelBitmaps[_local_1];
            };
            this._SuidLevelBitmaps = null;
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
            this.updateLevle();
            this.updateView();
        }

        private function updateLevle():void
        {
            var _local_3:InventoryItemInfo;
            var _local_7:int;
            var _local_1:Array = new Array();
            var _local_2:Array = new Array();
            var _local_4:int = int.MAX_VALUE;
            var _local_5:int = 10;
            while (_local_5 < 16)
            {
                _local_3 = this._playerInfo.Bag.getItemAt(_local_5);
                if (_local_3 != null)
                {
                    _local_1.push(_local_3);
                };
                _local_5++;
            };
            var _local_6:int;
            while (_local_6 < _local_1.length)
            {
                _local_2.push(_local_1[_local_6].StrengthenLevel);
                _local_6++;
            };
            for each (_local_7 in _local_2)
            {
                _local_4 = ((_local_7 > _local_4) ? _local_4 : _local_7);
            };
            if (MAX_EQUIP > _local_1.length)
            {
                this._suidLevel = 10;
                this._playerInfo.EquipNum = _local_1.length;
                this.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            }
            else
            {
                if (((_local_4 >= 10) && (_local_4 < 20)))
                {
                    this._playerInfo.EquipNum = 6;
                    this._suidLevel = 10;
                    this.filters = null;
                }
                else
                {
                    if (((_local_4 >= 20) && (_local_4 < 30)))
                    {
                        this._playerInfo.EquipNum = 6;
                        this._suidLevel = 20;
                        this.filters = null;
                    }
                    else
                    {
                        if (((_local_4 >= 30) && (_local_4 < 35)))
                        {
                            this._playerInfo.EquipNum = 6;
                            this._suidLevel = 30;
                            this.filters = null;
                        }
                        else
                        {
                            if (((_local_4 >= 35) && (_local_4 < 40)))
                            {
                                this._playerInfo.EquipNum = 6;
                                this._suidLevel = 35;
                                this.filters = null;
                            }
                            else
                            {
                                if (((_local_4 >= 40) && (_local_4 < 45)))
                                {
                                    this._playerInfo.EquipNum = 6;
                                    this._suidLevel = 40;
                                    this.filters = null;
                                }
                                else
                                {
                                    if (((_local_4 >= 45) && (_local_4 < 50)))
                                    {
                                        this._playerInfo.EquipNum = 6;
                                        this._suidLevel = 45;
                                        this.filters = null;
                                    }
                                    else
                                    {
                                        if (((_local_4 >= 50) && (_local_4 < 55)))
                                        {
                                            this._playerInfo.EquipNum = 6;
                                            this._suidLevel = 50;
                                            this.filters = null;
                                        }
                                        else
                                        {
                                            if (_local_4 >= 55)
                                            {
                                                this._playerInfo.EquipNum = 6;
                                                this._suidLevel = 55;
                                                this.filters = null;
                                            }
                                            else
                                            {
                                                this._suidLevel = 10;
                                                this._playerInfo.EquipNum = 1;
                                                this.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            this._playerInfo.SuidLevel = this._suidLevel;
            this.tipData = this._playerInfo;
        }

        private function updateView():void
        {
            this.clearnDisplay();
            this.addSuitLevelBitmap();
        }

        private function clearnDisplay():void
        {
            while (this._bmContainer.numChildren > 0)
            {
                this._bmContainer.removeChildAt(0);
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

        private function addSuitLevelBitmap():void
        {
            addChild(this._bmContainer);
            this._bmContainer.addChild(this.creatSuitBitmap(this._suidLevel));
        }

        private function creatSuitBitmap(_arg_1:int):Bitmap
        {
            if (this._SuidLevelBitmaps[_arg_1])
            {
                return (this._SuidLevelBitmaps[_arg_1]);
            };
            var _local_2:Bitmap = ComponentFactory.Instance.creatBitmap((SUID_ICON_BITMAP + _arg_1.toString()));
            _local_2.smoothing = true;
            this._SuidLevelBitmaps[_arg_1] = _local_2;
            return (_local_2);
        }


    }
}//package ddt.view.common

