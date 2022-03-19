// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//quest.QuestRewardCell

package quest
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.display.Bitmap;
    import shop.view.ShopItemCell;
    import ddt.data.goods.InventoryItemInfo;
    import com.pickgliss.ui.ComponentFactory;
    import bagAndInfo.cell.CellFactory;
    import ddt.utils.PositionUtils;
    import flash.events.MouseEvent;
    import com.greensock.TweenLite;
    import com.greensock.easing.Quad;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import ddt.manager.TaskManager;
    import com.pickgliss.utils.ObjectUtils;

    public class QuestRewardCell extends Sprite implements Disposeable 
    {

        private const NAME_AREA_HEIGHT:int = 44;

        private var quantityTxt:FilterFrameText;
        private var nameTxt:FilterFrameText;
        private var bgStyle:Scale9CornerImage;
        private var shine:Bitmap;
        private var item:ShopItemCell;
        private var _info:InventoryItemInfo;

        public function QuestRewardCell()
        {
            this.bgStyle = ComponentFactory.Instance.creatComponentByStylename("rewardCell.BGStyle1");
            addChild(this.bgStyle);
            this.shine = ComponentFactory.Instance.creat("asset.core.quest.QuestRewardCellBGShine");
            this.shine.visible = false;
            addChild(this.shine);
            var _local_1:Sprite = new Sprite();
            _local_1.graphics.beginFill(0xFFFFFF, 0);
            _local_1.graphics.drawRect(0, 0, 43, 43);
            _local_1.graphics.endFill();
            this.item = (CellFactory.instance.createShopItemCell(_local_1, null, true, true) as ShopItemCell);
            this.item.cellSize = 40;
            PositionUtils.setPos(this.item, "quest.rewardCellPos2");
            addChild(this.item);
            this.quantityTxt = ComponentFactory.Instance.creat("BagCellCountText");
            PositionUtils.setPos(this.quantityTxt, "quest.rewardCellPos");
            addChild(this.quantityTxt);
            this.nameTxt = ComponentFactory.Instance.creat("core.quest.QuestItemRewardName");
            addChild(this.nameTxt);
            this.item.addEventListener(MouseEvent.MOUSE_OVER, this.__overHandler);
            this.item.addEventListener(MouseEvent.MOUSE_OUT, this.__outHandler);
        }

        public function get _shine():Bitmap
        {
            return (this.shine);
        }

        private function __overHandler(_arg_1:MouseEvent):void
        {
            TweenLite.to(this.item, 0.25, {
                "x":-13,
                "y":-14,
                "scaleX":1.5,
                "scaleY":1.5,
                "ease":Quad.easeOut
            });
            TweenLite.to(this.quantityTxt, 0.25, {
                "y":34,
                "alpha":0
            });
        }

        private function __outHandler(_arg_1:MouseEvent):void
        {
            TweenLite.to(this.item, 0.25, {
                "x":-2,
                "y":-2,
                "scaleX":1,
                "scaleY":1,
                "ease":Quad.easeOut
            });
            TweenLite.to(this.quantityTxt, 0.25, {
                "y":29,
                "alpha":1
            });
        }

        public function set taskType(_arg_1:int):void
        {
        }

        public function set opitional(_arg_1:Boolean):void
        {
            if (this.bgStyle.visible)
            {
                this.bgStyle.setFrame(((_arg_1) ? 2 : 1));
            };
        }

        public function set info(_arg_1:InventoryItemInfo):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            this.item.info = _arg_1;
            if (_arg_1.Count > 1)
            {
                this.quantityTxt.text = _arg_1.Count.toString();
            }
            else
            {
                this.quantityTxt.text = "";
            };
            this._info = _arg_1;
            this.itemName = _arg_1.Name;
        }

        public function get info():InventoryItemInfo
        {
            return (this._info);
        }

        public function __setItemName(_arg_1:Event):void
        {
            this.itemName = this.info.Name;
        }

        public function set itemName(_arg_1:String):void
        {
            this.nameTxt.text = _arg_1;
            this.nameTxt.y = ((this.NAME_AREA_HEIGHT - this.nameTxt.textHeight) / 2);
        }

        public function set selected(_arg_1:Boolean):void
        {
            if (((!(this.shine.visible)) && (_arg_1)))
            {
                SoundManager.instance.play("008");
            };
            this.shine.visible = _arg_1;
            TaskManager.instance.Model.itemAwardSelected = this.info.TemplateID;
        }

        public function initSelected():void
        {
            this.shine.visible = true;
            TaskManager.instance.Model.itemAwardSelected = this.info.TemplateID;
        }

        public function get selected():Boolean
        {
            return (this.shine.visible);
        }

        public function canBeSelected():void
        {
            this.buttonMode = true;
            addEventListener(MouseEvent.CLICK, this.__selected);
        }

        private function __selected(_arg_1:MouseEvent):void
        {
            dispatchEvent(new RewardSelectedEvent(this));
        }

        public function dispose():void
        {
            this._info = null;
            this.item.removeEventListener(MouseEvent.MOUSE_OVER, this.__overHandler);
            this.item.removeEventListener(MouseEvent.MOUSE_OUT, this.__outHandler);
            TweenLite.killTweensOf(this.item);
            removeEventListener(MouseEvent.CLICK, this.__selected);
            if (this.quantityTxt)
            {
                ObjectUtils.disposeObject(this.quantityTxt);
            };
            this.quantityTxt = null;
            if (this.nameTxt)
            {
                ObjectUtils.disposeObject(this.nameTxt);
            };
            this.nameTxt = null;
            if (this.bgStyle)
            {
                ObjectUtils.disposeObject(this.bgStyle);
            };
            this.bgStyle = null;
            if (this.shine)
            {
                ObjectUtils.disposeObject(this.shine);
            };
            this.shine = null;
            if (this.item)
            {
                ObjectUtils.disposeObject(this.item);
            };
            this.item = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package quest

