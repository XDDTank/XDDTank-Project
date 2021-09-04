package store
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.ShineObject;
   import ddt.data.BagInfo;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class StoreCell extends BagCell
   {
       
      
      protected var _shiner:ShineObject;
      
      protected var _shinerPos:Point;
      
      protected var _index:int;
      
      public var DoubleClickEnabled:Boolean = true;
      
      public var mouseSilenced:Boolean = false;
      
      public function StoreCell(param1:Sprite, param2:int)
      {
         super(0,null,false,param1);
         this._index = param2;
         this._shiner = new ShineObject(ComponentFactory.Instance.creat("asset.ddtstore.cellShine"));
         this._shiner.addToBottom = false;
         this._shiner.visible = false;
         addChild(this._shiner);
         this._shiner.mouseChildren = this._shiner.mouseEnabled = false;
         if(_cellMouseOverBg)
         {
            ObjectUtils.disposeObject(_cellMouseOverBg);
         }
         _cellMouseOverBg = null;
         tipDirctions = "7,5,2,6,4,1";
         PicPos = new Point(-2,-2);
         this._shinerPos = new Point(16,28);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(_tbxCount)
         {
            ObjectUtils.disposeObject(_tbxCount);
         }
         _tbxCount = ComponentFactory.Instance.creat("ddtstore.StoneCountText");
         _tbxCount.mouseEnabled = false;
         addChild(_tbxCount);
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.enableDoubleClick(this);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.disableDoubleClick(this);
      }
      
      protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         if(!this.DoubleClickEnabled)
         {
            return;
         }
         if(info == null)
         {
            return;
         }
         if((param1.currentTarget as BagCell).info != null)
         {
            SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG,this.index,this.itemBagType,-1);
            if(!this.mouseSilenced)
            {
               SoundManager.instance.play("008");
            }
         }
      }
      
      override public function set info(param1:ItemTemplateInfo) : void
      {
         var _loc2_:EquipmentTemplateInfo = null;
         super.info = param1;
         updateCount();
         checkOverDate();
         if(info is InventoryItemInfo)
         {
            this.locked = this.info["lock"];
         }
         if(info == null)
         {
            _loc2_ = null;
            this.seteuipQualityBg(0);
         }
         if(info != null)
         {
            _loc2_ = ItemManager.Instance.getEquipTemplateById(info.TemplateID);
         }
         if(_loc2_ != null && info.Property8 == "0")
         {
            this.seteuipQualityBg(_loc2_.QualityID);
         }
         else
         {
            this.seteuipQualityBg(0);
         }
      }
      
      override public function seteuipQualityBg(param1:int) : void
      {
         if(_euipQualityBg == null)
         {
            _euipQualityBg = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.euipQuality.ViewTwo");
         }
         _euipQualityBg.width = 68;
         _euipQualityBg.height = 68;
         _euipQualityBg.x = -4;
         _euipQualityBg.y = -1;
         if(param1 == 0)
         {
            _euipQualityBg.visible = false;
         }
         else if(param1 == 1)
         {
            addChildAt(_euipQualityBg,1);
            _euipQualityBg.setFrame(param1);
            _euipQualityBg.visible = true;
         }
         else if(param1 == 2)
         {
            addChildAt(_euipQualityBg,1);
            _euipQualityBg.setFrame(param1);
            _euipQualityBg.visible = true;
         }
         else if(param1 == 3)
         {
            addChildAt(_euipQualityBg,1);
            _euipQualityBg.setFrame(param1);
            _euipQualityBg.visible = true;
         }
         else if(param1 == 4)
         {
            addChildAt(_euipQualityBg,1);
            _euipQualityBg.setFrame(param1);
            _euipQualityBg.visible = true;
         }
         else if(param1 == 5)
         {
            addChildAt(_euipQualityBg,1);
            _euipQualityBg.setFrame(param1);
            _euipQualityBg.visible = true;
         }
      }
      
      protected function __clickHandler(param1:InteractiveEvent) : void
      {
         if(_info && !locked && stage && allowDrag)
         {
            SoundManager.instance.play("008");
         }
         dragStart();
      }
      
      public function get itemBagType() : int
      {
         if(info && (info.CategoryID == 10 || info.CategoryID == 11 || info.CategoryID == 12))
         {
            return BagInfo.PROPBAG;
         }
         return BagInfo.EQUIPBAG;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function setShiner(param1:MovieClip) : void
      {
         ObjectUtils.disposeObject(this._shiner);
         this._shiner = null;
         if(param1)
         {
            this._shiner = new ShineObject(param1);
            this._shiner.addToBottom = false;
            this._shiner.visible = false;
            this._shiner.mouseChildren = this._shiner.mouseEnabled = false;
            addChild(this._shiner);
         }
      }
      
      public function get shinerPos() : Point
      {
         return this._shinerPos;
      }
      
      public function set shinerPos(param1:Point) : void
      {
         this._shinerPos = param1;
      }
      
      public function startShine() : void
      {
         if(this._shiner)
         {
            this._shiner.visible = true;
            setChildIndex(this._shiner,numChildren - 1);
            PositionUtils.setPos(this._shiner,this._shinerPos);
            this._shiner.shine();
         }
      }
      
      public function stopShine() : void
      {
         if(this._shiner)
         {
            this._shiner.visible = false;
            this._shiner.stopShine();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.disableDoubleClick(this);
         if(this._shiner)
         {
            ObjectUtils.disposeObject(this._shiner);
         }
         this._shiner = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
