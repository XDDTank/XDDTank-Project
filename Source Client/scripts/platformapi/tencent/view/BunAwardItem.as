package platformapi.tencent.view
{
   import bagAndInfo.cell.CellFactory;
   import bagAndInfo.cell.PersonalInfoCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.DaylyGiveInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import platformapi.tencent.DiamondManager;
   
   public class BunAwardItem extends Sprite implements Disposeable
   {
       
      
      private var cellSize:int = 42;
      
      private var _icon:BunIcon;
      
      private var _daytext:FilterFrameText;
      
      private var _cellNum:FilterFrameText;
      
      private var _cell:PersonalInfoCell;
      
      private var _line:Bitmap;
      
      private var _level:int;
      
      private var _light:Bitmap;
      
      public function BunAwardItem(param1:int)
      {
         super();
         this._level = param1;
         this.init();
      }
      
      override public function get height() : Number
      {
         return this.cellSize;
      }
      
      private function init() : void
      {
         this._icon = new BunIcon();
         this._icon.level = this._level;
         PositionUtils.setPos(this._icon,"memberDiamondGift.view.bunAwardItem.IconPos");
         addChild(this._icon);
         this._daytext = UICreatShortcut.creatTextAndAdd("memberDiamondGift.view.BunAwardFrame.dayText",LanguageMgr.GetTranslation("memberDiamondGift.view.BunAwardFrame.dayGet"),this);
         this._cellNum = UICreatShortcut.creatAndAdd("memberDiamondGift.view.BunAwardFrame.numText",this);
         this._line = UICreatShortcut.creatAndAdd("asset.MemberDiamondGift.bun.line",this);
         this._cell = PersonalInfoCell(CellFactory.instance.createPersonalInfoCell(0));
         PositionUtils.setPos(this._cell,"memberDiamondGift.view.bunAwardItem.cellPos");
         this._cell.setContentSize(this.cellSize,this.cellSize);
         addChild(this._cell);
         this._light = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.bun.shine");
         addChild(this._light);
         this._light.visible = PlayerManager.Instance.Self.Level3366 == this._level;
         this.update();
      }
      
      private function update() : void
      {
         var _loc1_:DaylyGiveInfo = null;
         _loc1_ = DiamondManager.instance.model.bunAwardList[this._level];
         if(_loc1_)
         {
            this._cellNum.visible = this._cell.visible = true;
            this._cellNum.text = "x" + _loc1_.Count.toString();
            this._cell.info = ItemManager.Instance.getTemplateById(_loc1_.TemplateID);
         }
         else
         {
            this._cellNum.visible = this._cell.visible = false;
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         ObjectUtils.disposeObject(this._daytext);
         this._daytext = null;
         ObjectUtils.disposeObject(this._cellNum);
         this._cellNum = null;
         ObjectUtils.disposeObject(this._cell);
         this._cell = null;
         ObjectUtils.disposeObject(this._line);
         this._line = null;
      }
   }
}
