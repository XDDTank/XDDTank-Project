package ddt.view.bossbox
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CellEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class BoxVipTipsInfoCell extends BaseCell
   {
       
      
      protected var _itemName:FilterFrameText;
      
      private var _di:ScaleBitmapImage;
      
      private var _isSelect:Boolean = false;
      
      private var _sunShinBg:Scale9CornerImage;
      
      public function BoxVipTipsInfoCell()
      {
         super(ComponentFactory.Instance.creat("asset.awardSystem.roulette.SelectCellBGAsset"));
         this.initView();
      }
      
      public function set isSelect(param1:Boolean) : void
      {
         this._isSelect = param1;
         grayFilters = !this._isSelect;
         if(this._isSelect)
         {
            this._sunShinBg = ComponentFactory.Instance.creat("Vip.GetAwardsShin");
            addChild(this._sunShinBg);
         }
         else if(this._sunShinBg)
         {
            ObjectUtils.disposeObject(this._sunShinBg);
            this._sunShinBg = null;
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         _picPos = new Point(7,7);
      }
      
      protected function initView() : void
      {
         this._di = ComponentFactory.Instance.creat("Vip.GetAwardsItemBG");
         addChild(this._di);
         var _loc1_:* = ComponentFactory.Instance.creat("Vip.GetAwardsItemCellBG");
         addChild(_loc1_);
         this._itemName = ComponentFactory.Instance.creat("BoxVipTips.ItemName");
         addChild(this._itemName);
      }
      
      override protected function onMouseClick(param1:MouseEvent) : void
      {
         dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,this));
      }
      
      public function set itemName(param1:String) : void
      {
         this._itemName.text = param1;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._itemName)
         {
            ObjectUtils.disposeObject(this._itemName);
         }
         this._itemName = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
