// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.bag.CellMenu

package bagAndInfo.bag
{
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import bagAndInfo.cell.LockBagCell;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.EquipType;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class CellMenu extends Sprite 
    {

        public static const ADDPRICE:String = "addprice";
        public static const MOVE:String = "move";
        public static const OPEN:String = "open";
        public static const USE:String = "use";
        public static const OPEN_ALL:String = "openAll";
        private static var _instance:CellMenu;

        private var _bg:Bitmap;
        private var _cell:LockBagCell;
        private var _addpriceitem:BaseButton;
        private var _moveitem:BaseButton;
        private var _openitem:BaseButton;
        private var _useitem:BaseButton;
        private var _openAllItem:BaseButton;
        private var _list:VBox;

        public function CellMenu(_arg_1:SingletonFoce)
        {
            this.init();
        }

        public static function get instance():CellMenu
        {
            if (_instance == null)
            {
                _instance = new CellMenu(new SingletonFoce());
            };
            return (_instance);
        }


        private function init():void
        {
            this._bg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cellMenu.CellMenuBGAsset");
            this._list = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.cellMenu.cellVBox");
            addChild(this._list);
            graphics.beginFill(0, 0);
            graphics.drawRect(-3000, -3000, 6000, 6000);
            graphics.endFill();
            addEventListener(MouseEvent.CLICK, this.__mouseClick);
            this._addpriceitem = ComponentFactory.Instance.creatComponentByStylename("addPriceBtn");
            this._moveitem = ComponentFactory.Instance.creatComponentByStylename("moveGoodsBtn");
            this._openitem = ComponentFactory.Instance.creatComponentByStylename("openGoodsBtn");
            this._useitem = ComponentFactory.Instance.creatComponentByStylename("useGoodsBtn");
            this._openAllItem = ComponentFactory.Instance.creatComponentByStylename("openAllGoodsBtn");
            this._addpriceitem.addEventListener(MouseEvent.CLICK, this.__addpriceClick);
            this._moveitem.addEventListener(MouseEvent.CLICK, this.__moveClick);
            this._openitem.addEventListener(MouseEvent.CLICK, this.__openClick);
            this._useitem.addEventListener(MouseEvent.CLICK, this.__useClick);
            this._openAllItem.addEventListener(MouseEvent.CLICK, this.__openAllClick);
        }

        public function get cell():LockBagCell
        {
            return (this._cell);
        }

        private function __mouseClick(_arg_1:MouseEvent):void
        {
            this.hide();
            SoundManager.instance.play("008");
        }

        private function __addpriceClick(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            SoundManager.instance.play("008");
            dispatchEvent(new Event(ADDPRICE));
            this.hide();
        }

        private function __moveClick(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            SoundManager.instance.play("008");
            dispatchEvent(new Event(MOVE));
            this.hide();
        }

        private function __openClick(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            SoundManager.instance.play("008");
            dispatchEvent(new Event(OPEN));
            this.hide();
        }

        private function __useClick(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            SoundManager.instance.play("008");
            if (parent)
            {
                parent.removeChild(this);
            };
            dispatchEvent(new Event(USE));
            this.hide();
        }

        private function __openAllClick(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            SoundManager.instance.play("008");
            dispatchEvent(new Event(OPEN_ALL));
            this.hide();
        }

        public function show(_arg_1:LockBagCell, _arg_2:int, _arg_3:int):void
        {
            this._cell = _arg_1;
            if (this._cell == null)
            {
                return;
            };
            var _local_4:ItemTemplateInfo = this._cell.info;
            if (_local_4 == null)
            {
                return;
            };
            if (InventoryItemInfo(_local_4).getRemainDate() <= 0)
            {
                this._list.addChild(this._addpriceitem);
            }
            else
            {
                if (EquipType.isPackage(_local_4))
                {
                    this._list.addChild(this._openitem);
                }
                else
                {
                    if (EquipType.isPetEgg(_local_4))
                    {
                        this._list.addChild(this._openitem);
                    }
                    else
                    {
                        if (EquipType.canBeUsed(_local_4))
                        {
                            this._list.addChild(this._useitem);
                        };
                    };
                };
            };
            if (EquipType.canOpenAll(_local_4))
            {
                this._list.addChild(this._openAllItem);
            };
            this._list.addChild(this._moveitem);
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_TOP_LAYER);
            this.x = _arg_2;
            this.y = _arg_3;
        }

        public function hide():void
        {
            if (parent)
            {
                parent.removeChild(this);
            };
            ObjectUtils.removeChildAllChildren(this._list);
            this._cell = null;
        }

        public function get showed():Boolean
        {
            return (!(stage == null));
        }


    }
}//package bagAndInfo.bag

class SingletonFoce 
{


}


