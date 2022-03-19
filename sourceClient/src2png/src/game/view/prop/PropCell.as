// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.prop.PropCell

package game.view.prop
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.core.ITipedDisplay;
    import ddt.interfaces.IDragable;
    import ddt.interfaces.IAcceptDrag;
    import ddt.data.PropInfo;
    import flash.display.DisplayObject;
    import ddt.view.tips.ToolPropInfo;
    import com.greensock.TweenLite;
    import ddt.manager.BitmapManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.DragManager;
    import org.aswing.KeyboardManager;
    import ddt.manager.SharedManager;
    import bagAndInfo.cell.DragEffect;
    import flash.display.Bitmap;
    import ddt.data.FightPropMode;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.ShowTipManager;
    import com.greensock.TweenMax;
    import com.pickgliss.utils.ObjectUtils;

    public class PropCell extends Sprite implements Disposeable, ITipedDisplay, IDragable, IAcceptDrag 
    {

        protected var _x:int;
        protected var _y:int;
        protected var _enabled:Boolean = true;
        protected var _info:PropInfo;
        protected var _asset:DisplayObject;
        protected var _isExist:Boolean;
        protected var _back:DisplayObject;
        protected var _fore:DisplayObject;
        protected var _shortcutKey:String;
        protected var _shortcutKeyShape:DisplayObject;
        protected var _tipInfo:ToolPropInfo;
        protected var _tweenMax:TweenLite;
        protected var _localVisible:Boolean = true;
        protected var _mode:int;
        protected var _bitmapMgr:BitmapManager;
        private var _allowDrag:Boolean;
        private var _grayFilters:Array;
        private var _isUsed:Boolean;
        private var _cellType:Boolean = false;

        public function PropCell(_arg_1:String=null, _arg_2:int=-1, _arg_3:Boolean=false)
        {
            this._bitmapMgr = BitmapManager.getBitmapMgr(BitmapManager.GameView);
            this._shortcutKey = _arg_1;
            this._grayFilters = ComponentFactory.Instance.creatFilters("grayFilter");
            this._mode = _arg_2;
            mouseChildren = false;
            this._allowDrag = _arg_3;
            this.configUI();
            this.addEvent();
        }

        public function get shortcutKey():String
        {
            return (this._shortcutKey);
        }

        public function get isUsed():Boolean
        {
            return (this._isUsed);
        }

        public function set isUsed(_arg_1:Boolean):void
        {
            this._isUsed = _arg_1;
        }

        public function dragStart():void
        {
            if (((this._info) && (this._allowDrag)))
            {
                if (this._enabled)
                {
                    DragManager.startDrag(this, this._info, this._asset, stage.mouseX, stage.mouseY, "none", false, true, false, false, true);
                }
                else
                {
                    this._asset.filters = this._grayFilters;
                    DragManager.startDrag(this, this._info, this._asset, stage.mouseX, stage.mouseY, "none", false, true, false, false, true);
                };
            };
        }

        public function setGrayFilter():void
        {
            filters = this._grayFilters;
        }

        public function dragStop(_arg_1:DragEffect):void
        {
            KeyboardManager.getInstance().isStopDispatching = false;
            if (((_arg_1.target == null) || ((_arg_1.target is PropCell) == false)))
            {
                this.info = this._info;
            };
            var _local_2:PropCell = (_arg_1.target as PropCell);
            var _local_3:PropInfo = _local_2.info;
            var _local_4:Boolean = _local_2._enabled;
            var _local_5:int = SharedManager.Instance.GameKeySets[_local_2.shortcutKey];
            _local_2.info = this.info;
            SharedManager.Instance.GameKeySets[_local_2.shortcutKey] = SharedManager.Instance.GameKeySets[this.shortcutKey];
            this.info = _local_3;
            SharedManager.Instance.GameKeySets[this.shortcutKey] = _local_5;
            SharedManager.Instance.save();
            _local_2.enabled = this.enabled;
            this.enabled = _local_4;
        }

        public function dragDrop(_arg_1:DragEffect):void
        {
            if (this._allowDrag)
            {
                _arg_1.action = DragEffect.NONE;
                DragManager.acceptDrag(this);
            };
        }

        public function getSource():IDragable
        {
            return (this);
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
        }

        public function get tipDirctions():String
        {
            return ("5,2,7,1,6,4");
        }

        public function set tipDirctions(_arg_1:String):void
        {
        }

        public function get tipGapH():int
        {
            return (20);
        }

        public function set tipGapH(_arg_1:int):void
        {
        }

        public function get tipGapV():int
        {
            return (20);
        }

        public function set tipGapV(_arg_1:int):void
        {
        }

        public function get tipStyle():String
        {
            return ("core.ToolPropTips");
        }

        public function set tipStyle(_arg_1:String):void
        {
        }

        protected function configUI():void
        {
            this._back = this._bitmapMgr.creatBitmapShape("asset.game.prop.ItemBack", null, false, true);
            addChild(this._back);
            this._fore = this._bitmapMgr.creatBitmapShape("asset.game.prop.ItemFore", null, false, true);
            this._fore.x = (this._fore.y = 2);
            addChild(this._fore);
            if (this._shortcutKey != null)
            {
                this._shortcutKeyShape = ComponentFactory.Instance.creatBitmap(("asset.game.prop.ShortcutKey" + this._shortcutKey));
                Bitmap(this._shortcutKeyShape).smoothing = true;
                this._shortcutKeyShape.y = -2;
                addChild(this._shortcutKeyShape);
            };
            this._tipInfo = new ToolPropInfo();
            this._tipInfo.showThew = true;
            this.drawLayer();
        }

        protected function drawLayer():void
        {
            if (this._shortcutKey == null)
            {
                return;
            };
            if (this._mode == FightPropMode.VERTICAL)
            {
                this._shortcutKeyShape.x = (36 - this._shortcutKeyShape.width);
            }
            else
            {
                this._shortcutKeyShape.x = 0;
            };
        }

        protected function addEvent():void
        {
            addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
        }

        protected function __mouseOut(_arg_1:MouseEvent):void
        {
            x = this._x;
            y = this._y;
            scaleX = (scaleY = 1);
            if (this._shortcutKey != null)
            {
                this._shortcutKeyShape.scaleX = (this._shortcutKeyShape.scaleY = 1);
            };
            if (this._tweenMax)
            {
                this._tweenMax.pause();
            };
            if (this._enabled)
            {
                filters = null;
            }
            else
            {
                filters = this._grayFilters;
            };
            ShowTipManager.Instance.hideTip(this);
        }

        protected function __mouseOver(_arg_1:MouseEvent):void
        {
            if (this._info != null)
            {
                if (this._shortcutKey != null)
                {
                    this._shortcutKeyShape.scaleX = (this._shortcutKeyShape.scaleY = 0.9);
                };
                x = (this._x - 3.6);
                y = (this._y - 3.6);
                scaleX = (scaleY = 1.2);
                if (this.enabled)
                {
                    if (this._tweenMax == null)
                    {
                        this._tweenMax = TweenMax.to(this, 0.5, {
                            "repeat":-1,
                            "yoyo":true,
                            "glowFilter":{
                                "color":16777011,
                                "alpha":1,
                                "blurX":4,
                                "blurY":4,
                                "strength":3
                            }
                        });
                    };
                    this._tweenMax.play();
                };
                if (parent)
                {
                    parent.setChildIndex(this, (parent.numChildren - 1));
                };
                if (((this._shortcutKey == "4") && (this.cellType == false)))
                {
                    this._tipInfo.isMax = true;
                }
                else
                {
                    this._tipInfo.isMax = false;
                };
                ShowTipManager.Instance.showTip(this);
            };
        }

        protected function removeEvent():void
        {
            removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            removeEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
        }

        public function get info():PropInfo
        {
            return (this._info);
        }

        public function setMode(_arg_1:int):void
        {
            this._mode = _arg_1;
            this.drawLayer();
        }

        public function get cellType():Boolean
        {
            return (this._cellType);
        }

        public function set cellType(_arg_1:Boolean):void
        {
            this._cellType = _arg_1;
            this.info = this.info;
        }

        public function set info(_arg_1:PropInfo):void
        {
            var _local_3:Bitmap;
            this._info = _arg_1;
            var _local_2:DisplayObject = this._asset;
            if (this._info != null)
            {
                if (((this._shortcutKey == "4") && (this.cellType == false)))
                {
                    _local_3 = ComponentFactory.Instance.creatBitmap("asset.game.rightProp.maxAsset");
                }
                else
                {
                    _local_3 = ComponentFactory.Instance.creatBitmap((("game.crazyTank.view.Prop" + this._info.Template.Pic) + "Asset"));
                };
                if (_local_3)
                {
                    _local_3.smoothing = true;
                    _local_3.x = (_local_3.y = 1);
                    _local_3.width = (_local_3.height = 35);
                    addChildAt(_local_3, getChildIndex(this._fore));
                };
                this._asset = _local_3;
                this._tipInfo.info = this._info.Template;
                this._tipInfo.shortcutKey = this._shortcutKey;
                buttonMode = true;
            }
            else
            {
                buttonMode = false;
            };
            if (_local_2 != null)
            {
                ObjectUtils.disposeObject(_local_2);
            };
        }

        public function get enabled():Boolean
        {
            return (this._enabled);
        }

        public function set enabled(_arg_1:Boolean):void
        {
            if (this._enabled != _arg_1)
            {
                this._enabled = _arg_1;
                if ((!(this._enabled)))
                {
                    filters = this._grayFilters;
                }
                else
                {
                    filters = null;
                };
            };
        }

        public function get isExist():Boolean
        {
            return (this._isExist);
        }

        public function set isExist(_arg_1:Boolean):void
        {
            this._isExist = _arg_1;
        }

        public function setPossiton(_arg_1:int, _arg_2:int):void
        {
            this._x = _arg_1;
            this._y = _arg_2;
            this.x = this._x;
            this.y = this._y;
        }

        public function dispose():void
        {
            this.removeEvent();
            ShowTipManager.Instance.removeTip(this);
            filters = null;
            if (this._tweenMax)
            {
                this._tweenMax.kill();
            };
            this._tweenMax = null;
            ObjectUtils.disposeObject(this._asset);
            this._asset = null;
            ObjectUtils.disposeObject(this._back);
            this._back = null;
            ObjectUtils.disposeObject(this._fore);
            this._fore = null;
            ObjectUtils.disposeObject(this._shortcutKeyShape);
            this._shortcutKeyShape = null;
            ObjectUtils.disposeObject(this._bitmapMgr);
            this._bitmapMgr = null;
            TweenLite.killTweensOf(this);
            ShowTipManager.Instance.removeTip(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function useProp():void
        {
            if (this._localVisible)
            {
                dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            };
        }

        public function get localVisible():Boolean
        {
            return (this._localVisible);
        }

        public function setVisible(_arg_1:Boolean):void
        {
            if (this._localVisible != _arg_1)
            {
                this._localVisible = _arg_1;
            };
        }


    }
}//package game.view.prop

