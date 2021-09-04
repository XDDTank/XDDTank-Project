package store.view.Compose.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.EquipmentTemplateInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.BagEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import flash.geom.Point;
   
   public class ComposeMaterialCell extends BaseCell
   {
       
      
      private var _countText:FilterFrameText;
      
      private var _count:int;
      
      private var _time:int;
      
      private var _haveCount:int;
      
      private var _canUseCount:int;
      
      private var _enough:Boolean;
      
      private var _LargestTime:int;
      
      private var _isBind:Boolean;
      
      private var _euipQualityBg:ScaleFrameImage;
      
      public function ComposeMaterialCell()
      {
         this._time = 1;
         super(ComponentFactory.Instance.creatBitmap("asset.ddtstore.materialCellBg"));
         _bg.visible = false;
         setContentSize(56,56);
         PicPos = new Point(9,8);
      }
      
      public function get canUseCount() : int
      {
         return this._canUseCount;
      }
      
      public function get haveCount() : int
      {
         return this._haveCount;
      }
      
      public function get isNotBind() : Boolean
      {
         return PlayerManager.Instance.Self.Bag.getItemBindsByTemplateID(info.TemplateID);
      }
      
      public function set count(param1:int) : void
      {
         if(info)
         {
            this._haveCount = PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(info.TemplateID);
         }
         else
         {
            this._haveCount = 0;
         }
         this._count = param1;
         this.updateEnough();
         if(param1 == 0)
         {
            this._countText.visible = false;
         }
         else
         {
            if(this._haveCount >= this._count * this._time)
            {
               this._countText.text = this._haveCount.toString() + "/" + (this._count * this._time).toString();
            }
            else
            {
               this._countText.htmlText = "<font color=\'#ff0000\'>" + this._haveCount.toString() + "</font>/" + (this._count * this._time).toString();
            }
            this._countText.visible = true;
         }
      }
      
      private function updateEnough() : void
      {
         var _loc2_:Array = null;
         var _loc3_:Boolean = false;
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:int = 0;
         var _loc1_:int = 0;
         if(_info)
         {
            _loc2_ = PlayerManager.Instance.Self.Bag.getItemsByTempleteID(info.TemplateID);
            for each(_loc4_ in _loc2_)
            {
               _loc3_ = false;
               _loc5_ = 1;
               while(_loc5_ <= 4)
               {
                  if(_loc4_["Hole" + _loc5_] > 1)
                  {
                     _loc3_ = true;
                     break;
                  }
                  _loc5_++;
               }
               if(!_loc3_)
               {
                  _loc1_ += _loc4_.Count;
               }
            }
         }
         this._canUseCount = _loc1_;
         this._enough = _loc1_ >= this._count * this._time;
      }
      
      public function addCount() : void
      {
         this._time += 1;
         this.count = this._count;
      }
      
      public function reduceCount() : void
      {
         this._time -= 1;
         if(this._time <= 0)
         {
            this._time = 1;
            return;
         }
         this.count = this._count;
      }
      
      public function get LargestTime() : int
      {
         return this._LargestTime = this._haveCount / this._count;
      }
      
      override public function set info(param1:ItemTemplateInfo) : void
      {
         var _loc2_:EquipmentTemplateInfo = null;
         super.info = param1;
         if(this._countText)
         {
            if(this._countText)
            {
               ObjectUtils.disposeObject(this._countText);
            }
            this._countText = null;
         }
         this._countText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.composeView.countText");
         addChild(this._countText);
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
         this.setTime(1);
      }
      
      private function seteuipQualityBg(param1:int) : void
      {
         if(this._euipQualityBg == null)
         {
            this._euipQualityBg = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.euipQuality.ViewTwo");
         }
         this._euipQualityBg.width = 55;
         this._euipQualityBg.height = 55;
         this._euipQualityBg.x = 9;
         this._euipQualityBg.y = 8;
         if(param1 == 0)
         {
            this._euipQualityBg.visible = false;
         }
         else if(param1 == 1)
         {
            addChildAt(this._euipQualityBg,1);
            this._euipQualityBg.setFrame(param1);
            this._euipQualityBg.visible = true;
         }
         else if(param1 == 2)
         {
            addChildAt(this._euipQualityBg,1);
            this._euipQualityBg.setFrame(param1);
            this._euipQualityBg.visible = true;
         }
         else if(param1 == 3)
         {
            addChildAt(this._euipQualityBg,1);
            this._euipQualityBg.setFrame(param1);
            this._euipQualityBg.visible = true;
         }
         else if(param1 == 4)
         {
            addChildAt(this._euipQualityBg,1);
            this._euipQualityBg.setFrame(param1);
            this._euipQualityBg.visible = true;
         }
         else if(param1 == 5)
         {
            addChildAt(this._euipQualityBg,1);
            this._euipQualityBg.setFrame(param1);
            this._euipQualityBg.visible = true;
         }
      }
      
      public function setTime(param1:int) : void
      {
         this._time = param1;
         this.count = this._count;
      }
      
      public function get enough() : Boolean
      {
         return this._enough;
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE,this.__updateCount);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this.__updateCount);
         PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.AFTERDEL,this.__updateCount);
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.AFTERDEL,this.__updateCount);
      }
      
      private function __updateCount(param1:BagEvent) : void
      {
         this.count = this._count;
      }
      
      override public function dispose() : void
      {
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE,this.__updateCount);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE,this.__updateCount);
         PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.AFTERDEL,this.__updateCount);
         PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.AFTERDEL,this.__updateCount);
         super.dispose();
         if(this._countText)
         {
            ObjectUtils.disposeObject(this._countText);
         }
         this._countText = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
