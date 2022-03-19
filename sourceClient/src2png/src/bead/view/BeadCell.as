// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bead.view.BeadCell

package bead.view
{
    import bagAndInfo.cell.BaseCell;
    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.DisplayObject;
    import ddt.data.goods.ItemTemplateInfo;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.manager.DragManager;
    import bagAndInfo.cell.DragEffect;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import bead.BeadManager;
    import ddt.manager.SocketManager;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.utils.PositionUtils;
    import com.pickgliss.utils.ClassUtils;

    public class BeadCell extends BaseCell 
    {

        private const maxLevel:int = 30;

        private var _place:int;
        private var _lockBG:Bitmap;
        private var _lockIcon:Bitmap;
        private var _levelLimit:int;
        private var _sPlace:int = -1;
        private var _mPlace:int = -1;
        private var _beadPic:MovieClip;
        private var _dragBeadPic:MovieClip;
        private var _nameTxt:FilterFrameText;
        private var _circleBg:Bitmap;
        private var isExpBead:Boolean;
        private var _picDic:Object;

        public function BeadCell(_arg_1:int, _arg_2:DisplayObject, _arg_3:ItemTemplateInfo=null, _arg_4:Boolean=true, _arg_5:Boolean=true)
        {
            _arg_2 = ((_arg_2) ? _arg_2 : ComponentFactory.Instance.creatComponentByStylename("asset.beadSystem.beadInset.cellBG"));
            super(_arg_2, _arg_3, _arg_4, _arg_5);
            this._place = _arg_1;
            this._picDic = new Object();
            this._nameTxt = ComponentFactory.Instance.creatComponentByStylename("beadInsetView.beadCell.name");
            this._nameTxt.mouseEnabled = false;
            this._nameTxt.visible = false;
            addChild(this._nameTxt);
            this._circleBg = ComponentFactory.Instance.creatBitmap("asset.beadSystem.beadCell.circleBG");
            this._circleBg.visible = false;
            addChildAt(this._circleBg, 0);
            if (((_arg_1 >= 0) && (_arg_1 < 7)))
            {
                this._nameTxt.x = 26;
                this._nameTxt.y = 72;
                _arg_2.x = 20;
                _arg_2.y = 20;
            };
        }

        public function lockCell(_arg_1:int):void
        {
            this._levelLimit = _arg_1;
            this.locked = true;
            this._lockBG = ComponentFactory.Instance.creatBitmap("asset.beadSystem.beadInset.holeLock");
            this.addChild(this._lockBG);
            this.info = null;
            filters = null;
        }

        public function unlockCell():void
        {
            this._levelLimit = 0;
            this.locked = false;
            if (this._lockBG)
            {
                ObjectUtils.disposeObject(this._lockBG);
            };
            this._lockBG = null;
            tipStyle = null;
            _tipData = null;
            this.info = null;
        }

        public function setBGVisible(_arg_1:Boolean):void
        {
            this._bg.alpha = ((_arg_1) ? 1 : 0);
            this._circleBg.visible = (!(_arg_1));
        }

        public function bgVisible(_arg_1:Boolean):void
        {
            this._bg.alpha = ((_arg_1) ? 1 : 0);
            this._circleBg.visible = _arg_1;
        }

        override public function dragDrop(_arg_1:DragEffect):void
        {
            var _local_2:InventoryItemInfo;
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if ((_arg_1.data is InventoryItemInfo))
            {
                _local_2 = (_arg_1.data as InventoryItemInfo);
                if (locked)
                {
                    if (_local_2 == this.info)
                    {
                        this.locked = false;
                        DragManager.acceptDrag(this);
                    }
                    else
                    {
                        DragManager.acceptDrag(this, DragEffect.NONE);
                    };
                }
                else
                {
                    _arg_1.action = DragEffect.NONE;
                    DragManager.acceptDrag(this);
                    if ((((this._place == 12) && (_local_2.beadIsLock)) || (((_local_2.Place == 12) && (this.info)) && ((this.info as InventoryItemInfo).beadIsLock))))
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("beadSystem.bead.unlock.tip2"));
                    }
                    else
                    {
                        BeadManager.instance.doWhatHandle = 3;
                        PlayerManager.Instance.Self.isBeadUpdate = false;
                        SocketManager.Instance.out.sendBeadMove(_local_2.Place, this._place);
                    };
                };
            }
            else
            {
                if ((_arg_1.source is BeadLockBtn))
                {
                    locked = true;
                    DragManager.acceptDrag(this);
                };
            };
        }

        private function getCombineTip(_arg_1:InventoryItemInfo, _arg_2:InventoryItemInfo):String
        {
            var _local_12:int;
            var _local_3:int = BeadManager.instance.calRequireExp(_arg_2);
            var _local_4:Object = BeadManager.instance.list;
            var _local_5:Object = _local_4[_arg_1.Property2];
            var _local_6:int = (_local_3 + _arg_1.beadExp);
            var _local_7:int = _arg_1.beadLevel;
            if (_local_5)
            {
                _local_12 = (_arg_1.beadLevel + 1);
                while (_local_12 <= this.maxLevel)
                {
                    if (_local_5[_local_12.toString()])
                    {
                        if (_local_6 < _local_5[_local_12.toString()].Exp)
                        {
                            _local_7 = (int(_local_5[_local_12.toString()].Level) - 1);
                            break;
                        };
                        if (_local_12 == this.maxLevel)
                        {
                            _local_7 = this.maxLevel;
                        };
                    };
                    _local_12++;
                };
            };
            var _local_8:String = BeadManager.instance.getBeadColorName(_arg_1, (!(int(_arg_2.Property2) == 0)), true);
            var _local_9:String = BeadManager.instance.getBeadColorName(_arg_2, (!(int(_arg_2.Property2) == 0)), true);
            var _local_10:int = ((BeadManager.instance.list[_arg_2.Property2][_arg_2.beadLevel.toString()]) ? BeadManager.instance.list[_arg_2.Property2][_arg_2.beadLevel.toString()].SellScore : 0);
            var _local_11:String = LanguageMgr.GetTranslation("beadSystem.bead.combine.tip", _local_8, _local_9, _local_3.toString(), ((_local_10 < 0) ? 0 : _local_10));
            if (_local_7 > _arg_1.beadLevel)
            {
                _local_11 = (_local_11 + LanguageMgr.GetTranslation("beadSystem.bead.combine.tip2", _local_7));
            };
            return (_local_11);
        }

        protected function onStack(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.target as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.onStack);
            _local_2.dispose();
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                BeadManager.instance.combineConfirm(this._mPlace, this.doCombine);
            };
        }

        private function doCombine():void
        {
            BeadManager.instance.doWhatHandle = 1;
            SocketManager.Instance.out.sendBeadCombine(this._sPlace, this._mPlace, ((this.isExpBead) ? 0 : 1));
        }

        override public function dragStop(_arg_1:DragEffect):void
        {
            SoundManager.instance.play("008");
            if (((_arg_1.action == DragEffect.MOVE) && (!(_arg_1.target))))
            {
                _arg_1.action = DragEffect.NONE;
            };
            this.disposeDragBeadPic();
            this.dragShowPicTxt();
            super.dragStop(_arg_1);
        }

        private function discardBead():void
        {
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_1:String = BeadManager.instance.getBeadColorName((info as InventoryItemInfo), true, true);
            var _local_2:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("beadSystem.bead.discard.tip", _local_1), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.ALPHA_BLOCKGOUND);
            _local_2.addEventListener(FrameEvent.RESPONSE, this.onStack2, false, 0, true);
        }

        private function onStack2(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.target as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.onStack2);
            _local_2.dispose();
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                BeadManager.instance.doWhatHandle = 4;
                SocketManager.Instance.out.sendBeadDiscardBead(this._place);
            };
        }

        override public function set info(_arg_1:ItemTemplateInfo):void
        {
            var _local_2:String;
            if (_info)
            {
                tipStyle = null;
                _tipData = null;
                locked = false;
                this.disposeBeadPic();
                this._nameTxt.htmlText = "";
                this._nameTxt.visible = false;
            };
            _info = _arg_1;
            if (_arg_1)
            {
                this.createBeadPic(_arg_1);
                if (int(_arg_1.Property2) == 0)
                {
                    _local_2 = BeadManager.instance.getBeadColorName((_arg_1 as InventoryItemInfo), false);
                }
                else
                {
                    _local_2 = BeadManager.instance.getBeadColorName((_arg_1 as InventoryItemInfo), true, false, "\n");
                };
                this._nameTxt.htmlText = _local_2;
                this._nameTxt.visible = true;
                this.setChildIndex(this._nameTxt, (this.numChildren - 1));
                if (int(_arg_1.Property2) == 0)
                {
                    tipStyle = "bead.view.ExpBeadTip";
                }
                else
                {
                    if (this._place == 12)
                    {
                        tipStyle = "beadSystem.BeadComposeTipPanel";
                    }
                    else
                    {
                        tipStyle = "beadSystem.beadTipPanel";
                    };
                };
                _tipData = _arg_1;
                if ((_arg_1 as InventoryItemInfo).beadIsLock)
                {
                    if (this._lockIcon)
                    {
                        this._lockIcon.visible = true;
                        setChildIndex(this._lockIcon, (numChildren - 1));
                    }
                    else
                    {
                        this._lockIcon = ComponentFactory.Instance.creatBitmap("asset.beadSystem.beadInset.lockIcon");
                        if (((this._place >= 0) && (this._place <= 4)))
                        {
                            PositionUtils.setPos(this._lockIcon, "beadInset.lockIcon.pos");
                        };
                        this.addChild(this._lockIcon);
                    };
                }
                else
                {
                    if (this._lockIcon)
                    {
                        this._lockIcon.visible = false;
                    };
                };
            }
            else
            {
                if (this._lockIcon)
                {
                    this._lockIcon.visible = false;
                };
                if ((((this._levelLimit > 0) && (this._place >= 0)) && (this._place <= 4)))
                {
                    tipStyle = "beadSystem.beadLock.tip";
                    _tipData = LanguageMgr.GetTranslation("beadSystem.bead.beadLock.tipTxt", this._levelLimit.toString());
                };
            };
        }

        public function get levelLimit():int
        {
            return (this._levelLimit);
        }

        private function createBeadPic(_arg_1:ItemTemplateInfo):void
        {
            var _local_2:MovieClip;
            if (((int(_arg_1.Property2) < 0) || (int(_arg_1.Property2) > 10)))
            {
                return;
            };
            if (this._picDic[_arg_1.Property2] == null)
            {
                _local_2 = ClassUtils.CreatInstance(("asset.beadSystem.typeBead" + _arg_1.Property2));
                this._picDic[_arg_1.Property2] = _local_2;
            }
            else
            {
                _local_2 = this._picDic[_arg_1.Property2];
            };
            this._beadPic = _local_2;
            var _local_3:int = (_arg_1 as InventoryItemInfo).Place;
            if (((_local_3 >= 0) && (_local_3 < 7)))
            {
                this._beadPic.scaleX = (52 / 68);
                this._beadPic.scaleY = (52 / 68);
                this._beadPic.x = 24.5;
                this._beadPic.y = 23;
            }
            else
            {
                this._beadPic.scaleX = (52 / 78);
                this._beadPic.scaleY = (52 / 78);
                this._beadPic.x = 5;
                this._beadPic.y = 4.5;
            };
            this._beadPic.visible = true;
            addChild(this._beadPic);
            this._beadPic.gotoAndPlay(1);
        }

        override protected function createDragImg():DisplayObject
        {
            if (this._beadPic)
            {
                this.disposeDragBeadPic();
                this._dragBeadPic = ClassUtils.CreatInstance(("asset.beadSystem.typeBead" + _info.Property2));
                this._dragBeadPic.gotoAndPlay(1);
                this._dragBeadPic.scaleX = this._beadPic.scaleX;
                this._dragBeadPic.scaleY = this._beadPic.scaleY;
                return (this._dragBeadPic);
            };
            return (null);
        }

        public function changeLockStatus():void
        {
            locked = false;
            if ((!(_info)))
            {
                return;
            };
            if (this._place == 12)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("beadSystem.bead.unlock.tip"));
            }
            else
            {
                SocketManager.Instance.out.sendBeadLock(this._place);
            };
        }

        override public function dragStart():void
        {
            if (((((_info) && (!(locked))) && (stage)) && (_allowDrag)))
            {
                if (DragManager.startDrag(this, _info, this.createDragImg(), stage.mouseX, stage.mouseY, DragEffect.MOVE))
                {
                    locked = true;
                    this.dragHidePicTxt();
                };
            };
        }

        override protected function initTip():void
        {
            tipDirctions = "7,6,2,1,5,4,0,3,6";
            tipGapV = 0;
            tipGapH = 0;
        }

        private function dragHidePicTxt():void
        {
            this._beadPic.visible = false;
            this._nameTxt.visible = false;
            if (this._lockIcon)
            {
                this._lockIcon.visible = false;
            };
        }

        private function dragShowPicTxt():void
        {
            this._beadPic.visible = true;
            this._nameTxt.visible = true;
            if ((((_info as InventoryItemInfo).beadIsLock) && (this._lockIcon)))
            {
                this._lockIcon.visible = true;
            };
        }

        private function disposeDragBeadPic():void
        {
            if (this._dragBeadPic)
            {
                this._dragBeadPic.gotoAndStop(this._dragBeadPic.totalFrames);
                ObjectUtils.disposeObject(this._dragBeadPic);
                this._dragBeadPic = null;
            };
        }

        private function disposeBeadPic():void
        {
            if (this._beadPic)
            {
                this._beadPic.gotoAndStop(this._beadPic.totalFrames);
                ObjectUtils.disposeObject(this._beadPic);
                this._beadPic = null;
            };
        }

        override public function dispose():void
        {
            this.disposeBeadPic();
            if (this._nameTxt)
            {
                ObjectUtils.disposeObject(this._nameTxt);
            };
            this._nameTxt = null;
            if (this._circleBg)
            {
                ObjectUtils.disposeObject(this._circleBg);
            };
            this._circleBg = null;
            if (this._lockBG)
            {
                ObjectUtils.disposeObject(this._lockBG);
            };
            this._lockBG = null;
            if (this._lockIcon)
            {
                ObjectUtils.disposeObject(this._lockIcon);
            };
            this._lockIcon = null;
            this._picDic = null;
            super.dispose();
        }


    }
}//package bead.view

