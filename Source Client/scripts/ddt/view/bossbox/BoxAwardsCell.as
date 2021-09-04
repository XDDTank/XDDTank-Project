package ddt.view.bossbox
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class BoxAwardsCell extends BaseCell implements IListCell
   {
       
      
      protected var _itemName:FilterFrameText;
      
      protected var _count_txt:FilterFrameText;
      
      private var _di:Scale9CornerImage;
      
      private var _di2:Scale9CornerImage;
      
      public function BoxAwardsCell()
      {
         super(ComponentFactory.Instance.creat("asset.awardSystem.roulette.SelectCellBGAsset"));
         this.initII();
         this.addEvent();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         _picPos = new Point(9,7);
      }
      
      protected function initII() : void
      {
         this._di = ComponentFactory.Instance.creatComponentByStylename("Vip.GetAwardsItemBG");
         this._di2 = ComponentFactory.Instance.creatComponentByStylename("Vip.GetAwardsItemCellBG");
         addChild(this._di);
         addChild(this._di2);
         this._itemName = ComponentFactory.Instance.creatComponentByStylename("roulette.GoodsCellName");
         this._itemName.mouseEnabled = false;
         this._itemName.multiline = true;
         this._itemName.wordWrap = true;
         addChild(this._itemName);
         this._count_txt = ComponentFactory.Instance.creatComponentByStylename("bossbox.boxCellCount");
         addChild(this._count_txt);
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
      }
      
      public function getCellValue() : *
      {
      }
      
      public function setCellValue(param1:*) : void
      {
      }
      
      private function addEvent() : void
      {
         addEventListener(Event.CHANGE,this.__setItemName);
      }
      
      public function set count(param1:int) : void
      {
         this._count_txt.parent.removeChild(this._count_txt);
         addChild(this._count_txt);
         if(param1 <= 1)
         {
            this._count_txt.text = "";
            return;
         }
         this._count_txt.text = String(param1);
      }
      
      public function __setItemName(param1:Event) : void
      {
         this.itemName = _info.Name;
      }
      
      public function set itemName(param1:String) : void
      {
         this._itemName.text = param1;
         this._itemName.y = (44 - this._itemName.textHeight) / 2 + 5;
      }
      
      override public function get height() : Number
      {
         return this._di.height;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(Event.CHANGE,this.__setItemName);
         ObjectUtils.disposeObject(this._itemName);
         this._itemName = null;
         ObjectUtils.disposeObject(this._di);
         this._di = null;
         ObjectUtils.disposeObject(this._di2);
         this._di2 = null;
         ObjectUtils.disposeObject(this._count_txt);
         this._count_txt = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
