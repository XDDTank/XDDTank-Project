// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.resolve.StoreIIResolveBG

package store.view.resolve
{
    import flash.display.Sprite;
    import store.IStoreViewBG;
    import store.StoreDragInArea;
    import com.pickgliss.ui.image.Image;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.BaseButton;
    import flash.geom.Point;
    import __AS3__.vec.Vector;
    import ddt.data.goods.SpliteListInfo;
    import com.pickgliss.ui.ComponentFactory;
    import bagAndInfo.cell.BaseCell;
    import ddt.utils.PositionUtils;
    import flash.events.MouseEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.BagInfo;
    import bagAndInfo.cell.BagCell;
    import ddt.manager.PlayerManager;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.ItemManager;
    import ddt.manager.MessageTipManager;
    import flash.utils.Dictionary;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class StoreIIResolveBG extends Sprite implements IStoreViewBG 
    {

        private static var CELL_COUNT:int = 4;

        private var _area:StoreDragInArea;
        private var _bg:Image;
        private var _resolveTitle:Bitmap;
        private var _resolveBtn:BaseButton;
        private var _mainCell:ResolveItemCell;
        private var _mainCellPos:Point;
        private var _cells:Array;
        private var _pointArray:Vector.<Point>;
        private var _spliteInfo:SpliteListInfo;

        public function StoreIIResolveBG()
        {
            this.init();
            this.initEvent();
        }

        private function init():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIResolveBG.ResolveBg");
            addChild(this._bg);
            this._resolveTitle = ComponentFactory.Instance.creatBitmap("asset.ddtstore.FusionTitle");
            addChild(this._resolveTitle);
            this._resolveBtn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIResolveBG.ResolveBtn");
            addChild(this._resolveBtn);
            this._cells = [];
            this.getCellsPoint();
            this.intItems();
            this._area = new StoreDragInArea(this._cells);
            addChildAt(this._area, 0);
            this.hide();
        }

        private function intItems():void
        {
            var _local_1:int;
            var _local_2:BaseCell;
            this._mainCell = new ResolveItemCell(0);
            this._mainCellPos = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIResolveBG.ResolveMainpoint");
            PositionUtils.setPos(this._mainCell, this._mainCellPos);
            addChild(this._mainCell);
            _local_1 = 0;
            while (_local_1 < CELL_COUNT)
            {
                _local_2 = new BaseCell(ComponentFactory.Instance.creatBitmap("asset.ddtstore.materialCellBg"));
                _local_2.x = this._pointArray[_local_1].x;
                _local_2.y = this._pointArray[_local_1].y;
                addChild(_local_2);
                this._cells.push(_local_2);
                _local_1++;
            };
        }

        private function getCellsPoint():void
        {
            var _local_2:Point;
            this._pointArray = new Vector.<Point>();
            var _local_1:int;
            while (_local_1 < CELL_COUNT)
            {
                _local_2 = ComponentFactory.Instance.creatCustomObject(("ddtstore.StoreIIResolveBG.Resolvepoint" + _local_1));
                this._pointArray.push(_local_2);
                _local_1++;
            };
        }

        private function initEvent():void
        {
            this._resolveBtn.addEventListener(MouseEvent.CLICK, this.__btnClick);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_SPLITE, this.__spliteResponse);
        }

        private function __spliteResponse(_arg_1:CrazyTankSocketEvent):void
        {
        }

        private function __btnClick(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            if (this._mainCell.info)
            {
                _local_2 = 2;
                SocketManager.Instance.out.sendItemSplite(this._mainCell.info.TemplateID, _local_2);
            };
        }

        public function setCell(_arg_1:BagCell):void
        {
            var _local_2:int;
            var _local_3:InventoryItemInfo = (_arg_1.info as InventoryItemInfo);
            SocketManager.Instance.out.sendMoveGoods(_local_3.BagType, _local_3.Place, BagInfo.STOREBAG, _local_2, _local_3.Count, true);
        }

        public function refreshData(_arg_1:Dictionary):void
        {
            var _local_2:int = int(_arg_1[0]);
            var _local_3:ItemTemplateInfo = PlayerManager.Instance.Self.StoreBag.items[_local_2];
            this._spliteInfo = ItemManager.Instance.getSpliteInfoByID(400200);
            if (this._spliteInfo)
            {
                this._mainCell.info = _local_3;
                this.updateData();
            }
            else
            {
                MessageTipManager.getInstance().show("此物品不能分解！");
                this.updateData();
            };
        }

        public function updateData():void
        {
            this.clearCellsInfo();
            if (((this._mainCell.info) && (this._spliteInfo)))
            {
                if (this._spliteInfo.Material1ID != 0)
                {
                    this._cells[0].info = ItemManager.Instance.getTemplateById(this._spliteInfo.Material1ID);
                };
                if (this._spliteInfo.Material2ID != 0)
                {
                    this._cells[1].info = ItemManager.Instance.getTemplateById(this._spliteInfo.Material2ID);
                };
                if (this._spliteInfo.Material3ID != 0)
                {
                    this._cells[2].info = ItemManager.Instance.getTemplateById(this._spliteInfo.Material3ID);
                };
                if (this._spliteInfo.Material4ID != 0)
                {
                    this._cells[3].info = ItemManager.Instance.getTemplateById(this._spliteInfo.Material4ID);
                };
            };
        }

        private function clearCellsInfo():void
        {
            var _local_1:BaseCell;
            for each (_local_1 in this._cells)
            {
                _local_1.info = null;
            };
        }

        public function hide():void
        {
            this.visible = false;
        }

        public function show():void
        {
            this.visible = true;
        }

        private function removeView():void
        {
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._resolveTitle)
            {
                ObjectUtils.disposeObject(this._resolveTitle);
            };
            this._resolveTitle = null;
            if (this._resolveBtn)
            {
                ObjectUtils.disposeObject(this._resolveBtn);
            };
            this._resolveBtn = null;
            if (this._area)
            {
                this._area.dispose();
            };
            this._area = null;
        }

        private function removeEvent():void
        {
            this._resolveBtn.removeEventListener(MouseEvent.CLICK, this.__btnClick);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_SPLITE, this.__spliteResponse);
        }

        public function dispose():void
        {
            this._pointArray = null;
            this.removeEvent();
        }

        public function openHelp():void
        {
        }


    }
}//package store.view.resolve

