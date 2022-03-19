// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.BagAndInfoFrame

package bagAndInfo
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.data.player.SelfInfo;
    import bagAndInfo.info.PlayerInfoView;
    import bagAndInfo.bag.BagView;
    import ddt.data.BagInfo;
    import bagAndInfo.cell.LockBagCell;
    import flash.utils.Timer;
    import flash.geom.Point;
    import ddt.data.goods.InventoryItemInfo;
    import equipretrieve.effect.AnimationControl;
    import flash.utils.getTimer;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.events.CellEvent;
    import ddt.events.BagEvent;
    import ddt.manager.SavePointManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.PlayerManager;
    import flash.events.Event;
    import bagAndInfo.cell.CellFactory;
    import flash.events.TimerEvent;
    import equipretrieve.effect.GlowFilterAnimation;
    import ddt.manager.SoundManager;
    import ddt.manager.ItemManager;
    import ddt.data.goods.EquipmentTemplateInfo;
    import com.greensock.TimelineLite;
    import com.greensock.TweenLite;
    import ddt.manager.SocketManager;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.EquipType;
    import com.pickgliss.utils.ObjectUtils;

    public class BagAndInfoFrame extends Sprite implements Disposeable 
    {

        private var _info:SelfInfo;
        public var _infoView:PlayerInfoView;
        public var _bagView:BagView;
        private var _currentType:int;
        private var _visible:Boolean = false;
        private var _isFirstOpenBead:Boolean = true;
        private var _bagInfo:BagInfo;
        private var _cell:LockBagCell;
        private var _startMove:Timer;
        private var _shineTimer:Timer;
        private var _index:int;
        private var _startPos:Point;
        private var _stopPos:Point;
        private var _setInfo:InventoryItemInfo;
        private var animationControl:AnimationControl;

        public function BagAndInfoFrame()
        {
            this.initView();
            this.initEvents();
        }

        private function initView():void
        {
            var _local_1:uint = getTimer();
            this._bagView = ComponentFactory.Instance.creatCustomObject("bagFrameBagView");
            addChild(this._bagView);
            _local_1 = getTimer();
            this._infoView = ComponentFactory.Instance.creatCustomObject("bagAndInfoPersonalInfoView");
            this._infoView.showSelfOperation = true;
            addChild(this._infoView);
            _local_1 = getTimer();
            this._bagView.sortBagEnable = false;
            this._bagView.breakBtnEnable = false;
            this._bagView.sellBtnFilter = ComponentFactory.Instance.creatFilters("grayFilter");
            this._bagView.sortBagFilter = ComponentFactory.Instance.creatFilters("grayFilter");
            this._bagView.breakBtnFilter = ComponentFactory.Instance.creatFilters("grayFilter");
            this._bagView.setClassBtnEnable = false;
            this._bagView.setClassBtnFilter = ComponentFactory.Instance.creatFilters("grayFilter");
        }

        private function initEvents():void
        {
            this._bagView.addEventListener(CellEvent.DRAGSTART, this.__startShine);
            this._bagView.addEventListener(CellEvent.DRAGSTOP, this.__stopShine);
            this._bagView.addEventListener(BagView.TABCHANGE, this.__changeHandler);
            this._infoView.addEventListener(BagEvent.WEAPON_READY, this.__weaponReady);
            this._infoView.addEventListener(BagEvent.WEAPON_REMOVE, this.__weaponRemove);
            this._infoView.addEventListener(BagEvent.FASHION_READY, this.__fashionReady);
            this._infoView.addEventListener(BagEvent.FASHION_REMOVE, this.__fashionRemove);
        }

        private function removeEvents():void
        {
            this._bagView.removeEventListener(CellEvent.DRAGSTART, this.__startShine);
            this._bagView.removeEventListener(CellEvent.DRAGSTOP, this.__stopShine);
            this._bagView.removeEventListener(BagView.TABCHANGE, this.__changeHandler);
            this._infoView.removeEventListener(BagEvent.WEAPON_READY, this.__weaponReady);
            this._infoView.removeEventListener(BagEvent.WEAPON_REMOVE, this.__weaponRemove);
            this._infoView.removeEventListener(BagEvent.FASHION_READY, this.__fashionReady);
            this._infoView.removeEventListener(BagEvent.FASHION_REMOVE, this.__fashionRemove);
        }

        private function __weaponReady(_arg_1:BagEvent):void
        {
            this._bagView.unlockBagCells();
            if (SavePointManager.Instance.isInSavePoint(33))
            {
                SavePointManager.Instance.setSavePoint(33);
            };
        }

        private function __weaponRemove(_arg_1:BagEvent):void
        {
            this._bagView.weaponShowLight();
        }

        private function __fashionReady(_arg_1:BagEvent):void
        {
            this._bagView.unlockBagCells();
            NewHandContainer.Instance.showArrow(ArrowType.CLICK_CLOSE_BAG, 225, "trainer.bagCloseArrowPos", "", "", LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
        }

        private function __fashionRemove(_arg_1:BagEvent):void
        {
            this._bagView.fashionShowLight();
        }

        public function set isScreenTexp(_arg_1:Boolean):void
        {
            this._bagView.isScreenTexp = _arg_1;
        }

        public function switchShow(_arg_1:int):void
        {
            var _local_2:uint = getTimer();
            this.info = PlayerManager.Instance.Self;
            this.bagInfo = BagAndInfoManager.Instance.bagInfo;
            this._currentType = _arg_1;
            if (_arg_1 == BagAndGiftFrame.BAGANDINFO)
            {
                this.bagType = BagView.EQUIP;
                if (SavePointManager.Instance.savePoints[34])
                {
                    this._bagView.sortBagEnable = true;
                    this._bagView.breakBtnEnable = true;
                    this._bagView.sellBtnFilter = null;
                    this._bagView.sortBagFilter = null;
                    this._bagView.breakBtnFilter = null;
                    this._bagView.setClassBtnEnable = true;
                    this._bagView.setClassBtnFilter = null;
                };
                this._infoView.visible = true;
                this._bagView.switchbagViewBtn = true;
                this._bagView.switchButtomVisible(true);
                this._bagView.switchLockBtnVisible(true);
            };
            _local_2 = getTimer();
        }

        public function clearTexpInfo():void
        {
        }

        private function __changeHandler(_arg_1:Event):void
        {
            if (((!(this._currentType == BagAndGiftFrame.PETVIEW)) && (!(this._currentType == BagAndGiftFrame.TEXPVIEW))))
            {
                this._infoView.switchShow(false);
                this._infoView.visible = true;
            };
        }

        private function __stopShine(_arg_1:CellEvent):void
        {
            this._infoView.stopShine();
        }

        public function setEuipInfo(_arg_1:InventoryItemInfo):void
        {
            this._setInfo = _arg_1;
            this._cell = (CellFactory.instance.createLockBagCell(this._setInfo.Place) as LockBagCell);
            this._cell.mouseChildren = false;
            this._cell.mouseEnabled = false;
            this._cell.info = this._setInfo;
            var _local_2:Point = this._bagView.setPlace(this._setInfo.Place);
            this._startPos = this.globalToLocal(_local_2);
            this._cell.x = this._startPos.x;
            this._cell.y = this._startPos.y;
            addChild(this._cell);
            this._cell.visible = true;
            if (this._setInfo.CategoryID == 40)
            {
                this._cell.light = false;
                this._startMove = new Timer(500, 1);
            }
            else
            {
                this._cell.light = true;
                this._startMove = new Timer(3000, 1);
            };
            this._startMove.start();
            this._startMove.addEventListener(TimerEvent.TIMER_COMPLETE, this.__startMove);
        }

        private function __startMove(_arg_1:TimerEvent):void
        {
            if (this._startMove == null)
            {
                return;
            };
            this._startMove.stop();
            this._startMove.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__startMove);
            this._startMove = null;
            if (this._setInfo.CategoryID != 40)
            {
                this._cell.light = false;
                this._cell.visible = false;
                return;
            };
            this._cellslightMovie();
        }

        private function _cellslightMovie():void
        {
            this.animationControl = new AnimationControl();
            this.animationControl.addEventListener(Event.COMPLETE, this._cellslightMovieOver);
            var _local_1:GlowFilterAnimation = new GlowFilterAnimation();
            _local_1.start(this._cell);
            _local_1.addMovie(0, 0, 1);
            this.animationControl.addMovies(_local_1);
            SoundManager.instance.play("147");
            this.animationControl.startMovie();
        }

        private function _cellslightMovieOver(_arg_1:Event):void
        {
            this.animationControl.removeEventListener(Event.COMPLETE, this._cellslightMovieOver);
            this._cellMove();
        }

        private function _cellMove():void
        {
            var _local_1:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(this._cell.info.TemplateID);
            var _local_2:TimelineLite = new TimelineLite({"onComplete":this._tweenlineComplete});
            var _local_3:Array = new Array();
            this._index = int(this.getCellIndex(_local_1));
            var _local_4:Point = this._infoView.getPerCellByPlace(this._index);
            this._stopPos = this.globalToLocal(_local_4);
            _local_3.push(TweenLite.to(this._cell, 0.5, {
                "x":(this._stopPos.x + 1),
                "y":this._stopPos.y
            }));
            _local_2.appendMultiple(_local_3);
        }

        private function _tweenlineComplete():void
        {
            this._cell.x = (this._stopPos.x + 1);
            this._cell.y = this._stopPos.y;
            this._cell.scaleX = (this._cell.scaleY = 1);
            if (this._infoView)
            {
                this._infoView.startShine(this._setInfo);
            };
            this._shineTimer = new Timer(2000, 1);
            this._shineTimer.start();
            this._shineTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__shineComplete);
            SocketManager.Instance.out.sendMoveGoods(0, this._setInfo.Place, 0, PlayerManager.Instance.getEquipPlace(this._setInfo), 0);
        }

        private function __shineComplete(_arg_1:TimerEvent):void
        {
            if (this._shineTimer == null)
            {
                return;
            };
            this._shineTimer.stop();
            this._shineTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__shineComplete);
            this._shineTimer = null;
            if (this._infoView)
            {
                this._infoView.stopShine();
            };
            this._cell.visible = false;
        }

        private function getCellIndex(_arg_1:EquipmentTemplateInfo):String
        {
            switch (_arg_1.TemplateType)
            {
                case 1:
                    return ("10");
                case 2:
                    return ("11");
                case 3:
                    return ("12");
                case 4:
                    return ("13");
                case 6:
                    return ("15");
                case 5:
                    return ("14");
                case 7:
                    return ("16");
                case 8:
                    return ("17");
                case 9:
                    return ("18");
                case 10:
                    return ("19");
                case 11:
                    return ("20");
                case 12:
                    return ("23");
                case 13:
                    return ("22");
                case 14:
                    return ("21");
                default:
                    return ("-1");
            };
        }

        private function __startShine(_arg_1:CellEvent):void
        {
            if ((_arg_1.data is ItemTemplateInfo))
            {
                if ((_arg_1.data as ItemTemplateInfo).CategoryID != EquipType.TEXP)
                {
                    if ((_arg_1.data as ItemTemplateInfo).CategoryID == 41)
                    {
                        return;
                    };
                    this._infoView.startShine((_arg_1.data as ItemTemplateInfo));
                };
            };
        }

        public function dispose():void
        {
            this.removeEvents();
            this._bagView.dispose();
            this._bagView = null;
            this._infoView.dispose();
            this._infoView = null;
            this._info = null;
            if (this.animationControl)
            {
                this.animationControl = null;
            };
            if (this._startMove)
            {
                this._startMove.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__startMove);
                this._startMove.stop();
                this._startMove = null;
            };
            if (this._shineTimer)
            {
                this._shineTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__shineComplete);
                this._shineTimer.stop();
                this._shineTimer = null;
            };
            TweenLite.killTweensOf(this._cell);
            ObjectUtils.disposeObject(this._cell);
            this._cell = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function get info():SelfInfo
        {
            return (this._info);
        }

        public function set info(_arg_1:SelfInfo):void
        {
            var _local_2:uint = getTimer();
            this._info = _arg_1;
            _local_2 = getTimer();
            this._infoView.info = _arg_1;
            _local_2 = getTimer();
            this._bagView.info = _arg_1;
            _local_2 = getTimer();
            this._infoView.allowLvIconClick();
            if (PlayerManager.Instance.Self.EquipInfo)
            {
                this.setEuipInfo(PlayerManager.Instance.Self.EquipInfo);
                PlayerManager.Instance.Self.EquipInfo = null;
            };
            _local_2 = getTimer();
        }

        public function get bagInfo():BagInfo
        {
            return (this._bagInfo);
        }

        public function set bagInfo(_arg_1:BagInfo):void
        {
            this._bagInfo = _arg_1;
            this._infoView.bagInfo = _arg_1;
        }

        public function set bagType(_arg_1:int):void
        {
            this._bagView.setBagType(_arg_1);
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }


    }
}//package bagAndInfo

