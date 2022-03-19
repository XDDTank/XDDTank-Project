// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//farm.view.SeedSelectedView

package farm.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import com.pickgliss.ui.controls.container.HBox;
    import __AS3__.vec.Vector;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import com.greensock.TweenLite;
    import ddt.manager.TaskManager;
    import ddt.manager.SavePointManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import flash.events.MouseEvent;
    import ddt.manager.PlayerManager;
    import ddt.events.BagEvent;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.SoundManager;
    import baglocked.BaglockedManager;
    import farm.FarmModelController;
    import ddt.data.EquipType;
    import ddt.manager.ItemManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class SeedSelectedView extends Sprite implements Disposeable 
    {

        public static const SEED:int = 1;

        private var _seedSelectViewBg:ScaleBitmapImage;
        private var _title:ScaleFrameImage;
        private var _preBtn:BaseButton;
        private var _nextBtn:BaseButton;
        private var _closeBtn:SimpleBitmapButton;
        private var _hBox:HBox;
        private var _cells:Vector.<FarmCell>;
        private var _type:int;
        private var _cellInfos:Vector.<InventoryItemInfo>;
        private var _currentPage:int;
        private var _totlePage:int;
        private var _isShow:Boolean;

        public function SeedSelectedView()
        {
            this.initView();
            this.initEvent();
        }

        public function set viewType(_arg_1:int):void
        {
            this._type = _arg_1;
            this.cellInfos();
            this.upCells(0);
            this._title.setFrame(this._type);
        }

        public function set isShow(_arg_1:Boolean):void
        {
            if (((_arg_1) && (this._cellInfos.length == 0)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("farm.seedView.noSeedTip"));
                return;
            };
            TweenLite.killTweensOf(this);
            this._isShow = _arg_1;
            if (this._isShow)
            {
                visible = true;
                this.alpha = 0;
                TweenLite.to(this, 0.5, {
                    "alpha":1,
                    "mouseEnabled":1,
                    "mouseChildren":1
                });
                if (((SavePointManager.Instance.isInSavePoint(48)) && (!(TaskManager.instance.isNewHandTaskCompleted(21)))))
                {
                    NewHandContainer.Instance.showArrow(ArrowType.FARM_GUILDE, 0, "trainer.farmSeedArrowPos", "", "");
                };
            }
            else
            {
                mouseEnabled = false;
                mouseChildren = false;
                TweenLite.to(this, 0.5, {
                    "alpha":0,
                    "visible":0
                });
            };
        }

        private function initEvent():void
        {
            this._closeBtn.addEventListener(MouseEvent.CLICK, this.__onClose);
            this._preBtn.addEventListener(MouseEvent.CLICK, this.__onPageBtnClick);
            this._nextBtn.addEventListener(MouseEvent.CLICK, this.__onPageBtnClick);
            PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE, this.__bagUpdate);
            addEventListener(MouseEvent.CLICK, this.__onClick);
        }

        private function removeEvent():void
        {
            this._closeBtn.removeEventListener(MouseEvent.CLICK, this.__onClose);
            this._preBtn.removeEventListener(MouseEvent.CLICK, this.__onPageBtnClick);
            this._nextBtn.removeEventListener(MouseEvent.CLICK, this.__onPageBtnClick);
            PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE, this.__bagUpdate);
            addEventListener(MouseEvent.CLICK, this.__onClick);
        }

        protected function __onClick(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
        }

        private function initView():void
        {
            this._seedSelectViewBg = ComponentFactory.Instance.creatComponentByStylename("farm.seedselectViewBg");
            this._title = ComponentFactory.Instance.creatComponentByStylename("farm.selectedView.title");
            this._title.setFrame(this._type);
            this._preBtn = ComponentFactory.Instance.creat("farm.btnPrePage1");
            this._nextBtn = ComponentFactory.Instance.creat("farm.btnNextPage1");
            this._closeBtn = ComponentFactory.Instance.creat("farm.seedselectcloseBtn");
            this._hBox = ComponentFactory.Instance.creat("farm.cropBox");
            addChild(this._seedSelectViewBg);
            addChild(this._title);
            addChild(this._preBtn);
            addChild(this._nextBtn);
            addChild(this._closeBtn);
            addChild(this._hBox);
            this._cells = new Vector.<FarmCell>(4);
            var _local_1:int;
            while (_local_1 < 4)
            {
                this._cells[_local_1] = new FarmCell();
                this._cells[_local_1].addEventListener(MouseEvent.CLICK, this.__clickHandler);
                this._hBox.addChild(this._cells[_local_1]);
                _local_1++;
            };
        }

        private function __clickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            this.visible = false;
            FarmModelController.instance._cell = (_arg_1.currentTarget as FarmCell);
            FarmModelController.instance._cell.dragStart();
            if (((SavePointManager.Instance.isInSavePoint(48)) && (!(TaskManager.instance.isNewHandTaskCompleted(21)))))
            {
                NewHandContainer.Instance.showArrow(ArrowType.FARM_GUILDE, 135, "trainer.farmSowArrowPos", "", "");
            };
        }

        private function __bagUpdate(_arg_1:BagEvent):void
        {
            this.cellInfos();
            this.upCells(this._currentPage);
        }

        private function __onClose(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (((SavePointManager.Instance.isInSavePoint(48)) && (!(TaskManager.instance.isNewHandTaskCompleted(21)))))
            {
                NewHandContainer.Instance.showArrow(ArrowType.FARM_GUILDE, 0, "trainer.farmFieldArrowPos", "", "");
            };
            this.isShow = false;
        }

        private function __onPageBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.currentTarget)
            {
                case this._preBtn:
                    this._currentPage = (((this._currentPage - 1) < 0) ? 0 : (this._currentPage - 1));
                    break;
                case this._nextBtn:
                    this._currentPage = (((this._currentPage + 1) > this._totlePage) ? this._totlePage : (this._currentPage + 1));
                    break;
            };
            this.upCells(this._currentPage);
        }

        private function cellInfos():void
        {
            var _local_1:Array = PlayerManager.Instance.Self.Bag.findItems(EquipType.SEED);
            _local_1.sortOn("TemplateID", Array.NUMERIC);
            this._cellInfos = this.combineSeed(_local_1);
            this._totlePage = (((this._cellInfos.length % 4) == 0) ? int(((this._cellInfos.length / 4) - 1)) : int((this._cellInfos.length / 4)));
        }

        private function combineSeed(_arg_1:Array):Vector.<InventoryItemInfo>
        {
            var _local_4:InventoryItemInfo;
            var _local_5:InventoryItemInfo;
            var _local_2:Vector.<InventoryItemInfo> = new Vector.<InventoryItemInfo>();
            var _local_3:int;
            for each (_local_4 in _arg_1)
            {
                if (_local_4.TemplateID == _local_3)
                {
                    _local_2[(_local_2.length - 1)].Count = (_local_2[(_local_2.length - 1)].Count + _local_4.Count);
                }
                else
                {
                    _local_5 = new InventoryItemInfo();
                    _local_5.TemplateID = _local_4.TemplateID;
                    ItemManager.fill(_local_5);
                    _local_5.IsBinds = _local_4.IsBinds;
                    _local_5.Count = _local_4.Count;
                    _local_2.push(_local_5);
                };
                _local_3 = _local_4.TemplateID;
            };
            return (_local_2);
        }

        private function upCells(_arg_1:int=0):void
        {
            this._currentPage = _arg_1;
            var _local_2:int = (_arg_1 * 4);
            var _local_3:int;
            while (_local_3 < 4)
            {
                if (this._cellInfos.length > (_local_3 + _local_2))
                {
                    this._cells[_local_3].itemInfo = this._cellInfos[(_local_3 + _local_2)];
                    if (this._cells[_local_3].itemInfo.Count > 0)
                    {
                        this._cells[_local_3].visible = true;
                    }
                    else
                    {
                        this._cells[_local_3].visible = false;
                    };
                }
                else
                {
                    this._cells[_local_3].visible = false;
                };
                _local_3++;
            };
        }

        public function dispose():void
        {
            var _local_1:FarmCell;
            TweenLite.killTweensOf(this);
            this.removeEvent();
            while (this._cells.length > 0)
            {
                _local_1 = this._cells.shift();
                _local_1.removeEventListener(MouseEvent.CLICK, this.__clickHandler);
                _local_1.dispose();
            };
            this._cells = null;
            this._cellInfos = null;
            if (this._seedSelectViewBg)
            {
                ObjectUtils.disposeObject(this._seedSelectViewBg);
            };
            this._seedSelectViewBg = null;
            if (this._title)
            {
                ObjectUtils.disposeObject(this._title);
            };
            this._title = null;
            if (this._preBtn)
            {
                ObjectUtils.disposeObject(this._preBtn);
            };
            this._preBtn = null;
            if (this._nextBtn)
            {
                ObjectUtils.disposeObject(this._nextBtn);
            };
            this._nextBtn = null;
            if (this._closeBtn)
            {
                ObjectUtils.disposeObject(this._closeBtn);
            };
            this._closeBtn = null;
            if (this._hBox)
            {
                ObjectUtils.disposeObject(this._hBox);
            };
            this._hBox = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package farm.view

