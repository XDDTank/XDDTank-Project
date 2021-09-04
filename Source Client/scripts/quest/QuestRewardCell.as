package quest
{
   import bagAndInfo.cell.CellFactory;
   import com.greensock.TweenLite;
   import com.greensock.easing.Quad;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import shop.view.ShopItemCell;
   
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
         super();
         this.bgStyle = ComponentFactory.Instance.creatComponentByStylename("rewardCell.BGStyle1");
         addChild(this.bgStyle);
         this.shine = ComponentFactory.Instance.creat("asset.core.quest.QuestRewardCellBGShine");
         this.shine.visible = false;
         addChild(this.shine);
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,43,43);
         _loc1_.graphics.endFill();
         this.item = CellFactory.instance.createShopItemCell(_loc1_,null,true,true) as ShopItemCell;
         this.item.cellSize = 40;
         PositionUtils.setPos(this.item,"quest.rewardCellPos2");
         addChild(this.item);
         this.quantityTxt = ComponentFactory.Instance.creat("BagCellCountText");
         PositionUtils.setPos(this.quantityTxt,"quest.rewardCellPos");
         addChild(this.quantityTxt);
         this.nameTxt = ComponentFactory.Instance.creat("core.quest.QuestItemRewardName");
         addChild(this.nameTxt);
         this.item.addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this.item.addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
      }
      
      public function get _shine() : Bitmap
      {
         return this.shine;
      }
      
      private function __overHandler(param1:MouseEvent) : void
      {
         TweenLite.to(this.item,0.25,{
            "x":-13,
            "y":-14,
            "scaleX":1.5,
            "scaleY":1.5,
            "ease":Quad.easeOut
         });
         TweenLite.to(this.quantityTxt,0.25,{
            "y":34,
            "alpha":0
         });
      }
      
      private function __outHandler(param1:MouseEvent) : void
      {
         TweenLite.to(this.item,0.25,{
            "x":-2,
            "y":-2,
            "scaleX":1,
            "scaleY":1,
            "ease":Quad.easeOut
         });
         TweenLite.to(this.quantityTxt,0.25,{
            "y":29,
            "alpha":1
         });
      }
      
      public function set taskType(param1:int) : void
      {
      }
      
      public function set opitional(param1:Boolean) : void
      {
         if(this.bgStyle.visible)
         {
            this.bgStyle.setFrame(!!param1 ? int(2) : int(1));
         }
      }
      
      public function set info(param1:InventoryItemInfo) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.item.info = param1;
         if(param1.Count > 1)
         {
            this.quantityTxt.text = param1.Count.toString();
         }
         else
         {
            this.quantityTxt.text = "";
         }
         this._info = param1;
         this.itemName = param1.Name;
      }
      
      public function get info() : InventoryItemInfo
      {
         return this._info;
      }
      
      public function __setItemName(param1:Event) : void
      {
         this.itemName = this.info.Name;
      }
      
      public function set itemName(param1:String) : void
      {
         this.nameTxt.text = param1;
         this.nameTxt.y = (this.NAME_AREA_HEIGHT - this.nameTxt.textHeight) / 2;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(!this.shine.visible && param1)
         {
            SoundManager.instance.play("008");
         }
         this.shine.visible = param1;
         TaskManager.instance.Model.itemAwardSelected = this.info.TemplateID;
      }
      
      public function initSelected() : void
      {
         this.shine.visible = true;
         TaskManager.instance.Model.itemAwardSelected = this.info.TemplateID;
      }
      
      public function get selected() : Boolean
      {
         return this.shine.visible;
      }
      
      public function canBeSelected() : void
      {
         this.buttonMode = true;
         addEventListener(MouseEvent.CLICK,this.__selected);
      }
      
      private function __selected(param1:MouseEvent) : void
      {
         dispatchEvent(new RewardSelectedEvent(this));
      }
      
      public function dispose() : void
      {
         this._info = null;
         this.item.removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
         this.item.removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         TweenLite.killTweensOf(this.item);
         removeEventListener(MouseEvent.CLICK,this.__selected);
         if(this.quantityTxt)
         {
            ObjectUtils.disposeObject(this.quantityTxt);
         }
         this.quantityTxt = null;
         if(this.nameTxt)
         {
            ObjectUtils.disposeObject(this.nameTxt);
         }
         this.nameTxt = null;
         if(this.bgStyle)
         {
            ObjectUtils.disposeObject(this.bgStyle);
         }
         this.bgStyle = null;
         if(this.shine)
         {
            ObjectUtils.disposeObject(this.shine);
         }
         this.shine = null;
         if(this.item)
         {
            ObjectUtils.disposeObject(this.item);
         }
         this.item = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
