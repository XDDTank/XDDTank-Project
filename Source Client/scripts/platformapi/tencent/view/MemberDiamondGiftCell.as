package platformapi.tencent.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.DaylyGiveInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class MemberDiamondGiftCell extends BagCell
   {
       
      
      private var _BG:Bitmap;
      
      private var _nameText:FilterFrameText;
      
      private var _light:Bitmap;
      
      public function MemberDiamondGiftCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:DisplayObject = null)
      {
         this._BG = UICreatShortcut.creatAndAdd("asset.MemberDiamondGift.RightCellBG",this);
         this._nameText = UICreatShortcut.creatAndAdd("memberDiamondGift.view.MemberDiamondGiftRightView.cellText",this);
         super(param1,param2,param3,param4);
         _bg.visible = false;
         _picPos = new Point(20,20);
         this._light = UICreatShortcut.creatAndAdd("asset.memberDiamondNewHandGift.light",this);
         this._light.visible = false;
      }
      
      public function showLight() : void
      {
         if(this._light)
         {
            this._light.visible = true;
         }
      }
      
      override protected function onMouseOver(param1:MouseEvent) : void
      {
      }
      
      public function set nameTextStyle(param1:String) : void
      {
         ObjectUtils.disposeObject(this._nameText);
         this._nameText = null;
         this._nameText = UICreatShortcut.creatAndAdd(param1,this);
      }
      
      public function setInfo(param1:DaylyGiveInfo) : void
      {
         var _loc2_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(param1.TemplateID);
         this._nameText.text = _loc2_.Name + "x" + param1.Count.toString();
         info = _loc2_;
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._BG);
         this._BG = null;
         ObjectUtils.disposeObject(this._nameText);
         this._nameText = null;
         ObjectUtils.disposeObject(this._light);
         this._light = null;
         super.dispose();
      }
   }
}
